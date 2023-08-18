import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:offside/MainPage/main_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offside/data/view/team_info_view_model.dart';
import '../data/view/user_view_model.dart';

/// 회원가입 화면
class KaKaoSignUpPage extends ConsumerStatefulWidget {
  @override
  _KaKaoSignUpPageState createState() => _KaKaoSignUpPageState();
}

class _KaKaoSignUpPageState extends ConsumerState<KaKaoSignUpPage> {
  TextStyle style = const TextStyle(fontFamily: 'NanumSquare', fontSize: 18.0);
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController _cnt;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _cnt = SingleValueDropDownController();
  }

  @override
  void dispose() {
    _cnt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userViewModelProvider);
    final teamInfo = ref.read(teamInfoViewModelProvider).teamInfoList;
    List<DropDownValueModel> dropDownValueList = [];
    for (var i = 1; i < teamInfo.length; i++) {
      dropDownValueList
          .add(DropDownValueModel(name: teamInfo[i].fullName, value: i));
    }
    return Scaffold(
      key: _key,
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text('회원가입',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 30),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                child: DropDownTextField(
                  controller: _cnt,
                  validator: (value) =>
                      (_cnt.dropDownValue == null) ? "응원하는 팀을 선택해주세요" : null,
                  clearOption: false,
                  textFieldFocusNode: textFieldFocusNode,
                  searchFocusNode: searchFocusNode,
                  // searchAutofocus: true,
                  dropDownItemCount: 25,
                  searchShowCursor: false,
                  enableSearch: true,
                  searchKeyboardType: TextInputType.number,
                  textFieldDecoration: InputDecoration(
                      prefixIcon: const Icon(Icons.favorite),
                      labelText: "응원하는 팀",
                      filled: true,
                      fillColor: const Color(0xffF6F6F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      )),
                  dropDownList: dropDownValueList,
                  onChanged: (val) {},
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 180.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(5.0), //둥근효과
                  color: const Color(0xff0E2057),
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await user.updateTeam(
                              team: _cnt.dropDownValue!.value);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainPage()),
                              (route) => false);
                        } catch (e) {
                          print("$e");
                        }
                      }
                    },
                    height: 65,
                    child: const Text(
                      "회원가입",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
