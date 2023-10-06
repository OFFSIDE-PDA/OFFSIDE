import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/Match/match.dart';
import 'package:offside/TourSchedule/tourPlan.dart';
import 'package:offside/data/view/match_view_model.dart';
import 'package:offside/data/view/team_info_view_model.dart';

class TourSchedule extends ConsumerStatefulWidget {
  const TourSchedule({super.key});

  @override
  _TourSchedule createState() => _TourSchedule();
}

class AdaptiveTextSize {
  const AdaptiveTextSize();
  getadaptiveTextSize(BuildContext context, dynamic value) {
    // 720 is medium screen height
    return (value / 720) * MediaQuery.of(context).size.height;
  }
}

List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class _TourSchedule extends ConsumerState {
  String selectedDate = '230825';
  String selectedMatch = 'One';
  var matchList = [];
  var selectedIdx = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var matchData = ref.watch(matchViewModelProvider);
    final teamInfoList = ref.watch(teamInfoViewModelProvider).teamInfoList;
    selectedDate = matchData.getLatestDay(); //오늘 날짜로부터 가장 가까운 경기 일정
    var data = matchData.getMatchDateFromToday(); //오늘 날짜 이후에 있는 경기만 가져옴
    // 오늘 날짜 이후에 k1 또는 k2 경기가 없으면 경기 없음 리턴
    var matches = [];
    if (data['date'].isNotEmpty) {
      if (data['k1'][selectedDate] != null &&
          data['k2'][selectedDate] != null) {
        matches = data['k1'][selectedDate] + data['k2'][selectedDate];
      } else if (data['k1'][selectedDate] != null &&
          data['k2'][selectedDate] == null) {
        matches = data['k1'][selectedDate];
      } else if (data['k1'][selectedDate] == null &&
          data['k2'][selectedDate] != null) {
        matches = data['k2'][selectedDate];
      }

      var tmp = [];
      for (var element in matches) {
        tmp.add(
            '${teamInfoList[element.team1].name}vs${teamInfoList[element.team2].name}');
      }
      matchList = tmp;
      selectedMatch = selectedIdx <= matchList.length - 1
          ? matchList[selectedIdx]
          : matchList[0];
    }

    const borderSide =
        BorderSide(color: Color.fromARGB(255, 67, 67, 67), width: 1.0);
    const iconStyle =
        Icon(Icons.expand_more, color: Color.fromARGB(255, 67, 67, 67));
    var elevatedStyle = ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        backgroundColor: Colors.white,
        side: borderSide);

    return (Column(
      children: [
        Container(
            alignment: Alignment.topLeft,
            child: SizedBox(
                child: SafeArea(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 3.0),
                                  child: Icon(Icons.card_travel,
                                      size: 22,
                                      color: Color.fromRGBO(91, 143, 255, 1))),
                              SizedBox(width: size.width * 0.01),
                              Text('My Travel',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: const AdaptiveTextSize()
                                          .getadaptiveTextSize(context, 14),
                                      color:
                                          const Color.fromRGBO(33, 58, 135, 1)))
                            ]))))),
        data['date'].isNotEmpty
            ? Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('관람할 경기를 선택해주세요!',
                        style: TextStyle(
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 14),
                            fontWeight: FontWeight.w600)),
                    SizedBox(height: size.height * 0.025),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: elevatedStyle,
                          child: DropdownButton(
                            isDense: true,
                            style: TextStyle(
                                fontSize: const AdaptiveTextSize()
                                    .getadaptiveTextSize(context, 12),
                                color: const Color.fromARGB(
                                    255, 67, 67, 67)), //Dropdown font color
                            dropdownColor:
                                Colors.white, //dropdown menu background color
                            icon: iconStyle,
                            value: selectedDate,
                            onChanged: (String? value) {
                              setState(() {
                                selectedDate = value!;
                              });
                            },
                            items: data['date']
                                .map<DropdownMenuItem<String>>((dynamic value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(getDate(value)),
                              );
                            }).toList(),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {},
                            style: elevatedStyle,
                            child: matchList.isNotEmpty
                                ? DropdownButton(
                                    isDense: true,
                                    style: TextStyle(
                                        fontSize: const AdaptiveTextSize()
                                            .getadaptiveTextSize(context, 12),
                                        color: const Color.fromARGB(255, 67, 67,
                                            67)), //Dropdown font color
                                    dropdownColor: Colors
                                        .white, //dropdown menu background color
                                    icon: iconStyle,
                                    value: selectedMatch,
                                    onChanged: (String? value) {
                                      // This is called when the user selects an item.
                                      setState(() {
                                        selectedMatch = value!;
                                        selectedIdx =
                                            matchList.indexOf(selectedMatch);
                                      });
                                    },
                                    items: matchList
                                        .map<DropdownMenuItem<String>>(
                                            (dynamic value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  )
                                : const SizedBox()),
                      ],
                    ),
                    SizedBox(height: size.height * 0.025),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: const Color.fromARGB(255, 27, 78, 145),
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '20${getDate(selectedDate)}',
                                style: TextStyle(
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 14),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            width: size.width * 0.1,
                                            height: size.width * 0.1,
                                            child: Image.network(teamInfoList[
                                                    matches[selectedIdx].team1]
                                                .logoImg)),
                                        SizedBox(width: size.width * 0.03),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                teamInfoList[
                                                        matches[selectedIdx]
                                                            .team1]
                                                    .middleName,
                                                style: TextStyle(
                                                    fontSize:
                                                        const AdaptiveTextSize()
                                                            .getadaptiveTextSize(
                                                                context, 13),
                                                    fontWeight:
                                                        FontWeight.w500),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(
                                                  width: size.width * 0.02),
                                              Text(
                                                ' vs ',
                                                style: TextStyle(
                                                  fontSize:
                                                      const AdaptiveTextSize()
                                                          .getadaptiveTextSize(
                                                              context, 14),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(
                                                  width: size.width * 0.02),
                                              Text(
                                                teamInfoList[
                                                        matches[selectedIdx]
                                                            .team2]
                                                    .middleName,
                                                style: TextStyle(
                                                    fontSize:
                                                        const AdaptiveTextSize()
                                                            .getadaptiveTextSize(
                                                                context, 13),
                                                    fontWeight:
                                                        FontWeight.w500),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(
                                                  width: size.width * 0.03),
                                              SizedBox(
                                                  width: size.width * 0.1,
                                                  height: size.width * 0.1,
                                                  child: Image.network(
                                                      teamInfoList[matches[
                                                                  selectedIdx]
                                                              .team2]
                                                          .logoImg))
                                            ])
                                      ])),
                              const SizedBox(height: 10),
                              Opacity(
                                opacity: 0.8,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.network(
                                    teamInfoList[matches[selectedIdx].team1]
                                        .stadiumImg,
                                    fit: BoxFit.fill,
                                    width: size.width * 0.75,
                                    height: size.height * 0.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 23,
                                    color: Color.fromARGB(255, 27, 78, 145),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      teamInfoList[matches[selectedIdx].team1]
                                          .stadium,
                                      style: TextStyle(
                                          fontSize: const AdaptiveTextSize()
                                              .getadaptiveTextSize(context, 14),
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromRGBO(
                                              68, 68, 68, 1))),
                                ],
                              )
                            ])),
                    SizedBox(height: size.height * 0.025),
                    Text(
                      'START TRAVEL',
                      style: TextStyle(
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 14),
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(39, 176, 255, 1)),
                    ),
                    SizedBox(height: size.height * 0.025),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TourPlan(
                                      home: matches[selectedIdx].team1,
                                      away: matches[selectedIdx].team2,
                                      date: matches[selectedIdx].data,
                                      time: matches[selectedIdx].time)));
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: const Color.fromRGBO(
                              33, 58, 135, 1), // <-- Button color
                          foregroundColor: Colors.white,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 25,
                        ))
                  ],
                ),
              )
            : const Expanded(child: Center(child: Text('남은 경기가 없습니다')))
      ],
    ));
  }
}
