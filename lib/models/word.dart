class Word {
  final int? id;
  final String? word;
  final String? definition;
  final int? vocId;

  const Word({
    this.id,
    this.word,
    this.definition,
    this.vocId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'definition': definition,
      'vocId': vocId,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'],
      word: map['word'],
      definition: map['definition'],
      vocId: map['vocId'],
    );
  }
}
