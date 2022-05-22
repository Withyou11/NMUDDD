import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_study_app/SignUpScreen.dart';
import 'package:english_study_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Bottom_Navigation.dart';
import 'Bottom_Navigation_Admin.dart';
import 'Game/GuessWord/Storage.dart';
import 'HomeScreen.dart';
import 'HomeScreen_Admin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _visibilityErr = false;
  bool _isObscure = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // ignore: avoid_unnecessary_containers
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          height: size.height,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                    child: Center(
                  child: Image(
                    image: AssetImage("assets/images/background_login.jpg"),
                    width: 260,
                    height: 260,
                  ),
                )),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Please enter the detail to continue!",
                      style: TextStyle(
                          color: Color.fromARGB(255, 238, 47, 111),
                          fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            hintText: "User Email",
                            prefixIcon: Icon(Icons.mail,
                                color: Color.fromRGBO(80, 207, 116, 1))),
                      ),
                    ),
                    const SizedBox(height: 0),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                      child: TextField(
                          controller: _passwordController,
                          obscureText: _isObscure,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              hintText: "Enter password",
                              prefixIcon: const Icon(Icons.lock,
                                  color: Color.fromRGBO(80, 207, 116, 1)),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                  icon: Icon(_isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  color:
                                      const Color.fromARGB(255, 2, 67, 119)))),
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      child: const Text(
                        'email or password invalid!',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      visible: _visibilityErr,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      child: const Text(
                        "Forgot password?",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Color.fromRGBO(13, 209, 33, 1),
                            fontSize: 16),
                      ),
                    ),

                    const SizedBox(height: 10),
                    // ignore: sized_box_for_whitespace
                    Center(
                      child: SizedBox(
                          width: 150,
                          child: RawMaterialButton(
                            fillColor: const Color.fromRGBO(13, 209, 33, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            onPressed: () {
                              Login();
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("Don't have an account!",
                            style: TextStyle(color: Colors.blue, fontSize: 16)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                          },
                          child: const Text("SignUp",
                              style:
                                  TextStyle(color: Colors.pink, fontSize: 16)),
                        ),
                      ],
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> Login() async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then((value) {
      if (FirebaseAuth.instance.currentUser?.uid.toString() ==
          'ja68CVRrbjPJ8xh9g1qoqZaNvcX2') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NavigationBottomAdmin()));
        print('Login with admin');
      } else {
        print(FirebaseAuth.instance.currentUser?.uid.toString());
        Storage.uid = FirebaseAuth.instance.currentUser!.uid;
        createGameData();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NavigationBottom()));
        print('Login with user');
      } //Chuyển về HomeScreen
    }).onError((error, stackTrace) {
      setState(() {
        _visibilityErr = true;
      });
      print(
        "Error ${error.toString()}",
      );
    });
  }
  Future<void> createGameData() async {
    List<GetDataTopic> list = [];
    await FirebaseFirestore.instance
        .collection('getTopicGame')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        GetDataTopic obj = GetDataTopic.fromMap(doc.data());
        obj.doc = doc.id;
        if(!check(obj)) {
          list.add(obj);
        }
      });
    });
    for (int i = 0; i < list.length; i++) {
      list[i].list.add(Storage.uid);
      CollectionReference addDataGame =
          FirebaseFirestore.instance.collection('DataMenu');
      await  FirebaseFirestore.instance
          .collection('getTopicGame')
          .doc(list[i].doc)
          .update({'listUser': list[i].list})
          .then((_) => print('Updated'));
      await addDataGame
          .doc()
          .set({
            'completedQuestion': 0,
            'image': list[i].image,
            'name': list[i].doc,
            'maxQuestion': 0,
            'uid': Storage.uid,
          })
          .then((value) => print('Added DataGame'))
          .catchError((e) => print("Failed to add DataGame: $e"));
    }
  }
  bool check(GetDataTopic obj){
    for(int i=0;i<obj.list.length;i++){
      if(obj.list[i] == Storage.uid){
        return true;
      }
    }
    return false;
  }
}
