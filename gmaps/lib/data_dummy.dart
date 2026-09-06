import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceData {
  final String id;
  final String name;
  final String address;  // TAMBAHKAN
  final String imageUrl;
  final double latitude;
  final double longitude;
  final double rating;
  final String openStatus;
  final String openHours;
  
  PlaceData({
    required this.id,
    required this.name,
    required this.address,  // TAMBAHKAN
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.openStatus,
    required this.openHours,
  });
}

List<PlaceData> placesList = [
  PlaceData(
    id: "imaStudio",
    name: "Ima Studio Foto",
    address: "Jalan Raya Tenggulungan, RT.18/RW.7, Surabaya",  // TAMBAHKAN
    imageUrl: "https://idn.sch.id/wp-content/uploads/2016/10/ima-studio.jpg",
    latitude: -6.1952988,
    longitude: 106.7926625,
    rating: 4.8,
    openStatus: "Tutup",
    openHours: "Buka Kam pukul 08.00",
  ),
  PlaceData(
    id: "monas",
    name: "Monumen Nasional",
    address: "Gambir, Kecamatan Gambir, Jakarta Pusat",
    imageUrl: "https://cdn-2.tstatic.net/jakarta/foto/bank/images/monas.jpg",
    latitude: -6.1753871,
    longitude: 106.8249587,
    rating: 4.7,
    openStatus: "Buka",
    openHours: "Buka 24 jam",
  ),
  PlaceData(
    id: "istana",
    name: "Istana Merdeka",
    address: "Jalan Medan Merdeka Utara, Jakarta Pusat",
    imageUrl: "https://cdn1-production-images-kly.akamaized.net/ffl8n9sXo2qjLh7e/smart/1200x630/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/3488785/original/032803200_1650969603-istana-merdeka.jpg",
    latitude: -6.1701812,
    longitude: 106.8219803,
    rating: 4.5,
    openStatus: "Tutup",
    openHours: "Buka Senin pukul 09.00",
  ),
  PlaceData(
    id: "istiqlal",
    name: "Masjid Istiqlal",
    address: "Jalan Taman Wijaya Kusuma, Jakarta Pusat",
    imageUrl: "https://cdn1-production-images-kly.akamaized.net/ffl8n9sXo2qjLh7e/smart/1200x630/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/3488785/original/032803200_1650969603-istana-merdeka.jpg",
    latitude: -6.1699883,
    longitude: 106.8287337,
    rating: 4.9,
    openStatus: "Buka",
    openHours: "Buka 24 jam",
  ),
];

// Marker tetap sama
Set<Marker> markers = {};

void initMarkers() {
  markers.clear();
  for (var place in placesList) {
    markers.add(
      Marker(
        markerId: MarkerId(place.id),
        position: LatLng(place.latitude, place.longitude),
        infoWindow: InfoWindow(
          title: place.name,
          snippet: place.address,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        onTap: () {
          // Akan diproses di MapsV1Page
        },
      ),
    );
  }
}