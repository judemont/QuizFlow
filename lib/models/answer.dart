class Answer {
  final int? id;
  final String? answer;
  final int? wordId;
  final int? vocId;

  const Answer({this.id, this.answer, this.wordId, this.vocId});

  Map<String, dynamic> toMap() {
    return {'id': id, 'answer': answer, 'wordId': wordId, 'vocId': vocId};
  }

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      id: map['id'],
      answer: map['answer'],
      wordId: map['wordId'],
      vocId: map['vocId'],
    );
  }
}
