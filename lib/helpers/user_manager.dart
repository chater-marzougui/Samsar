import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:samsar/helpers/house_manager.dart';
import '../values/structures.dart';

class UserManager with WidgetsBindingObserver {
  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;

  UserManager._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final HouseManager _houseManager = HouseManager();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User? _user;

  SamsarUser? samsarUser;
  List<House> houses = [];
  List<House> favouriteHouses = [];
  LatLng _location = LatLng(36.8002275, 10.186199454411298);
  String stringLocation = "";
  String countryCode = "tn";

  LatLng get location => _location;

  set location(LatLng value) {
    _location = value;
    _houseManager.location = value;
  }

  Future<void> _checkAndRequestPermissions() async {
    var locationStatus = await Permission.location.status;

    if (!locationStatus.isGranted) {
      await Permission.location.request();
    }

    // var storageStatus = await Permission.storage.status;
    // if (!storageStatus.isGranted) {
    //   await Permission.storage.request();
    // }
  }

  Future<void> _getUserLocation() async {
    await _checkAndRequestPermissions();
    await _getUserLocationFromGPS();
  }

  Future<void> loadUserData() async {
    _user = _auth.currentUser;
    await _getUserLocation();
    final DocumentSnapshot snapshot =
        await _db.collection('users').doc(_user!.uid).get();

    samsarUser = samsarUserFromFirestore(snapshot);

    updateUserHouses();
  }

  Future<void> updateUserHouses() async {
    List<String> favoritesAndOwn = List.from(samsarUser !.favouriteHouses);
    favoritesAndOwn.addAll(samsarUser !.houses);
    final housesQuery = await _db
        .collection('houses')
        .where(FieldPath.documentId, whereIn: favoritesAndOwn)
        .get();

    favouriteHouses = housesQuery.docs
        .where((doc) => samsarUser !.favouriteHouses.contains(doc.id))
        .map((doc) => houseFromFirestore(doc.data(), doc.id))
        .toList();

    houses = housesQuery.docs
        .where((doc) => samsarUser !.houses.contains(doc.id))
        .map((doc) => houseFromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<void> _getLocationFromIP() async {
    try {
      final response = await http.get(Uri.parse('https://ipapi.co/json/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _setLocation(LatLng(data['latitude'], data['longitude']));

        countryCode = data['country_code'].toLowerCase();
      } else {
        throw Exception('Failed to get location from IP');
      }
    } catch (e) {
      _setLocation(LatLng(36.8002275, 10.186199454411298));
    }
  }

  Future<void> _getUserLocationFromGPS() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _getLocationFromIP();
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      _setLocation(LatLng(position.latitude, position.longitude));
    } catch (e) {
      await _getLocationFromIP();
    }
  }

  void _setLocation(LatLng position) {
    _location = position;
    _houseManager.location = position;
  }

  Future<bool> toggleFavorite(String houseId, bool isFavorite) async {
    try {
      final userRef = _db.collection('users').doc(_user!.uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final userDoc = await transaction.get(userRef);
        List<String> favoriteHouses =
            List<String>.from(userDoc.data()?['favouriteHouses'] ?? []);

        if (isFavorite) {
          favoriteHouses.remove(houseId);
        } else {
          favoriteHouses.add(houseId);
        }

        transaction.update(userRef, {'favouriteHouses': favoriteHouses});
      });

      await loadUserData();
      return samsarUser?.favouriteHouses.contains(houseId) ?? false;
    } catch (e) {
      rethrow; // Re-throwing the error to handle in the screen
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveLastLocation() async {
    if (_user != null) {
      await _db.collection('users').doc(_user!.uid).update({
        'desiredLocation': {
          'latitude': _houseManager.location.latitude,
          'longitude': _houseManager.location.longitude,
        },
      });
    }
  }

  Future<void> rateHouse(Rating rating, House house) async {
    try {
      final currentRatings = house.ratings;
      final existingRatingIndex =
          currentRatings.indexWhere((r) => r.uid == rating.uid);
      final bool isUpdate = existingRatingIndex != -1;

      // Prepare the ratings array update
      Map<String, dynamic> updateData;
      if (isUpdate) {
        // For update: remove old rating, add new rating
        final previousRating = currentRatings[existingRatingIndex];
        currentRatings[existingRatingIndex] = rating;
        updateData = {
          'rate.totalRating': FieldValue.increment(
              rating.rate.round() - previousRating.rate.round()),
          'ratings': currentRatings.map((r) => r.toMap()).toList(),
        };
      } else {
        // For new rating: increment raters, add rating value, append to ratings array
        updateData = {
          'rate.raters': FieldValue.increment(1),
          'rate.totalRating': FieldValue.increment(rating.rate.round()),
          'ratings': FieldValue.arrayUnion([rating.toMap()]),
        };
      }

      await _db.collection('houses').doc(house.id).update(updateData);

      if (!isUpdate) {
        await _db.collection('users').doc(_user!.uid).update({
          'ratedHouses': FieldValue.arrayUnion([house.id])
        });
        samsarUser?.ratedHouses.add(house.id);
      }

      await _houseManager.fetchHouses();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRating(Rating rating, House house) async {
    try {
      final currentRatings = house.ratings;
      final existingRatingIndex =
          currentRatings.indexWhere((r) => r.uid == rating.uid);
      if (existingRatingIndex == -1) {
        return;
      }

      final previousRating = currentRatings[existingRatingIndex];
      currentRatings.removeAt(existingRatingIndex);

      // Prepare the ratings array update
      final updateData = {
        'rate.raters': FieldValue.increment(-1),
        'rate.totalRating': FieldValue.increment(-previousRating.rate.round()),
        'ratings': currentRatings.map((r) => r.toMap()).toList(),
      };

      // Update house document with atomic operations
      await _db.collection('houses').doc(house.id).update(updateData);

      // Update user's rated houses
      await _db.collection('users').doc(_user!.uid).update({
        'ratedHouses': FieldValue.arrayRemove([house.id])
      });
      samsarUser?.ratedHouses.remove(house.id);

      await _houseManager.fetchHouses();
    } catch (e) {
      rethrow;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      saveLastLocation();
    }
  }
}
