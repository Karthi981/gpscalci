import 'dart:async';

import 'package:geolocator/geolocator.dart';


typedef PositionCallback = Function (Position position);

class Gps{

  late StreamSubscription<Position> _positionstream;

  bool isAccessGranted(LocationPermission permission){
    return permission==LocationPermission.whileInUse||permission==LocationPermission.always;
  }
  Future<bool>requestpermission()async{
    LocationPermission permission=await Geolocator.checkPermission();
    if(isAccessGranted(permission)){
      return true;
    }
      permission = await Geolocator.requestPermission();
    return isAccessGranted(permission);
    }
  Future<void> startPositionstream(Function(Position position) callback)async{
  bool permissionGranted= await requestpermission();
  if(!permissionGranted){
    throw Exception("User did not Grant permission");
  }
  _positionstream= await Geolocator.getPositionStream(
    locationSettings: LocationSettings(accuracy: LocationAccuracy.high)
  ).listen((callback) );
  }

  Future<void> stoppositionStream()async{
    await _positionstream.cancel();
  }
}