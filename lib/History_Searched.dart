import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Bottom_Navigation.dart';
import 'History_Storage.dart';

final _listColors = [
  const Color.fromRGBO(13, 209, 33, 1),
  const Color.fromRGBO(255, 236, 66, 1)
  // Colors.lightBlue.shade300,
  // Colors.orange.shade300,
  // Colors.pinkAccent.shade100,
  // Colors.tealAccent.shade100
];

class SearchModel {
  String? fromSearch;
  String? toSearch;
  DateTime? timeSearch;
  String? id;

  SearchModel({this.fromSearch, this.toSearch, this.timeSearch, this.id});

  factory SearchModel.fromMap(map) {
    return SearchModel(
        fromSearch: map['fromSearch'],
        toSearch: map['toSearch'],
        timeSearch: map['timeSearch'].toDate());
  }
}

class SearchedPage extends StatefulWidget {
  const SearchedPage({Key? key}) : super(key: key);

  @override
  State<SearchedPage> createState() => _SearchedPageState();
}

class _SearchedPageState extends State<SearchedPage> {
  User? user = FirebaseAuth.instance.currentUser;
  List<SearchModel> listSearch = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    LoadSearched();
  }

  @override
  Future LoadSearched() async {
    setState(() => isLoading = true);

    listSearch.clear();
    await FirebaseFirestore.instance
        .collection('searched')
        .where("uid", isEqualTo: user?.uid.toString())
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        SearchModel obj = SearchModel.fromMap(doc.data());
        obj.id = doc.id;
        listSearch.add(obj);
      });
    });

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NavigationBottom()));
                  },
                  child: Container(
                      // margin: const EdgeInsets.only(
                      //   left: 10,
                      // ),
                      child: const Icon(Icons.arrow_back)),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    right: 20,
                  ),
                  child: const Text(
                    'History',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyStoragePage()));
                  },
                  child: Container(
                    child: Column(
                      children: const [
                        Text(
                          'My Storage',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  child: Column(
                    children: [
                      const Text(
                        'Searched',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: 3,
                        width: 80,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(13, 209, 33, 1),
                            borderRadius: BorderRadius.circular(8)),
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.black54,
            ),
            const SizedBox(
              height: 20,
            ),
            // List view:------------------------
            Expanded(
              flex: 1,
              child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : listSearch.isEmpty
                          ? ListSearchEmpty()
                          : ListSearch()),
            ),
          ]),
    )));
  }

  Widget ListSearchEmpty() => Text('list is empty');

  Widget ListSearch() => ListView.builder(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: listSearch.length,
        itemBuilder: (context, index) {
          final item = listSearch[index];
          final pickcolor = _listColors[index % _listColors.length];
          final time =
              DateFormat('yyyy-MM-dd – kk:mm').format(item.timeSearch!);

          return Card(
            color: const Color.fromARGB(255, 245, 244, 244),
            child: Container(
              child: Column(children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: pickcolor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(10, 4, 5, 0),
                        // height: 80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(4, 18),
                                  blurRadius: 17,
                                  spreadRadius: -10,
                                  color: Color.fromARGB(255, 110, 107, 104))
                            ]),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'from',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                              child: Text(item.fromSearch.toString(),
                                  style: const TextStyle(color: Colors.black)),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(5, 4, 10, 0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(4, 18),
                                  blurRadius: 17,
                                  spreadRadius: -10,
                                  color: Color.fromARGB(255, 110, 107, 104))
                            ]),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'to',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                              child: Text(item.toSearch.toString(),
                                  style: const TextStyle(color: Colors.black)),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        time,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          showWarningNotifi(context, item);
                        },
                        child: Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 243, 242, 242),
                                border: Border.all(color: pickcolor, width: 2),
                                borderRadius: BorderRadius.circular(8)),
                            child: const Image(
                              image: AssetImage(
                                "assets/images/trash.png",
                              ),
                            )),
                      )
                    ],
                  ),
                )
              ]),
            ),
          );
        },
      );

  void DeleteWord(SearchModel item) {
    FirebaseFirestore.instance
        .collection('searched')
        .doc(item.id)
        .delete()
        .then((value) => showSuccessNotifi(context))
        .catchError((err) => print(err.toString()));
  }

  showSuccessNotifi(BuildContext context) {
    Widget okButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('OK',
          style: TextStyle(color: Color.fromRGBO(13, 209, 33, 1))),
    );

    AlertDialog alert = AlertDialog(
      title: const Text('Successfully!',
          style: TextStyle(color: Color.fromRGBO(13, 209, 33, 1))),
      content: const Text('This text is removed out of your search history.'),
      actions: [
        okButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  showWarningNotifi(BuildContext context, SearchModel item) {
    Widget noButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('No'),
    );

    Widget yesButton = TextButton(
      onPressed: () {
        DeleteWord(item);
        setState(() {
          LoadSearched();
        });
        Navigator.of(context).pop();
      },
      child: const Text('Yes'),
    );

    AlertDialog alert = AlertDialog(
      title: const Text('Warning!',
          style: TextStyle(color: Color.fromRGBO(255, 236, 66, 1))),
      content: const Text('Do you want to remove this Text?'),
      actions: [
        yesButton,
        noButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
