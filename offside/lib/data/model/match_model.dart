class MatchModel {
  MatchModel(this.data, this.score2, this.team1, this.team2, this.location,
      this.time, this.score1);

  MatchModel.fromMap(Map<String, dynamic> map) {
    data = map["data"];
    score1 = map["score1"];
    score2 = map["score2"];
    team1 = map["team1"];
    team2 = map["team2"];
    location = map["location"];
    time = map["time"];
  }

  ///`matchModel` 깊은 복사
  MatchModel.copy(MatchModel matchModel) {
    data = matchModel.data;
    score1 = matchModel.score1;
    score2 = matchModel.score2;
    team1 = matchModel.team1;
    team2 = matchModel.team2;
    location = matchModel.location;
    time = matchModel.time;
  }

  //todo : data, time을 Timestamp datetime;으로 변경
  String? data;
  String? time;
  int? score2;
  int? team1;
  int? team2;
  int? location;
  int? score1;
}

class RecordModel {
  RecordModel(this.score2, this.score1, this.draw);

  RecordModel.fromMap(Map<String, dynamic> map) {
    score1 = map["team1Win"];
    score2 = map["team2Win"];
    draw = map["draw"];
  }

  //todo : data, time을 Timestamp datetime;으로 변경
  int score2 = 0;
  int score1 = 0;
  int draw = 0;
}
