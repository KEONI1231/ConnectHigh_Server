import 'package:flutter/material.dart';
import 'package:per_pro/constant/color.dart';
import 'package:per_pro/screen/login/find_pw_screen.dart';

import '../../component/appbar.dart';
import 'find_id_screen.dart';

//이화면은 id를 찾을 건지 pw를 찾을지를 물어보는 라우팅화면임. 별로 볼거 없음.
class findAccount extends StatefulWidget {
  const findAccount({Key? key}) : super(key: key);

  @override
  State<findAccount> createState() => _findAccountState();
}

class _findAccountState extends State<findAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BRIGHT_COLOR,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(titleText: '계정찾기'),
            Image.asset(
              'asset/img/logo_blue.png',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 48, 0, 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FindIdPwBtn(labelText: 'ID 찾기'),
                  FindIdPwBtn(labelText: 'PW 찾기')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FindIdPwBtn extends StatelessWidget {
  final String labelText;

  const FindIdPwBtn({
    required this.labelText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return labelText == 'ID 찾기' ? findId() : findPw();
            },
          ),
        );
      },
      child: Text(labelText),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(150, 30),
        primary: PRIMARY_COLOR,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
