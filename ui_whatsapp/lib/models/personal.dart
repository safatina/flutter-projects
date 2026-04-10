class Personal {
  String message;
  bool isMe;

  Personal({
    required this.message,
    required this.isMe,
  });
}

List<Personal> messageList = [
  Personal(message: "Halo, apa kabar?", isMe: false),
  Personal(message: "Baik, kamu bagaimana?", isMe: true),
  Personal(message: "Hari ini ada kuliah Flutter", isMe: false),
];