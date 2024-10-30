import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../values/structures.dart';
import 'finds_houses_in_drawing.dart';

typedef HouseTapCallback = void Function(String houseId);

class HouseManager {
  static final HouseManager _instance = HouseManager._internal();
  factory HouseManager() => _instance;
  HouseManager._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<House> _houses = [];
  List<HouseWithDistance> _housesWithDistance = [];
  bool _applyPolygonFilter = false;
  List<Marker> _markers = [];
  int _shownLevel = 5;
  List<LatLng> _lastPolygon = [];
  Map<String, dynamic> _filters = {};
  LatLng _location = LatLng(0, 0);

  final Map<String, List<String>> _regionsAndDistricts = {};

  List<House> get houses => _houses;
  List<Marker> get markers => _markers;
  List<HouseWithDistance> get housesWithDistance => _housesWithDistance;
  LatLng get location => _location;

  int get shownLevel => _shownLevel;
  Map<String, List<String>> get regionsAndDistricts => _regionsAndDistricts;
  bool get applyPolygonFilter => _applyPolygonFilter;
  set location(LatLng value) {
    _location = value;
    fetchHousesWithDistance();
  }

  HouseTapCallback? onHouseTap;

  Future<List<House>> _getDataFromFireStore(
      {Map<String, dynamic>? filters}) async {
    Query query = _db.collection('houses');

    if (filters != null && filters.isNotEmpty) {
      _filters = filters;
      query = _applyFilters(query, _filters);
    }

    final QuerySnapshot snapshot = await query.get();

    List<House> houses = snapshot.docs.map((doc) {
      return houseFromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
    return houses;
  }

  Future<void> fetchHouses({Map<String, dynamic>? filters}) async {
    try {
      _houses = await _getDataFromFireStore(filters: filters);

      if (_filters.isNotEmpty) {
        _updateMarkers(_applyRangeFilters(_houses));
      } else {
        _updateMarkers(_houses);
      }
    } catch (e) {
      throw Exception('Error fetching houses: $e');
    }
  }

  Future<void> fetchHousesWithDistance(
      {Map<String, dynamic>? filters, bool sortWithPrice = false}) async {
    try {
      await _getDataFromFireStore(filters: filters);

      List<House> houses = await _getDataFromFireStore(filters: filters);

      if (_filters.isNotEmpty) {
        houses = _applyRangeFilters(houses);
      }
      _updateHousesWithDistance(houses, sortWithPrice);
    } catch (e) {
      throw Exception('Error fetching houses: $e');
    }
  }

  Query _applyFilters(Query query, Map<String, dynamic> filters) {
    /*
      Prod filters:
      TODO apply screen bounding box algorithm
      query = query.where('Status.isAvailable', isEqualTo: true);
      query = query.where('samsarStatus.expiresAt', isGreaterThan: DateTime.now());
    */

    if (filters['hasParking']) {
      query = query.where('specs.hasParking', isEqualTo: true);
    }

    if (filters['isFurnished']) {
      query = query.where('specs.isFurnished', isEqualTo: true);
    }

    if (filters['isForRent'] && !filters['isForSale']) {
      query = query.where('status.isForRent', isEqualTo: true);
    } else if (!filters['isForRent'] && filters['isForSale']) {
      query = query.where('status.isForSale', isEqualTo: true);
    }

    if (filters['isMonthlyPayment'] || filters['isDailyPayment']) {
      if (filters['isMonthlyPayment'] && !filters['isDailyPayment']) {
        query = query.where('status.isMonthlyPayment', isEqualTo: true);
      } else if (!filters['isMonthlyPayment'] && filters['isDailyPayment']) {
        query = query.where('status.isDailyPayment', isEqualTo: true);
      }
    }

    if (filters['is3D']) {
      query = query.where('samsarStatus.is3D', isEqualTo: true);
    }

    if (filters['selectedRegion'].isNotEmpty) {
      query =
          query.where('location.region', isEqualTo: filters['selectedRegion']);
    }
    if (filters['selectedDistrict'].isNotEmpty) {
      query =
          query.where('location.city', isEqualTo: filters['selectedDistrict']);
    }
    return query;
  }

  List<House> _applyRangeFilters(List<House> houses) {
    if (_filters.isNotEmpty) {
      RangeValues priceRange =
          _filters['priceRange'] ?? RangeValues(100, 10000);
      RangeValues sizeRange = _filters['sizeRange'] ?? RangeValues(30, 500);
      RangeValues bedroomsRange =
          _filters['bedroomsRange'] ?? RangeValues(0, 10);
      RangeValues floorRange = _filters['floorRange'] ?? RangeValues(0, 10);

      final filteredHouses = houses.where((house) {
        if (priceRange.start > 100 || priceRange.end < 10000) {
          final price = house.specs.price;
          if (price < priceRange.start || price > priceRange.end) return false;
        }

        if (sizeRange.start > 30 || sizeRange.end < 500) {
          final area = house.specs.area;
          if (area < sizeRange.start || area > sizeRange.end) return false;
        }

        if (bedroomsRange.start > 0 || bedroomsRange.end < 10) {
          final bedrooms = house.specs.rooms;
          if (bedrooms < bedroomsRange.start || bedrooms > bedroomsRange.end) {
            return false;
          }
        }

        if (floorRange.start > 0 || floorRange.end < 10) {
          final floor = house.specs.floor;
          if (floor < floorRange.start || floor > floorRange.end) return false;
        }

        return true;
      }).toList();
      return filteredHouses;
    } else {
      return houses;
    }
  }

  void _updateMarkers(List<House> newHouses) {
    List<House> filteredHouses = _localFiltersUpdate(newHouses);
    if (_applyPolygonFilter) {
      filteredHouses = getHousesInsidePolygon(filteredHouses, _lastPolygon);
    }
    filteredHouses =
        filteredHouses.where((house) => house.priorityLevel >= 0).toList();
    _markers = filteredHouses.map((house) => _createMarker(house)).toList();
  }

  void _updateHousesWithDistance(List<House> newHouses, bool sortWithPrice) {
    List<House> filteredHouses = _localFiltersUpdate(newHouses);
    _housesWithDistance = _sortHouses(
        filteredHouses, _location.latitude, _location.longitude, sortWithPrice);
  }

  List<House> _localFiltersUpdate(List<House> housesToFilter) {
    List<House> filteredHouses = _applyRangeFilters(housesToFilter);

    if (_filters.isNotEmpty) {
      filteredHouses = filteredHouses.where((house) {
        if (_filters['hasParking']) {
          if (!house.specs.hasParking) return false;
        }

        if (_filters['isFurnished']) {
          if (!house.specs.isFurnished) return false;
        }

        if (_filters['isForRent'] && !_filters['isForSale']) {
          if (!house.status.isForRent) return false;
        } else if (!_filters['isForRent'] && _filters['isForSale']) {
          if (!house.status.isForSale) return false;
        }

        if (_filters['isMonthlyPayment'] || _filters['isDailyPayment']) {
          if (_filters['isMonthlyPayment'] && !_filters['isDailyPayment']) {
            if (!house.status.isMonthlyPayment) return false;
          } else if (!_filters['isMonthlyPayment'] &&
              _filters['isDailyPayment']) {
            if (!house.status.isDailyPayment) return false;
          }
        }

        if (_filters['is3D']) {
          if (!house.samsarStatus.is3D) return false;
        }

        if (_filters['selectedRegion'].isNotEmpty) {
          if (house.location.region != _filters['selectedRegion']) return false;
        }

        if (_filters['selectedDistrict'].isNotEmpty) {
          if (house.location.city != _filters['selectedDistrict']) return false;
        }

        return true;
      }).toList();

      return filteredHouses;
    } else {
      return housesToFilter;
    }
  }

  void _addToRegionsAndDistricts(House house) {
    if (!_regionsAndDistricts.containsKey(house.location.region)) {
      _regionsAndDistricts[house.location.region] = [house.location.city];
    } else if (!_regionsAndDistricts[house.location.region]!
        .contains(house.location.city)) {
      _regionsAndDistricts[house.location.region]!.add(house.location.city);
    }
  }

  Marker _createMarker(House house) {
    _addToRegionsAndDistricts(house);
    return Marker(
      point: LatLng(house.location.latitude, house.location.longitude),
      width: 40,
      height: 40,
      rotate: true,
      child: GestureDetector(
        onTap: () {
          if (onHouseTap != null) {
            onHouseTap!(house.id);
          }
        },
        child: Image.asset(
          'assets/icons/home_loc.png',
          height: 40,
          width: 40,
        ),
      ),
    );
  }

  void updateShownLevel(int level) {
    _shownLevel = level;
    _updateMarkers(_localFiltersUpdate(_houses));
  }

  void updateHouses(List<House> houses) {
    _updateMarkers(houses);
  }

  void findHousesInsidePolygon(List<LatLng> polygon) {
    _applyPolygonFilter = true;
    _lastPolygon = polygon;
    List<House> insidePolygon = getHousesInsidePolygon(_houses, polygon);
    List<House> filteredAndInsidePolygon = _localFiltersUpdate(insidePolygon);
    _updateMarkers(filteredAndInsidePolygon);
  }

  void turnOffPolygonFilter() {
    _applyPolygonFilter = false;
    _lastPolygon = [];
  }

  Future<House> getHouseById(String id) async {
    for (House house in _houses) {
      if (house.id == id) return house;
    }

    final doc = await _db.collection('houses').doc(id).get();

    if (doc.exists && doc.data() != null) {
      return houseFromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    } else {
      throw Exception("House with ID $id not found");
    }
  }

  List<HouseWithDistance> _sortHouses(List<House> houses, double latitude,
      double longitude, bool sortWithPrice) {
    final housesWithDistance = houses.map((house) {
      final distance = Geolocator.distanceBetween(
        latitude,
        longitude,
        house.location.latitude,
        house.location.longitude,
      );
      return HouseWithDistance(house, distance);
    }).toList();

    if (!sortWithPrice) {
      housesWithDistance.sort((a, b) => a.distance.compareTo(b.distance));
    } else {
      housesWithDistance
          .sort((a, b) => a.house.specs.price.compareTo(b.house.specs.price));
    }
    return housesWithDistance;
  }

}
