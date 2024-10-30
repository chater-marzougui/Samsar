import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../helpers/CachedTileProvider.dart';
import '../values/structures.dart';

class POI {
  final String type;
  final LatLng location;

  POI(this.type, this.location);
}

class LocationDocWidget extends StatefulWidget {
  final House house;

  const LocationDocWidget({
    super.key,
    required this.house,
  });

  @override
  State<LocationDocWidget> createState() => _LocationDocWidgetState();
}

class _LocationDocWidgetState extends State<LocationDocWidget> {
  final MapController mapController = MapController();
  double zoomLevel = 14.0;
  List<POI> pois = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPOIs();
    });
  }

  Future<void> fetchPOIs() async {
    final bounds = mapController.camera.visibleBounds;
    final double distance = 0.045;
    final south = bounds.south - distance;
    final west = bounds.west - distance;
    final north = bounds.north + distance;
    final east = bounds.east + distance;
    final box = "($south,$west,$north,$east)";

    final query = '''
      [out:json];
      (
        node["amenity"="hospital"]$box;
        node["amenity"="pharmacy"]$box;
        node["amenity"="police"]$box;
        node["amenity"="atm"]$box;
        node["amenity"="bank"]$box;
        node["amenity"="fuel"]$box;
        node["shop"="supermarket"]$box;
        node["amenity"="parking"]$box;
        node["leisure"="park"]$box;
      );
      out center;
    ''';

    final response = await http.get(Uri.parse(
        'https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(query)}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        pois = (data['elements'] as List).map((element) {
          final type = element['tags']['amenity'] ?? element['tags']['shop'] ?? element['tags']['leisure'];
          final lat = element['lat'] ?? element['center']['lat'];
          final lon = element['lon'] ?? element['center']['lon'];
          return POI(type, LatLng(lat, lon));
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    LatLng currentMapCenter = LatLng(widget.house.location.latitude, widget.house.location.longitude);

    return Card(
      elevation: 4,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 16.0, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, size: 24, color: theme.iconTheme.color),
                const SizedBox(width: 8),
                Text(
                  'Address',
                  style: theme.textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.house.location.address,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: currentMapCenter,
                      initialZoom: zoomLevel,
                      maxZoom: 17.5,
                      minZoom: 13,
                      onMapReady: () {
                        mapController.move(currentMapCenter, zoomLevel);
                        fetchPOIs();
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        tileProvider: CachedTileProvider(),
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(widget.house.location.latitude, widget.house.location.longitude),
                            width: 40,
                            height: 40,
                            child : Image.asset(
                              'assets/icons/home_loc.png',
                              height: 40,
                              width: 40,
                            ),
                          ),
                          ...pois.map((poi) => Marker(
                            point: poi.location,
                            width: 60,
                            height: 60,
                            child: Icon(
                              _getIconForPOI(poi.type),
                              color: _getColorForPOI(poi.type),
                              size: 30.0,
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        mapController.move(currentMapCenter, zoomLevel);
                        fetchPOIs();
                      },
                      icon: const Icon(Icons.my_location),
                      label: const Text("Recenter"),
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
}

IconData _getIconForPOI(String type) {
  switch (type) {
    case 'hospital':
      return Icons.local_hospital;
    case 'pharmacy':
      return Icons.local_pharmacy;
    case 'police':
      return Icons.local_police;
    case 'atm':
    case 'bank':
      return Icons.attach_money;
    case 'fuel':
      return Icons.local_gas_station;
    case 'supermarket':
      return Icons.shopping_cart;
    case 'parking':
      return Icons.local_parking;
    case 'park':
      return Icons.park;
    default:
      return Icons.place;
  }
}

Color _getColorForPOI(String type) {
  switch (type) {
    case 'hospital':
    case 'pharmacy':
      return Colors.red;
    case 'police':
      return Colors.blue;
    case 'atm':
    case 'bank':
      return Colors.green;
    case 'fuel':
      return Colors.orange;
    case 'supermarket':
      return Colors.purple;
    case 'parking':
      return Colors.indigo;
    case 'park':
      return Colors.lightGreen;
    default:
      return Colors.grey;
  }
}