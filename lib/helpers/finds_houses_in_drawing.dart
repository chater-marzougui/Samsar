import 'dart:math';

import 'package:latlong2/latlong.dart';

import '../values/structures.dart';

class Point {
  double x, y;
  Point(this.x, this.y);

  Point operator +(Point other) {
    return Point(x + other.x, y + other.y);
  }

  Point operator -(Point other) {
    return Point(x - other.x, y - other.y);
  }
}

double crossProduct(Point A, Point B){
  return  A.x * B.y - A.y * B.x;
}

int sign(double x) {
  if (x > 0) return 1;
  if (x < 0) return -1;
  return 0;
}

String isInside(House house, List<LatLng> polygon) {
  int n = polygon.length;
  int num = 0;

  for (int i = 0; i < n; i++) {
    int j = (i + 1) % n;
    Point B = Point(house.location.latitude, 0);

    if (polygon[i].latitude == polygon[j].latitude) {
      if (house.location.latitude == polygon[i].latitude &&
          house.location.longitude <=
              max(polygon[i].longitude, polygon[j].longitude) &&
          house.location.longitude >=
              min(polygon[i].longitude, polygon[j].longitude)) {
        return "BOUNDARY";
      }
      continue;
    }

    double b =
        (polygon[i].longitude * (polygon[i].latitude - polygon[j].latitude) -
                polygon[i].latitude *
                    (polygon[i].longitude - polygon[j].longitude)) /
            (polygon[i].latitude - polygon[j].latitude);
    double a = (polygon[i].longitude - polygon[j].longitude) /
        (polygon[i].latitude - polygon[j].latitude);
    B.y = b + a * house.location.latitude;

    if (B.y < house.location.longitude) continue;
    if ((house.location.longitude - B.y).abs() < 1e-6 &&
        house.location.latitude <=
            max(polygon[i].latitude, polygon[j].latitude) &&
        house.location.latitude >=
            min(polygon[i].latitude, polygon[j].latitude)) {
      return "BOUNDARY";
    }

    if (B.x < max(polygon[i].latitude, polygon[j].latitude) &&
        B.x > min(polygon[i].latitude, polygon[j].latitude)) num++;
  }
  for (int i = 0; i < n; i++) {
    if (polygon[i].latitude == house.location.latitude && polygon[i].longitude > house.location.longitude) {
      Point L = Point(0, 0), M = Point(0, 0);
      L.x = polygon[i].latitude; L.y = polygon[i].longitude;
      M.x = house.location.latitude;M.x = house.location.longitude;
      Point polygonIM1 = Point(polygon[(i - 1 + n) % n].latitude, polygon[(i - 1 + n) % n].longitude);
      Point polygonIP1 = Point(polygon[(i + 1) % n].latitude, polygon[(i + 1) % n].longitude);
      if (sign(crossProduct( L - M, polygonIM1 - L)) != sign(crossProduct(L - M, polygonIP1 - L))) {
        num++;
      }
    }
  }
  if (num % 2 != 0) return "INSIDE";
  return "OUTSIDE";
}



List<House> getHousesInsidePolygon(List<House> houses, List<LatLng> polygon) {
  List<House> insideHouses = [];

  for (House house in houses) {
    String position = isInside(house, polygon);
    if (position != "OUTSIDE") {
      insideHouses.add(house);
    }
  }

  return insideHouses;
}
