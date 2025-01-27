import 'package:dayush_clinic/utils/constants.dart';
import 'package:dayush_clinic/views/homepage/homepage.dart';
import 'package:dayush_clinic/views/profilepage/profile_screen.dart';
import 'package:dayush_clinic/views/scheduledappointmentspage/scheduledappointmentspage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int currentIndex = 0;
  bool hasPressedBackOnce = false;
  void setPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [Homepage(), Scheduledappointmentspage(), ProfileScreen()];
    return PopScope(
      canPop: hasPressedBackOnce,
      onPopInvokedWithResult: (didPop, result) {
        if (!hasPressedBackOnce) {
          hasPressedBackOnce = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              content: Row(
                children: [
                  SizedBox(
                      width: 24,
                      height: 24,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: SvgPicture.asset(
                          'assets/svg/dayushclinics.svg',
                          fit: BoxFit.cover,
                        ),
                      )),
                  SizedBox(width: 5),
                  Text("Press again to exit"),
                ],
              ),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width / 20,
                  left: MediaQuery.of(context).size.width / 4,
                  right: MediaQuery.of(context).size.width / 4),
            ),
          );
          Future.delayed(Duration(seconds: 2), () {
            hasPressedBackOnce = false;
          });
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey,
          currentIndex: currentIndex,
          selectedItemColor: Constants.buttoncolor,
          selectedIconTheme: IconThemeData(color: Constants.buttoncolor),
          onTap: setPage,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/bottomnavhome.svg',
                color: currentIndex == 0 ? Constants.buttoncolor : Colors.grey,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/bottomnavtele.svg',
                color: currentIndex == 1 ? Constants.buttoncolor : Colors.grey,
              ),
              label: 'My Appoinments',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/bottomnavprofile.svg',
                color: currentIndex == 2 ? Constants.buttoncolor : Colors.grey,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
