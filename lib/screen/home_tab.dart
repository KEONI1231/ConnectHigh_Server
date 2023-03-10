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
                          user.mySchool + ' ??????',
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
            '<????????? ??????????????????>',
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
            child: Text('?????? ????????????'),
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
      child: Text('?????? ??????'),
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
        fontSize: 18, fontWeight: FontWeight.w700, color: PRIMARY_COLOR);
    final tsContent = TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: PRIMARY_COLOR,
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
                      : latestFreePost = '?????? ???????????? ????????????.';
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
                      235 ~ 244. ?????? ???????????? ????????? ????????????????????? ???????????? ?????????.
                      1. 240?????? ?????? postValue: 'post-free-board',
                         ????????? ????????? ????????? ????????? ?????????.
                         free_board.dart?????? ???????????? ??????.

                         ?????? ??????????????? ?????? ??????????????? post-meal-board ??????
                         post-love-board????????? ????????? ??? ?????? ???.

                     */
                    child: Row(
                      children: [
                        Text('?????? ?????????', style: ts),
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
                  Text('??????????????????', style: ts),
                  SizedBox(width: 24),
                  Flexible(
                    child: Text(
                      '?????????????????? ???????????? ????????? ?????? ?????????',
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
                        : latestLovePost = '?????? ???????????? ????????????.';
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
                          Text('?????? ?????????', style: ts),
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
                        : latestLovePost = '?????? ???????????? ????????????.';
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
                          Text('?????? ?????????', style: ts),
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
                  Text('????????? ?????????', style: ts),
                  SizedBox(width: 24),
                  Flexible(
                    child: Text(
                      '????????? ???????????? ????????? ?????? ?????????',
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
