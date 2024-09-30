class Subset {
  final int? id;
  final int? from;
  final int? to;
  final int? vocId;

  const Subset({
    this.id,
    this.from,
    this.to,
    this.vocId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'from': from,
      'to': to,
      'vocId': vocId,
    };
  }

  factory Subset.fromMap(Map<String, dynamic> map) {
    return Subset(
      id: map['id'],
      from: map['from'],
      to: map['to'],
      vocId: map['vocId'],
    );
  }
}
