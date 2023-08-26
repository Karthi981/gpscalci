import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'mathutil.dart';

class AreaCalci{
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
}