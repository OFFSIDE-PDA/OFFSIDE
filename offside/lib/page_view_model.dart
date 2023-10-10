import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterPageProvider = StateProvider<List<int>>((ref) => [2, 0]);
