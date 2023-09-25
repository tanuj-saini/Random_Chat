import 'package:amazon/AuthContoller/authContoller.dart';
import 'package:amazon/Home/HomeScreen.dart';
import 'package:amazon/constants/LoderScreen.dart';
import 'package:amazon/constants/global_variables.dart';
import 'package:amazon/login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  SignUpScreen({super.key});
  @override
  ConsumerState<SignUpScreen> createState() {
    return _signUP();
  }
}

class _signUP extends ConsumerState<SignUpScreen>
    with SingleTickerProviderStateMixin {
  void sendToUserFirebase({
    required String email,
    required String Password,
    required String name,
  }) {
    ref
        .watch(authContioller.notifier)
        .SignIn(Password: Password, Email: email, context: context, name: name);
  }

  final TextEditingController emailContoller = TextEditingController();
  final TextEditingController passwordContoller = TextEditingController();
  final TextEditingController nameContoller = TextEditingController();

  late AnimationController controller;
  late Animation<double> logoAnimation;

  late Animation<Offset> slideTransition;
  late Animation<double> scaleAnimation;
  late Animation<double> scaleScreenAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    logoAnimation = Tween<double>(begin: 0, end: 1).animate(controller);

    slideTransition = Tween<Offset>(begin: Offset(-1, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: controller, curve: Curves.ease));

    scaleAnimation = Tween<double>(begin: 0, end: 1).animate(controller);
    scaleScreenAnimation = Tween<double>(begin: 0, end: 10).animate(controller);
    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    emailContoller.dispose();
    passwordContoller.dispose();
    nameContoller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoding = ref.watch(authContioller);
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome! to see you again'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              border: Border.symmetric(horizontal: BorderSide.none)),
          child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(children: [
                isLoding
                    ? LoderScreen()
                    : Center(
                        child: FadeTransition(
                            opacity: logoAnimation,
                            child: const FlutterLogo(
                              size: 100,
                            ))),
                SizedBox(
                  height: 30,
                ),
                ScaleTransition(
                  scale: scaleAnimation,
                  child: SlideTransition(
                    position: slideTransition,
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: () {},
                                icon: Icon(
                                  Icons.add_circle_outline_sharp,
                                  color: Colors.black,
                                ),
                                label: Text(
                                  'Create Account.',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ))),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: emailContoller,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: passwordContoller,
                          decoration: InputDecoration(
                            hintText: "Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: nameContoller,
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => LoginScreen()));
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.black,
                                ),
                                label: Text(
                                  'Already Have a account.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )),
                            ElevatedButton(
                                onPressed: () {
                                  sendToUserFirebase(
                                      name: nameContoller.text,
                                      email: emailContoller.text,
                                      Password: passwordContoller.text);
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: Text('Sign Up')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ])),
        ),
      ),
    );
  }
}
