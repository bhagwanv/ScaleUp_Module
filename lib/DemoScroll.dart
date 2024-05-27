import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Flutter code sample for [FlexibleSpaceBar].

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  double getHeight() {
    return 800;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(
          children: [
            DefaultTabController(
              length: 3,
              child: NestedScrollView(
                headerSliverBuilder: (context, value) {
                  return [
                    SliverAppBar(
                      expandedHeight: 200.0,
                      flexibleSpace: FlexibleSpaceBar(),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        minHeight: 90,
                        maxHeight: 90,
                        child: Container(
                          height: getHeight() * (1 / 11),
                          width: double.infinity,
                          color: Colors.green[200],
                          child: Center(
                            child: Text(
                              "TEXT atul",
                              style: TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        minHeight: 90,
                        maxHeight: 90,
                        child: Container(
                          color: Colors.green[200],
                          child: TabBar(
                            controller: _tabController,
                            tabs: [
                              Tab(
                                child: Text(
                                  'TITLE1',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  'TITLE2',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  'TITLE3',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 600),
                        child: Column(
                          children: [
                            // RoundedPicture(),
                            Icon(
                              Icons.favorite,
                              color: Colors.pink,
                              size: 150.0,
                              semanticLabel:
                              'Text to announce in accessibility modes',
                            ),
                            FittedBox(
                              child: Text("Hello World",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 40)),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20),
                                      text: 'Info1:  ',
                                      children: [
                                        TextSpan(
                                          text: "123",
                                          style: TextStyle(),
                                        ),
                                      ]),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20),
                                      text: 'Info2:  ',
                                      children: [
                                        TextSpan(
                                          text: "abcd",
                                          style: TextStyle(),
                                        ),
                                      ]),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20),
                                      text: 'Info3:  ',
                                      children: [
                                        TextSpan(
                                          text: "xyz",
                                          style: TextStyle(),
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 600),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 600),
                              child: Center(
                                child: Text("TITLE2"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 600),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 600),
                              child: Center(
                                child: Text("TITLE3"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 90,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: InkWell(
                onTap: () {},
                child: Icon(Icons.arrow_back),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
