import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as path;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';


List<String> homeFeatures = [
  "Gaz de ville",
  "2 toilets",
  "Pool",
  "Garage",
  "Garden",
  "Terrace",
  "Balcony",
  "Elevator",
  "Parking",
  "Cellar",
  "Attic",
  "Fireplace",
  "Central heating",
  "Air conditioning",
  "Double glazing",
  "Alarm system",
  "Security cameras",
  "Intercom",
  "Private entrance",
  "Shared garden",
  "Shared parking",
];

List<String> furniture = [
  "Fridge",
  "Freezer",
  "Oven",
  "Microwave",
  "Dishwasher",
  "Washing machine",
  "Dryer",
  "Coffee machine",
  "Kettle",
  "Toaster",
  "Blender",
  "Iron",
  "Hair dryer",
  "Vacuum cleaner",
  "TV",
  "Satellite TV",
  "Internet",
  "Wifi",
  "Telephone"
];

List<String> homeTypes = ["Studio", "Apartment", "House", "Villa"];

List<String> comments = [
  'Great location with amazing view!',
  'Needs some renovation, but a great deal overall.',
  'Perfect for families.',
  'Modern interior with a spacious layout.',
  'Close to public transport and schools.',
];

Future<void> createRandomData() async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  try {
    final Map<String, Map<String, dynamic>> houses = {};

    // Iterate through the existing homes
    for (int i = 21; i < 70; i++) {
      final Map<String, dynamic> houseData = {};
      final String houseId = i.toString();

      houseData['id'] = i;
      // Fetch or generate random owner details
      var ownerDetails = await _fetchRandomOwnerData();
      houseData['owner'] = {
        'id': houseId,
        'name': ownerDetails['name'],
        'prename': ownerDetails['prename'],
        'email': ownerDetails['email'],
        'phone': ownerDetails['phone'],
      };

      // Fetch random house images
      var houseImages = await _fetchRandomHouseImages();
      houseData['images'] = houseImages;

      // Generate random location
      List<double> x = generateRandomLocation(35.56203,9.61098);

      var jsonData = await isoCodeFromLatLong(x[0], x[1]);
      var location = {
        'latitude': x[0],
        'longitude': x[1],
        'address': jsonData['display_name'],
        'city': jsonData['address']['state_district'],
        'region': jsonData['address']['state'],
      };
      houseData['location'] = location;

      // Generate random specs
      var specs = {
        'price': _randomInt(100, 10000),
        'floor': _randomInt(0, 10),
        'rooms': _randomInt(0, 10),
        'area': _randomDouble(30, 500),
        'hasLivingRoom': _randomBool(),
        'hasParking': _randomBool(),
        'hasWifi': _randomBool(),
        'isFurnished': _randomBool(),
        'features': getRandomHomeFeatures(homeFeatures),
        'furniture': getRandomHomeFeatures(furniture),
        'type': getRandomHomeType(homeTypes),
      };
      houseData['specs'] = specs;

      // Generate random rate
      int raters = _randomInt(0, 40);
      var rate = {
        'raters': raters,
        'totalRating': (raters * _randomDouble(0.1, 5.0)).toInt(),
      };

      houseData['rate'] = rate;

      // Generate random Samsar status
      var samsarStatus = {
        'is3D': false,
        'link3D': '',
        'paidAt': DateTime.now(),
        'expiresAt': DateTime.now().add(Duration(days: 30)),
      };
      houseData['samsarStatus'] = samsarStatus;

      // Generate random status
      var status = {
        'isAvailable': _randomBool(),
        'isForRent': _randomBool(),
        'isForSale': _randomBool(),
        'isMonthlyPayment': _randomBool(),
        'isDailyPayment': _randomBool(),
      };
      houseData['status'] = status;

      // Add the random comment to the house data
      String randomComment = getRandomComment();
      houseData['comment'] = randomComment;

      houseData['createdAt'] = DateTime.now();
      houseData['updatedAt'] = DateTime.now();
      houses[houseId] = houseData;

    }

    if (houses.isNotEmpty) {
      // Loop through the updated homes and save each one in the 'houseDetails' collection
      for (var entry in houses.entries) {
        Map<String, dynamic> houseData = entry.value;

        await db
            .collection('houses')
            .doc(houseData['id'].toString())
            .set(houseData, SetOptions(merge: true));
      }
      print('Updated homes saved to Firestore in houses collection successfully.');
    }
  } catch (e) {
    print('Error fetching or updating markers: $e');
  }
}

List<double> generateRandomLocation(double latitude, double longitude) {
  // Range for randomization (around 0.01 degrees, which is approx. 1.1km)
  const double latRange = 0.5;
  const double longRange = 0.5;

  double randomLat = latitude + Random().nextDouble() * latRange - (latRange / 2);
  double randomLong = longitude + Random().nextDouble() * longRange - (longRange / 2);

  return [randomLat, randomLong];
}

Future<List<String>> _fetchRandomHouseImages({int limit = 12}) async {
  try {
    var response =
    await http.get(Uri.parse('https://picsum.photos/v2/list?limit=$limit'));
    var jsonData = json.decode(response.body);

    List<String> images = [];
    for (var image in jsonData) {
      if (_randomBool()) {
        images.add(image['download_url']);
      }
    }

    return images.isNotEmpty
        ? images
        : [
      'https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg?auto=compress&cs=tinysrgb&w=800'
    ]; // Fallback image
  } catch (e) {
    print('Error fetching house images: $e');
    return [
      'https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg?auto=compress&cs=tinysrgb&w=800'
    ]; // Fallback
  }
}

Future<Map<String, dynamic>> _fetchRandomOwnerData() async {
  try {
    var response = await http.get(Uri.parse('https://randomuser.me/api/'));
    var jsonData = json.decode(response.body);

    var user = jsonData['results'][0];
    return {
      'name': '${user['name']['first']} ${user['name']['last']}',
      'prename': user['name']['first'],
      'email': user['email'],
      'phone': user['phone'],
    };
  } catch (e) {
    return {
      'name': 'Unknown Name',
      'prename': 'Unknown',
      'email': 'unknown@example.com',
      'phone': '0000000000',
    };
  }
}

double _randomDouble(double min, double max) {
  return min + (max - min) * Random().nextDouble();
}

int _randomInt(int min, int max) {
  return min + Random().nextInt(max - min);
}

bool _randomBool() {
  return Random().nextBool();
}

Future<dynamic> isoCodeFromLatLong(double lat, double long) async {
  final response = await http.get(
    Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$long'),
  );
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return jsonData;
  } else {
    throw Exception('Failed to load location data');
  }
}

List<String> getRandomHomeFeatures(List<String> homeFeatures) {
  Random random = Random();
  List<String> randomFeatures = [];

  int randomCount = random.nextInt(homeFeatures.length);
  List<int> usedIndices = [];

  while (randomFeatures.length < randomCount) {
    int randomIndex = random.nextInt(homeFeatures.length);
    if (!usedIndices.contains(randomIndex)) {
      randomFeatures.add(homeFeatures[randomIndex]);
      usedIndices.add(randomIndex);
    }
  }

  return randomFeatures;
}

String getRandomHomeType(List<String> homeFeatures) {
  Random random = Random();
  int randomCount = random.nextInt(homeFeatures.length);
  return homeFeatures[randomCount];
}

String getRandomComment() {
  Random random = Random();
  return comments[random.nextInt(comments.length)];
}

// Function to fetch documents, add a comment, and re-upload them
Future<void> fetchAddSomethingAndReUpload() async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  try {
    // Fetching the documents
    final QuerySnapshot snapshot = await db.collection('houses').get();

    if (snapshot.docs.isNotEmpty) {
      // Iterate over each document
      for (var doc in snapshot.docs) {
        // Add a random comment to the document's data
        Map<String, dynamic> houseData = doc.data() as Map<String, dynamic>;

        // Add the random comment to the house data
        houseData['priorityLevel'] = _randomInt(1, 5);

        // Re-upload the updated document
        await db
            .collection('houses')
            .doc(doc.id)
            .set(houseData, SetOptions(merge: true));
      }
      print('Comments added and documents re-uploaded successfully.');
    } else {
      print('No documents found.');
    }
  } catch (e) {
    print('Error while updating documents with comments: $e');
  }
}

List<XFile> _images = [];

Future<List<String>> uploadImages(List<String> images) async {
  List<String> imageUrls = [];
  for (var image in _images) {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('house_images/${DateTime.now()}_$fileName');
    UploadTask uploadTask = storageReference.putFile(File(image.path));
    await uploadTask.whenComplete(() async {
      String url = await storageReference.getDownloadURL();
      imageUrls.add(url);
    });
  }
  return imageUrls;
}

Future<void> fetchAddDatesAndReUpload() async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  try {
    // Fetching the documents
    final QuerySnapshot snapshot = await db.collection('houses').get();

    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        Map<String, dynamic> houseData = doc.data() as Map<String, dynamic>;

        // Add the random comment to the house data
        houseData['createdAt'] = DateTime.now();
        houseData['updatedAt'] = DateTime.now();

        // Re-upload the updated document
        await db
            .collection('houses')
            .doc(doc.id)
            .set(houseData, SetOptions(merge: true));
      }
      print('Dates added and documents re-uploaded successfully.');
    } else {
      print('No documents found.');
    }
  } catch (e) {
    print('Error while updating documents with comments: $e');
  }
}

Future<void> deleteFields() async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final QuerySnapshot snapshot = await db.collection('houses').get();

  if (snapshot.docs.isNotEmpty) {
    for (var doc in snapshot.docs) {
      Map<String, dynamic> houseData = doc.data() as Map<String, dynamic>;

      // Delete the specified fields
      houseData.remove('bedrooms');
      houseData.remove('floor');
      houseData.remove('latitude');
      houseData.remove('longitude');
      houseData.remove('price');

      // Re-upload the updated document
      await db
          .collection('houses')
          .doc(doc.id)
          .set(houseData, SetOptions(merge: false));
    }
}
}

Future<void> modifyFields() async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final QuerySnapshot snapshot = await db.collection('houses').get();

  if (snapshot.docs.isNotEmpty) {
    for (var doc in snapshot.docs) {
      Map<String, dynamic> houseData = doc.data() as Map<String, dynamic>;

      var x = await isoCodeFromLatLong(houseData["location"]["latitude"], houseData["location"]["longitude"]);
      houseData['location']['city'] = x['address']['state_district'];
      // Re-upload the updated document
      await db.collection('houses').doc(doc.id).set(houseData, SetOptions(merge: true));
    }
  } else {
    print('empty');
  }
}

class FirebaseImageUpdater {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Random _random = Random();

  // Load all local images from assets
  Future<List<File>> _getLocalImages() async {
    List<File> imageFiles = [];
    try {
      // Get the manifest file
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // Filter for your images
      final imagePaths = manifestMap.keys
          .where((String key) => key.startsWith('assets/fake/') && key.endsWith('.jpg'))
          .toList();

      // Copy assets to temporary directory to get File objects
      final tempDir = await getTemporaryDirectory();

      for (String assetPath in imagePaths) {
        final ByteData data = await rootBundle.load(assetPath);
        final bytes = data.buffer.asUint8List();

        final String filename = path.basename(assetPath);
        final File tempFile = File('${tempDir.path}/$filename');
        await tempFile.writeAsBytes(bytes);

        imageFiles.add(tempFile);
        print('Loaded image: $filename');
      }

      // Sort to ensure consistent ordering
      imageFiles.sort((a, b) => path.basename(a.path).compareTo(path.basename(b.path)));

    } catch (e) {
      print('Error loading local images: $e');
      rethrow;
    }
    return imageFiles;
  }

  // Upload a single image to Firebase Storage
  Future<String?> _uploadSingleImage(File imageFile) async {
    try {
      String fileName = path.basename(imageFile.path);
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child('house_images/${timestamp}_$fileName');

      UploadTask uploadTask = storageRef.putFile(imageFile);
      await uploadTask.whenComplete(() => null);

      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image ${imageFile.path}: $e');
      return null;
    }
  }

  // Upload all images to Firebase Storage
  Future<List<String>> _uploadAllImages(List<File> imageFiles) async {
    List<String> allImageUrls = [];

    for (var imageFile in imageFiles) {
      String? imageUrl = await _uploadSingleImage(imageFile);
      if (imageUrl != null) {
        allImageUrls.add(imageUrl);
        print('Uploaded: ${path.basename(imageFile.path)} -> $imageUrl');
      }
    }

    return allImageUrls;
  }

  // Get random subset of images
  List<String> _getRandomImages(List<String> allImages) {
    // Generate random number between 2 and 12
    int numberOfImages = _random.nextInt(11) + 2; // 2 to 12 images

    // Shuffle the list and take the first n elements
    List<String> shuffled = List.from(allImages)..shuffle(_random);
    return shuffled.take(numberOfImages).toList();
  }

  // Update all houses in Firestore
  Future<void> updateAllHousesImages() async {
    try {
      // First, load and upload all local images
      print('Loading local images from assets...');
      List<File> localImages = await _getLocalImages();

      if (localImages.isEmpty) {
        throw Exception('No images found in assets/fake directory');
      }

      print('Found ${localImages.length} images');
      print('Uploading images to Firebase Storage...');
      List<String> allImageUrls = await _uploadAllImages(localImages);

      if (allImageUrls.isEmpty) {
        throw Exception('Failed to upload any images');
      }

      print('Updating Firestore documents...');
      // Get all houses
      QuerySnapshot snapshot = await _db.collection('houses').get();

      // Update each house with random images
      for (var doc in snapshot.docs) {
        List<String> randomImages = _getRandomImages(allImageUrls);

        await _db.collection('houses').doc(doc.id).update({
          'images': randomImages
        });

        print('Updated house ${doc.id} with ${randomImages.length} images');
      }

      print('Successfully completed updating all houses!');

    } catch (e) {
      print('Error in updateAllHousesImages: $e');
      rethrow;
    }
  }
}
