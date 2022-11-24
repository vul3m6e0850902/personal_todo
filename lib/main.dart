import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

import 'pages/account_page.dart';
import 'pages/home_page.dart';
import 'pages/language_page.dart';
import 'pages/setting_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: TextTheme(headline6: TextStyle(color: Colors.white))),
      home: new MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  //目前選擇頁索引值
  int _currentIndex = 1; //預設值
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _isLoaded = false;
    _loadAd();
  }

  final pages = [AccountPage(), HomePage(), languagepage(), settingpage()];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: AppBar(
          title: const Text('Personal_Todolist'),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.search),
                tooltip: 'searching',
                onPressed: (() {
                  showSearch(
                    context: context,
                    delegate: MySearchDelegate(),
                  );
                })),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        drawer: Drawer(
          backgroundColor: Color.fromARGB(255, 30, 30, 30),
          child: ListView(
            children: <Widget>[
              //設定用户名稱
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                accountName: new Text(
                  "訪客",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                //設定Email
                accountEmail: new Text(
                  "請登入google drive同步資料",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                //設定大頭照
                currentAccountPicture:
                    new CircleAvatar(child: Icon(Icons.person)),
                arrowColor: Color.fromARGB(255, 255, 255, 255),
                onDetailsPressed: () {
                  _onItemClick(0);
                },
              ),
              //選單
              ListTile(
                leading: new CircleAvatar(
                    backgroundColor: Colors.blue, child: Icon(Icons.home)),
                title: Text(
                  '主頁面',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  _onItemClick(1);
                },
              ),
              ListTile(
                leading: new CircleAvatar(
                    backgroundColor: Colors.blue, child: Icon(Icons.language)),
                title: Text(
                  '語言',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  _onItemClick(2);
                },
              ),
              ListTile(
                leading: new CircleAvatar(
                    backgroundColor: Colors.blue, child: Icon(Icons.settings)),
                title: Text(
                  '設定',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  _onItemClick(3);
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Padding(
              //左边添加8像素补白
              padding: EdgeInsets.only(bottom: 50),
              child: pages[_currentIndex],
            ),
            if (_bannerAd != null && _isLoaded)
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: SizedBox(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
              )
          ],
        ));
  }

  void _loadAd() async {
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      // Unable to get width of anchored banner.
      return;
    }
    BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }

  void _onItemClick(int index) {
    setState(() {
      _currentIndex = index;
      Navigator.of(context).pop();
    });
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      scaffoldBackgroundColor: Color.fromARGB(255, 30, 30, 30),
      hintColor: Colors.white,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView();
  }
}
