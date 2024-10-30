part of 'structures.dart';


extension HouseConversion on House {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'priorityLevel': priorityLevel,
      'images': images,
      'comment': comment,
      'owner': {
        'id': owner.id,
        'name': owner.name,
        'prename': owner.prename,
        'email': owner.email,
        'phone': owner.phone,
      },
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
        'address': location.address,
        'city': location.city,
        'region': location.region,
      },
      'specs': {
        'price': specs.price,
        'salePrice': specs.salePrice,
        'floor': specs.floor,
        'rooms': specs.rooms,
        'area': specs.area,
        'hasLivingRoom': specs.hasLivingRoom,
        'hasParking': specs.hasParking,
        'hasWifi': specs.hasWifi,
        'isFurnished': specs.isFurnished,
        'features': specs.features,
        'furniture': specs.furniture,
        'type': specs.type,
      },
      'rate': {
        'raters': rate.raters,
        'totalRating': rate.totalRating,
      },
      'ratings': ratings.map((rating) => rating.toMap()).toList(),
      'samsarStatus': {
        'is3D': samsarStatus.is3D,
        'link3D': samsarStatus.link3D,
        'paidAt': samsarStatus.paidAt,
        'expiresAt': samsarStatus.expiresAt,
      },
      'status': {
        'isAvailable': status.isAvailable,
        'isForRent': status.isForRent,
        'isForSale': status.isForSale,
        'isMonthlyPayment': status.isMonthlyPayment,
        'isDailyPayment': status.isDailyPayment,
      },
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

House houseFromFirestore(Map<String, dynamic> data, String id) {
  try {
    return (
    id: id,
    priorityLevel: data['priorityLevel'] ?? 5,
    images: List<String>.from(data['images'] ?? []),
    comment: data['comment'] ?? '',
    owner: (
      id: data['owner']['id'] ?? '',
      name: data['owner']['name'] ?? '',
      prename: data['owner']['prename'] ?? '',
      email: data['owner']['email'] ?? '',
      phone: data['owner']['phone'] ?? '',
    ),
    location: (
      latitude: data['location']['latitude']?.toDouble() ?? 0.0,
      longitude: data['location']['longitude']?.toDouble() ?? 0.0,
      address: data['location']['address'] ?? '',
      city: data['location']['city'] ?? '',
      region: data['location']['region'] ?? '',
    ),
    specs: (
      price: data['specs']['price'] ?? 0,
      salePrice: data['specs']['salePrice'] ?? 0,
      floor: data['specs']['floor'] ?? 0,
      rooms: data['specs']['rooms'] ?? 0,
      area: data['specs']['area']?.toDouble() ?? 0.0,
      hasLivingRoom: data['specs']['hasLivingRoom'] ?? false,
      hasParking: data['specs']['hasParking'] ?? false,
      hasWifi: data['specs']['hasWifi'] ?? false,
      isFurnished: data['specs']['isFurnished'] ?? false,
      features: List<String>.from(data['specs']['features'] ?? []),
      furniture: List<String>.from(data['specs']['furniture'] ?? []),
      type: data['specs']['type'] ?? '',
    ),
    rate: (
      raters: data['rate']['raters'] ?? 0,
      totalRating: data['rate']['totalRating'] ?? 0,
    ),
    ratings: (data['ratings'] as List?)
        ?.map((item) => RatingConversion.fromMap(item as Map<String, dynamic>))
        .toList() ?? [],
    samsarStatus: (
      is3D: data['samsarStatus']['is3D'] ?? false,
      link3D: data['samsarStatus']['link3D'] ?? '',
      paidAt: (data['samsarStatus']['paidAt'] as Timestamp?)?.toDate(),
      expiresAt: (data['samsarStatus']['expiresAt'] as Timestamp?)?.toDate(),
    ),
    status: (
      isAvailable: data['status']['isAvailable'] ?? false,
      isForRent: data['status']['isForRent'] ?? false,
      isForSale: data['status']['isForSale'] ?? false,
      isMonthlyPayment: data['status']['isMonthlyPayment'] ?? false,
      isDailyPayment: data['status']['isDailyPayment'] ?? false,
    ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    ) as House;
  } catch (e) {
    rethrow;
  }
}

extension RatingConversion on Rating {
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'imageUrl': imageUrl,
      'rate': rate,
      'comment': comment,
      'timestamp': timestamp,
    };
  }

  static Rating fromMap(Map<String, dynamic> map) {
    return (
    uid: map['uid'] as String,
    displayName: map['displayName'] as String,
    imageUrl: map['imageUrl'] as String,
    rate: (map['rate'] as num).toDouble(),
    comment: map['comment'] as String,
    timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

class HouseWithDistance {
  final House house;
  final double distance;

  HouseWithDistance(this.house, this.distance);
}

typedef House = ({
  String id,
  int priorityLevel,
  List<String> images,
  String comment,
  Owner owner,
  Location location,
  Specs specs,
  Rate rate,
  List<Rating> ratings,
  SamsarStatus samsarStatus,
  Status status,
  DateTime createdAt,
  DateTime updatedAt,
});

typedef Location = ({
  double latitude,
  double longitude,
  String address,
  String city,
  String region,
});

typedef Rate = ({
  int raters,
  int totalRating,
});

typedef Rating = ({
  String uid,
  String displayName,
  String imageUrl,
  double rate,
  String comment,
  DateTime timestamp,
});

typedef Status = ({
  bool isAvailable,
  bool isForRent,
  bool isForSale,
  bool isMonthlyPayment,
  bool isDailyPayment,
});

typedef Specs = ({
  int price,
  int salePrice,
  int floor, // 0 for ground floor
  int rooms,
  double area,
  bool hasLivingRoom,
  bool hasParking,
  bool hasWifi,
  bool isFurnished,
  List<String> features,
  List<String> furniture,
  String type,
});

typedef SamsarStatus = ({
  bool is3D,
  String link3D,
  DateTime paidAt,
  DateTime expiresAt,
});

typedef Owner = ({
  String id,
  String name,
  String prename,
  String email,
  String phone,
});