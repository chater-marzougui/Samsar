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
import '../../l10n/l10n.dart';
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
        message: S.of(context).notLoggedIn,
        indicatorColor: theme.primaryColor,
      );
    }

    if (_isLoading) {
      return CustomLoadingScreen(
        message:  S.of(context).weReUploadingWait,
        indicatorColor: theme.primaryColor,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).uploadHouseListing),
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
                            _currentStep == 4 ? S.of(context).submit : S.of(context).justContinue,
                          ),
                        ),
                        if (_currentStep > 0) ...[
                          SizedBox(width: 12),
                          TextButton(
                            onPressed: controls.onStepCancel,
                            style: TextButton.styleFrom(
                              minimumSize: Size(120, 40),
                            ),
                            child: Text(S.of(context).back),
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
                    title: Text(S.of(context).basicInformation),
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
                                  S.of(context).mainImage,
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
                                          Text(S.of(context).addMainImage),
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
                                      S.of(context).additionalImages,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    TextButton.icon(
                                      onPressed: () => _showImageSource(context, false),
                                      icon: Icon(Icons.add_photo_alternate),
                                      label: Text(S.of(context).add),
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
                                                      S.of(context).main,
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
                                      child: Text(S.of(context).noAdditionalImages),
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
                    title: Text(S.of(context).houseSpecifications),
                    content: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: S.of(context).type,
                            hintText: S.of(context).hintText,
                            hintStyle: TextStyle(color: Colors.grey[500]),
                          ),
                          keyboardType: TextInputType.text,
                          onSaved: (value) => _type = value ?? "",
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: S.of(context).floor,
                              hintText: S.of(context).groundFloor,
                              hintStyle: TextStyle(color: Colors.grey[500]
                              ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => _floor = int.parse(value!),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: S.of(context).bedrooms,
                            hintText: S.of(context).noRooms,
                            hintStyle: TextStyle(color: Colors.grey[500]
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => _rooms = int.parse(value!),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: '${S.of(context).area} (m²)',
                            hintText: '${S.of(context).justIn} m²',
                            hintStyle: TextStyle(color: Colors.grey[500]
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => _area = double.parse(value!),
                        ),
                        CheckboxListTile(
                          title: Text(S.of(context).hasLivingRoom),
                          value: _hasLivingRoom,
                          onChanged: (value) =>
                              setState(() => _hasLivingRoom = value!),
                        ),
                        CheckboxListTile(
                          title: Text(S.of(context).hasParking),
                          value: _hasParking,
                          onChanged: (value) => setState(() => _hasParking = value!),
                        ),
                        CheckboxListTile(
                          title: Text(S.of(context).hasWifi),
                          value: _hasWifi,
                          onChanged: (value) => setState(() => _hasWifi = value!),
                        ),
                        CheckboxListTile(
                          title: Text(S.of(context).isFurnished),
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
                                      labelText: S.of(context).addFurniture,
                                      hintText: S.of(context).furnitureItems,
                                      hintStyle: TextStyle(color: Colors.grey[500]),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: _addFurniture,
                                  child: Text(S.of(context).add),
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
                                    labelText: S.of(context).addFeature,
                                    hintText: S.of(context).garageFeatures
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _addFeature,
                              child: Text(S.of(context).add),
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
                    title: Text(S.of(context).status),
                    content: Column(
                      children: [
                        CheckboxListTile(
                          title: Text(S.of(context).isAvailable),
                          value: _isAvailable,
                          onChanged: (value) => setState(() => _isAvailable = value!),
                        ),
                        CheckboxListTile(
                          title: Text(S.of(context).forRent),
                          value: _isForRent,
                          onChanged: (value) => setState(() => _isForRent = value!),
                        ),
                        if (_isForRent)
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: S.of(context).price,
                              hintText: '${S.of(context).justIn} TND',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (value) => _price = int.parse(value!),
                          ),
                        CheckboxListTile(
                          title: Text(S.of(context).forSale),
                          value: _isForSale,
                          onChanged: (value) => setState(() => _isForSale = value!),
                        ),
                        if (_isForSale)
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: S.of(context).salePrice,
                              hintText: '${S.of(context).justIn} TND',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (value) => _salePrice = int.parse(value!),
                          ),
                        CheckboxListTile(
                          title: Text(S.of(context).monthlyPayment),
                          value: _isMonthlyPayment,
                          onChanged: (value) => setState(() => _isMonthlyPayment = value!),
                        ),
                        CheckboxListTile(
                          title: Text(S.of(context).dailyPayment),
                          value: _isDailyPayment,
                          onChanged: (value) => setState(() => _isDailyPayment = value!),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: Text(S.of(context).location),
                    content: Column(
                      children: [
                        CheckboxListTile(
                          title: Text(S.of(context).useCurrentLocation),
                          value: _useCurrentLocation,
                          onChanged: (value) => setState(() => _useCurrentLocation = value!),
                        ),
                        if (!_useCurrentLocation)
                          ElevatedButton(
                            onPressed: () {
                              // TODO: Implement custom location picker
                            },
                            child: Text(S.of(context).pickCustomLocation),
                          ),
                      ],
                    ),
                  ),
                  Step(
                    title: Text(S.of(context).ownerInformation),
                    content: Column(
                      children: [
                        TextFormField(
                          focusNode: _commentFocusNode,
                          decoration: InputDecoration(
                            labelText: S.of(context).comment,
                            hintText: S.of(context).addCommentOptional,
                            hintStyle: TextStyle(color: Colors.grey[500]),
                          ),
                          onSaved: (value) => _comment = value!,
                          onTapOutside: (_) => {_commentFocusNode.unfocus()},
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
                                  S.of(context).ownerInfoMessage,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                title: Text(S.of(context).gallery),
                onTap: () {
                  Navigator.pop(context);
                  isMainImage ? _pickMainImageFrom(ImageSource.gallery)
                      : _pickImagesFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text(S.of(context).camera),
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
          "priorityLevel": 5,
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
        await _userManager.updateUserHouses();
        if(mounted) showSnackBar(context, S.of(context).houseUploadedSuccess);

        setState(() {
          _currentStep = 0;
          _mainImage = null;
          _images.clear();
          _formKey.currentState!.reset();
          _isLoading = false;
        });

        if (context.mounted && mounted) {
          HomePage.switchToPage(context, 1);
        }

        if (context.mounted && mounted) {
          Navigator.pushNamed(
              context,
              AppRoutes.houseDetails,
              arguments: houseId
          );
        }

      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) showSnackBar(context, S.of(context).errorUploadingHouse);
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
