import 'package:flutter/material.dart';
import 'package:samsar/Widgets/widgets.dart';
import 'package:samsar/helpers/user_manager.dart';
import 'package:samsar/helpers/house_manager.dart';
import '../../Widgets/location_doc.dart';
import '../../l10n/l10n.dart';
import '../../values/structures.dart';

class HouseDetailsPage extends StatefulWidget {
  final String houseId;

  const HouseDetailsPage({super.key, required this.houseId});

  @override
  State<HouseDetailsPage> createState() => _HouseDetailsPageState();
}

class _HouseDetailsPageState extends State<HouseDetailsPage> {
  late House _houseDetails;
  final HouseManager _houseManager = HouseManager();
  final UserManager _userManager = UserManager();
  bool _isLoading = true;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _fetchHouseDetails();
  }

  Future<void> _fetchHouseDetails() async {
    try {
      _houseDetails = await _houseManager.getHouseById(widget.houseId);
      _checkFavoriteAndRateStatus();

      setState(() {});
    } catch (e) {
      if(mounted) showSnackBar(context, S.of(context).errorFetchingHouses);
    }
  }

  Future<void> _checkFavoriteAndRateStatus() async {
    try {
      setState(() {
        _isFavorite = _userManager.samsarUser?.favouriteHouses.contains(widget.houseId) ?? false;
        _isLoading = false;
      });
    } catch (e) {
      if(mounted) showSnackBar(context, S.of(context).errorCheckingFavoriteStatus(e));
    }
  }

  Future<void> _handleToggleFavorite() async {
    try {
      bool newFavoriteStatus = await _userManager.toggleFavorite(widget.houseId, _isFavorite);

      setState(() {
        _isFavorite = newFavoriteStatus;
      });

      if (mounted) {
        showSnackBar(context, _isFavorite ? S.of(context).addedToFavorites : S.of(context).removedFromFavorites);
      }
    } catch (e) {
      if (mounted) showSnackBar(context, S.of(context).errorUpdatingFavoriteStatus(e));
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final House data = _houseDetails;

    List<String> photos = data.images;
    String ownerFullName = "${data.owner.name} ${data.owner.prename}";
    String phoneNumber = data.owner.phone;
    String email = data.owner.email;
    int bedrooms = data.specs.rooms;
    int floor = data.specs.floor;
    int price = data.specs.price;
    String comment = data.comment;
    // int numberOfRaters = data.rate.raters;
    // int ratings = data.rate.totalRating;
    String city = data.location.city;
    int area = data.specs.area.round();
    String type = data.specs.type;
    bool isFurnished = data.specs.isFurnished;
    bool hasLivingRoom = data.specs.hasLivingRoom;
    List<String> features = data.specs.features;
    List<String> furniture = data.specs.furniture;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S.of(context).ownerHouse(data.owner.prename)),
            if(data.owner.id != _userManager.samsarUser!.uid)
              IconButton(
                icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
                color: _isFavorite ? Colors.red : Colors.white,
                onPressed: _handleToggleFavorite,
              ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EnhancedImageViewer(photos: photos),
              const SizedBox(height: 24),
              LocationDocWidget(house: data),
              SizedBox(height: 8),
              buildInfoDoc(context, Icons.location_city, S.of(context).city, city),
              SizedBox(height: 8),
              buildInfoDoc(context, Icons.comment, S.of(context).ownerComment, comment),

              const SizedBox(height: 12),

              buildInfoCard(
                context,
                Icons.house_outlined,
                S.of(context).houseSpecifications,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDetailRow(context, Icons.apartment, S.of(context).type, type),
                    buildDetailRow(context, Icons.tv, S.of(context).livingRoom,
                        hasLivingRoom ? S.of(context).yes : S.of(context).no),
                    buildDetailRow(
                        context, Icons.bed, S.of(context).bedrooms, bedrooms.toString()),
                    buildDetailRow(
                        context, Icons.layers, S.of(context).floor, floor.toString()),
                    buildDetailRow(
                        context, Icons.area_chart, S.of(context).area, '$area m²'),
                    buildDetailRow(context, Icons.weekend, S.of(context).furnished,
                        isFurnished ? S.of(context).yes : S.of(context).no),
                    buildDetailRow(context, Icons.attach_money_rounded, S.of(context).price,
                        S.of(context).priceValue(price)),
                  ],
                ),
              ),

              if (isFurnished)
                buildSection(context, Icons.chair, S.of(context).furniture, furniture),

              if (data.specs.features.isNotEmpty)
                buildSection(
                    context, Icons.featured_video_sharp, S.of(context).options, features),

              buildInfoCard(
                context,
                Icons.person_outline_sharp,
                S.of(context).ownerInformation,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDetailRow(
                        context, Icons.person, S.of(context).name, ownerFullName),
                    buildDetailRow(context, Icons.phone, S.of(context).phone, phoneNumber),
                    buildDetailRow(context, Icons.email, S.of(context).email, email),
                  ],
                ),
              ),

              RatingSection(
                house: _houseDetails,
                onRatingUpdated: _fetchHouseDetails,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
