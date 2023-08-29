import 'dart:async';


import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gpscalci/Calculate%20area.dart';

import 'Gps.dart';


class Walkarea extends StatefulWidget {
  const Walkarea({super.key});


  @override
  State<Walkarea> createState() => _WalkareaState();
}

class _WalkareaState extends State<Walkarea> {

  final Gps _gps= Gps();
  Position? _userposition;
  List<LatLng> polygonVertices = [];
  final Set<Polygon> polygons = {};
  final Set<Polyline> polyline={};
  Set<Marker> _markers={};
  ///////////////////////
  void _handlepositionStream(Position position){
    setState(() {
      _markers.clear();
      _userposition=position;
      _markers.add(
          Marker(
            markerId: MarkerId(_userposition.toString()),
            position: LatLng(_userposition!.latitude,_userposition!.longitude),
            infoWindow: InfoWindow(
              title: 'Lat=${_userposition!.latitude.toStringAsFixed(3)},Long:${_userposition!.longitude.toStringAsFixed(3)}',
            ),
            icon:
            BitmapDescriptor.defaultMarker,
            onDragEnd:  ((LatLng newPosition) {

            }),

          ));

    });

  }
  //////////////////
  MapType _currentMapType = MapType.normal;
  void _onMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.hybrid
          : MapType.normal;
    });
  }
  //////////////////
  Completer<GoogleMapController> _controller = Completer();
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);


    });

  }
  //////////////////////////
  void initState()
  {
    super.initState();
    _gps.startPositionstream(_handlepositionStream);
  }

  @override
  Widget build(BuildContext context) {

    Widget content;
    if(_userposition==null)
    {content=Center(child: CircularProgressIndicator());}
    else
    { content=SafeArea(
      child: Stack(
          children:[
            GoogleMap(
              markers: _markers,
              polylines: polyline,
              polygons: polygons,



              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType:_currentMapType,
              onMapCreated: _onMapCreated,

              initialCameraPosition: CameraPosition(
                target: LatLng(_userposition!.latitude, _userposition!.longitude),

                zoom: 20,
              ),),
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
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: FloatingActionButton(
                    onPressed:(){
                      setState(() {
                        _markers.add(
                            Marker(
                              markerId: MarkerId(_userposition.toString()),
                              position: LatLng(_userposition!.latitude,_userposition!.longitude),
                              infoWindow: InfoWindow(
                                title: 'Lat=${_userposition!.latitude.toStringAsFixed(3)},Long:${_userposition!.longitude.toStringAsFixed(3)}',
                              ),
                              icon:
                              BitmapDescriptor.defaultMarker,
                              onDragEnd:  ((LatLng newPosition) {

                              }),

                            ));
                        polygonVertices.add(LatLng(_userposition!.latitude,_userposition!.longitude));
                        polygons.add(
                            Polygon(
                              polygonId: PolygonId('my_polygon'),
                              points: polygonVertices,
                              fillColor: Colors.blue.withOpacity(0.3),
                              strokeColor: Colors.amberAccent,
                              geodesic: true,
                              consumeTapEvents: true,
                              visible: true,
                              strokeWidth: 4,
                            )
                        );
                      });


                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:  Column(
                          children: [
                            Text('added'),


                          ],
                        ),

                      )
                      );
                    },
                    child: Column(
                      children: [
                        const Icon(Icons.add_location_alt),
                        Text("Point")
                      ],
                    ),
                  ),

                )
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FloatingActionButton(
                    onPressed:(){

                      var res=calculatearea();
                      var acre=calculatearea()*0.000247105;
                      _gps.stoppositionStream();








                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:  Column(
                          children: [
                            Text('${res.toString()}((AREA))'),
                            Text('${acre.toString()}((ACRE))'),


                          ],
                        ),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            setState(() {
                              _markers.clear();
                              polygonVertices.clear();
                              _gps.startPositionstream(_handlepositionStream);

                            });
                          },
                        ),
                      )
                      );
                    },
                    child:   Icon(Icons.area_chart),
                  ),

                )
            ),




          ] ),
    );
    }
    return Scaffold(
      body: content,
    );
  }
  double calculatearea () {
    var area;
    if(polygonVertices.length>=3)
    {

      final p1 = polygonVertices[0];
      final p2 = polygonVertices[1];
      final p3 = polygonVertices[2];
      final p4 = polygonVertices[3];
      area = AreaCalci.computeArea([p1, p2, p3, p4, p1]);
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:  Text("need more points to calculte area"),

      ));
    }
    return area;



  }
  ///////////
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _gps.stoppositionStream();
  }
}