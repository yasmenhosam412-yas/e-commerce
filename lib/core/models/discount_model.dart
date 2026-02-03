class DiscountModel {
  final String id;
  final String name;
  final String value;
  final String start;
  final String end;

  DiscountModel({
    required this.id,
    required this.name,
    required this.value,
    required this.start,
    required this.end,
  });

  factory DiscountModel.fromMap(Map<String, dynamic> map, String docId) {
    return DiscountModel(
      id: docId,
      name: map['name'] ?? '',
      value: map['value'] ?? "",
      start: map['start'] ?? '',
      end: map['end'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'value': value,
      'start': start,
      'end': end,
    };
  }
}
