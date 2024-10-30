// NominatimReverse class
part of 'structures.dart';

class NominatimReverse {
  double lat;
  double lon;
  String addressType;
  String name;
  String displayName;
  Address address;
  List<String> boundingBox;

  NominatimReverse(
      {required this.lat,
      required this.lon,
      required this.addressType,
      required this.name,
      required this.displayName,
      required this.address,
      required this.boundingBox});

  factory NominatimReverse.fromJson(Map<String, dynamic> json) {
    return NominatimReverse(
        lat: double.parse(json['lat']),
        lon: double.parse(json['lon']),
        addressType: json['addresstype'],
        name: json['name'],
        displayName: json['display_name'],
        address: Address.fromJson(json['address']),
        boundingBox: List<String>.from(json['boundingbox']));
  }
}

class Address {
  String road;
  String suburb;
  String village;
  String stateDistrict;
  String state;
  String postcode;
  String county;
  String country;
  String countryCode;

  Address(
      {required this.road,
      required this.village,
      required this.suburb,
      required this.stateDistrict,
      required this.state,
      required this.postcode,
      required this.county,
      required this.country,
      required this.countryCode});

  // factory Address.fromJson(Map<String, dynamic> json) {
  //   bool _isNormalType = json['country'] != null;
  //   if(_isNormalType) {
  //     return Address(
  //       road: json['road'] ?? "",
  //       suburb: json['suburb'] ?? "",
  //       village: json['village'] ?? "",
  //       stateDistrict: json['state_district'] ?? "",
  //       state: json['state'] ?? "",
  //       postcode: json['postcode'] ?? "",
  //       county: json['postcode'] ?? "",
  //       country: json['country'] ?? "",
  //       countryCode: json['country_code'] ?? "");
  //   } else {
  //     for (var component in location.addressComponents!) {
  //       print('${component.type}: ${component.localname}');
  //     }
  //   }
  // }
  factory Address.fromJson(Map<String, dynamic> json) {
    bool isNormalType = json['country'] != null;

    if (isNormalType) {
      return Address(
        road: json['road'] ?? "",
        suburb: json['suburb'] ?? "",
        village: json['village'] ?? "",
        stateDistrict: json['state_district'] ?? "",
        state: json['state'] ?? "",
        postcode: json['postcode'] ?? "",
        county: json['county'] ?? "",
        country: json['country'] ?? "",
        countryCode: json['country_code'] ?? "",
      );
    } else {
      String road = "";
      String suburb = "";
      String village = "";
      String stateDistrict = "";
      String state = "";
      String postcode = "";
      String county = "";
      String country = "";
      String countryCode = "";

      final List<dynamic> components = json.values as List<dynamic>;

      for (var component in components) {
        switch (component['type']) {
          case 'road':
          case 'residential':
            road = component['localname'] ?? "";
            break;
          case 'suburb':
            suburb = component['localname'] ?? "";
            break;
          case 'village':
            village = component['localname'] ?? "";
            break;
          case 'administrative':
          // Check admin_level to determine the type of administrative division
            switch (component['admin_level']) {
              case 4:
                state = component['localname'] ?? "";
                break;
              case 5:
                stateDistrict = component['localname'] ?? "";
                break;
              case 6:
                county = component['localname'] ?? "";
                break;
            }
            break;
          case 'postcode':
            postcode = component['localname'] ?? "";
            break;
          case 'country':
            country = component['localname'] ?? "";
            break;
          case 'country_code':
            countryCode = component['localname'] ?? "";
            break;
        }
      }

      return Address(
        road: road,
        suburb: suburb,
        village: village,
        stateDistrict: stateDistrict,
        state: state,
        postcode: postcode,
        county: county,
        country: country,
        countryCode: countryCode,
      );
    }
  }
}


Future<NominatimReverse> getLocationFromLatLong(double lat, double long) async {
  try {
    final UserManager userManager = UserManager();
    final response = await http.get(
      Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$long'),
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'samsar/0.2.0',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = NominatimReverse.fromJson(jsonDecode(response.body));
      userManager.countryCode = jsonData.address.countryCode;
      userManager.stringLocation = _setCurrentLocation(jsonData.address);
      SearchScreen.refreshPage?.call();
      return jsonData;
    } else {
      throw Exception('Failed to load location data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error getting location data: $e');
  }
}

String _setCurrentLocation(Address address) {
  String loc;
  if (address.county != "") {
    loc = address.county;
  } else if (address.suburb != "") {
    loc = address.suburb;
  } else if (address.stateDistrict != "") {
    loc = address.stateDistrict;
  } else if (address.state != "") {
    loc = address.state;
  } else if (address.village != "") {
    loc = address.village;
  } else {
    loc = address.country;
  }
  return loc;
}