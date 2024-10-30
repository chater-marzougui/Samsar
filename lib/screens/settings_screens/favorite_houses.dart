import 'package:flutter/material.dart';
import 'package:samsar/Widgets/widgets.dart';
import 'package:samsar/helpers/user_manager.dart';
import 'package:samsar/values/app_routes.dart';
import '../../values/structures.dart';

class FavouriteHousesPage extends StatefulWidget {
  const FavouriteHousesPage({super.key});

  @override
  State<FavouriteHousesPage> createState() => _FavouriteHousesPageState();
}

class _FavouriteHousesPageState extends State<FavouriteHousesPage> {
  final UserManager _userManager = UserManager();
  List<House> _userFavouriteHouses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserFavouriteHouses();
  }
/*
  Future<void> _fetchUserFavouriteHouses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc =
        await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          final favouriteHousesIds =
          List<String>.from(userDoc.data()?['favouriteHouses'] ?? []);

          if (favouriteHousesIds.isNotEmpty) {
            final housesQuery = await _firestore
                .collection('houses')
                .where(FieldPath.documentId, whereIn: favouriteHousesIds)
                .get();

            setState(() {
              _userFavouriteHouses = housesQuery.docs
                  .map((doc) => houseFromFirestore(doc.data(), doc.id))
                  .toList();
              _isLoading = false;
            });
          } else {
            setState(() {
              _userFavouriteHouses = [];
              _isLoading = false;
            });
          }
        } else {
          throw Exception('User document not found');
        }
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
*/
  Future<void> _fetchUserFavouriteHouses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      setState(() {
        _userFavouriteHouses = _userManager.favouriteHouses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) showSnackBar(context, "Error fetching houses: $e");
    }
  }

  Future<void> _refreshFavHouses() async {
    setState(() {
      _isLoading = true;
    });
    await _userManager.updateUserHouses();
    _fetchUserFavouriteHouses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourite Houses"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userFavouriteHouses.isEmpty
          ? const Center(child: Text("You don't have any houses listed."))
          : RefreshIndicator(
              onRefresh: _refreshFavHouses,
              child: ListView.builder(
                itemCount: _userFavouriteHouses.length,
                itemBuilder: (context, index) {
                  final house = _userFavouriteHouses[index];
                  return FavouriteHouseOverviewItem(
                    house: house,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.houseDetails,
                          arguments: house.id)
                      .then((_) => _userManager.updateUserHouses())
                          .then((_) => _fetchUserFavouriteHouses());
                    },
                  );
                },
              ),
            ),
    );
  }
}

class FavouriteHouseOverviewItem extends StatelessWidget {
  final House house;
  final VoidCallback onTap;

  const FavouriteHouseOverviewItem({
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
}