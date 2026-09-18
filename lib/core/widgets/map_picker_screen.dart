import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../constants/app_colors.dart';

class MapPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;
  final String title;

  const MapPickerScreen({
    super.key,
    this.initialLocation,
    this.title = 'Pilih Lokasi',
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late MapController _mapController;
  late LatLng _currentCenter;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    // Default to Wirosari if no initial location
    _currentCenter = widget.initialLocation ?? const LatLng(-7.0648, 110.9172);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentCenter,
              initialZoom: 15.5,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  setState(() => _currentCenter = position.center);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.jastip_application',
              ),
            ],
          ),
          
          // Center Marker Pin
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 40), // offset to point exactly at center
              child: Icon(
                Icons.location_on,
                size: 40,
                color: AppColors.primary,
              ),
            ),
          ),
          
          // Bottom button
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(_currentCenter);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Pilih Lokasi Ini',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // Current location FAB
          Positioned(
            right: 20,
            bottom: 100,
            child: FloatingActionButton(
              heroTag: 'my_location',
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              onPressed: () {
                // Move back to initial
                _mapController.move(widget.initialLocation ?? const LatLng(-7.0648, 110.9172), 15.5);
              },
              child: const Icon(Icons.my_location),
            ),
          )
        ],
      ),
    );
  }
}
