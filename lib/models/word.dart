class Word {
  final int? id;
  final String? word;
  final int? vocId;

  const Word({this.id, this.word, this.vocId});

  Map<String, dynamic> toMap() {
    return {'id': id, 'word': word, 'vocId': vocId};
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(id: map['id'], word: map['word'], vocId: map['vocId']);
  }
}
