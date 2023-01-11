import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:per_pro/constant/color.dart';
import '../component/board/board_default_form.dart';
import '../component/meal_info.dart';
import '../firebase_database_model/user.dart';
import '../model/school_information_model.dart';

class HomeTab extends StatelessWidget {
  final MealModel meal;
  final loginUser user;

  const HomeTab({
    required this.meal,
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _HomeMeal(
            meal: meal,
            user: user,
          ),
          Column(
            children: [
              _HomeWordCloud(),
              _HomeBannerAd(),
              const SizedBox(height: 16),
              HomeBoard(user: user),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomeMeal extends StatelessWidget {
  final MealModel meal;
  final loginUser user;

  const _HomeMeal({
    required this.meal,
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: SizedBox(
            height: 305,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                ),
              ),
              color: BRIGHT_COLOR,
              child: LayoutBuilder(builder: (context, constraint) {
                constraint.maxWidth;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: PRIMARY_COLOR,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          user.mySchool + ' 급식',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: PageScrollPhysics(),
                        children: List.generate(
                          20,
                          (index) => MealInfo(
                            width: constraint.maxWidth / 3,
                            mealdate: (DateTime.now().year.toString()) +
                                '-' +
                                DateTime.now()
                                    .month
                                    .toString()
                                    .padLeft(2, '0') +
                                '-' +
                                DateTime.now().day.toString().padLeft(2, '0') +
                                '\n',
                            meal: meal.DDISH_NM
                                .replaceAll(RegExp('<br/>'), '')
                                .replaceAll(RegExp('[0-9.()*]'), '')
                                .replaceAll(RegExp(' '), '\n'),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeWordCloud extends StatelessWidget {
  const _HomeWordCloud({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(
            '<오늘의 워드클라우드>',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16.0,
            ),
          ),
          Image.asset(
            'asset/img/word_cloud.png',
            height: 200.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: PRIMARY_COLOR,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () {
              DefaultTabController.of(context)?.animateTo(1);
            },
            child: Text('의견 반영하기'),
          ),
        ],
      ),
    );
  }
}

class _HomeBannerAd extends StatelessWidget {
  const _HomeBannerAd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text('배너 광고'),
    );
  }
}

class HomeBoard extends StatelessWidget {
  final loginUser user;

  const HomeBoard({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String latestFreePost = '';
    String latestLovePost = '';
    final ContainerDecoration = BoxDecoration(
      color: Colors.white,
      //border: Border.all(width: 2, color: PRIMARY_COLOR),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 10))
      ],
    );
    final ts = TextStyle(
        fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black);
    final tsContent = TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        overflow: TextOverflow.ellipsis);

    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      decoration: ContainerDecoration,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('post-free-board')
                    .orderBy('posted time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  //latestFreePost = snapshot.data?.docs[0]['content'];
                  snapshot.data!.docs.length != 0
                      ? latestFreePost = snapshot.data?.docs[0]['content']
                      : latestFreePost = '최근 게시물이 없습니다.';
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(color: PRIMARY_COLOR);
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return BoardDefaultForm(
                          postValue: 'post-free-board',
                          user: user,
                        );
                      }));
                    },
                    /*
                      235 ~ 244. 터치 이벤트를 받아서 자유게시판으로 넘어가는 부분임.
                      1. 240번째 줄에 postValue: 'post-free-board',
                         파이어 베이스 컬렉션 이름을 넘겨줌.
                         free_board.dart에서 쓰기위한 거임.

                         연애 게시판이나 급식 게시판에선 post-meal-board 또는
                         post-love-board등으로 작명할 수 있을 듯.

                     */
                    child: Row(
                      children: [
                        Text('자유 게시판', style: ts),
                        SizedBox(width: 24),
                        Flexible(
                          child: Text(
                            latestFreePost,
                            style: tsContent,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('워드클라우드', style: ts),
                  SizedBox(width: 24),
                  Flexible(
                    child: Text(
                      '워드클라우드 게시판에 올라온 최근 게시물',
                      style: tsContent,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      //softWrap: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('post-love-board')
                      .orderBy('posted time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    //latestFreePost = snapshot.data?.docs[0]['content'];
                    snapshot.data!.docs.length != 0
                        ? latestLovePost = snapshot.data?.docs[0]['content']
                        : latestLovePost = '최근 게시물이 없습니다.';
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(color: PRIMARY_COLOR);
                    }
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return BoardDefaultForm(
                            postValue: 'post-love-board',
                            user: user,
                          );
                        }));
                      },
                      child: Row(
                        children: [
                          Text('연애 게시판', style: ts),
                          SizedBox(width: 24),
                          Flexible(
                            child: Text(
                              latestLovePost,
                              style: tsContent,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('post-meal-board')
                      .orderBy('posted time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    //latestFreePost = snapshot.data?.docs[0]['content'];
                    snapshot.data!.docs.length != 0
                        ? latestLovePost = snapshot.data?.docs[0]['content']
                        : latestLovePost = '최근 게시물이 없습니다.';
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(color: PRIMARY_COLOR);
                    }
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return BoardDefaultForm(
                                postValue: 'post-meal-board',
                                user: user,
                              );
                            }));
                      },
                      child: Row(
                        children: [
                          Text('급식 게시판', style: ts),
                          SizedBox(width: 24),
                          Flexible(
                            child: Text(
                              latestLovePost,
                              style: tsContent,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('동아리 게시판', style: ts),
                  SizedBox(width: 24),
                  Flexible(
                    child: Text(
                      '동아리 게시판에 올라온 최근 게시물',
                      style: tsContent,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
