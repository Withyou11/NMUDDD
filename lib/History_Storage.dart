import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Bottom_Navigation.dart';
import 'History_Searched.dart';

final _listColors = [
  const Color.fromRGBO(13, 209, 33, 1),
  const Color.fromRGBO(255, 236, 66, 1)
  // Colors.lightBlue.shade300,
  // Colors.orange.shade300,
  // Colors.pinkAccent.shade100,
  // Colors.tealAccent.shade100
];

class VocaModel {
  String? vocaEng;
  String? vocaVie;
  DateTime? timeSave;
  String? type;
  String? id;

  VocaModel({this.vocaEng, this.vocaVie, this.timeSave, this.type, this.id});

  factory VocaModel.fromMap(map) {
    return VocaModel(
        vocaEng: map['vocaEng'],
        vocaVie: map['vocaVie'],
        timeSave: map['timeSave'].toDate(),
        type: map['type']);
  }
}

class MyStoragePage extends StatefulWidget {
  const MyStoragePage({Key? key}) : super(key: key);

  @override
  State<MyStoragePage> createState() => _MyStoragePageState();
}

class _MyStoragePageState extends State<MyStoragePage> {
  User? user = FirebaseAuth.instance.currentUser;
  List<VocaModel> listVoca = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    LoadStorage();
  }

  @override
  Future LoadStorage() async {
    setState(() => isLoading = true);

    listVoca.clear();
    await FirebaseFirestore.instance
        .collection('storage')
        .where("uid", isEqualTo: user?.uid.toString())
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        VocaModel obj = VocaModel.fromMap(doc.data());
        // obj.timeSave =
        obj.id = doc.id;
        listVoca.add(obj);
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
                Container(
                  child: Column(
                    children: [
                      const Text(
                        'My Storage',
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
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchedPage()));
                  },
                  child: Container(
                    child: Column(
                      children: const [
                        Text(
                          'Searched',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
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
                      : listVoca.isEmpty
                          ? ListVocaEmpty()
                          : Listvoca()),
            ),
          ]),
    )));
  }

  Widget ListVocaEmpty() => Text('data');

  Widget Listvoca() => ListView.builder(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: listVoca.length,
        // itemCount: listString.length,
        itemBuilder: (context, index) {
          final item = listVoca[index];
          // final item = listString[index];
          final pickcolor = _listColors[index % _listColors.length];
          final time = DateFormat('yyyy-MM-dd – kk:mm').format(item.timeSave!);

          return Card(
            child: IntrinsicHeight(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      // height: 50,
                      width: 8,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4)),
                        color: pickcolor,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              // item.vocaEng.toString() + ' (type)',
                              item.vocaEng.toString() +
                                  ' (' +
                                  item.type.toString() +
                                  ')',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              // item.vocaVie.toString(),
                              item.vocaVie.toString(),
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                    // Wrap Button_save()
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            // '2:30 pm',
                            time,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // Button_save()
                          GestureDetector(
                            onTap: () {
                              showWarningNotifi(context, item);
                            },
                            child: Container(
                                height: 40,
                                width: 40,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Image(
                                  image: AssetImage(
                                    "assets/images/trash.png",
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          );
        },
      );

  void DeleteWord(VocaModel item) {
    FirebaseFirestore.instance
        .collection('storage')
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
      content: const Text('A word is removed out of your storage.'),
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

  showWarningNotifi(BuildContext context, VocaModel item) {
    Widget noButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text('No'),
    );

    Widget yesButton = TextButton(
      onPressed: () {
        DeleteWord(item);
        setState(() {
          LoadStorage();
        });
        Navigator.of(context).pop();
      },
      child: Text('Yes'),
    );

    AlertDialog alert = AlertDialog(
      title: const Text('Warning!',
          style: TextStyle(color: Color.fromRGBO(255, 236, 66, 1))),
      content: const Text('Do you want to remove this word?'),
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
