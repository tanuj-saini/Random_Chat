import 'package:amazon/AuthContoller/authContoller.dart';
import 'package:amazon/Home/HomeScreen.dart';
import 'package:amazon/UserModel/UserModel.dart';
import 'package:amazon/constants/LoderScreen.dart';
import 'package:amazon/constants/global_variables.dart';
import 'package:amazon/signUp/SignUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  void Login(
      {required String email,
      required String Password,
      required String name}) async {
    ref.watch(authContioller.notifier).sendDetailsToFirebase(
        email: email,
        Password: Password,
        Latitiude: '',
        longitude: '',
        context: context,
        name: name);
  }

  final TextEditingController nameContoller = TextEditingController();
  final TextEditingController emailContoller = TextEditingController();
  final TextEditingController passwordContoller = TextEditingController();

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

  void sendDetailsToFirebsae(
      {required String email,
      required String Password,
      required String Latitiude,
      required String longitude,
      required String name}) async {
    ref.watch(authContioller.notifier).sendDetailsToFirebase(
        email: email,
        Password: Password,
        Latitiude: Latitiude,
        longitude: longitude,
        context: context,
        name: name);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameContoller.dispose();
    emailContoller.dispose();
    passwordContoller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoding = ref.watch(authContioller);
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
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
                      
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: nameContoller,
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
                                      builder: (ctx) => SignUpScreen()));
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.black,
                                ),
                                label: Text(
                                  'Sign-In.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )),
                            ElevatedButton(
                                onPressed: () => Login(
                                    email: emailContoller.text,
                                    Password: passwordContoller.text,
                                    name: nameContoller.text),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: Text('Login in')),
                          ],
                        ),
                      ],
                    ),
                  ),
                    Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: () {
                                  sendDetailsToFirebsae(
                                      email: emailContoller.text,
                                      Password: passwordContoller.text,
                                      Latitiude: "",
                                      longitude: "",
                                      name: nameContoller.text);
                                },
                                icon: Icon(
                                  Icons.add_circle_outline_sharp,
                                  color: Colors.black,
                                ),
                                label: Text(
                                  'Next...',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ))),
                ),
              ])),
        ),
      ),
    );
  }
}
