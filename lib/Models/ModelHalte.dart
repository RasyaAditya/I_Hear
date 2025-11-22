// halte.dart
class Halte {
  final String id;
  final String name;
  final String type; // "halte" atau "stasiun"

  Halte({required this.id, required this.name, required this.type});

  factory Halte.fromJson(Map<String, dynamic> json) {
    return Halte(
      id: json["id"].toString(),
      name: json["name"],
      type: json["type"], // pastikan dataset ada field type
    );
  }
}
