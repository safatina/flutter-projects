class Community {
  String name;
  String description;

  Community({
    required this.name,
    required this.description,
  });
}

List<Community> communityList = [
  Community(
    name: "Informatics Community",
    description: "Selamat datang di komunitas informatika",
  ),
  Community(
    name: "Programming Community",
    description: "Info terbaru seputar coding",
  ),
];