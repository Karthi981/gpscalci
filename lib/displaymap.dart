
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import 'mathutil.dart';



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

  // static double calculatePolygonArea(List coordinates) {
  //   double area = 0;
  //
  //   if (coordinates.length > 2) {
  //     for (var i = 0; i < coordinates.length - 1; i++) {
  //       var p1 = coordinates[i];
  //       var p2 = coordinates[i + 1];
  //       area += convertToRadian(p2.longitude - p1.longitude) *
  //           (2 +
  //               Math.sin(convertToRadian(p1.latitude)) +
  //               Math.sin(convertToRadian(p2.latitude)));
  //     }
  //
  //     area = area * 6378137 * 6378137 / 2;
  //   }
  //
  //   return area.abs() * 0.000247105;  //sq meters to Acres
  // }





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

      double lon1 = points[0].longitude;
      double lon2 = points[changeindex-1].longitude;
      double lat1 = points[0].latitude;
      double lat2 = points[changeindex-1].latitude;

      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 - c((lat2 - lat1) * p)/2 +
          c(lat1 * p) * c(lat2 * p) *
              (1 - c((lon2 - lon1) * p))/2;
      return 12742 * asin(sqrt(a));



  }
  num CalculateArea(){
    final p1 = polygonpoints[0];
    final p2 = polygonpoints[1];
    final p3 = polygonpoints[2];
    final p4 = polygonpoints[3];
    polygonpoints.add(polygonpoints[0]);
    areapoints= polygonpoints;
    print(areapoints);
    return computeArea([p1,p2,p3,p4,p1]);
  }
  static const num earthRadius = 6371009.0;
  static num computeArea(List<LatLng> path) => computeSignedArea(path).abs();

  /// Returns the signed area of a closed path on Earth. The sign of the area
  /// may be used to determine the orientation of the path.
  /// "inside" is the surface that does not contain the South Pole.
  /// @param path A closed path.
  /// @return The loop's area in square meters.
  static num computeSignedArea(List<LatLng> path) =>
      _computeSignedArea(path, earthRadius);

  /// Returns the signed area of a closed path on a sphere of given radius.
  /// The computed area uses the same units as the radius squared.
  /// Used by SphericalUtilTest.
  static num _computeSignedArea(List<LatLng> path, num radius) {
    if (path.length < 3) {
      return 0;
    }

    final prev = path.last;
    var prevTanLat = tan((pi / 2 - MathUtil.toRadians(prev.latitude)) / 2);
    var prevLng = MathUtil.toRadians(prev.longitude);

    // For each edge, accumulate the signed area of the triangle formed by the
    // North Pole and that edge ("polar triangle").
    final total = path.fold<num>(0.0, (value, point) {
      final tanLat = tan((pi / 2 - MathUtil.toRadians(point.latitude)) / 2);
      final lng = MathUtil.toRadians(point.longitude);

      value += _polarTriangleArea(tanLat, lng, prevTanLat, prevLng);

      prevTanLat = tanLat;
      prevLng = lng;

      return value;
    });

    return total * (radius * radius);
  }
  static num _polarTriangleArea(num tan1, num lng1, num tan2, num lng2) {
    final deltaLng = lng1 - lng2;
    final t = tan1 * tan2;
    return 2 * atan2(t * sin(deltaLng), 1 + t * cos(deltaLng));
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