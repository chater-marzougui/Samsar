import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:samsar/Widgets/widgets.dart';
import 'package:samsar/helpers/house_manager.dart';
import 'package:samsar/helpers/user_manager.dart';
import 'package:samsar/values/app_routes.dart';
import '../../values/structures.dart';
import '../bottom_navigator.dart';

class HouseUploadPage extends StatefulWidget {
  const HouseUploadPage({super.key});

  @override
  State<HouseUploadPage> createState() => _HouseUploadPageState();
}

class _HouseUploadPageState extends State<HouseUploadPage> {
  final _formKey = GlobalKey<FormState>();
  final UserManager _userManager = UserManager();
  int _currentStep = 0;
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();
  final db = FirebaseFirestore.instance;
  SamsarUser? samsarUser;
  final FocusNode _commentFocusNode = FocusNode();


  XFile? _mainImage;
  bool _useCurrentLocation = true;
  final TextEditingController _featureController = TextEditingController();
  final TextEditingController _furnitureController = TextEditingController();
  bool _isLoading = false;

  String _comment = '';
  int _price = 0;
  int _floor = 0;
  int _rooms = 0;
  double _area = 0.0;
  bool _hasLivingRoom = false;
  bool _hasParking = false;
  bool _hasWifi = false;
  bool _isFurnished = false;
  final List<String> _features = [];
  final List<String> _furniture = [];
  String _type = '';
  bool _isAvailable = true;
  bool _isForRent = false;
  bool _isForSale = false;
  bool _isMonthlyPayment = false;
  bool _isDailyPayment = false;
  int _salePrice = 0;

  @override
  void initState() {
    super.initState();
    samsarUser = _userManager.samsarUser;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (samsarUser == null) {
      return CustomLoadingScreen(
        message: "Not logged in...",
        indicatorColor: theme.primaryColor,
      );
    }

    if (_isLoading) {
      return CustomLoadingScreen(
        message: "We're uploading your House, please wait...",
        indicatorColor: theme.primaryColor,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Upload House Listing'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              color: theme.primaryColor.withOpacity(0.1),
              child: Row(
                children: List.generate(5, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: _currentStep >= index
                            ? theme.primaryColor
                            : theme.disabledColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: Stepper(
                type: StepperType.vertical,
                currentStep: _currentStep,
                elevation: 0,
                margin: EdgeInsets.zero,
                controlsBuilder: (context, controls) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: controls.onStepContinue,
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(120, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            _currentStep == 4 ? 'Submit' : 'Continue',
                          ),
                        ),
                        if (_currentStep > 0) ...[
                          SizedBox(width: 12),
                          TextButton(
                            onPressed: controls.onStepCancel,
                            style: TextButton.styleFrom(
                              minimumSize: Size(120, 40),
                            ),
                            child: Text('Back'),
                          ),
                        ],
                      ],
                    ),
                  );
                },
                onStepContinue: () {
                  if (_currentStep < 4) {
                    setState(() {
                      _currentStep += 1;
                    });
                  } else {
                    _submitForm();
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() {
                      _currentStep -= 1;
                    });
                  }
                },
                steps: [
                  Step(
                    title: Text('Basic Information'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Main Image',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                SizedBox(height: 8),
                                InkWell(
                                  onTap: () => _showImageSource(context, true),
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: _mainImage != null
                                        ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(_mainImage!.path),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    )
                                        : Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_photo_alternate, size: 40),
                                          SizedBox(height: 8),
                                          Text('Add Main Image'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Additional Images',
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    TextButton.icon(
                                      onPressed: () => _showImageSource(context, false),
                                      icon: Icon(Icons.add_photo_alternate),
                                      label: Text('Add'),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                if (_images.isNotEmpty)
                                  SizedBox(
                                    height: 120,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _images.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Image.file(
                                                  File(_images[index].path),
                                                  width: 120,
                                                  height: 120,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Positioned(
                                                top: 4,
                                                right: 4,
                                                child: GestureDetector(
                                                  onTap: () => _removeImage(index),
                                                  child: Container(
                                                    padding: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black.withOpacity(0.5),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if (_mainImage?.path == _images[index].path)
                                                Positioned(
                                                  bottom: 4,
                                                  left: 4,
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black.withOpacity(0.5),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Text(
                                                      'Main',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                else
                                  Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text('No additional images selected'),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: Text('Specifications'),
                    content: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Type',
                            hintText: 'villa, apartment, studio...',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                          ),
                          keyboardType: TextInputType.text,
                          onSaved: (value) => _type = value ?? "",
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Floor',
                              hintText: '0 for ground flour',
                              hintStyle: TextStyle(color: Colors.grey[500]
                              ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => _floor = int.parse(value!),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Rooms',
                            hintText: '0 if no rooms',
                            hintStyle: TextStyle(color: Colors.grey[500]
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => _rooms = int.parse(value!),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Area (m²)',
                            hintText: 'in m²',
                            hintStyle: TextStyle(color: Colors.grey[500]
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => _area = double.parse(value!),
                        ),
                        CheckboxListTile(
                          title: Text('Has Living Room'),
                          value: _hasLivingRoom,
                          onChanged: (value) =>
                              setState(() => _hasLivingRoom = value!),
                        ),
                        CheckboxListTile(
                          title: Text('Has Parking'),
                          value: _hasParking,
                          onChanged: (value) => setState(() => _hasParking = value!),
                        ),
                        CheckboxListTile(
                          title: Text('Has WiFi'),
                          value: _hasWifi,
                          onChanged: (value) => setState(() => _hasWifi = value!),
                        ),
                        CheckboxListTile(
                          title: Text('Is Furnished'),
                          value: _isFurnished,
                          onChanged: (value) => setState(() => _isFurnished = value!),
                        ),
                        if(_isFurnished)
                          ...[
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _furnitureController,
                                    decoration: InputDecoration(
                                      labelText: 'Add Furniture',
                                      hintText: 'Fridge, TV, Table....',
                                      hintStyle: TextStyle(color: Colors.grey[500]),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: _addFurniture,
                                  child: Text('Add'),
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 8.0,
                              children: _furniture
                                  .map((item) => Chip(
                                label: Text(item),
                                onDeleted: () => _deleteFurniture(item),
                                deleteIcon: Icon(Icons.close, size: 18),
                              ))
                                  .toList(),
                            ),
                            SizedBox(height: 12),
                          ],
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _featureController,
                                decoration: InputDecoration(
                                    labelText: 'Add Features',
                                    hintText: 'Garage, 2 Salle, 2 Toilet...'
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _addFeature,
                              child: Text('Add'),
                            ),
                          ],
                        ),
                        Wrap(
                          spacing: 8.0,
                          children: _features
                              .map((feature) => Chip(
                            label: Text(feature),
                            onDeleted: () => _deleteFeature(feature),
                            deleteIcon: Icon(Icons.close, size: 18),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: Text('Status'),
                    content: Column(
                      children: [
                        CheckboxListTile(
                          title: Text('Is Available'),
                          value: _isAvailable,
                          onChanged: (value) => setState(() => _isAvailable = value!),
                        ),
                        CheckboxListTile(
                          title: Text('For Rent'),
                          value: _isForRent,
                          onChanged: (value) => setState(() => _isForRent = value!),
                        ),
                        if (_isForRent)
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Price',
                              hintText: 'in TND',
                              hintStyle: TextStyle(color: Colors.grey[500]
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (value) => _price = int.parse(value!),
                          ),
                        CheckboxListTile(
                          title: Text('For Sale'),
                          value: _isForSale,
                          onChanged: (value) => setState(() => _isForSale = value!),
                        ),
                        if (_isForSale)
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Sale Price',
                              hintText: 'in TND',
                              hintStyle: TextStyle(color: Colors.grey[500]
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (value) => _salePrice = int.parse(value!),
                          ),
                        CheckboxListTile(
                          title: Text('Monthly Payment'),
                          value: _isMonthlyPayment,
                          onChanged: (value) =>
                              setState(() => _isMonthlyPayment = value!),
                        ),
                        CheckboxListTile(
                          title: Text('Daily Payment'),
                          value: _isDailyPayment,
                          onChanged: (value) =>
                              setState(() => _isDailyPayment = value!),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: Text('Location'),
                    content: Column(
                      children: [
                        CheckboxListTile(
                          title: Text('Use Current Location'),
                          value: _useCurrentLocation,
                          onChanged: (value) =>
                              setState(() => _useCurrentLocation = value!),
                        ),
                        if (!_useCurrentLocation)
                          ElevatedButton(
                            onPressed: () {
                              // TODO: Implement custom location picker
                              // This could open a map or a form to input address details
                            },
                            child: Text('Pick Custom Location'),
                          ),
                      ],
                    ),
                  ),
                  Step(
                    title: Text('Owner Information'),
                    content: Column(
                      children: [
                        TextFormField(
                          focusNode: _commentFocusNode,
                          decoration: InputDecoration(labelText: 'Comment',
                            hintText: 'villa, apartment, studio...',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                          ),
                          onSaved: (value) => _comment = value!,
                          onTapOutside: (_) => {
                            _commentFocusNode.unfocus()
                          },
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            border: Border.all(color: Colors.blue, width: 1.5),
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  'Owner information will be automatically filled based on your account details.',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showImageSource(BuildContext context, bool isMainImage) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  isMainImage ? _pickMainImageFrom(ImageSource.gallery)
                      : _pickImagesFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  isMainImage ? _pickMainImageFrom(ImageSource.camera)
                      : _pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickMainImageFrom(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _mainImage = image;
        if (_images.isNotEmpty) {
          _images.insert(0, image);
        } else {
          _images.add(image);
        }
      });
    }
  }

  Future<void> _pickImagesFromGallery() async {
    final List<XFile> selectedImages = await _picker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      setState(() {
        _images.addAll(selectedImages);
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _images.add(image);
      });
    }
  }

  Future<void> _removeImage(int index) async {
    setState(() {
      if (_images[index].path == _mainImage?.path) {
        _mainImage = null;
      }
      _images.removeAt(index);
    });
  }

  void _addFeature() {
    if (_featureController.text.isNotEmpty) {
      setState(() {
        _features.add(_featureController.text);
        _featureController.clear();
      });
    }
  }

  void _deleteFeature(String feature) {
    setState(() {
      _features.remove(feature);
    });
  }

  void _addFurniture() {
    if (_furnitureController.text.isNotEmpty) {
      setState(() {
        _furniture.add(_furnitureController.text);
        _furnitureController.clear();
      });
    }
  }

  void _deleteFurniture(String furniture) {
    setState(() {
      _furniture.remove(furniture);
    });
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        Position position = await _getCurrentLocation();

        var locData =
            await getLocationFromLatLong(position.latitude, position.longitude);

        List<String> imageUrls = await _uploadImages();

        final house = {
          "priorityLevel": 3,
          'images': imageUrls,
          'comment': _comment,
          'owner': {
            'id': samsarUser!.uid,
            'name': samsarUser!.firstName,
            'prename': samsarUser!.lastName,
            'email': samsarUser!.email,
            'phone': samsarUser!.phoneNumber ?? "",
          },
          'location': {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'address': locData.displayName,
            'city': locData.address.stateDistrict,
            'region': locData.address.state,
          },
          'specs': {
            'price': _price,
            'salePrice': _salePrice,
            'floor': _floor,
            'rooms': _rooms,
            'area': _area,
            'hasLivingRoom': _hasLivingRoom,
            'hasParking': _hasParking,
            'hasWifi': _hasWifi,
            'isFurnished': _isFurnished,
            'features': _features,
            'furniture': _furniture,
            'type': _type,
          },
          'rate': {
            'raters': 0,
            'totalRating': 0,
          },
          'ratings': [],
          'samsarStatus': {
            'is3D': false,
            'link3D': "",
            'paidAt': DateTime.now(),
            'expiresAt': DateTime.now().add(Duration(days: 3)),
          },
          'status': {
            'isAvailable': _isAvailable,
            'isForRent': _isForRent,
            'isForSale': _isForSale,
            'isMonthlyPayment': _isMonthlyPayment,
            'isDailyPayment': _isDailyPayment,
          },
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
        };

        String houseId = (await db.collection('houses').add(house)).id;

        await db.collection("users").doc(samsarUser!.uid).update({
          'houses': FieldValue.arrayUnion([houseId])
        });

        HouseManager().fetchHouses();
        setState(() {
          _formKey.currentState!.reset();
          _isLoading = false;
          _currentStep = 0;
        });
        if (mounted) {
          showSnackBar(context, 'House listing uploaded successfully!');

          if (context.mounted) {
            HomePage.switchToHomeTab(context);
          }

          if (context.mounted) {
            Navigator.pushNamed(
                context,
                AppRoutes.houseDetails,
                arguments: houseId
            );
          }
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) showSnackBar(context, 'Error uploading house listing: $e');
      }
    }
  }

  Future<List<String>> _uploadImages() async {
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
}
