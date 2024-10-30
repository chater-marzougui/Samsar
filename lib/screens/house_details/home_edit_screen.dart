import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samsar/Widgets/widgets.dart';
import '../../values/structures.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HouseEditPage extends StatefulWidget {
  final String houseId;

  const HouseEditPage({super.key, required this.houseId});

  @override
  State<HouseEditPage> createState() => _HouseEditPageState();
}

class _HouseEditPageState extends State<HouseEditPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late House _houseDetails;
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _featureController = TextEditingController();
  final TextEditingController _furnitureController = TextEditingController();

  // Controllers for editable fields
  late TextEditingController _priceController;
  late TextEditingController _salePriceController;
  late TextEditingController _commentController;
  late bool _isFurnished;
  late bool _isForRent;
  late bool _isForSale;
  late bool _isAvailable;
  late List<String> _features;
  late List<String> _furniture;
  late List<String> _images;

  @override
  void initState() {
    super.initState();
    _fetchHouseDetails();
  }

  Future<void> _fetchHouseDetails() async {
    try {
      DocumentSnapshot doc = await db.collection('houses').doc(widget.houseId).get();

      setState(() {
        _houseDetails = houseFromFirestore(doc.data() as Map<String, dynamic>, doc.id);
        _isLoading = false;

        _priceController = TextEditingController(text: _houseDetails.specs.price.toString());
        _salePriceController = TextEditingController(text: _houseDetails.specs.salePrice.toString());
        _commentController = TextEditingController(text: _houseDetails.comment);
        _isFurnished = _houseDetails.specs.isFurnished;
        _isForRent = _houseDetails.status.isForRent;
        _isForSale = _houseDetails.status.isForSale;
        _isAvailable = _houseDetails.status.isAvailable;
        _features = List<String>.from(_houseDetails.specs.features);
        _furniture = List<String>.from(_houseDetails.specs.furniture);
        _images = List<String>.from(_houseDetails.images);
      });
    } catch (e) {
      if (mounted) showSnackBar(context, "Error Fetching house details: $e");
    }
  }

  Future<void> _updateHouse() async {
    if (_formKey.currentState!.validate()) {
      try {
        await db.collection('houses').doc(widget.houseId).update({
          'specs.price': _isForSale ? int.parse(_priceController.text) : 0,
          'specs.salePrice': _isForRent ? int.parse(_salePriceController.text) : 0,
          'comment': _commentController.text,
          'specs.isFurnished': _isFurnished,
          'status.isForRent': _isForRent,
          'status.isForSale': _isForSale,
          'status.isAvailable': _isAvailable,
          'specs.features': _features,
          'specs.furniture': _furniture,
        });
        if (mounted) showSnackBar(context, "House details updated successfully");
      } catch (e) {
        if (mounted) showSnackBar(context, "Error updating house details: $e");
      }
    }
  }

  Future<void> _deleteHouse() async {
    try {
      await db.collection('houses').doc(widget.houseId).delete();
      if (mounted) {
        showSnackBar(context, "House deleted successfully");
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) showSnackBar(context, "Error deleting house: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Update ${ _houseDetails.specs.type}"),
        backgroundColor: Colors.blueAccent,
        actions: [
          TextButton(
            onPressed: _updateHouse,
            child: Text(
              'Save Changes',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

        body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image display
                if (_images.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CachedNetworkImage(
                            imageUrl: _images[index],
                            fit: BoxFit.cover,
                            width: 200,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 20),

                SwitchListTile(
                  title: Text('Available',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      )),
                  value: _isAvailable,
                  activeColor: Colors.green,
                  subtitle: Text("Enable this if your house is available",
                      style: theme.textTheme.titleSmall),
                  shape: Border.all(width: 2),

                  onChanged: (bool value) {
                    setState(() {
                      _isAvailable = value;
                    });
                  },
                ),
                buildInfoCard(
                  context,
                  Icons.house_outlined,
                  'House Specifications',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildDetailRow(context, Icons.apartment, 'Type', _houseDetails.specs.type),
                      buildDetailRow(context, Icons.tv, 'Living Room',
                          _houseDetails.specs.hasLivingRoom ? 'Yes' : 'No'),
                      buildDetailRow(
                          context, Icons.bed, 'Bedrooms', _houseDetails.specs.rooms.toString()),
                      buildDetailRow(
                          context, Icons.layers, 'Floor', _houseDetails.specs.floor.toString()),
                      buildDetailRow(
                          context, Icons.area_chart, 'Area', '${_houseDetails.specs.area.round()} m²'),
                    ],
                  ),
                ),
                buildInfoCard(
                  context,
                  Icons.location_on,
                  'Location',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildDetailRow(context, Icons.location_on, 'Address', _houseDetails.location.address),
                      buildDetailRow(context, Icons.location_city, 'City', _houseDetails.location.city),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Editable fields
                SwitchListTile(
                  title: const Text('For Sale'),
                  value: _isForSale,
                  onChanged: (bool value) {
                    setState(() {
                      _isForSale = value;
                    });
                  },
                ),
                if (_isForSale)
                  TextFormField(
                    controller: _salePriceController,
                    decoration: const InputDecoration(labelText: 'Sale Price (TND)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (_isForSale && (value == null || value.isEmpty)) {
                        return 'Please enter a sale price';
                      }
                      return null;
                    },
                  ),
                SwitchListTile(
                  title: const Text('For Rent'),
                  value: _isForRent,
                  onChanged: (bool value) {
                    setState(() {
                      _isForRent = value;
                    });
                  },
                ),
                if (_isForRent)
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Rent Price (TND)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (_isForRent && (value == null || value.isEmpty)) {
                        return 'Please enter a rent price';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: const Text('Furnished'),
                  value: _isFurnished,
                  onChanged: (bool value) {
                    setState(() {
                      _isFurnished = value;
                    });
                  },
                ),
                if(_isFurnished) Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _furnitureController,
                        decoration: const InputDecoration(labelText: 'Add Furniture'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _addFurniture,
                      child: const Text('Add'),
                    ),
                  ],
                ),
                if(_isFurnished) Wrap(
                  spacing: 8.0,
                  children: _furniture.map((item) => Chip(
                    label: Text(item),
                    onDeleted: () => _removeFurniture(item),
                  )).toList(),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _featureController,
                        decoration: const InputDecoration(labelText: 'Add Feature'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _addFeature,
                      child: const Text('Add'),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8.0,
                  children: _features.map((feature) => Chip(
                    label: Text(feature),
                    onDeleted: () => _removeFeature(feature),
                  )).toList(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _commentController,
                  decoration: const InputDecoration(labelText: 'Comment'),
                  maxLines: 3,
                ),
                const SizedBox(height: 25),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _updateHouse,
                        child: const Text('Update House Details'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete House'),
                                content: const Text('Are you sure you want to delete this house listing?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Delete'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _deleteHouse();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Delete House', style: TextStyle(color: Colors.white70)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addFeature() {
    if (_featureController.text.isNotEmpty) {
      setState(() {
        _features.add(_featureController.text);
        _featureController.clear();
      });
    }
  }

  void _removeFeature(String feature) {
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

  void _removeFurniture(String item) {
    setState(() {
      _furniture.remove(item);
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    _salePriceController.dispose();
    _commentController.dispose();
    _featureController.dispose();
    _furnitureController.dispose();
    super.dispose();
  }
}