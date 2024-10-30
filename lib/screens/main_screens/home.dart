import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:samsar/helpers/user_manager.dart';
import 'package:samsar/values/structures.dart';
import '../../Widgets/widgets.dart';
import '../../helpers/CachedTileProvider.dart';
import '../../helpers/house_manager.dart';
import '../../values/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isMapReady = false;

  final HouseManager _houseManager = HouseManager();
  final MapController _mapController = MapController();
  final UserManager _userManager = UserManager();

  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  LatLng? _currentPosition;
  LatLng _currentMapCenter = const LatLng(36.8002275, 10.186199454411298);
  double _zoomLevel = 7.0;
  bool _isLoading = true;
  bool _isDrawing = false;
  bool _isChoosingPosition = false;
  List<LatLng> _drawnPoints = [];
  Polyline _currentLine =
      Polyline(points: [], color: Colors.blue, strokeWidth: 3.0);
  Polygon _currentPolygon = Polygon(points: []);

  @override
  void initState() {
    super.initState();
    _initializeLocationAndMap();
    _houseManager.onHouseTap = _navigateToHouseDetails;
  }


  Future<void> _initializeLocationAndMap() async {
    _currentPosition = _userManager.location;
    await _houseManager.fetchHouses();
    setState(() {
      _isLoading = false;
    });
  }

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentMapCenter,
              initialZoom: _zoomLevel,
              maxZoom: 19,
              minZoom: 4.5,
              onMapReady: () {
                setState(() {
                  isMapReady = true;
                });
                _mapController.move(_currentMapCenter, _zoomLevel);
              },
              onPositionChanged: (mapPosition, _) {
                _handleZoomChange(mapPosition.zoom);
                if (!_isDrawing) {
                  _currentMapCenter = mapPosition.center;
                  _zoomLevel = mapPosition.zoom;
                }
              },
              interactionOptions: InteractionOptions(
                flags: _isDrawing ? InteractiveFlag.none : InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                tileProvider: CachedTileProvider(),
              ),
              if (_currentPolygon.points.isNotEmpty)
                PolygonLayer(polygons: [_currentPolygon]),
              PolylineLayer(polylines: [_currentLine]),
              MarkerLayer(markers: [
                ..._houseManager.markers,
                if (_currentPosition != null)
                  Marker(
                    point: LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                    rotate: true,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.person_pin_circle,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
              ]),
            ],
          ),
          if (_isDrawing || _isChoosingPosition)
            Positioned.fill(
              child: GestureDetector(
                onPanStart: (details) {
                  final latLng =
                      _getLatLngFromScreenCoordinates(details.localPosition);
                  if (latLng != null) {
                    _startDrawing(latLng);
                  }
                },
                onPanUpdate: (details) {
                  final latLng =
                      _getLatLngFromScreenCoordinates(details.localPosition);
                  if (latLng != null) {
                    _continueDrawing(latLng);
                  }
                },
                onPanEnd: (_) => _finishDrawing(),
                child: Container(color: Colors.transparent),
              ),
            ),
          if (_isChoosingPosition)
            Positioned.fill(
              child: GestureDetector(
                onTapDown: (details) {
                  final latLng =
                      _getLatLngFromScreenCoordinates(details.localPosition);
                  latLng != null ? _changePosition(latLng) : null;
                },
                child: Container(color: Colors.transparent),
              ),
            ),
          if (_isLoading)
              Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 60, right: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          onTapOutside: (event) => _focusNode.unfocus(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.grey[900],
                          ),
                          decoration: InputDecoration(
                            hintText: 'Change another location',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: InputBorder.none,
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.grey),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear,
                                        color: Colors.grey),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        _searchResults = [];
                                      });
                                    },
                                  )
                                : null,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onChanged: (value) {
                            _searchPlace(value);
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_alt_rounded),
                      iconSize: 38,
                      color: Colors.blue,
                      onPressed: () async {
                        final Map<String, dynamic>? newFilters = await showFilterDialog(context);
                        if (newFilters != null) {
                          await _houseManager.fetchHouses(filters: newFilters);
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
              ),
              if (_searchResults.isNotEmpty)
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16), // Adds padding around the dropdown
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.9), // Semi-transparent background
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Subtle shadow
                        blurRadius: 10,
                        offset: const Offset(0, 4), // Slight elevation effect
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10), // Adds some padding inside the list
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final place = _searchResults[index];
                      final lat = double.parse(place['lat']);
                      final lon = double.parse(place['lon']);

                      return Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical:
                                    10), // Adds padding inside each ListTile
                            tileColor: Colors
                                .white, // White background for individual tiles
                            title: Text(
                              getSubstringLocation(place['display_name']),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color:
                                    Colors.black, // Darker text for readability
                                fontWeight:
                                    FontWeight.w500, // Slightly bold text
                              ),
                            ),
                            leading: const Icon(Icons.location_on,
                                color: Colors.blue), // Icon for location
                            trailing: Icon(Icons.arrow_forward_ios,
                                color: Colors.grey[400],
                                size: 16), // Right arrow for visual indication
                            onTap: () {
                              _moveToPlace(LatLng(lat, lon));
                              _changePosition(LatLng(lat, lon));
                              setState(() {
                                _searchResults = [];
                                _searchController.clear();
                              });
                            },
                          ),
                          if (index < _searchResults.length - 1)
                            const Divider(
                                height: 1,
                                color: Colors
                                    .grey), // Adds a divider between list items
                        ],
                      );
                    },
                  ),
                )
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.zoom_in),
                  onPressed: _zoomIn,
                  color: Colors.blue,
                  iconSize: 36.0,
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: const Icon(Icons.zoom_out),
                  onPressed: _zoomOut,
                  color: Colors.blue,
                  iconSize: 36.0,
                ),
              ],
            ),
          ),
          Positioned(
            top: 150,
            right: 12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _houseManager.applyPolygonFilter ? 50 : 0,
                      child: _houseManager.applyPolygonFilter
                          ? buildFloatingButton(
                        tag: "Cancel Filter+Draw Button",
                        onPressed: () {
                          setState(() {
                            _houseManager.turnOffPolygonFilter();
                          });
                        },
                        icon: Icons.close,
                        backgroundColor: Colors.lightBlue[200]!,
                      )
                          : null,
                    ),
                    buildFloatingButton(
                      tag: "Toggle draw on map",
                      onPressed: _toggleDrawing,
                      image: _isDrawing
                          ? 'assets/icons/draw_on_map.png'
                          : "assets/icons/no_draw_on_map.png",
                      backgroundColor: Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                buildFloatingButton(
                  tag: "Toggle change position",
                  onPressed: _toggleChangePosition,
                  image: _isChoosingPosition
                      ? 'assets/icons/choose_position.png'
                      : "assets/icons/no_choose_position.png",
                  backgroundColor: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleChangePosition() {
    setState(() {
      _isDrawing = false;
      _isChoosingPosition = !_isChoosingPosition;
    });
  }

  void _changePosition(LatLng point) {
    getLocationFromLatLong(point.latitude, point.longitude);
    setState(() {
      _currentPosition = point;
      _currentMapCenter = point;
      _userManager.location =  point;
    });
  }

  void _handleZoomChange(double newZoom) {
    int newShownLevel = _getLevelByZoom(newZoom);
    if (newShownLevel != _houseManager.shownLevel) {
      _houseManager.updateShownLevel(newShownLevel);
      setState(() {});
    }
  }

  int _getLevelByZoom(double zoom) {
    if (zoom < 7.5) return 5;
    if (zoom < 9) return 4;
    if (zoom < 10.5) return 3;
    if (zoom < 12) return 2;
    return 1;
  }

  void _toggleDrawing() {
    setState(() {
      _isChoosingPosition = false;
      _isDrawing = !_isDrawing;
      _drawnPoints = [];
      _currentLine = Polyline(points: [], color: Colors.blue, strokeWidth: 3.0);
      _currentPolygon = Polygon(points: [], color: Colors.blue);
    });
  }

  void _startDrawing(LatLng point) {
    setState(() {
      _currentPolygon = Polygon(
        points: [],
        color: Colors.blue.withOpacity(0.3),
        borderColor: Colors.blueAccent,
        borderStrokeWidth: 1.0,
      );
      _drawnPoints = [point];
      _currentLine = Polyline(
        points: _drawnPoints,
        color: Colors.blue,
        strokeWidth: 3.0,
      );
    });
  }

  void _continueDrawing(LatLng point) {
    setState(() {
      _drawnPoints.add(point);
      _currentLine = Polyline(
        points: _drawnPoints,
        color: Colors.blue,
        strokeWidth: 3.0,
      );
    });
  }

  void _finishDrawing() {
    _drawnPoints.add(_drawnPoints.first);
    _houseManager.findHousesInsidePolygon(_drawnPoints);

    setState(() {
      _currentLine =
          Polyline(points: _drawnPoints, color: Colors.blue, strokeWidth: 3.0);
      _currentPolygon = Polygon(
        points: _drawnPoints,
        color: Colors.blue.withOpacity(0.3),
        borderColor: Colors.blueAccent,
        borderStrokeWidth: 1.0,
      );
    });
  }

  String getSubstringLocation(String loc) {
    if (loc.length > 83) {
      return "${loc.substring(0, 83)}...";
    } else {
      return loc;
    }
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
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Error searching for places');
      }
    }
  }

  LatLng? _getLatLngFromScreenCoordinates(Offset position) {
    final bounds = _mapController.camera.offsetToCrs(position);
    return LatLng(bounds.latitude, bounds.longitude);
  }

  void _moveToPlace(LatLng location) {
    _mapController.move(location, _zoomLevel);
    setState(() {
      _currentMapCenter = location;
    });
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel++;
      _mapController.move(_currentMapCenter, _zoomLevel);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel--;
      _mapController.move(_currentMapCenter, _zoomLevel);
    });
  }

  void _navigateToHouseDetails(String houseId) {
    Navigator.pushNamed(context, AppRoutes.houseDetails, arguments: houseId);
  }

}

