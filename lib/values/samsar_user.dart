part of 'structures.dart';

typedef SamsarUser = ({
  String uid,
  String email,
  String displayName,
  String firstName,
  String middleName,
  String lastName,
  String? phoneNumber,
  String gender,
  DateTime birthdate,
  DateTime createdAt,
  String profileImage,
  List<String> houses,
  List<String> favouriteHouses,
  List<String> ratedHouses,
  LatLng desiredLocation,
});

SamsarUser samsarUserFromFirestore(DocumentSnapshot snapshot) {
  final data = snapshot.data() as Map<String, dynamic>?;

  return (
  uid: snapshot.id,
  email: snapshot.get('email'),
  displayName: data?['displayName'] ?? "",
  firstName: snapshot.get('firstName'),
  middleName: snapshot.get('middleName'),
  lastName: snapshot.get('lastName'),
  phoneNumber: data?['phoneNumber'] ?? "",
  gender: data?['gender'] ?? "other",
  birthdate: (data?['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  createdAt: (data?['createdAt'] as Timestamp?)?.toDate(),
  profileImage: data?['profileImage'] ?? '',
  houses: data?['houses']?.cast<String>() ?? [],
  favouriteHouses: data?['favouriteHouses']?.cast<String>() ?? [],
  ratedHouses: data?['ratedHouses']?.cast<String>() ?? [],
  desiredLocation: data?['location'] != null
      ? LatLng(
    data?['location']['latitude'] ?? 0.0,
    data?['location']['longitude'] ?? 0.0,
  )
      : LatLng(0.0,0.0), // Set to null if location field is not present
  ) as SamsarUser;
}
