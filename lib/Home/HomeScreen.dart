import 'package:amazon/AuthContoller/authContoller.dart';
import 'package:amazon/Home/Container.dart';
import 'package:amazon/Profile/test.dart';
import 'package:amazon/UserModel/UserModel.dart';
import 'package:amazon/constants/LoderScreen.dart';
import 'package:amazon/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
// required String name,
//       required String Email,
//       required String Latitiude,
//       required String longitude,
//       required String UserUId

class HomeScreen extends ConsumerStatefulWidget {
  final String CurrentUserID;
  final String name;
  final String Email;
  HomeScreen(
      {required this.Email,
      required this.name,
      required this.CurrentUserID,
      super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  var latitudeCurr = ",mfmfl;asml;fmsal;d";
  var longitudeCurr = ",mndflnasdlkfdnlkaf";

  final TextEditingController searchContoller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetPermission();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
  }

  void UpdateUserModelLocation(
      {required BuildContext context,
      required String name,
      required String Email,
      required String Latitiude,
      required String longitude,
      required String UserUId}) async {
    UserModel userModel = UserModel(
        name: name,
        Latitiude: Latitiude,
        longitude: longitude,
        Email: Email,
        UserUId: UserUId);
    ref.watch(authContioller.notifier).UpdateUserLocation(
          userModel: userModel,
          context: context,
          Latitiude: Latitiude,
          longitude: longitude,
        );
  }

  void GetPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      showSnackBar(context, "Permission Not Allowed");
      LocationPermission asked = await Geolocator.requestPermission();
    } else {
      Position currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print("Latitiude" + currentLocation.latitude.toString());
      print("Latitiude" + currentLocation.longitude.toString());
      setState(() {
        latitudeCurr = currentLocation.latitude.toString();
        print("lat" + latitudeCurr);
        longitudeCurr = currentLocation.longitude.toString();
        print("lat" + longitudeCurr);
      });

      //Geolocator.distanceBetween(currentLocation.latitude,currentLocation.longitude, endLatitude, endLongitude)
    }
  }

  void Logout() {
    ref.watch(authContioller.notifier).logOutUser(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchContoller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final TextEditingController nameContoller=TextEditingController();
    final isLoding = ref.watch(authContioller);
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello,"),
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            isLoding
                ? LoderScreen()
                : SizedBox(
                    height: 50,
                  ),
            ListTile(
              title: Text("My Happiness Jorney"),
            ),
            ListTile(
              title: Text("My Happines Pint"),
            ),
            ListTile(
              title: Text("My Notification"),
            ),
            ListTile(
              title: Text("My Privacy Setting"),
            ),
            ListTile(
              title: Text("FAQ.s"),
            ),
            GestureDetector(
              onTap: () => Logout(),
              child: ListTile(
                onTap: () {},
                title: TextButton.icon(
                    onPressed: () => Logout(),
                    icon: IconButton(
                        onPressed: () {
                          Logout();
                        },
                        icon: Icon(Icons.logout)),
                    label: Text("LogOut")),
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "Disclamer click each botton one by one and wait for 3-4 sec after each click"),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  GetPermission();
                },
                child: Text("Location")),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () => UpdateUserModelLocation(
                    context: context,
                    name: widget.name,
                    Email: widget.Email,
                    Latitiude: latitudeCurr,
                    longitude: longitudeCurr,
                    UserUId: widget.CurrentUserID),
                child: Text("SendCurrentLocation")),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => TestScreen(
                          cuuId: widget.CurrentUserID,
                          currEmail: widget.Email,
                          currName: widget.name,
                          currLatitude: latitudeCurr,
                          currLogititude: longitudeCurr)));
                },
                child: Text("List Of contacts")),
          ],
        ),
      ),
    );
  }
}
