import 'package:flutter/material.dart';
import 'package:samsar/Widgets/widgets.dart';
import 'package:samsar/helpers/user_manager.dart';
import 'package:samsar/helpers/house_manager.dart';
import '../../Widgets/location_doc.dart';
import '../../l10n/l10n.dart';
import '../../values/structures.dart';

class SlidePageRoute extends PageRouteBuilder {
  final Widget page;
  final bool slideFromRight;

  SlidePageRoute({required this.page, required this.slideFromRight})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(slideFromRight ? 1.0 : -1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.easeInOutCubic;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

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
  bool _isNavigating = false;

  String _nextHouseId = '';
  String _previousHouseId = '';


  @override
  void initState() {
    super.initState();
    _fetchHouseDetails();
  }

  Future<String> _getNextHouse() async {
    // this returns the next house id
    return _houseManager.getNextHouse(_houseDetails);
  }

  Future<String> _getPreviousHouse() async {
    // this returns the previous house id
    return _houseManager.getPreviousHouse(_houseDetails);
  }

  Future<void> _navigateToHouse(String houseId) async {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        SlidePageRoute(
          page: HouseDetailsPage(houseId: houseId),
          slideFromRight: houseId == _nextHouseId,
        ),
      );
    }
  }

  Future<void> _handleSwipe(DragEndDetails details) async {
    if (_isNavigating) return;

    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() < 300) return;

    setState(() => _isNavigating = true);

    try {
      String? nextHouseId;
      if (velocity > 0) {
        nextHouseId = _previousHouseId;
      } else {
        nextHouseId = _nextHouseId;
      }

      if (nextHouseId.isNotEmpty && mounted) {
        await _navigateToHouse(nextHouseId);
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, S.of(context).errorFetchingHouses);
      }
    } finally {
      if (mounted) {
        setState(() => _isNavigating = false);
      }
    }
  }


  Future<void> _fetchHouseDetails() async {
    try {
      _houseDetails = await _houseManager.getHouseById(widget.houseId);
      _checkFavoriteAndRateStatus();

      setState(() {});
      _nextHouseId = await _getNextHouse();
      _previousHouseId = await _getPreviousHouse();
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
      body: GestureDetector(
        onHorizontalDragEnd: _handleSwipe,
        child: SingleChildScrollView(
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
                      buildDetailRow(context, Icons.email, S.of(context).email, email, wrapText: true),
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
      ),
    );
  }
}
