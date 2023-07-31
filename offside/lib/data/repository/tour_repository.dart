import 'package:offside/data/datasource/tour_data_source.dart';

final tourDataRepositoryProvider = TourDataRepository();

class TourDataRepository {
  late final TourDataSource _tourDataRepository = TourDataSource();

  Future<Map<String, dynamic>> getTourData() async {
    return await _tourDataRepository.getTourData();
  }
}
