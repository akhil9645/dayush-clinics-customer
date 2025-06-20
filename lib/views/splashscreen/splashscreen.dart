import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.width / 2,
              child: Image.asset(
                  'assets/images/59cc1b60234293ffa59fad969db4a07ea957962a.png'),
            ),
            SvgPicture.asset('assets/svg/splashscreen.svg'),
          ],
        ),
      ),
    );
  }
}
