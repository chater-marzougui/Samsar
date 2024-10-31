import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samsar/Widgets/widgets.dart';
import '../../l10n/l10n.dart';
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
      if (mounted) showSnackBar(context, S.of(context).errorFetchingHouses);
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
        if (mounted) showSnackBar(context, S.of(context).houseUploadedSuccess);
      } catch (e) {
        if (mounted) showSnackBar(context, S.of(context).errorUploadingHouse);
      }
    }
  }

  Future<void> _deleteHouse() async {
    try {
      await db.collection('houses').doc(widget.houseId).delete();
      if (mounted) {
        showSnackBar(context, S.of(context).houseDeleteSuccess);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) showSnackBar(context, S.of(context).errorDeletingHouse);
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
        title: Text("${S.of(context).update} ${_houseDetails.specs.type}"),
        backgroundColor: Colors.blueAccent,
        actions: [
          TextButton(
            onPressed: _updateHouse,
            child: Text(
              S.of(context).saveChanges,
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
                  title: Text(S.of(context).available,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      )),
                  value: _isAvailable,
                  activeColor: Colors.green,
                  subtitle: Text(S.of(context).availableHint,
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
                  S.of(context).houseSpecifications,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildDetailRow(context, Icons.apartment, S.of(context).type, _houseDetails.specs.type),
                      buildDetailRow(context, Icons.tv, S.of(context).livingRoom,
                          _houseDetails.specs.hasLivingRoom ? S.of(context).yes : S.of(context).no),
                      buildDetailRow(
                          context, Icons.bed, S.of(context).bedrooms, _houseDetails.specs.rooms.toString()),
                      buildDetailRow(
                          context, Icons.layers, S.of(context).floor, _houseDetails.specs.floor.toString()),
                      buildDetailRow(
                          context, Icons.area_chart, S.of(context).area, '${_houseDetails.specs.area.round()} m²'),
                    ],
                  ),
                ),
                buildInfoCard(
                  context,
                  Icons.location_on,
                  S.of(context).location,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildDetailRow(context, Icons.location_on, S.of(context).address, _houseDetails.location.address),
                      buildDetailRow(context, Icons.location_city, S.of(context).city, _houseDetails.location.city),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Editable fields
                SwitchListTile(
                  title: Text(S.of(context).forSale),
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
                    decoration: InputDecoration(labelText: '${S.of(context).salePrice} (TND)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (_isForSale && (value == null || value.isEmpty)) {
                        return S.of(context).enterSalePrice;
                      }
                      return null;
                    },
                  ),
                SwitchListTile(
                  title: Text(S.of(context).forRent),
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
                    decoration: InputDecoration(labelText: '${S.of(context).rentPrice} (TND)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (_isForRent && (value == null || value.isEmpty)) {
                        return S.of(context).enterRentPrice;
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: Text(S.of(context).furnished),
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
                        decoration: InputDecoration(labelText: S.of(context).addFurniture),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _addFurniture,
                      child: Text(S.of(context).add),
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
                        decoration: InputDecoration(labelText: S.of(context).addFeature),
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
                  children: _features.map((feature) => Chip(
                    label: Text(feature),
                    onDeleted: () => _removeFeature(feature),
                  )).toList(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _commentController,
                  decoration: InputDecoration(labelText: S.of(context).comment),
                  maxLines: 3,
                ),
                const SizedBox(height: 25),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _updateHouse,
                        child: Text(S.of(context).updateHouseDetails),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(S.of(context).deleteHouse),
                                content: Text(S.of(context).deleteHouseConfirmation),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(S.of(context).cancel),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(S.of(context).delete),
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
                        child: Text(S.of(context).deleteHouse,
                            style: TextStyle(color: Colors.white70)),
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