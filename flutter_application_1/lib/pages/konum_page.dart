import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class KonumPage extends StatefulWidget {
  final double lat;
  final double long;
  const KonumPage({required this.lat, required this.long});

  @override
  State<KonumPage> createState() => _KonumPageState();
}

class _KonumPageState extends State<KonumPage> {
  Set<Marker> _markers = {};
  @override
  Widget build(BuildContext context) {
    LatLng konum = LatLng(widget.lat, widget.long);
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: konum,
          zoom: 15,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _markers.add(
              Marker(
                markerId: MarkerId('1'),
                position: konum,
              ),
            );
          });
        },
      ),
    );
  }
}