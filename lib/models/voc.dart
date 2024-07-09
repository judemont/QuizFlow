class Voc {
  final int? id;
  final String? title;
  final String? description;

  const Voc({
    this.id,
    this.title,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  factory Voc.fromMap(Map<String, dynamic> map) {
    return Voc(
      id: map['id'],
      title: map['title'],
      description: map['description'],
    );
  }
}
