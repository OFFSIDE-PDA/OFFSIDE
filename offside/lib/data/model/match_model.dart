class MatchModel {
  MatchModel(this.data, this.score2, this.team1, this.team2, this.location,
      this.time, this.score1);

  String? data;
  String? score2;
  String? team1;
  String? team2;
  String? location;
  String? time;
  String? score1;

  String? getDate() => data;

  String? getTeam1() => team1;

  String? getTeam2() => team2;

  String? getLocation() => location;

  String? getScore1() => score1;

  String? getScore2() => score2;

  String? getTime() => time;
}
