import 'dart:async';
import 'package:flutter/material.dart';
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

 final Gps _gps= Gps();
 Position? _userposition;
 Exception? _exception;

  MapType _currentMapType = MapType.normal;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers={};
  final Set<Polyline> polyline={};
  List<LatLng> polylinevertices=[];
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);


    });

  }

  void _handlepositionStream(Position position){
    setState(() {
      _userposition=position;
    });
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

  ///permission
  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled');
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //
  //     if (permission == LocationPermission.denied) {
  //       return Future.error("Location permission denied");
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error('Location permissions are permanently denied');
  //   }
  //
  //   Position position = await Geolocator.getCurrentPosition();
  //
  //   return position;
  // }

  ///get location
  getLocation() async {

    setState(() {
      polylinevertices.add(LatLng(_userposition!.latitude,_userposition!.longitude));
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
      });
      polyline.add(
          Polyline(polylineId: PolylineId("1"),
              points: polylinevertices,
              color: Colors.blue

          )
      );
    }  );
    CameraPosition cameraPosition = new CameraPosition(
      target: LatLng(_userposition!.latitude, _userposition!.longitude),
      zoom: 24,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
    // setState(() {
    //   polylinevertices.add(LatLng(loca.latitude!,loca.longitude!));
    //   _markers.add(
    //       Marker(
    //         markerId: MarkerId(loca.toString()),
    //         position: LatLng(loca.latitude!,loca.longitude!),
    //         infoWindow: InfoWindow(
    //           title: 'Lat=${position.latitude.toStringAsFixed(3)},Long:${position.longitude.toStringAsFixed(3)}',
    //         ),
    //         icon:
    //         BitmapDescriptor.defaultMarker,
    //         onDragEnd:  ((LatLng newPosition) {
    //
    //         }),
    //
    //       ));
    //   polyline.add(
    //       Polyline(polylineId: PolylineId("1"),
    //           points: polylinevertices,
    //           color: Colors.blue
    //
    //       ));
    //
    // });

  }
  ///
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: Stack(
            children:[
              GoogleMap(
                //polygons: polygons,
                // polylines: polyline,
                myLocationEnabled: true,

                markers: _markers,
                mapType: _currentMapType,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(_userposition!.latitude, _userposition!.longitude),

                  zoom: 12,
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
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: FloatingActionButton(
                      onPressed:getLocation,
                      child:   Column(
                        children: [
                          Icon(Icons.location_on_outlined),
                          Text("start")
                        ],
                      ),
                    ),

                  )
              ),
            ]
        ),

    ),
    );
  }






  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _gps.stoppositionStream();
  }
}