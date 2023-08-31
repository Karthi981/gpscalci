
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import 'Calculate area.dart';



class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int count=0;
  var result;
  var clk=true;
  var resultinkm;
  var areainsqkm;
  var areainAcres;
  List<LatLng> points = [];
  List<LatLng> areapoints = [];
  List<LatLng> polygonpoints= [];
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = Set();
  //markers for google map
  var showLocation = LatLng(11.055372, 77.120339);
  MapType viewer=  MapType.normal;
   Set<Polyline> _polyline = {};
   Set<Polygon> _polygon ={};
  void Changemapview(){
    setState(() {
      viewer= viewer==MapType.normal? MapType.hybrid:MapType.normal;
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // markers.add(Marker(
    //   markerId: MarkerId(showLocation.toString()),
    //   position: showLocation,
    //   infoWindow: InfoWindow( //popup info
    //     title: 'My Custom Title ',
    //     snippet: 'My Custom Subtitle',
    //   ),
    //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 = token
    //   icon: BitmapDescriptor.defaultMarker,
    // ));
  }

  void getpolyline(LatLng point){

      setState(() {
        markers.add(Marker(
          markerId: MarkerId(point.toString()),
          position: point,
          infoWindow: InfoWindow(
            title: 'lat:${point.latitude.toStringAsFixed(3)},long:${point.longitude.toStringAsFixed(3)}',
          ),
          icon:
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),

        ));
        points.add(point);
        count++;
        _polyline.add(
            Polyline(
              polylineId: PolylineId('1'),
              points: points,
              color: Colors.green[200]!,
              onTap: (){
                Fluttertoast.showToast(
                    msg: "This is Center Short Toast",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
            ),
        );
      });


  }


  void getpolygon(LatLng point){
    setState(() {
      markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: 'lat:${point.latitude.toStringAsFixed(3)},long:${point
              .longitude.toStringAsFixed(3)}',
        ),
        icon:
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),

      ));
    });
    polygonpoints.add(point);
    _polygon.add(Polygon(
      polygonId: PolygonId("my polygon"),
      points: polygonpoints,
      strokeColor: Colors.blue,
      visible: true,
      geodesic: true,
      strokeWidth: 4,
      consumeTapEvents: true,
      fillColor: Colors.blue.withOpacity(0.3),
    ));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Google Map in Flutter"),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Stack(
          children: [
            GoogleMap( //Map widget from google_maps_flutter package
              zoomGesturesEnabled: true, //enable Zoom in, out on map
              initialCameraPosition: CameraPosition( //innital position in map
                target: showLocation, //initial position
                zoom: 10.0, //initial zoom level
              ),
              polygons: _polygon,
              polylines: _polyline,
              markers: markers, //markers to show on map
              mapType: viewer, //map type
              onMapCreated: (GoogleMapController controller){
                _controller.complete(controller);
              },

              onTap: (LatLng point){
                if(clk){
                  getpolyline(point);
                  //if(points.length>1){
                    //CalculateDistance();
                  //}
                }
                else{
                  getpolygon(point);
                }
              },
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
            ),
            Positioned(
              top: 20,
              right: 20,
              child: FloatingActionButton(
                  onPressed: Changemapview,
                child: Icon(Icons.change_circle),
              ),
            ),
            Positioned(
              left: 10,top: 80,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      onPressed: (){
                        areainsqkm=CalculateArea();
                        areainAcres=CalculateArea()*0.000247105;
                        showDialog(context: context,
                            builder: (BuildContext context){
                          return AlertDialog(
                            backgroundColor: Colors.red[200],
                            title: Column(
                              children: [
                                Text('Area in Sq meters:${areainsqkm.toStringAsFixed(3)}'),
                                Text('Area in Acres:${areainAcres.toStringAsFixed(3)}'),
                              ],
                            ),
                            actions: [
                              ElevatedButton(onPressed: (){
                                markers.clear();
                                _polygon.clear();
                                polygonpoints.clear();
                              }, child: Text("Undo"))
                            ],
                          );

                        });
                      },
                      child:Text("Area") ,),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 8,top: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      onPressed: (){
                        resultinkm=CalculateDistance();
                        result=CalculateDistance()*1000;
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //
                        //       content:  Text(result.toString()),
                        //       action: SnackBarAction(
                        //         label: 'Undo',
                        //         onPressed: () {
                        //           markers.clear();
                        //           count=0;
                        //           points.clear();
                        //         },
                        //   ),
                        // ));
                        showDialog(context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                backgroundColor: Colors.red[200],
                                title: Column(
                                  children: [
                                    Text('Meters:${result.toStringAsFixed(3)}'),
                                    Text('In Km:${resultinkm.toStringAsFixed(3)}')
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(onPressed: (){
                                    markers.clear();
                                    count=0;
                                    points.clear();
                                  }, child: Text("Undo"))
                                ],
                              );

                            });
                      },
                      child:Icon(Icons.social_distance_outlined) ,),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 8,bottom: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      onPressed: (){
                        setState(() {
                          if(clk){
                            markers.clear();
                            points.clear();
                            clk=false;
                          }
                          else {
                            markers.clear();
                            _polygon.clear();
                            polygonpoints.clear();
                            clk=true;
                          }
                        });
                      },
                      child:clk?Text("Distance"):Text("Area"),),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 88,
              right: 20,
              child: FloatingActionButton(
                onPressed: () async {
                  Position position = await _determinePosition();

                   markers.clear();
                   points.clear();
                   polygonpoints.clear();
                   _polygon.clear();
                  markers.add(Marker(
                      markerId:  MarkerId(position.toString()),
                      position: LatLng(position.latitude, position.longitude)));
                  CameraPosition cameraPosition = new CameraPosition(
                    target: LatLng(position.latitude, position.longitude),
                    zoom: 24,
                  );
                  final GoogleMapController controller = await _controller.future;
                  controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
                  setState(() {});

                },
                child: Icon(Icons.location_city),

              ),
            )
          ],
        ),
    );
  }
  double  CalculateDistance(){
     int changeindex = points.length;
     var totaldistance=0.0;
      for(int i=0;i<changeindex-1;i++){
        double lon1 = points[i].longitude;
        double lon2 = points[i+1].longitude;
        double lat1 = points[i].latitude;
        double lat2 = points[i+1].latitude;

        var p = 0.017453292519943295;
        var c = cos;
        var a = 0.5 - c((lat2 - lat1) * p)/2 +
            c(lat1 * p) * c(lat2 * p) *
                (1 - c((lon2 - lon1) * p))/2;
         totaldistance = totaldistance + (12742 * asin(sqrt(a)));
      }
     return totaldistance;
  }
  num CalculateArea(){
    // final p1 = polygonpoints[0];
    // final p2 = polygonpoints[1];
    // final p3 = polygonpoints[2];
    // final p4 = polygonpoints[3];
    polygonpoints.add(polygonpoints[0]);
    areapoints= polygonpoints;
    print(areapoints);
    return AreaCalci.computeArea(areapoints);
  }
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}