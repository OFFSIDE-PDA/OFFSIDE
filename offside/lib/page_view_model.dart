import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterPageProvider = StateProvider<List<dynamic>>((ref) => [2, null]);
