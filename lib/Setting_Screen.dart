// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Bottom_Navigation.dart';

class UserModel {
  String? uid;
  String? username;
  String? email;

  UserModel({this.uid, this.username, this.email});

  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'], email: map['email'], username: map['username']);
  }

// Map<String, dynamic> toMap(){
//   return();
// }
}

class SetttingScreen extends StatefulWidget {
  const SetttingScreen({Key? key}) : super(key: key);

  @override
  State<SetttingScreen> createState() => _SetttingScreenState();
}

class _SetttingScreenState extends State<SetttingScreen> {
  UserModel settingInfo = UserModel();
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();

  @override
  void initState() {
    User? user = FirebaseAuth.instance.currentUser;
    // TODO: implement initState
    super.initState();
    final data = FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.settingInfo = UserModel.fromMap(value.data());
      setState(() {
        _usernameController.text = this.settingInfo.username.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(13, 209, 33, 1),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          height: size.height,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: SafeArea(
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NavigationBottom()));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, top: 10),
                            child: const Icon(Icons.arrow_back),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 20, top: 10),
                          child: const Text(
                            'Setting',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Image(
                          image: AssetImage('assets/images/user.png'),
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${settingInfo.username}",
                          // 'Phuc Hoang Van',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${settingInfo.email}",
                          // 'phuchv@gmail.com',
                          style: const TextStyle(
                              color: Color.fromRGBO(137, 136, 136, 1)),
                        )
                      ],
                    )
                  ]),
                ),
              ),
              // const SizedBox(
              //   height: 14,
              // ),
              Expanded(
                flex: 9,
                // child: Align(
                //   alignment: Alignment.bottomCenter,
                child: Container(
                  height: 400,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // USERNAME
                        const Text(
                          'Username',
                          style: TextStyle(
                              color: Color.fromRGBO(13, 209, 33, 1),
                              fontWeight: FontWeight.w600),
                        ),
                        TextField(
                          controller: _usernameController,
                          // keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 5, 0, 5),
                              fillColor: const Color.fromRGBO(243, 237, 237, 1),
                              filled: true,
                              // hintText: "${settingInfos.username}",
                              // hintText: "Phuc Hoang Van",
                              hintStyle: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: Container(
                                margin: const EdgeInsets.only(right: 4),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(255, 236, 66, 1),
                                ),
                                child: const Icon(
                                  Icons.edit_rounded,
                                  color: Colors.black,
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        // EMAIL
                        const Text(
                          'Email',
                          style: TextStyle(
                              color: Color.fromRGBO(13, 209, 33, 1),
                              fontWeight: FontWeight.w600),
                        ),
                        TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(15, 5, 0, 5),
                            fillColor: const Color.fromRGBO(243, 237, 237, 1),
                            filled: true,
                            hintText: "${settingInfo.email}",
                            // hintText: "phuchv@gmail.com",
                            hintStyle: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _changeUsername(_usernameController.text);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 80,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: const Color.fromRGBO(13, 209, 33, 1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      width: 1,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                          offset: Offset(4, 18),
                                          blurRadius: 14,
                                          spreadRadius: -8,
                                          color: Color.fromARGB(
                                              255, 110, 107, 104))
                                    ]),
                                child: const Text(
                                  "Save",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                            width: 150,
                            height: 2,
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(204, 204, 204, 1),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 4),
                                      blurRadius: 2,
                                      spreadRadius: -2,
                                      color: Color.fromARGB(255, 199, 194, 189))
                                ]),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        //PASSWORD
                        const Text(
                          'Password',
                          style: TextStyle(
                              color: Color.fromRGBO(13, 209, 33, 1),
                              fontWeight: FontWeight.w600),
                        ),
                        TextField(
                          controller: _passwordController,
                          obscureText: _isObscure1,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 5, 0, 5),
                              fillColor: const Color.fromRGBO(243, 237, 237, 1),
                              filled: true,
                              hintText: "Enter password",
                              hintStyle: const TextStyle(
                                fontSize: 15,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(255, 236, 66, 1),
                                  ),
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isObscure1 = !_isObscure1;
                                        });
                                      },
                                      icon: Icon(_isObscure1
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      color: const Color.fromARGB(
                                          255, 2, 67, 119)))),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        // NEW PASSWORD
                        const Text(
                          'New Password',
                          style: TextStyle(
                              color: Color.fromRGBO(13, 209, 33, 1),
                              fontWeight: FontWeight.w600),
                        ),
                        TextField(
                          controller: _newpasswordController,
                          obscureText: _isObscure2,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 5, 0, 5),
                              fillColor: const Color.fromRGBO(243, 237, 237, 1),
                              filled: true,
                              hintText: "Enter new password",
                              hintStyle: const TextStyle(
                                fontSize: 15,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(255, 236, 66, 1),
                                  ),
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isObscure2 = !_isObscure2;
                                        });
                                      },
                                      icon: Icon(_isObscure2
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      color: const Color.fromARGB(
                                          255, 2, 67, 119)))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // BUTTON
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _changePassword(_passwordController.text,
                                    _newpasswordController.text);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 80,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: const Color.fromRGBO(13, 209, 33, 1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      width: 1,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                          offset: Offset(4, 18),
                                          blurRadius: 14,
                                          spreadRadius: -8,
                                          color: Color.fromARGB(
                                              255, 110, 107, 104))
                                    ]),
                                child: const Text(
                                  "Save",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _changePassword(String currentPassword, String newPassword) async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: (user?.email).toString(), password: currentPassword);

    user?.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        print('Update password successfully!!!');
        showSuccessNotifi(context, 'Update password successfully!');
      }).catchError((error) {
        print('Failed to update password: $error');
        showErrorNotifi(context, 'Failed to update password');
      });
    }).catchError((err) {
      print('Password is invalid');
      showErrorNotifi(context, 'Password is invalid');
    });
  }

  Future<void> _changeUsername(String username) async {
    if (!username.isEmpty) {
      User? user = await FirebaseAuth.instance.currentUser;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference updateUsername =
          FirebaseFirestore.instance.collection('users');
      return updateUsername
          .doc(user!.uid)
          .update({'username': username}).then((value) {
        print('update username successfully!!!');
        showSuccessNotifi(context, 'update username successfully!');
      }).catchError((err) => print('Failed to update username: $err'));
    } else
      showErrorNotifi(context, 'Please enter new username');
  }

  showSuccessNotifi(BuildContext context, String content) {
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
      content: Text(content),
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

  showErrorNotifi(BuildContext context, String content) {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text(
          'OK',
          style: TextStyle(color: Colors.yellow),
        ));

    AlertDialog alert = AlertDialog(
      title: const Text('Failure!', style: TextStyle(color: Colors.red)),
      content: Text(content, style: TextStyle(color: Colors.black)),
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
}
