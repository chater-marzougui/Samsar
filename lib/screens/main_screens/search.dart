import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:samsar/helpers/user_manager.dart';
import 'package:samsar/values/structures.dart';
import '../../Widgets/widgets.dart';
import '../../helpers/house_manager.dart';
import '../../l10n/l10n.dart';
import '../../values/app_routes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static void Function()? refreshPage;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final HouseManager _houseManager = HouseManager();
  final UserManager _userManager = UserManager();

  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  bool _isListNearbyEmpty = true;

  LatLng? _currentPosition;
  double _maxAllowedDistance = 100.0;
  bool _sortByDistance = true;

  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _houseManager.onHouseTap = _navigateToHouseDetails;
    _initializeHouses();

    SearchScreen.refreshPage = () async {
      await _houseManager.fetchHousesWithDistance(sortWithPrice: !_sortByDistance);
      _scrollToTop();

      if (mounted) {
        setState(() {});
      }
    };

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 60, right: 16, bottom: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200], // Light background color
                            borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                          ),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _focusNode,
                            onTapOutside: (event) => {_focusNode.unfocus()},
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.grey[900],
                            ),
                            decoration: InputDecoration(
                              hintText: S.of(context).changeToAnotherLoc,
                              hintStyle: const TextStyle(
                                  color: Colors.grey), // Subtle hint text color
                              border: InputBorder.none,
                              prefixIcon: const Icon(Icons.search,
                                  color: Colors.grey), // Search icon
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                icon:
                                  const Icon(Icons.clear, color: Colors.grey),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchResults = [];
                                      });
                                    },
                                  )
                                  : null,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15), // Padding for text
                            ),
                            onChanged: (value) {
                              _searchPlace(value);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.filter_alt_rounded),
                        iconSize: 38,
                        color: Colors.blue,
                        onPressed: () async {
                          final Map<String, dynamic>? newFilters =
                          await showFilterDialog(context);
                          if (newFilters != null) {
                            setState(() {
                              _isLoading = true;
                            });
                            await _houseManager.fetchHousesWithDistance(
                                filters: newFilters, sortWithPrice: !_sortByDistance);
                            setState(() {
                              _isLoading = false;
                            });
                            _scrollToTop();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverAppBar(
                        floating: true,
                        backgroundColor: theme.canvasColor,
                        elevation: 0,
                        flexibleSpace: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                height: 30,
                                width: 30,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.map_outlined,
                                    size: 30,
                                  ),
                                  onPressed: _showMap,
                                ),
                              ),
                              Visibility(
                                maintainAnimation: true,
                                maintainState: true,
                                maintainSize: true,
                                visible: _userManager.stringLocation != "",
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedBuilder(
                                      animation: _controller,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: _scaleAnimation.value,
                                          child: Opacity(
                                            opacity: _opacityAnimation.value,
                                            child: const Icon(
                                              Icons.location_on,
                                              size: 30,
                                              color: Colors.red,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _userManager.stringLocation,
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                height: 30,
                                width: 30,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.sort,
                                    size: 30,
                                  ),
                                  onPressed: _showDistanceAndSortingDialog,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if(!_isLoading)
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              if (index < _houseManager.housesWithDistance.length) {
                                final houseWithDistance = _houseManager.housesWithDistance[index];
                                if (houseWithDistance.distance < _maxAllowedDistance * 1000) {
                                  _isListNearbyEmpty = false;
                                  return HousePreviewWidget(
                                    house: houseWithDistance.house,
                                    distance: houseWithDistance.distance,
                                    onTap: () => _navigateToHouseDetails(houseWithDistance.house.id),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              } else {
                                if (_isListNearbyEmpty || _houseManager.housesWithDistance.isEmpty) {
                                  return SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.6,
                                      child: SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.6,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.search_off,
                                                size: 64,
                                                color: theme.disabledColor,
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                S.of(context).noResultsFound,
                                                style: theme.textTheme.titleMedium?.copyWith(
                                                  color: theme.disabledColor,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                S.of(context).adjustSearchOrFilters,
                                                style: theme.textTheme.bodyMedium?.copyWith(
                                                  color: theme.disabledColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  );
                                } else {
                                  return Padding(
                                      padding: const EdgeInsets.all(48.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(48.0),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  // House Icon
                                                  Icon(
                                                    Icons.house,
                                                    size: 48,
                                                    color: theme.disabledColor,
                                                  ),
                                                  Positioned(
                                                    top: 24,
                                                    right: -8,
                                                    child: Transform.rotate(
                                                      angle: -0.7854,
                                                      child: Container(
                                                        height: 3, // Thickness of the line
                                                        width: 62, // Width of the line
                                                        decoration: BoxDecoration(
                                                          color: theme.disabledColor, // Color of the line
                                                          borderRadius: BorderRadius.circular(2), // Add border radius
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                S.of(context).noMoreHousesFound,
                                                style: theme.textTheme.bodySmall?.copyWith(
                                                  color: theme.disabledColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  );
                                }
                              }
                            },
                            childCount: _houseManager.housesWithDistance.length + 1,
                          ),
                        )
                      else
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
            if (_searchResults.isNotEmpty)
              Positioned(
                height: 300,
                top: 115,
                left: 0,
                right: 0,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10),
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final place = _searchResults[index];
                      return Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10),
                            tileColor: Colors
                                .transparent,
                            title: Text(
                              _getLocationSubstring(place['display_name']),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.black, // Darker text for readability
                                fontWeight: FontWeight.w500, // Slightly bold text
                              ),
                            ),
                            leading: const Icon(Icons.location_on,
                                color: Colors.blue),
                            trailing: Icon(Icons.arrow_forward_ios,
                                color: Colors.grey[400],
                                size: 16),
                            onTap: () => _selectPlace(place),
                          ),
                          if (index < _searchResults.length - 1)
                            const Divider(
                                height: 1,
                                color: Colors
                                    .grey),
                        ],
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _initializeHouses() async {
    _currentPosition = _userManager.location;
    await _updatePositionVariables();

    await _houseManager.fetchHousesWithDistance();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updatePositionVariables() async {
    await getLocationFromLatLong(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );
    if (_currentPosition != null) {
      setState(() {
        _userManager.location =
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
      });
    }
  }

  void _navigateToHouseDetails(String houseId) {
    Navigator.pushNamed(context, AppRoutes.houseDetails, arguments: houseId);
  }

  Future<void> _sort() async{
    setState(() {
      _isLoading = true;
    });
    await _houseManager.fetchHousesWithDistance(
        sortWithPrice: !_sortByDistance);
    setState(() {
      _isLoading = false;
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  void _showDistanceAndSortingDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                S.of(context).sorting,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(S.of(context).maxDistance(_maxAllowedDistance.round())),
                  Slider(
                    min: 1,
                    max: 100,
                    value: _maxAllowedDistance,
                    divisions: 99,
                    label: _maxAllowedDistance.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _maxAllowedDistance = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    S.of(context).sortBy,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _sortByDistance,
                        onChanged: (value) {
                          setState(() {
                            _sortByDistance = value!;
                          });
                        },
                      ),
                      Text(
                        S.of(context).distance,
                        style: theme.textTheme.titleSmall,
                        textAlign: TextAlign.center,
                      ),
                      Radio<bool>(
                        value: false,
                        groupValue: _sortByDistance,
                        onChanged: (value) {
                          setState(() {
                            _sortByDistance = value!;
                          });
                        },
                      ),
                      Text(
                        S.of(context).price,
                        style: theme.textTheme.titleSmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(S.of(context).cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(S.of(context).apply),
                  onPressed: () {
                    _sort();
                    Navigator.of(context).pop();

                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _searchPlace(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    final encodedQuery = Uri.encodeComponent('$query*');
    final url = Uri.parse('https://nominatim.openstreetmap.org/search'
        '?q=$encodedQuery'
        '&format=json'
        '&limit=7'
        '&addressdetails=0'
        '&countrycodes=${_userManager.countryCode}'
        '&accept-language=ar,fr,en');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _searchResults = jsonDecode(response.body);
        });
      } else {
        if (mounted) throw Exception(S.of(context).failedToLoadSearchResults);
      }
    } catch (e) {
      if (mounted) showSnackBar(context, S.of(context).errorSearchingForPlaces);
    }
  }

  Future<void> _selectPlace(Map<String, dynamic> place) async {
    setState(() {
      _isLoading = true;
      _searchResults = [];
    });
    final lat = double.parse(place['lat']);
    final lon = double.parse(place['lon']);
    _userManager.location = LatLng(lat, lon);
    await getLocationFromLatLong(lat, lon);
    await _houseManager.fetchHousesWithDistance(sortWithPrice: !_sortByDistance);

    setState(() {
      _isLoading = false;
      _searchController.text = place['display_name'];
    });
    _focusNode.unfocus();
  }

  String _getLocationSubstring(String loc) {
    if (loc.length > 83) {
      return "${loc.substring(0, 83)}...";
    } else {
      return loc;
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _houseManager.fetchHousesWithDistance(sortWithPrice: !_sortByDistance);
    setState(() {
      _isLoading = false;
    });
  }

  void _showMap() {
    // TODO Show show map dialog
  }
}
