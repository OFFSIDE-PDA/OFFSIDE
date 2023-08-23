import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  String selectedDate = '230624';
  String selectedMatch = 'One';
  var matchList = [];
  var selectedIdx = 0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var matchData = ref.watch(matchViewModelProvider);
    final teamInfoList = ref.watch(teamInfoViewModelProvider).teamInfoList;
    var data = matchData.getMatchDate();
    var matches = [];
    if (data['k1'][selectedDate] != null && data['k2'][selectedDate] != null) {
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
            height: size.height * 0.2,
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text('나의 여행 일정',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: const AdaptiveTextSize()
                        .getadaptiveTextSize(context, 18)))),
        Column(
          children: [
            Text('원하시는 경기를 선택해주세요!',
                style: TextStyle(
                  fontSize:
                      const AdaptiveTextSize().getadaptiveTextSize(context, 15),
                )),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                const SizedBox(
                  width: 10,
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
                                color: const Color.fromARGB(
                                    255, 67, 67, 67)), //Dropdown font color
                            dropdownColor:
                                Colors.white, //dropdown menu background color
                            icon: iconStyle,
                            value: selectedMatch,
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                selectedMatch = value!;
                                selectedIdx = matchList.indexOf(selectedMatch);
                              });
                            },
                            items: matchList
                                .map<DropdownMenuItem<String>>((dynamic value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                        : const SizedBox()),
              ],
            ),
            const SizedBox(height: 30),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: const Color.fromARGB(255, 54, 54, 54),
                    ),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '20${getDate(selectedDate)}',
                        style: TextStyle(
                          fontSize: const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 15),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: size.width * 0.08,
                                    height: size.width * 0.08,
                                    child: Image.network(
                                        teamInfoList[matches[selectedIdx].team1]
                                            .logoImg)),
                                const SizedBox(width: 20),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        teamInfoList[matches[selectedIdx].team1]
                                            .name,
                                        style: TextStyle(
                                          fontSize: const AdaptiveTextSize()
                                              .getadaptiveTextSize(context, 15),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        ' vs ',
                                        style: TextStyle(
                                          fontSize: const AdaptiveTextSize()
                                              .getadaptiveTextSize(context, 15),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        teamInfoList[matches[selectedIdx].team2]
                                            .name,
                                        style: TextStyle(
                                          fontSize: const AdaptiveTextSize()
                                              .getadaptiveTextSize(context, 15),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(width: 20),
                                      SizedBox(
                                          width: size.width * 0.08,
                                          height: size.width * 0.08,
                                          child: Image.network(teamInfoList[
                                                  matches[selectedIdx].team2]
                                              .logoImg))
                                    ])
                              ])),
                      const SizedBox(height: 5),
                      Text(teamInfoList[matches[selectedIdx].team1].stadium,
                          style: TextStyle(
                            fontSize: const AdaptiveTextSize()
                                .getadaptiveTextSize(context, 15),
                          ))
                    ])),
            const SizedBox(height: 30),
            Text(
              '해당 경기로 여행계획 바로 시작하기',
              style: TextStyle(
                fontSize:
                    const AdaptiveTextSize().getadaptiveTextSize(context, 15),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TourPlan(
                            home: matches[selectedIdx].team1,
                            away: matches[selectedIdx].team2,
                            date: matches[selectedIdx].data)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(25),
                  backgroundColor:
                      const Color.fromRGBO(33, 58, 135, 1), // <-- Button color
                  foregroundColor: Colors.white,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 25,
                ))
          ],
        ),
      ],
    ));
  }
}
