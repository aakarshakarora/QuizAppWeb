class QuizDetailModel {
  final AccessCode;
  final CreationDate;
  final Creator;
  final Description;
  final MaxScore;
  final QuestionCount;
  final SubjectName;
  final endDate;
  final startDate;

  QuizDetailModel(
      this.AccessCode,
      this.CreationDate,
      this.Creator,
      this.Description,
      this.MaxScore,
      this.QuestionCount,
      this.SubjectName,
      this.endDate,
      this.startDate);

  QuizDetailModel.fromMap(Map<String, dynamic> map)
      : assert(map['AccessCode'] != null),
        assert(map['CreationDate'] != null),
        assert(map['Creator'] != null),
        assert(map['Description'] != null),
        assert(map['MaxScore'] != null),
        assert(map['QuestionCount'] != null),
        assert(map['SubjectName'] != null),
        assert(map['endDate'] != null),
        assert(map['startDate'] != null),
        AccessCode = map['AccessCode'],
        CreationDate = map['CreationDate'],
        Creator = map['Creator'],
        Description = map['Description'],
        MaxScore = map['MaxScore'],
        QuestionCount = map['QuestionCount'],
        SubjectName = map['SubjectName'],
        endDate = map['endDate'],
        startDate = map['startDate'];
}
