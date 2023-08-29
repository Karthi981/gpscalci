import 'package:flutter/material.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/position/gf_position.dart';
import 'package:gpscalci/walk.dart';

import 'areawalk.dart';
import 'displaymap.dart';


class Mainpage extends StatefulWidget {
  const Mainpage({Key? key}) : super(key: key);

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Gps Calculater"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
              },
              child: Stack(
                children: [
                  GFCard(
                    height: 160,
                    borderRadius: BorderRadius.circular(20),
                    boxFit: BoxFit.fill,
                    titlePosition: GFPosition.start,
                    showOverlayImage: true,
                    imageOverlay: AssetImage("assets/phot1.gif"),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 63, 41, 53),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text("Measure Distance and Area\non Map",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Walk()));
              },
              child: Stack(
                children: [
                  GFCard(
                    height: 160,
                    borderRadius: BorderRadius.circular(20),
                    boxFit: BoxFit.fill,
                    titlePosition: GFPosition.start,
                    showOverlayImage: true,
                    imageOverlay: AssetImage("assets/photo3.jpg"),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 63, 41, 53),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text("Measure Distance\non Map by Walking",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Walkarea()));
              },
              child: Stack(
                  children: [
                  GFCard(
                  height: 160,
                  borderRadius: BorderRadius.circular(20),
                  boxFit: BoxFit.fill,
                  titlePosition: GFPosition.start,
                  showOverlayImage: true,
                  imageOverlay: AssetImage("assets/photo2.jpg"),
                  ),
                  Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                      decoration: BoxDecoration(
                      gradient: LinearGradient(
                      colors: [
                      Color.fromARGB(255, 63, 41, 53),
                      Color.fromARGB(0, 0, 0, 0)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      ),
                      ),
                      padding: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                      child: Text("Measure Area\non Map by Walking",
                      style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      ),
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
