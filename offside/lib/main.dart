import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:offside/MainPage/main_page.dart';
import 'package:offside/data/view/match_view_model.dart';
import 'package:offside/data/view/tour_view_model.dart';
import 'package:offside/data/view/user_view_model.dart';
import 'package:offside/data/view/team_info_view_model.dart';
import 'package:offside/firebase_options.dart';
import 'package:offside/login/login.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding); //스플래쉬화면 유지
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  KakaoSdk.init(
    nativeAppKey: '3b301db0810e0f8f0caa883c9c7b43ba',
    javaScriptAppKey: 'a8bd91fccbb230b5011148456b3cd404',
  );

  runApp(const ProviderScope(
    child: Offside(),
  ));
}

class Offside extends ConsumerWidget {
  const Offside({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoLogin = ref.read(userViewModelProvider).autoSignIn();
    ref.read(tourViewModelProvider).getTourData();
    Future.wait([
      ref.read(teamInfoViewModelProvider).getTeamInfo(),
      ref.read(matchViewModelProvider).getAllMatches()
    ]).then((value) {
      print("정보 다운 완료");
      FlutterNativeSplash.remove(); //스플래쉬화면 삭제
    });

    return MaterialApp(
        title: 'Offside',
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 255, 255, 255)),
          useMaterial3: true,
        ),
        home: autoLogin == true ? const MainPage() : LoginPage());
  }
}
