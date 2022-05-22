import 'package:flutter/material.dart';

import 'Bottom_Navigation.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NavigationBottom()));
                    },
                    child: Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: const Icon(Icons.arrow_back)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      right: 20,
                    ),
                    child: const Text(
                      'About Us',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Image(
                  image: AssetImage('assets/images/logo.png'),
                  width: 70,
                  height: 70,
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: RichText(
                      text: const TextSpan(
                          text: 'Eudora',
                          style: TextStyle(
                              color: Color.fromRGBO(13, 209, 33, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  ' is a free English learning platform with many new functions and easy to use. The application supports users to translate text, documents, learn vocabulary through flash cards or learn by suggested topics. In addition, users can play games on the application to memorize or take notes on lessons.',
                              style: TextStyle(
                                color: Color.fromRGBO(82, 80, 80, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    width: 4,
                                    height: 100,
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(13, 209, 33, 1),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(6, 0),
                                            blurRadius: 1,
                                            spreadRadius: -4,
                                            color: Color.fromRGBO(
                                                13, 209, 33, 0.2),
                                          )
                                        ])),
                                ////
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, //start-11r1
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: RichText(
                                          text: const TextSpan(
                                              text: 'Free',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      27, 111, 226, 1),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: ' to you',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          27, 111, 226, 1),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: ' Easy',
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      43,
                                                                      170,
                                                                      238,
                                                                      1),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 24),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text: ' to use',
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        43,
                                                                        170,
                                                                        238,
                                                                        1),
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            )
                                                          ])
                                                    ]),
                                              ]),
                                        ),
                                      ),
                                      //
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          // child: Expanded(
                                          child: RichText(
                                            text: const TextSpan(
                                                text:
                                                    'Created on April 19, 2022 by 4 enthusiastic programmers, ready to bring the best user experience.',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      82, 80, 80, 1),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          ),
                                        ),
                                      ),
                                      // ),
                                    ],
                                  ),
                                )
                              ]),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Technology used:',
                                style: TextStyle(
                                    color: Color.fromRGBO(13, 209, 33, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline),
                              ),
                              Expanded(
                                  //List icon app
                                  child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const <Widget>[
                                  AppIcon(PathImg: "assets/images/figma.png"),
                                  AppIcon(PathImg: "assets/images/dart.png"),
                                  AppIcon(
                                      PathImg: "assets/images/firebase.png"),
                                  AppIcon(PathImg: "assets/images/flutter.png"),
                                  AppIcon(PathImg: "assets/images/visual.png")
                                ],
                              ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class AppIcon extends StatelessWidget {
  final PathImg;
  const AppIcon({
    Key? key,
    this.PathImg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
              image: AssetImage(
            PathImg,
          )),
          boxShadow: const [
            BoxShadow(
                offset: Offset(0, 14),
                blurRadius: 12,
                spreadRadius: -5,
                color: Color.fromARGB(255, 110, 107, 104))
          ]),
    );
  }
}
