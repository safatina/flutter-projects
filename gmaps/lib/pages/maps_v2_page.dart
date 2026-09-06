import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gmaps/map_type_google.dart';
import 'package:gmaps/utils/place_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class MapsV2Page extends StatefulWidget {
  const MapsV2Page({super.key});

  @override
  State<MapsV2Page> createState() => _MapsV2PageState();
}

class _MapsV2PageState extends State<MapsV2Page> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  double latitude = -6.198415050563709;
  double longitude = 106.79999550685112;

  var mapType = MapType.normal;

  Position? devicePosition;
  String address = "";
  
  // Variabel untuk menyimpan hasil pencarian
  LatLng? _searchedLocation;
  String? _searchedAddress;
  bool _showSearchResultCard = false;
  
  // Untuk marker hasil pencarian (warna MERAH)
  Set<Marker> _searchMarkers = {};

  @override
  void initState() {
    super.initState();
    Geolocator.requestPermission();
    _loadFavorites();
  }

  // Load tempat favorit dari PlaceUtils
  Future<void> _loadFavorites() async {
    await PlaceUtils.loadFavoritePlacesV2();
    setState(() {});
  }

  // Tambah marker untuk lokasi yang dicari (warna MERAH)
  void _addSearchMarker(LatLng location, String title) {
    setState(() {
      _searchMarkers.clear();
      _searchMarkers.add(
        Marker(
          markerId: const MarkerId("searched_location"),
          position: location,
          infoWindow: InfoWindow(
            title: title,
            snippet: "Hasil pencarian",
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed
          ),
        ),
      );
    });
  }

  // Hapus marker pencarian
  void _clearSearchMarker() {
    setState(() {
      _searchMarkers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Maps V2"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: _showFavoriteDialog,
          ),
          PopupMenuButton(
            onSelected: onSelectedMapType,
            itemBuilder: (context) {
              return googleMapsTypes.map(
                (typeGoogle) {
                  return PopupMenuItem(
                      value: typeGoogle.type,
                      child: Text(typeGoogle.type.name));
                }
              ).toList();
            },
          )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: mapType,
            initialCameraPosition: CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            markers: _searchMarkers,
          ),

          _buildSearchCard(),
          
          if (_showSearchResultCard && _searchedAddress != null)
            _buildSearchResultCard(),
          
          Positioned(
            bottom: 20,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              onPressed: _goToCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  // Card hasil pencarian
  Widget _buildSearchResultCard() {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Hasil Pencarian",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () {
                      setState(() {
                        _showSearchResultCard = false;
                        _searchedAddress = null;
                        _searchedLocation = null;
                        _clearSearchMarker();
                      });
                    },
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_searchedLocation != null) {
                        _centerOnLocation(_searchedLocation!);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _searchedAddress ?? "",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Lat: ${_searchedLocation?.latitude.toStringAsFixed(6)}, Lng: ${_searchedLocation?.longitude.toStringAsFixed(6)}",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (_searchedAddress != null && _searchedLocation != null) {
                          await PlaceUtils.saveFavoritePlaceV2(
                            _searchedAddress!.split(',').first,
                            _searchedAddress!,
                            _searchedLocation!.latitude,
                            _searchedLocation!.longitude,
                          );
                          setState(() {});
                        }
                      },
                      icon: const Icon(Icons.save_alt, size: 18),
                      label: const Text("Simpan"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_searchedAddress != null && _searchedLocation != null) {
                          PlaceUtils.showShareOptionsV2(
                          context,
                          _searchedAddress!,
                          _searchedLocation!.latitude,
                          _searchedLocation!.longitude,
                          version: "V2",
                         );
                        }
                      },
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text("Share"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _centerOnLocation(LatLng location) async {
    final GoogleMapController controller = await _controller.future;
    
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 17,
          tilt: 30,
        ),
      ),
    );
    
    if (_searchedAddress != null) {
      _addSearchMarker(location, _searchedAddress!);
    }
    
    Fluttertoast.showToast(msg: "Memusatkan ke lokasi");
  }

  void _showFavoriteDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tempat Favorit",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Klik tempat untuk melihat di peta",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const Divider(),
              Expanded(
                child: PlaceUtils.favoritePlacesV2.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              "Belum ada tempat favorit",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Cari tempat lalu klik Simpan",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: PlaceUtils.favoritePlacesV2.length,
                        itemBuilder: (context, index) {
                          final place = PlaceUtils.favoritePlacesV2[index];
                          return Dismissible(
                            key: Key(place['latitude'].toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) async {
                              await PlaceUtils.removeFavoritePlaceV2(index);
                              setState(() {});
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              color: Colors.red,
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: const Icon(Icons.favorite, color: Colors.red),
                                title: Text(
                                  place['name'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  place['address'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.location_on, color: Colors.red),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _centerOnLocation(
                                          LatLng(place['latitude'], place['longitude']),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.share, color: Colors.green),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        PlaceUtils.showShareOptionsV2(
                                        context,
                                        place['address'],
                                        place['latitude'],
                                        place['longitude'],
                                        version: "V2",
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _goToCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 17,
          ),
        ),
      );
      
      _clearSearchMarker();
    } catch (e) {
      Fluttertoast.showToast(msg: "Gagal mendapatkan lokasi");
    }
  }

  void onSelectedMapType(Type value) {
    setState((){
      switch(value) {
        case Type.Normal:
          mapType = MapType.normal;
          break;
         case Type.Hybrid:
          mapType = MapType.hybrid;
          break;
        case Type.Terrain:
          mapType = MapType.terrain;
          break;
        case Type.Satellite:
          mapType = MapType.satellite;
          break;
        default:
      }
    });
  }

  Widget _buildSearchCard() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 8, bottom: 4,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Masukkan alamat...",
                    contentPadding: const EdgeInsets.only(left: 15, top: 15),
                    suffixIcon: IconButton(
                      onPressed: searchLocation,
                      icon: const Icon(Icons.search),
                    ),
                  ),
                  onChanged: (value) {
                    address = value;
                  },
                  onSubmitted: (value) {
                    searchLocation();
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    getCurrentPosition().then((value) async {
                      setState(() {
                        devicePosition = value;
                      });
                      GoogleMapController controller = await _controller.future;
                      final cameraPosition = CameraPosition(
                        target: LatLng(
                          value!.latitude,
                          value.longitude,
                        ),
                        zoom: 17,
                      );
                      final cameraUpdate =
                          CameraUpdate.newCameraPosition(cameraPosition);
                      controller.animateCamera(cameraUpdate);
                      _clearSearchMarker();
                    });
                  },
                  icon: const Icon(Icons.my_location),
                  label: const Text("Dapatkan lokasi saat ini"),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: devicePosition != null
                    ? Text(
                        "Lokasi: ${devicePosition!.latitude.toStringAsFixed(4)}, ${devicePosition!.longitude.toStringAsFixed(4)}")
                    : const Text("Lokasi belum terdeteksi"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Position?> getCurrentPosition() async {
    Position? currentPosition;

    try {
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentPosition = null;
    }
    return currentPosition; 
  }

  Future searchLocation() async {
    try {
      await GeocodingPlatform.instance
          ?.locationFromAddress(address)
          .then((value) async {
        GoogleMapController controller = await _controller.future;
        LatLng target = LatLng(value[0].latitude, value[0].longitude);
        
        List<Placemark> placemarks = await placemarkFromCoordinates(
          target.latitude,
          target.longitude,
        );
        
        String fullAddress = "";
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          fullAddress = "${place.name ?? ""} ${place.street ?? ""}, ${place.locality ?? ""}, ${place.country ?? ""}".trim();
          if (fullAddress.isEmpty || fullAddress == ",") {
            fullAddress = address;
          }
        } else {
          fullAddress = address;
        }
        
        _addSearchMarker(target, fullAddress);
        
        CameraPosition cameraPosition =
            CameraPosition(target: target, zoom: 17);
        CameraUpdate cameraUpdate =
            CameraUpdate.newCameraPosition(cameraPosition);
        await controller.animateCamera(cameraUpdate);
        
        setState(() {
          _searchedLocation = target;
          _searchedAddress = fullAddress;
          _showSearchResultCard = true;
        });
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Alamat tidak ditemukan");
      setState(() {
        _showSearchResultCard = false;
        _clearSearchMarker();
      });
    }
  }
}