import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import './DetailsPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  List data;
  double _rotationAngle = 0;
  AnimationController animationController;
  Animation animation;
  @override
  void initState() {
    fetch_data_from_api();
    animationController =
        new AnimationController(duration: Duration(seconds: 8), vsync: this);
    animation = IntTween(begin: 0, end: data == null ? 0 : data.length)
        .animate(animationController)
          ..addListener(() {
            setState(() {
              index = animation.value;
            });
          });
    animationController.repeat();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  int index = 0;
  Future<String> fetch_data_from_api() async {
    var url =
        "http://newsapi.org/v2/everything?q=tech&apiKey=";
    var jsondata = await http.get(url);
    var fetchdata = jsonDecode(jsondata.body);
    setState(() {
      data = fetchdata['articles'];
    });
    return "Success";
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: Text("IndoPatrika"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            IconButton(
                icon: Icon(Icons.notifications_active), onPressed: () {}),
          ],
        ),
        drawer:
         Drawer(
          
        
          
          child: Container(
            color: Colors.orangeAccent,
                      child: ListView(
              
              children: <Widget>[
                
                UserAccountsDrawerHeader(
                  
                  accountName: Text("Akash Kumar", style: TextStyle(color: Colors.orangeAccent)),
                  accountEmail: Text("akashsingh@gmail.com", style: TextStyle(color: Colors.orangeAccent)),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('images/Capture.PNG'),
                  ),
                  decoration: BoxDecoration(color: Colors.white),
                ),
                ListTile(
                  leading: const Icon(Icons.trending_up),
                  title: Text("Trending News", style: TextStyle(color: Colors.white)),
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_border),
                  title: Text("Favorite News!", style: TextStyle(color: Colors.white)),
                ),
                ListTile(
                  leading: const Icon(Icons.settings_applications),
                  title: Text("Settings", style: TextStyle(color: Colors.white)),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: Text("Logout!", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
        body: NotificationListener(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification) {
              setState(() {
                double newSpeed = notification.scrollDelta * 0.03;
                double deltaSpeed =
                    (newSpeed.abs() - _rotationAngle.abs()).abs();
                if (newSpeed.abs() < 0.8) {
                  if (deltaSpeed <= 0.3) {
                    _rotationAngle = -1 * newSpeed;
                  }
                }
              });
            }
          },
          child: Swiper(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context,index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailsPage(
                                author: data[index]["author"],
                                title: data[index]["title"],
                                description: data[index]["description"],
                                urlToImage: data[index]["urlToImage"],
                                publishedAt: data[index]["publishedAt"],
                              )));
                },
                child: PageView.builder(
                    itemCount: data.length,
                    itemBuilder: (_, index) {
                      return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(_rotationAngle),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: 70.0,
                              bottom: 59,
                              child: Container(
                                height: 500,
                                width: 371,
                                margin: EdgeInsets.only(right: 30),
                                decoration: BoxDecoration(
                                    color: Colors.orangeAccent,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(35),
                                        topRight: Radius.circular(35)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black87,
                                          blurRadius: 30,
                                          offset: Offset(20, 20)
                                          //     ,spreadRadius: 3
                                          )
                                    ]),
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 20),
                                          child: Text(
                                            data[index]["title"],
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.black12, width: 2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      height: 144,
                                      width: 286,
                                    )),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: 500,
                                child: Image.network(
                                  data[index]["urlToImage"],
                                  width: 350,
                                  height: 350,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              );
            },
          ),
        ),
      ),
    );
  }
}
