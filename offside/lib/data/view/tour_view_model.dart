import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/data/model/tour_model.dart';
import 'package:offside/data/repository/tour_repository.dart';

final tourViewModelProvider =
    ChangeNotifierProvider<TourViewModel>((ref) => TourViewModel());

class TourViewModel extends ChangeNotifier {
  Map<String, dynamic>? _tourViewModel;
  void getTourData() async {
    var data = await tourDataRepositoryProvider.getTourData();
    Map<String, dynamic> tourData = {};
    data.forEach((key, value) {
      var tour = tourModelData(value['tour']);
      var culture = tourModelData(value['culture']);
      var hotel = tourModelData(value['hotel']);
      var food = tourModelData(value['food']);
      tourData[key] = {
        'tour': tour,
        'culture': culture,
        'hotel': hotel,
        'food': food
      };
    });
    _tourViewModel = tourData;
  }

  getTourInfo(String teamName) {
    return _tourViewModel?[teamName];
  }
}

List<dynamic> tourModelData(tour) {
  var data = [];

  tour.then((values) {
    for (var value in values) {
      data.add(TourModel(
          value['addr1'],
          value['contentid'],
          getType[value['contenttypeid']],
          value['firstimage'],
          value['title']));
    }
  });
  return data;
}

Map<int, String> getType = {12: '관광지', 14: '문화시설', 32: '숙박', 39: '음식점'};
