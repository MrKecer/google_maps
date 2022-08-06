import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({Key? key}) : super(key: key);

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  late GoogleMapController mapController;

  List<Marker> _marker = [];
  LatLng? location;
  String? searchAdress;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            mapType: MapType.normal,
            markers: _marker.toSet(),
            //onTap: _handleTap,
            onCameraMove: (position) {
              setState(() {
                _marker.first =
                    _marker.first.copyWith(positionParam: position.target);
                print(position);
              });
            },
            onMapCreated: (GoogleMapController map) {
              Marker marker = const Marker(
                visible: false,
                markerId: MarkerId('0'),
                position: LatLng(37, 40),
              );
              _marker.add(marker);
              mapController = map;
              //map oluşturma logicleri custom marker vs
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
          ),
          Positioned(
            left: 15,
            right: 15,
            top: 30,
            child: SizedBox(
              height: 55,
              width: MediaQuery.of(context).size.width - 50,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchAdress = value;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 10),
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchNavigate();
                    },
                    icon: Icon(Icons.search),
                  ),
                  filled: true,
                  hintText: "Adres Girin",
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                onPressed: () {
                  mapController
                      .animateCamera(CameraUpdate.newLatLngZoom(location!, 17));
                  getAdressFromLatLng();
                  print("$location");
                },
                tooltip: "Seçili Adrese Git",
                icon: const Icon(
                  Icons.map,
                  color: Colors.indigo,
                  size: 36,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  searchNavigate() {
    print(searchAdress);
    locationFromAddress(searchAdress!).then((value) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(value[0].latitude, value[0].longitude), zoom: 20),
        ),
      );
    });
  }

  getAdressFromLatLng() {
    placemarkFromCoordinates(location!.latitude, location!.longitude)
        .then((value) {
      print(value[0].administrativeArea);
    });
  }

  static final CameraPosition _kGooglePlex =
      CameraPosition(target: const LatLng(37.743388, 29.104555), zoom: 14);

  // _handleTap(LatLng tappedPoint) {
  //   setState(() {
  //     marker = [];
  //     marker.add(
  //       Marker(
  //         markerId: MarkerId(tappedPoint.toString()),
  //         position: tappedPoint,
  //         infoWindow: const InfoWindow(title: "Tıklanan Bölge"),
  //         draggable: true,
  //         onDragEnd: ((dragEndPositions) {
  //           location = dragEndPositions;
  //         }),
  //       ),
  //     );
  //   });
  //   location = tappedPoint;
  //   print(location);
  // }

}
