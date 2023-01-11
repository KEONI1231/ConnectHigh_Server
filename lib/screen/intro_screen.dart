import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../component/alert_dialog.dart';
import '../component/circular_progress_indicator_dialog.dart';
import '../constant/color.dart';
import '../constant/data.dart';
import '../firebase_database_model/user.dart';
import 'home_screen.dart';
import 'login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    initializeFlutterFire();
    super.initState();
  }

  void initializeFlutterFire() async {
    await Firebase.initializeApp();
  }

  //에뮬레이터 실행시에 처음 보여줄 화면
  // splash screen(로딩중) 이 될 화면. 이 화면은 크게 어려운거 없고 걍 읽어보셈
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: PRIMARY_COLOR,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('asset/img/logo_purple.png'), //고등어 이미지.
            intro_bottom(), //각종 기본적인 텍스트.
            ElevatedButton(
              onPressed: tryLogin,
              child: Text('시작하기'),
            ),
          ],
        ),
      ),
    );
  }

  void tryLogin() async {
    String stateid;
    String statepw;
    bool login;
    SharedPreferences sp = await SharedPreferences.getInstance();
    try {
      stateid = sp.getString(userId)!;
      statepw = sp.getString(userPassword)!;
      login = sp.getBool(loginState)!;
      print("=========================");
      print(stateid);
      print(statepw);
      print(login);
      print("=========================");
      if (login == true) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        String id;
        String pw;
        List<String> anonyMessage = [];
        String nickName;
        String realName;
        String mySchool;
        String email;
        String phoneNumber;
        String eduOfficeCode;
        int boolAdmin;
        int boolCertificated;
        int postCount;
        int replCount;
        String createdTime;
        DocumentSnapshot userData;
        try {
          // try catch.
          CustomCircular(context, '로그인 중...');
          userData = await firestore.collection('users').doc(stateid).get();
          id = userData['id'];
          pw = userData['pw'];
          if (id == stateid && pw == statepw) {
            nickName = userData['nick name'];
            realName = userData['real name'];
            mySchool = userData['my school'];
            email = userData['email'];
            phoneNumber = userData['phone number'];
            eduOfficeCode = userData['edu office code'];
            boolAdmin = userData['bool Admin'];
            boolCertificated = userData['bool certificated'];
            createdTime = userData['created Time'];
            postCount = userData['post count'];
            replCount = userData['repl count'];
            anonyMessage.addAll((List.from(userData['anony message'])));
            loginUser user = new loginUser(
              id,
              nickName,
              pw,
              realName,
              mySchool,
              email,
              phoneNumber,
              eduOfficeCode,
              anonyMessage,
              boolAdmin,
              boolCertificated,
              createdTime,
              postCount,
              replCount,
            );
            Navigator.pop(context);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return HomeScreen(user: user);
            }));
          } else {
            Navigator.pop(context);
            DialogShow(context, '회원정보가 잘못되었습니다.');
          }
        } catch (e) {
          Navigator.pop(context);
          //DialogShow(context, '시스템 에러');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return LoginScreen(); //로그인 화면으로 이동.
              },
            ),
          );
        }
      }
      else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return LoginScreen(); //로그인 화면으로 이동.
            },
          ),
        );
      }

    } catch (e) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return LoginScreen(); //로그인 화면으로 이동.
          },
        ),
      );
    }
  }
}

class intro_bottom extends StatefulWidget {
  const intro_bottom({Key? key}) : super(key: key);

  @override
  State<intro_bottom> createState() => _intro_bottomState();
}

class _intro_bottomState extends State<intro_bottom> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        children: [
          Text(
            'ⓒConnect-High',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '고등학생들의 커뮤니티',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.0,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Test.ver',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
