import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StoreLocationMap extends StatefulWidget {
  const StoreLocationMap({Key? key}) : super(key: key);

  @override
  _StoreLocationMapState createState() => _StoreLocationMapState();
}

class _StoreLocationMapState extends State<StoreLocationMap> {
  final List<Marker> _markers = [];
  LatLng? position;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GoogleMap(
          initialCameraPosition: _kGooglePlex,
          markers: _markers.toSet(),
          onMapCreated: (controller) {
            Marker marker = const Marker(
              visible: false,
              markerId: MarkerId('0'),
              position: LatLng(37, 40),
            );

            _markers.add(marker);
          },
          onCameraMove: (position) {
            setState(() {
              _markers.first =
                  _markers.first.copyWith(positionParam: position.target);
              print(position);
            });
          },
        ),
        Image.asset(
          'images/pin.png',
          height: 55,
          width: 55,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return Transform.translate(
              offset: const Offset(0, -25),
              child: child,
            );
          },
        )
      ],
    );
  }

  static final CameraPosition _kGooglePlex =
      CameraPosition(target: const LatLng(37.743388, 29.104555), zoom: 14);
}
