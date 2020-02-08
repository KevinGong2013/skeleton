import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeleton/skeleton.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Skeleton Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.play_arrow), title: Text('home')),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.mail), title: Text('list')),
              ],
            ),
            tabBuilder: (BuildContext context, int index) {
              return YoutubePage();
            }));
  }
}

class YoutubePage extends StatefulWidget {
  @override
  _YoutubePageState createState() => _YoutubePageState();
}

class _YoutubePageState extends State<YoutubePage> {
  final controller = SkeletonController();

  @override
  void initState() {
    super.initState();
    controller.start();
  }

  @override
  void dispose() {
    super.dispose();
    controller.stop();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('YOUTUBE'),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            _buildSkeletonItem(context),
            _buildSkeletonItem(context),
            Container(
              height: 50,
              child: Skeleton(
                controller,
                increasing: UniqueKey(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonItem(BuildContext context) {
    final increasing = UniqueKey();
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Skeleton(controller, increasing: increasing),
          ),
          Expanded(
            child: Container(
              color: CupertinoColors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: SizedBox.fromSize(
                          size: Size(60, 60),
                          child: Skeleton(controller),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Skeleton(controller,
                                    increasing: increasing),
                              )),
                          Spacer(),
                          Expanded(
                            flex: 2,
                            child: FractionallySizedBox(
                                widthFactor: 0.7,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Skeleton(controller,
                                      increasing: increasing),
                                )),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 2,
                            child: FractionallySizedBox(
                                widthFactor: 0.5,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Skeleton(controller,
                                      increasing: increasing),
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
