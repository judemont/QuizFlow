class Word {
  final int? id;
  final String? word;
  final String? answer;
  final int? vocId;

  const Word({
    this.id,
    this.word,
    this.answer,
    this.vocId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'definition': answer,
      'vocId': vocId,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'],
      word: map['word'],
      answer: map['definition'],
      vocId: map['vocId'],
    );
  }
}
