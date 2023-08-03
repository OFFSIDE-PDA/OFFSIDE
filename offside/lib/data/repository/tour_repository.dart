import 'package:offside/data/datasource/tour_data_source.dart';

final tourDataRepositoryProvider = TourDataRepository();

class TourDataRepository {
  late final TourDataSource _tourDataSource = TourDataSource();

  Future<Map<String, dynamic>> getTourData() async {
    return _tourDataSource.getTourData();
  }
}
