import 'package:flutter/material.dart';
import 'package:samsar/Widgets/widgets.dart';
import 'package:samsar/helpers/user_manager.dart';
import 'package:samsar/values/app_routes.dart';
import '../../values/structures.dart';

class MyHousesPage extends StatefulWidget {
  const MyHousesPage({super.key});

  @override
  State<MyHousesPage> createState() => _MyHousesPageState();
}

class _MyHousesPageState extends State<MyHousesPage> {
  final UserManager _userManager = UserManager();
  List<House> _userHouses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserHouses();
  }

  Future<void> _fetchUserHouses() async {
    setState(() {
      _isLoading = true;
    });
    try {
      setState(() {
        _userHouses = _userManager.houses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) showSnackBar(context, "Error fetching houses: $e");
    }
  }

  Future<void> _refreshUserHouses() async {
    setState(() {
      _isLoading = true;
    });
    await _userManager.updateUserHouses();
    _fetchUserHouses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Houses"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userHouses.isEmpty
          ? const Center(child: Text("You don't have any houses listed."))
          : RefreshIndicator(
        onRefresh: _refreshUserHouses,
        child: ListView.builder(
          itemCount: _userHouses.length,
          itemBuilder: (context, index) {
            final house = _userHouses[index];
            return MyHouseOverviewItem(
              house: house,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.editHouse,
                  arguments: house.id,
                ).then((_) =>_userManager.updateUserHouses())
                    .then((_) => _fetchUserHouses());
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.uploadHouse);
        },
        tooltip: 'Add New House',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyHouseOverviewItem extends StatelessWidget {
  final House house;
  final VoidCallback onTap;

  const MyHouseOverviewItem({
    super.key,
    required this.house,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageHeader(theme),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTypeAndLocation(theme),
                  const SizedBox(height: 8),
                  _buildPriceRow(theme),
                  const SizedBox(height: 8),
                  _buildSpecsRow(theme),
                  const SizedBox(height: 8),
                  _buildStatusRow(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageHeader(ThemeData theme) {
    return Stack(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            image: house.images.isNotEmpty
                ? DecorationImage(
              image: NetworkImage(house.images[0]),
              fit: BoxFit.cover,
            )
                : null,
          ),
          child: house.images.isEmpty
              ? Center(child: Icon(Icons.home, size: 50, color: theme.primaryColor))
              : null,
        ),
        Positioned(
          top: 8,
          right: 8,
          child: _build3DChip(theme),
        ),
      ],
    );
  }

  Widget _buildTypeAndLocation(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            house.specs.type,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Icon(Icons.location_on, size: 16, color: theme.hintColor),
        Text(
          house.location.city,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildPriceRow(ThemeData theme) {
    return Row(
      children: [
        Text(
          '${house.specs.price} TND',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (house.status.isForRent)
          Text(
            'For Rent',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.blue),
          ),
        if (house.status.isForRent && house.status.isForSale)
          Text(
            ' & ',
            style: theme.textTheme.bodySmall
          ),
        if (house.status.isForSale)
          Text(
            'For Sale',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.green),
          ),
      ],
    );
  }

  Widget _buildSpecsRow(ThemeData theme) {
    return Row(
      children: [
        Icon(Icons.home, size: 16, color: theme.hintColor),
        const SizedBox(width: 4),
        Text('${house.specs.rooms} rooms'),
        const SizedBox(width: 16),
        Icon(Icons.square_foot, size: 16, color: theme.hintColor),
        const SizedBox(width: 4),
        Text('${house.specs.area.round()} m²'),
      ],
    );
  }

  Widget _buildStatusRow(ThemeData theme) {
    return Row(
      children: [
        Icon(Icons.access_time, size: 16, color: theme.hintColor),
        const SizedBox(width: 4),
        Text(
          'Updated ${_formatDate(house.updatedAt)}',
          style: theme.textTheme.bodySmall,
        ),
        const Spacer(),
        _buildAvailabilityChip(theme),
      ],
    );
  }

  Widget _build3DChip(ThemeData theme) {
    return house.samsarStatus.is3D
        ? Chip(
      label: Text(
        '3D',
        style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.blue,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    )
        : const SizedBox.shrink();
  }

  Widget _buildAvailabilityChip(ThemeData theme) {
    return Chip(
      label: Text(
        house.status.isAvailable ? 'Available' : 'Not Available',
        style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: house.status.isAvailable ? Colors.green : Colors.red,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year(s) ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month(s) ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day(s) ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour(s) ago';
    } else {
      return 'Recently';
    }
  }
}
/*
class MyHouseOverviewItem extends StatelessWidget {
  final House house;
  final VoidCallback onTap;

  const MyHouseOverviewItem({
    super.key,
    required this.house,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHouseImage(theme),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${house.specs.type} in ${house.location.city}",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildHouseDetails(theme),
                    const SizedBox(height: 8),
                    Text(
                      "${house.specs.price} TND",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStatusChip(theme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHouseImage(ThemeData theme) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: house.images.isNotEmpty
            ? DecorationImage(
          image: NetworkImage(house.images[0]),
          fit: BoxFit.cover,
        )
            : null,
      ),
      child: house.images.isEmpty
          ? Icon(Icons.house, size: 50, color: theme.primaryColor)
          : null,
    );
  }

  Widget _buildHouseDetails(ThemeData theme) {
    return Row(
      children: [
        Icon(Icons.bedroom_parent, size: 16, color: theme.hintColor),
        const SizedBox(width: 4),
        Text("${house.specs.rooms}"),
        const SizedBox(width: 16),
        Icon(Icons.square_foot, size: 16, color: theme.hintColor),
        const SizedBox(width: 4),
        Text("${house.specs.area.round()}m²"),
      ],
    );
  }

  Widget _buildStatusChip(ThemeData theme) {
    return Chip(
      label: Text(
        _getStatusName(house.status.isAvailable),
        style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: _getStatusColor(house.status.isAvailable),
    );
  }

  String _getStatusName(bool available) {
    if(available) return "Available";
    return "Pending";
  }

  Color _getStatusColor(bool available) {
    if(available) return Colors.green;
    return Colors.orange;
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:samsar/Widgets/widgets.dart';
import 'package:samsar/values/app_routes.dart';
import '../../values/structures.dart';

class MyHousesPage extends StatefulWidget {
  const MyHousesPage({super.key});

  @override
  State<MyHousesPage> createState() => _MyHousesPageState();
}

class _MyHousesPageState extends State<MyHousesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<House> _userHouses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserHouses();
  }

  Future<void> _fetchUserHouses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user != null) {
        final querySnapshot = await _firestore
            .collection('houses')
            .where('owner.id', isEqualTo: user.uid)
            .get();

        setState(() {
          _userHouses = querySnapshot.docs
              .map((doc) => houseFromFirestore(doc.data(), doc.id))
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception('No user logged in');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) showSnackBar(context, "Error fetching houses: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Houses"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userHouses.isEmpty
          ? const Center(child: Text("You don't have any houses listed."))
          : RefreshIndicator(
            onRefresh: _fetchUserHouses,
            child: ListView.builder(
              itemCount: _userHouses.length,
              itemBuilder: (context, index) {
                final house = _userHouses[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 80,  // Increased width
                      height: 80, // Increased height
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: house.images.isNotEmpty
                            ? DecorationImage(
                          image: NetworkImage(house.images[0]),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: house.images.isEmpty
                          ? Icon(Icons.house, size: 40, color: theme.primaryColor)
                          : null,
                    ),
                    title: Text(
                      "${house.specs.type} in ${house.location.city}",
                      style: theme.textTheme.bodyMedium,
                    ),
                    subtitle: Column(
                      children: [
                        Text(
                          "${house.specs.rooms} rooms - ${house.specs.area.round()}m²",
                          style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white
                          ),
                        ),
                        Text(
                          "${house.specs.price} TND",
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.editHouse, arguments: house.id).then((_) => _fetchUserHouses());
                    },
                  ),
                );
              },
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.uploadHouse);
        },
        tooltip: 'Add New House',
        child: const Icon(Icons.add),
      ),
    );
  }
}*/