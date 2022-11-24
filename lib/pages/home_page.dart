import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:personal_todo/main.dart';

class HomePage extends StatefulWidget {
  _BarState createState() => _BarState();
}

class _BarState extends State<HomePage> with TickerProviderStateMixin {
  var bloablid = 10;

  // //table
  int startingTabCount = 20;
  List<Tab> _tabs = <Tab>[];
  List<Widget> _generalWidgets = <Widget>[];
  late TabController _tabController;
  @override
  void initState() {
    _tabs = getTabs(startingTabCount);
    _tabController = getTabController();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<todo> listItems = new List<todo>.generate(10, (i) {
    return todo(
      name: '測試資料 $i',
      id: i,
    );
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // //table
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            tabs: _tabs,
            controller: _tabController,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _addAnotherTab,
            ),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: _removeTab,
            ),
          ],
        ),
        body: Stack(
          children: [
            //table
            TabBarView(
              controller: _tabController,
              children: getWidgets(),
            ),

            ListView.builder(
              itemCount: listItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: IconButton(
                    icon: Icon(
                      Icons.check_box,
                      color: Colors.white,
                    ),
                    onPressed: () => setState(() => listItems.removeLast()),
                  ),
                  title: Text(
                    '${listItems[index].name}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            bloablid = bloablid + 1,
            setState(() => listItems.add(todo(name: "aa", id: bloablid)))
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
  }

  //table
  TabController getTabController() {
    return TabController(length: _tabs.length, vsync: this);
  }

  Tab getTab(int widgetNumber) {
    return Tab(
      text: "$widgetNumber",
    );
  }

  Widget getWidget(int widgetNumber) {
    return Center(
      child: Text("Widget nr: $widgetNumber"),
    );
  }

  List<Tab> getTabs(int count) {
    _tabs.clear();
    for (int i = 0; i < count; i++) {
      _tabs.add(getTab(i));
    }
    return _tabs;
  }

  List<Widget> getWidgets() {
    _generalWidgets.clear();
    for (int i = 0; i < _tabs.length; i++) {
      _generalWidgets.add(getWidget(i));
    }
    return _generalWidgets;
  }

  void _addAnotherTab() {
    _tabs = getTabs(_tabs.length + 1);
    _tabController.index = 0;
    _tabController = getTabController();
    _updatePage();
  }

  void _removeTab() {
    _tabs = getTabs(_tabs.length - 1);
    _tabController.index = 0;
    _tabController = getTabController();
    _updatePage();
  }

  void _updatePage() {
    setState(() {});
  }
}

class todo {
  final String name;
  final int id;
  todo({required this.name, required this.id});
}
