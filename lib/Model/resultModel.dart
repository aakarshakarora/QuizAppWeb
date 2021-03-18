class ResultModel {
  final bool login;
  final String emailID;
  final String s_name;
  final String s_regno;
  final String s_uid;
  final int score;
  final int tabSwitch;
  final int maxScore;

  ResultModel(this.login, this.emailID, this.s_name, this.s_regno, this.s_uid,
      this.score, this.tabSwitch,this.maxScore);

  ResultModel.fromMap(Map<String, dynamic> map)
      : assert(map['attempted'] != null),
        assert(map['S_EmailID'] != null),
        assert(map['S_Name'] != null),
        assert(map['S_RegNo'] != null),
        assert(map['S_Name'] != null),
        assert(map['S_UID'] != null),
        assert(map['Score'] != null),
        assert(map['tabSwitch'] != null),
        assert(map['maxScore'] != null),
        login = map['Login'],
        emailID = map['S_EmailID'],
        s_name = map['S_Name'],
        s_regno = map['S_RegNo'],
        s_uid = map['S_UID'],
        score = map['Score'],
        tabSwitch = map['tabSwitch'],
        maxScore = map['maxScore'];
}
