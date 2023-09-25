import 'package:amazon/AuthContoller/authContoller.dart';
import 'package:amazon/UserModel/UserModel.dart';
import 'package:amazon/chat/ChatScreen.dart';
import 'package:amazon/constants/LoderScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class TestScreen extends ConsumerStatefulWidget {
  final String currName;
  final String currEmail;
  final String currLatitude;
  final String currLogititude;
  final String cuuId;

  TestScreen(
      {required this.cuuId,
      required this.currEmail,
      required this.currName,
      required this.currLatitude,
      required this.currLogititude,
      super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TestScreen();
  }
}

class _TestScreen extends ConsumerState<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ref.watch(authContioller.notifier).getDetailsAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoderScreen();
          }
          return Scaffold(
              body: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              UserModel user = snapshot.data![index];

              String strCla = widget.currLatitude;
              String strClo = widget.currLogititude;
              String strla = user.Latitiude;
              String strlo = user.longitude;

              double cuula = double.parse(strCla);
              double cuulo = double.parse(strClo);
              double ranLa = double.parse(strla);
              double ranLo = double.parse(strlo);

              var distanceBetween =
                  Geolocator.distanceBetween(cuula, cuulo, ranLa, ranLo);
              double meters =
                  distanceBetween; // Replace with your value in meters
              double kilometers = meters / 1000;
              print("this is  my logic " + kilometers.toString());

              if (kilometers <= 2) {
                return GestureDetector(
                  onTap: () => ChatScreen(
                      currId: widget.cuuId,
                      CurrName: widget.currName,
                      RuserModel: user,
                      currEmail: widget.currEmail),
                  child: ListTile(
                    title: Text(user.name),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => ChatScreen(
                          currId: widget.cuuId,
                          CurrName: widget.currName,
                          RuserModel: user,
                          currEmail: widget.currEmail),
                    )),
                    subtitle: Text("Distance$kilometers Km"),
                  ),
                );
              }
            },
          ));
        });
  }
}
