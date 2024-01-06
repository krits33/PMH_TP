import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TabularNavigationApp(),
    );
  }
}

class TabularNavigationApp extends StatefulWidget {
  @override
  _TabularNavigationAppState createState() => _TabularNavigationAppState();
}

class _TabularNavigationAppState extends State<TabularNavigationApp>
    with SingleTickerProviderStateMixin {
  final List<Widget> _tabs = [
    Tab(text: 'Tab 1'),
    Tab(text: 'Tab 2'),
    Tab(text: 'Tab 3'),
  ];

  final List<Widget> _tabViews = [
    Center(child: Text('Content for Tab 1')),
    Center(child: Text('Content for Tab 2')),
    Center(child: Text('Content for Tab 3')),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabular Navigation App'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabViews,
      ),
    );
  }
}
