import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gmaps/data_dummy.dart';
import 'package:gmaps/map_type_google.dart';
import 'package:gmaps/utils/place_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MapsV1Page extends StatefulWidget {
  const MapsV1Page({super.key});

  @override
  State<MapsV1Page> createState() => _MapsV1PageState();
}

class _MapsV1PageState extends State<MapsV1Page> {
  final Completer<GoogleMapController> _controller = 
    Completer<GoogleMapController>();
  double latitude = -6.198415050563709;
  double longitude = 106.79999550685112;

  var mapType = MapType.normal;
  
  // Untuk marker lokasi yang dipilih (warna MERAH)
  Set<Marker> _selectedLocationMarkers = {};
  
  // Data lengkap untuk setiap tempat
  final List<Map<String, dynamic>> _placesData = [
    {
      'name': 'ImaStudio',
      'imageUrl': 'https://media.licdn.com/dms/image/v2/C560BAQFNY3o9JxKXaw/company-logo_200_200/company-logo_200_200/0/1631336563920?e=2147483647&v=beta&t=mKd72TJskaFVuRLXUIoIJoGPOjBboHByENl05bOdk24',
      'lat': -6.1952988,
      'lng': 106.7926625,
      'address': 'Jalan Raya Tenggulungan, Surabaya',
      'rating': 4.8,
      'openStatus': 'Buka',
      'openHours': 'Buka 08.00 - 20.00',
    },
    {
      'name': 'Monas',
      'imageUrl': 'https://upload.wikimedia.org/wikipedia/id/thumb/b/b1/Merdeka_Square_Monas_02.jpg/330px-Merdeka_Square_Monas_02.jpg',
      'lat': -6.1753871,
      'lng': 106.8249587,
      'address': 'Gambir, Jakarta Pusat',
      'rating': 4.7,
      'openStatus': 'Buka',
      'openHours': 'Buka 24 jam',
    },
    {
      'name': 'Masjid Istiqlal',
      'imageUrl': 'https://marclanhotels.com/wp-content/uploads/2025/05/Istiqlal.jpg',
      'lat': -6.1702229,
      'lng': 106.8293614,
      'address': 'Jalan Taman Wijaya Kusuma, Jakarta Pusat',
      'rating': 4.9,
      'openStatus': 'Buka',
      'openHours': 'Buka 04.00 - 21.00',
    },
    {
      'name': 'Istana Merdeka',
      'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/c/c9/Istana_Negara%2C_2023_%28Istana_Kepresidenan_Republik_Indonesia%29.jpg',
      'lat': -6.1701812,
      'lng': 106.8219803,
      'address': 'Jalan Medan Merdeka Utara, Jakarta Pusat',
      'rating': 4.5,
      'openStatus': 'Tutup',
      'openHours': 'Buka Senin pukul 09.00',
    },
  ];

  @override
  void initState() {
    super.initState();
    Geolocator.requestPermission();
    _loadFavorites();
  }

  // Load tempat favorit dari PlaceUtils
  Future<void> _loadFavorites() async {
    await PlaceUtils.loadFavoritePlacesV1();
    setState(() {});
  }

  // Tambah marker merah untuk lokasi yang dipilih
  void _addRedMarker(LatLng location, String title) {
    setState(() {
      _selectedLocationMarkers.clear();
      _selectedLocationMarkers.add(
        Marker(
          markerId: const MarkerId("selected_location"),
          position: location,
          infoWindow: InfoWindow(
            title: title,
            snippet: "Lokasi dipilih",
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed
          ),
        ),
      );
    });
  }

  // Hapus marker merah
  void _clearRedMarker() {
    setState(() {
      _selectedLocationMarkers.clear();
    });
  }

  // Dialog daftar tempat favorit
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
                child: PlaceUtils.favoritePlaces.isEmpty
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
                              "Klik Simpan pada card tempat",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: PlaceUtils.favoritePlaces.length,
                        itemBuilder: (context, index) {
                          final place = PlaceUtils.favoritePlaces[index];
                          return Dismissible(
                            key: Key(place['latitude'].toString()),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) async {
                              await PlaceUtils.removeFavoritePlaceV1(index);
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
                                        _goToLocation(
                                          LatLng(place['latitude'], place['longitude']),
                                          place['name'],
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.share, color: Colors.green),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        final tempPlace = {
                                          'name': place['name'],
                                          'address': place['address'],
                                          'lat': place['latitude'],
                                          'lng': place['longitude'],
                                          'rating': place['rating'] ?? 0,
                                          'openStatus': 'Buka',
                                          'openHours': 'Lihat di peta',
                                        };
                                        PlaceUtils.showShareOptionsV1(context, tempPlace);
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

  // Pergi ke lokasi favorit
  Future<void> _goToLocation(LatLng location, String name) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 17,
        ),
      ),
    );
    _addRedMarker(location, name);
    Fluttertoast.showToast(msg: "Menuju ke $name");
  }

  // Pergi ke lokasi saat ini
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
      _clearRedMarker();
    } catch (e) {
      Fluttertoast.showToast(msg: "Gagal mendapatkan lokasi");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Maps V1"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: _showFavoriteDialog,
          ),
          PopupMenuButton(
            onSelected: onSelectedMapType,
            itemBuilder: (context){
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
          _buildGoogleMaps(),
          _buildDetailCard(),
          Positioned(
            bottom: 20,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
              onPressed: _goToCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleMaps() {
    return GoogleMap(
      mapType: mapType,
      initialCameraPosition: CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 17,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: {
        ...markers,
        ..._selectedLocationMarkers,
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
    );
  }

  void onSelectedMapType(Type type) {
    setState(() {
      switch (type) {
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

  _buildDetailCard(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: _placesData.map((place) {
            return Row(
              children: [
                _displayPlaceCard(place),
                const SizedBox(width: 10),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _displayPlaceCard(Map<String, dynamic> place) {
    return GestureDetector(
      onTap: () {
        _onClickPlaceCard(place['lat'], place['lng'], place['name']);
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  child: Image.network(
                    place['imageUrl'],
                    width: 110,
                    height: 130,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 110,
                        height: 130,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              place['rating'].toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 4),
                            Row(
                              children: _buildStars(place['rating']),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 12, color: Colors.grey),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                place['address'],
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: place['openStatus'] == "Buka" ? Colors.green : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                "${place['openStatus']} · ${place['openHours']}",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: place['openStatus'] == "Buka" ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () async {
                        await PlaceUtils.saveFavoritePlaceV1(place);
                        setState(() {});
                      },
                      icon: const Icon(Icons.save_alt, size: 18),
                      label: const Text("Simpan", style: TextStyle(fontSize: 13)),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                    ),
                  ),
                  Container(width: 1, height: 25, color: Colors.grey[300]),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        PlaceUtils.showShareOptionsV1(context, place);
                      },
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text("Share", style: TextStyle(fontSize: 13)),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
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

  List<Widget> _buildStars(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 12));
    }
    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 12));
    }
    for (int i = stars.length; i < 5; i++) {
      stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 12));
    }
    return stars;
  }

  void _onClickPlaceCard(double lat, double lng, String name) async {
    setState(() {
      latitude = lat;
      longitude = lng;
    });
    
    _addRedMarker(LatLng(lat, lng), name);

    GoogleMapController controller = await _controller.future;
    final cameraPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 17,
    );
    final cameraUpdate = CameraUpdate.newCameraPosition(cameraPosition);
    controller.animateCamera(cameraUpdate);
  }
}