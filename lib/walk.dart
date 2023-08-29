import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gpscalci/Gps.dart';


// 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

class Walk extends StatefulWidget {
  const Walk({super.key});

  @override
  State<Walk> createState() => _WalkState();
}

class _WalkState extends State<Walk> {

  var showLocation = LatLng(11.055372, 77.120339);
 final Gps _gps= Gps();
 Set<Marker>startmarker={};
 Position? _userposition;
  var distance;
  MapType _currentMapType = MapType.normal;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers={};
  final Set<Polyline> polyline={};
  List<LatLng> polylinevertices=[];
 List<LatLng> Distancelatlng=[];
 var Gotposition = false ;
 var _startmarker=true;
 var walkdistance;
  Uint8List? marketimages;
  List<String> images = ['assets/marker.png','assets/marker1.png'];


  Future<Uint8List> getImages(String path, int width) async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return(await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();

  }


  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);
    });

  }

   void _handlepositionStream(Position position)async {
    Gotposition=true;
    final Uint8List markIcons = await getImages(images[1], 130);
    setState(() {
      _userposition=  position;
      _markers.clear();
      Distancelatlng.add(LatLng(_userposition!.latitude,_userposition!.longitude));
      polylinevertices.add(LatLng(_userposition!.latitude,_userposition!.longitude));
      _markers.add(
          Marker(
            markerId: MarkerId(_userposition.toString()),
            position: LatLng(_userposition!.latitude,_userposition!.longitude),
            infoWindow: InfoWindow(
              title: 'Lat=${_userposition!.latitude.toStringAsFixed(3)},Long:${_userposition!.longitude.toStringAsFixed(3)}',
            ),
            icon: BitmapDescriptor.fromBytes(markIcons),
            onDragEnd:  ((LatLng newPosition) {

            }),

          ));
      polyline.add(
          Polyline(
              polylineId: PolylineId("1"),
              points: polylinevertices,
              color: Colors.blue,
               width:4,
          ),
      );
    });
    if(_startmarker){
      _startmarker=false;
      startmarker.add(
          Marker(
            markerId: MarkerId(_userposition.toString()),
            position: LatLng(_userposition!.latitude,_userposition!.longitude),
            infoWindow: InfoWindow(
              title: 'Lat=${_userposition!.latitude.toStringAsFixed(3)},Long:${_userposition!.longitude.toStringAsFixed(3)}',
            ),
            icon:
            BitmapDescriptor.defaultMarkerWithHue(200),
            onDragEnd:  ((LatLng newPosition) {

            }),

          ));
    }
  }
  void initState(){
    super.initState();
    _gps.startPositionstream(_handlepositionStream);
    //getLocation();
  }
  void _onMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.hybrid
          : MapType.normal;
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget valueget;
    if(_userposition==null){
      valueget= Center(child: CircularProgressIndicator());
    }
    else{
      valueget= Stack(
              children:[
                GoogleMap(
                  //polygons: polygons,
                  // polylines: polyline,
                  myLocationEnabled: true,
                  polylines: polyline,
                  markers: _markers,
                  mapType: _currentMapType,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: Gotposition ? LatLng(_userposition!.latitude, _userposition!.longitude):showLocation,

                    zoom: 20,
                  ),
                  //onTap:_addPoint ,

                  myLocationButtonEnabled: true,


                ),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: FloatingActionButton(
                        onPressed:_onMapType,
                        child:   Icon(Icons.change_circle),
                      ),

                    )
                ),
                Positioned(
                  top: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FloatingActionButton(
                        onPressed:(){
                              _gps.stoppositionStream();


                        },
                        child:  Text("End"),
                      ),

                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FloatingActionButton(
                        onPressed:(){
                          walkdistance=walkDistance()*1000;
                          _gps.stoppositionStream();
                          showDialog(context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  backgroundColor: Colors.red[200],
                                  title: Center(child: Text('Distance in meters:${walkdistance.toStringAsFixed(3)}')),
                                  actions: [
                                    ElevatedButton(onPressed: (){
                                      startmarker.clear();
                                      _startmarker=true;
                                      _markers.clear();
                                      Distancelatlng.clear();
                                      polylinevertices.clear();
                                      _gps.startPositionstream(_handlepositionStream);
                                    }, child: Text("Undo"))
                                  ],
                                );

                              });
                        },
                        child:   Text("   Walk\nDistance"),
                      ),

                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: FloatingActionButton(
                      onPressed:(){
                        distance=CalculateDistance()*1000;
                        var distance1=CalculateDistance();
                        _gps.stoppositionStream();
                        showDialog(context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                backgroundColor: Colors.red[200],
                                title: Column(
                                  children: [
                                    Text('Distance in meters:${distance.toStringAsFixed(3)}'),
                                    Text('Distance in  km:${distance1.toStringAsFixed(3)}'),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(onPressed: (){
                                    startmarker.clear();
                                    _startmarker=true;
                                    _markers.clear();
                                    Distancelatlng.clear();
                                    polylinevertices.clear();
                                    _gps.startPositionstream(_handlepositionStream);
                                  }, child: Text("Undo"))
                                ],
                              );

                            });
                      },
                      child:   Text("Result"),
                    ),

                  ),
                ),
              ]
          );    }
    return SafeArea(
      child: Scaffold(

        body: valueget,
    ),
    );
  }
 double CalculateDistance(){
   int changeindex = Distancelatlng.length;

   double lon1 = Distancelatlng[0].longitude;
   double lon2 = Distancelatlng[changeindex-1].longitude;
   double lat1 = Distancelatlng[0].latitude;
   double lat2 = Distancelatlng[changeindex-1].latitude;

   var p = 0.017453292519943295;
   var c = cos;
   var a = 0.5 - c((lat2 - lat1) * p)/2 +
       c(lat1 * p) * c(lat2 * p) *
           (1 - c((lon2 - lon1) * p))/2;
   return 12742 * asin(sqrt(a));
  }
  double walkDistance(){
    int changeindex = Distancelatlng.length;
    print(changeindex);
    var result = 0.0 ;
    for (int i = 0; i<changeindex-1;i++) {
      double lon1 = Distancelatlng[i].longitude;
      double lon2 = Distancelatlng[i+1].longitude;
      double lat1 = Distancelatlng[i].latitude;
      double lat2 = Distancelatlng[i+1].latitude;

      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 - c((lat2 - lat1) * p)/2 +
          c(lat1 * p) * c(lat2 * p) *
              (1 - c((lon2 - lon1) * p))/2;
      result = result +( 12742 * asin(sqrt(a)));
    }
    return result;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _gps.stoppositionStream();
  }
}