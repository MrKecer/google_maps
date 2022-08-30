import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//FIXME:Search buton altındaki pusula kaldırılacak.
class GoogleMaps extends StatefulWidget {
  const GoogleMaps({Key? key}) : super(key: key);

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  late GoogleMapController mapController;
  MapType mapStatus = MapType.normal;
  List<Marker> _marker = [];
  double? lt;
  double? lng;
  String? searchAdress;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        //  clipBehavior: Clip.antiAlias,
        // decoration: const BoxDecoration(
        //     borderRadius: BorderRadius.all(Radius.circular(49))),
        child: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: _kGooglePlex,
              mapType: mapType(),
              markers: _marker.toSet(),
              //onTap: _handleTap,
              onCameraMove: move,
              onMapCreated: (GoogleMapController map) {
                Marker marker = const Marker(
                  visible: false,
                  markerId: MarkerId('0'),
                  position: LatLng(37, 40),
                );

                _marker.add(marker);
                mapController = map;
              },
            ),
            Image.asset(
              'images/pin.png',
              height: 50,
              width: 50,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                return Transform.translate(
                  offset: const Offset(0, -20),
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
                child: Theme(
                  data: themeData(),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchAdress = value;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 15),
                      suffixIcon: IconButton(
                        tooltip: "Adres Ara",
                        onPressed: () {
                          searchNavigate();
                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.green.shade900,
                        ),
                      ),
                      filled: true,
                      hintText: "Adres Girin",
                      fillColor: Colors.green.shade300,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
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
                    setState(() {
                      mapStatus;
                    });

                    print(mapStatus);
                    //getAdressFromLatLng();
                  },
                  tooltip: "Seçili adrese git",
                  icon: Icon(
                    Icons.map,
                    color: Colors.green.shade700,
                    size: 36,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  searchNavigate() {
    print(searchAdress);
    locationFromAddress(searchAdress!).then((value) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(value.first.latitude, value.first.longitude),
              zoom: 20),
        ),
      );
    });
  }

  getAdressFromLatLng() {
    //FIXME:boş/geçersiz adres kontrolü
    placemarkFromCoordinates(lt!, lng!).then((value) {
      print(value[0].administrativeArea);
    });
  }

  final CameraPosition _kGooglePlex =
      const CameraPosition(target: LatLng(37.743388, 29.104555), zoom: 14);

  move(position) {
    setState(() {
      _marker.first = _marker.first.copyWith(positionParam: position.target);
      lt = _marker.first.position.latitude;
      lng = _marker.first.position.longitude;
    });
    print("Locaion: $lt $lng");
  }

  MapType mapType() {
    if (mapStatus == MapType.normal) {
      mapStatus = MapType.normal;
    } else {
      mapStatus = MapType.normal;
    }
    return mapStatus;
  }
}

ThemeData themeData() {
  return ThemeData(
      colorScheme:
          ThemeData().colorScheme.copyWith(primary: Colors.green.shade700));
}

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
  //   print(location)
  // }