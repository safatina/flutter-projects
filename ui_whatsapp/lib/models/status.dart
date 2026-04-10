class Status {
  String name;
  String statusDate;

  Status({
    required this.name,
    required this.statusDate,
  });
}

List<Status> statusList = [
  Status(name: "Budi", statusDate: "Today, 18:00"),
  Status(name: "Sinta", statusDate: "Today, 19:00"),
  Status(name: "Raka", statusDate: "Today, 20:00"),
  Status(name: "Nanda", statusDate: "Yesterday, 21:00"),
  Status(name: "Putri", statusDate: "Yesterday, 22:00"),
];