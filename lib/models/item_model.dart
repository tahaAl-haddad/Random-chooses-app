class ChoiceItem {
  final String id;
  final String text;
  final String? imagePath;
  final DateTime createdAt;

  ChoiceItem({
    required this.id,
    required this.text,
    this.imagePath,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'imagePath': imagePath,
    'createdAt': createdAt.toIso8601String(),
  };

  factory ChoiceItem.fromJson(Map<String, dynamic> json) => ChoiceItem(
    id: json['id'],
    text: json['text'],
    imagePath: json['imagePath'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}