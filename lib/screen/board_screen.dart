import 'package:flutter/material.dart';
import 'package:per_pro/constant/color.dart';
import 'package:per_pro/firebase_database_model/user.dart';

import '../component/board/board_default_form.dart';


class BoardScreen extends StatelessWidget {
  final loginUser user;
  const BoardScreen({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ts = TextStyle(
        fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black);

    return SafeArea(
      child: Scaffold(
        backgroundColor: BRIGHT_COLOR,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Text('모아보기', style: ts.copyWith(fontSize: 32)),
              const SizedBox(height: 24),
              mypage(ts: ts), // 내 글들 모음
              const SizedBox(height: 24),
              totalboard(user: user, ts: ts), // 게시판 모음
              const SizedBox(height: 24),
              subboard(ts: ts), // 서브 게시판 모음
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class mypage extends StatelessWidget {
  final TextStyle ts;
  const mypage({
    required this.ts,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ContainerDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 10))
      ],
    );

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.1,
        decoration: ContainerDecoration,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text('내가 쓴 글', style: ts),
              SizedBox(height: 16),
              Text('댓글 단 글', style: ts),
              SizedBox(height: 16),
              Text('스크랩', style: ts),
              SizedBox(height: 16),
              Text('HOT 게시판', style: ts),
              SizedBox(height: 16),
              Text('BEST 게시판', style: ts),
            ],
          ),
        ),
      ),
    );
  }
}

class totalboard extends StatelessWidget {
  final TextStyle ts;
  final loginUser user;
  const totalboard({
    required this.user,
    required this.ts,
    Key? key,
  }) : super(key: key);
  //totalboard = 게시판 모음
  @override
  Widget build(BuildContext context) {
    final ContainerDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 10))
      ],
    );

    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      decoration: ContainerDecoration,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return BoardDefaultForm(postValue: 'post-free-board', user: user);
                  }));
                },
                child: Text('자유게시판', style: ts)),
            SizedBox(height: 16),
            Text('워드클라우드', style: ts),
            SizedBox(height: 16),
            Text('연애게시판', style: ts),
            SizedBox(height: 16),
            Text('급식 게시판', style: ts),
          ],
        ),
      ),
    );
  }
}

class subboard extends StatelessWidget {
  final TextStyle ts;
  const subboard({
    required this.ts,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ContainerDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 10))
      ],
    );
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      decoration: ContainerDecoration,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text('오늘의 급식', style: ts),
            SizedBox(height: 16),
            Text('교원 평가', style: ts),
            SizedBox(height: 16),
            Text('스터디', style: ts),
            SizedBox(height: 16),
            Text('중고 거래', style: ts),
          ],
        ),
      ),
    );
  }
}
