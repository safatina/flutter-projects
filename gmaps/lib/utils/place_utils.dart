import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceUtils {
  // Untuk menyimpan tempat favorit
  static List<Map<String, dynamic>> favoritePlaces = [];
  static List<Map<String, dynamic>> favoritePlacesV2 = [];

  // ==================== FAVORITE PLACES V1 ====================
  static Future<void> loadFavoritePlacesV1() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString('favorite_places_v1');
    if (favoritesJson != null) {
      List<dynamic> decoded = json.decode(favoritesJson);
      favoritePlaces = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }
  }

  static Future<void> saveFavoritePlaceV1(Map<String, dynamic> place) async {
    final prefs = await SharedPreferences.getInstance();
    
    final newPlace = {
      'name': place['name'],
      'address': place['address'],
      'latitude': place['lat'],
      'longitude': place['lng'],
      'rating': place['rating'],
      'date': DateTime.now().toString(),
    };
    
    bool exists = favoritePlaces.any((p) => 
      p['latitude'] == place['lat'] && p['longitude'] == place['lng']
    );
    
    if (exists) {
      Fluttertoast.showToast(msg: "${place['name']} sudah ada di favorit!");
      return;
    }
    
    favoritePlaces.add(newPlace);
    await prefs.setString('favorite_places_v1', json.encode(favoritePlaces));
    Fluttertoast.showToast(msg: "${place['name']} berhasil disimpan ke favorit!");
  }

  static Future<void> removeFavoritePlaceV1(int index) async {
    final prefs = await SharedPreferences.getInstance();
    String name = favoritePlaces[index]['name'];
    favoritePlaces.removeAt(index);
    await prefs.setString('favorite_places_v1', json.encode(favoritePlaces));
    Fluttertoast.showToast(msg: "$name dihapus dari favorit");
  }

  // ==================== FAVORITE PLACES V2 ====================
  static Future<void> loadFavoritePlacesV2() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString('favorite_places_v2');
    if (favoritesJson != null) {
      List<dynamic> decoded = json.decode(favoritesJson);
      favoritePlacesV2 = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }
  }

  static Future<void> saveFavoritePlaceV2(String name, String address, double lat, double lng) async {
    final prefs = await SharedPreferences.getInstance();
    
    final newPlace = {
      'name': name,
      'address': address,
      'latitude': lat,
      'longitude': lng,
      'date': DateTime.now().toString(),
    };
    
    bool exists = favoritePlacesV2.any((place) => 
      place['latitude'] == lat && place['longitude'] == lng
    );
    
    if (exists) {
      Fluttertoast.showToast(msg: "Tempat sudah ada di favorit!");
      return;
    }
    
    favoritePlacesV2.add(newPlace);
    await prefs.setString('favorite_places_v2', json.encode(favoritePlacesV2));
    Fluttertoast.showToast(msg: "Tempat berhasil disimpan ke favorit!");
  }

  static Future<void> removeFavoritePlaceV2(int index) async {
    final prefs = await SharedPreferences.getInstance();
    favoritePlacesV2.removeAt(index);
    await prefs.setString('favorite_places_v2', json.encode(favoritePlacesV2));
    Fluttertoast.showToast(msg: "Dihapus dari favorit");
  }

  // ==================== SHARE FUNCTIONS ====================
  
  // Share menggunakan system share sheet
  static Future<void> shareWithSystemSheet(String address, double lat, double lng, {String version = "V2"}) async {
    String googleMapsLink = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    
    String shareMessage = "📍 *$address*\n\n"
        "📌 Koordinat: $lat, $lng\n\n"
        "🗺️ Lihat di Google Maps:\n"
        "$googleMapsLink\n\n"
        "_Dikirim dari Aplikasi Google Maps $version";  // ← Perbaikan: $version bukan $version_
    
    await Share.share(
      shareMessage,
      subject: 'Bagikan Lokasi - $address',
    );
  }

  // Share untuk V1 dengan parameter Map
  static Future<void> shareWithSystemSheetV1(Map<String, dynamic> place) async {
    String googleMapsLink = "https://www.google.com/maps/search/?api=1&query=${place['lat']},${place['lng']}";
    
    String shareMessage = "📍 *${place['name']}*\n"
        "${place['address']}\n\n"
        "⭐ Rating: ${place['rating']}\n"
        "🕐 Status: ${place['openStatus']} · ${place['openHours']}\n\n"
        "📌 Koordinat: ${place['lat']}, ${place['lng']}\n\n"
        "🗺️ Lihat di Google Maps:\n"
        "$googleMapsLink\n\n"
        "_Dikirim dari Aplikasi Google Maps V1_";
    
    await Share.share(
      shareMessage,
      subject: 'Bagikan Lokasi - ${place['name']}',
    );
  }

  // Share langsung ke WhatsApp untuk V1
  static Future<void> shareToWhatsAppDirectV1(Map<String, dynamic> place) async {
    String googleMapsLink = "https://www.google.com/maps/search/?api=1&query=${place['lat']},${place['lng']}";
    String message = "📍 ${place['name']}\n${place['address']}\n⭐ Rating: ${place['rating']}\n\nLihat di Google Maps: $googleMapsLink";
    String encodedMessage = Uri.encodeComponent(message);
    
    String whatsappUrl = "whatsapp://send?text=$encodedMessage";
    final Uri uri = Uri.parse(whatsappUrl);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        String webUrl = "https://wa.me/?text=$encodedMessage";
        await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "WhatsApp tidak terinstal");
    }
  }

  // Share ke Telegram untuk V1
  static Future<void> shareToTelegramDirectV1(Map<String, dynamic> place) async {
    String googleMapsLink = "https://www.google.com/maps/search/?api=1&query=${place['lat']},${place['lng']}";
    String message = "📍 ${place['name']}\n${place['address']}\n⭐ Rating: ${place['rating']}\n\nLihat di Google Maps: $googleMapsLink";
    String encodedMessage = Uri.encodeComponent(message);
    
    String telegramUrl = "tg://msg?text=$encodedMessage";
    final Uri uri = Uri.parse(telegramUrl);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        String webUrl = "https://t.me/share/url?url=$encodedMessage";
        await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Telegram tidak terinstal");
    }
  }

  // Share ke Twitter untuk V1
  static Future<void> shareToTwitterV1(Map<String, dynamic> place) async {
    String googleMapsLink = "https://www.google.com/maps/search/?api=1&query=${place['lat']},${place['lng']}";
    String message = "📍 ${place['name']}\n${place['address']}\n⭐ Rating: ${place['rating']}\n\nLihat di Google Maps: $googleMapsLink";
    String encodedMessage = Uri.encodeComponent(message);
    
    String url = "https://twitter.com/intent/tweet?text=$encodedMessage";
    final Uri uri = Uri.parse(url);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Gagal membuka Twitter");
    }
  }

  // Share ke Instagram untuk V1
  static Future<void> shareToInstagramV1(Map<String, dynamic> place) async {
    String instagramUrl = "instagram://";
    final Uri uri = Uri.parse(instagramUrl);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        Fluttertoast.showToast(msg: "Screenshot lokasi untuk diunggah ke Instagram");
      } else {
        String playStoreUrl = "https://play.google.com/store/apps/details?id=com.instagram.android";
        await launchUrl(Uri.parse(playStoreUrl));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Instagram tidak terinstal");
    }
  }

  // Copy link ke clipboard untuk V1
  static Future<void> copyToClipboardV1(Map<String, dynamic> place) async {
    String googleMapsLink = "https://www.google.com/maps/search/?api=1&query=${place['lat']},${place['lng']}";
    await Fluttertoast.showToast(msg: "Link lokasi disalin ke clipboard!");
  }

  // ==================== SHARE FUNCTIONS FOR V2 ====================
  
  // Share langsung ke WhatsApp V2
  static Future<void> shareToWhatsAppDirectV2(String address, double lat, double lng) async {
    String googleMapsLink = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    String message = "📍 $address\n\nLihat di Google Maps: $googleMapsLink";
    String encodedMessage = Uri.encodeComponent(message);
    
    String whatsappUrl = "whatsapp://send?text=$encodedMessage";
    final Uri uri = Uri.parse(whatsappUrl);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        String webUrl = "https://wa.me/?text=$encodedMessage";
        await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "WhatsApp tidak terinstal");
    }
  }

  // Share ke Telegram V2
  static Future<void> shareToTelegramDirectV2(String address, double lat, double lng) async {
    String googleMapsLink = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    String message = "📍 $address\n\nLihat di Google Maps: $googleMapsLink";
    String encodedMessage = Uri.encodeComponent(message);
    
    String telegramUrl = "tg://msg?text=$encodedMessage";
    final Uri uri = Uri.parse(telegramUrl);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        String webUrl = "https://t.me/share/url?url=$encodedMessage";
        await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Telegram tidak terinstal");
    }
  }

  // Share ke Twitter V2
  static Future<void> shareToTwitterV2(String address, double lat, double lng) async {
    String googleMapsLink = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    String message = "📍 $address\n\nLihat di Google Maps: $googleMapsLink";
    String encodedMessage = Uri.encodeComponent(message);
    
    String url = "https://twitter.com/intent/tweet?text=$encodedMessage";
    final Uri uri = Uri.parse(url);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Gagal membuka Twitter");
    }
  }

  // Share ke Instagram V2
  static Future<void> shareToInstagramV2(String address, double lat, double lng) async {
    String instagramUrl = "instagram://";
    final Uri uri = Uri.parse(instagramUrl);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        Fluttertoast.showToast(msg: "Screenshot lokasi untuk diunggah ke Instagram");
      } else {
        String playStoreUrl = "https://play.google.com/store/apps/details?id=com.instagram.android";
        await launchUrl(Uri.parse(playStoreUrl));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Instagram tidak terinstal");
    }
  }

  // Copy link ke clipboard V2
  static Future<void> copyToClipboardV2(String address, double lat, double lng) async {
    String googleMapsLink = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    await Fluttertoast.showToast(msg: "Link lokasi disalin ke clipboard!");
  }

  // Widget icon share
  static Widget buildShareIcon({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Menampilkan pilihan share untuk V2 (dengan parameter String)
  static void showShareOptionsV2(BuildContext context, String address, double lat, double lng, {String version = "V2"}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Bagikan Lokasi",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Pilih metode berbagi:",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildShareIcon(
                    icon: Icons.chat,
                    color: Colors.green,
                    label: "WhatsApp",
                    onTap: () {
                      Navigator.pop(context);
                      shareToWhatsAppDirectV2(address, lat, lng);
                    },
                  ),
                  buildShareIcon(
                    icon: Icons.send,
                    color: Colors.blue,
                    label: "Telegram",
                    onTap: () {
                      Navigator.pop(context);
                      shareToTelegramDirectV2(address, lat, lng);
                    },
                  ),
                  buildShareIcon(
                    icon: Icons.edit_note,
                    color: Colors.black,
                    label: "Twitter/X",
                    onTap: () {
                      Navigator.pop(context);
                      shareToTwitterV2(address, lat, lng);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildShareIcon(
                    icon: Icons.camera_alt,
                    color: Colors.purple,
                    label: "Instagram",
                    onTap: () {
                      Navigator.pop(context);
                      shareToInstagramV2(address, lat, lng);
                    },
                  ),
                  buildShareIcon(
                    icon: Icons.copy,
                    color: Colors.orange,
                    label: "Salin Link",
                    onTap: () {
                      Navigator.pop(context);
                      copyToClipboardV2(address, lat, lng);
                    },
                  ),
                  buildShareIcon(
                    icon: Icons.devices,
                    color: Colors.teal,
                    label: "Quick Share",
                    onTap: () {
                      Navigator.pop(context);
                      shareWithSystemSheet(address, lat, lng, version: version);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    shareWithSystemSheet(address, lat, lng, version: version);
                  },
                  icon: const Icon(Icons.share),
                  label: const Text("Bagikan ke semua aplikasi"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // Menampilkan pilihan share untuk V1 (dengan parameter Map)
  static void showShareOptionsV1(BuildContext context, Map<String, dynamic> place) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Bagikan Lokasi",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Pilih metode berbagi:",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildShareIcon(
                    icon: Icons.chat,
                    color: Colors.green,
                    label: "WhatsApp",
                    onTap: () {
                      Navigator.pop(context);
                      shareToWhatsAppDirectV1(place);
                    },
                  ),
                  buildShareIcon(
                    icon: Icons.send,
                    color: Colors.blue,
                    label: "Telegram",
                    onTap: () {
                      Navigator.pop(context);
                      shareToTelegramDirectV1(place);
                    },
                  ),
                  buildShareIcon(
                    icon: Icons.edit_note,
                    color: Colors.black,
                    label: "Twitter/X",
                    onTap: () {
                      Navigator.pop(context);
                      shareToTwitterV1(place);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildShareIcon(
                    icon: Icons.camera_alt,
                    color: Colors.purple,
                    label: "Instagram",
                    onTap: () {
                      Navigator.pop(context);
                      shareToInstagramV1(place);
                    },
                  ),
                  buildShareIcon(
                    icon: Icons.copy,
                    color: Colors.orange,
                    label: "Salin Link",
                    onTap: () {
                      Navigator.pop(context);
                      copyToClipboardV1(place);
                    },
                  ),
                  buildShareIcon(
                    icon: Icons.devices,
                    color: Colors.teal,
                    label: "Quick Share",
                    onTap: () {
                      Navigator.pop(context);
                      shareWithSystemSheetV1(place);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    shareWithSystemSheetV1(place);
                  },
                  icon: const Icon(Icons.share),
                  label: const Text("Bagikan ke semua aplikasi"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}