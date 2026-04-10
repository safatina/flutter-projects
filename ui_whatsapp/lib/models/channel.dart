class Channel {
  String name;
  String message;

  Channel({
    required this.name,
    required this.message,
  });
}

List<Channel> channelList = [
  Channel(
    name: "Campus Information",
    message: "Pengumuman jadwal terbaru",
  ),
  Channel(
    name: "Weather Update",
    message: "Prakiraan cuaca hari ini",
  ),
  Channel(
    name: "Health News",
    message: "Tips menjaga kesehatan",
  ),
  Channel(
    name: "Tech World",
    message: "Berita teknologi terbaru",
  ),
];