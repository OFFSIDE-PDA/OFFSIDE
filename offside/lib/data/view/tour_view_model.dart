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
      var tour = value['tour'];
      // var culture = value['culture'];
      // var hotel = value['hotel'];
      // var food = value['food'];
      tourData[key] = {
        'tour': TourModel(tour['addr'], tour['contentid'], '관광지',
            tour['firstimage'], tour['title']),
        // 'culture': TourModel(culture['addr'], culture['contentid'], '문화시설',
        //     culture['firstimage'], culture['title']),
        // 'hotel': TourModel(hotel['addr'], hotel['contentid'], '숙박',
        //     hotel['firstimage'], hotel['title']),
        // 'food': TourModel(food['addr'], food['contentid'], '음식점',
        //     food['firstimage'], food['title'])
      };
    });
    _tourViewModel = tourData;
  }

  getTour() {
    return _tourViewModel;
  }

  Map<int, String> getType = {12: '관광지', 14: '문화시설', 32: '숙박', 39: '음식점'};
}
