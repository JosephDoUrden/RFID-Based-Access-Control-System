import 'package:flutter/material.dart';
import 'package:frontend/views/login/login_view.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height * 0.2)),
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: "Welcome",
              body: "Experience the next level of security with our RFID-based access control system.",
              image: _buildImageWithBorder("assets/images/slide1.svg"),
              decoration: const PageDecoration(
                titleTextStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                bodyTextStyle: TextStyle(fontSize: 16.0),
              ),
            ),
            PageViewModel(
              title: "Real-time Monitoring",
              body: "Monitor access activities in real-time and receive instant alerts for any unauthorized attempts.",
              image: _buildImageWithBorder("assets/images/slide2.svg"),
              decoration: const PageDecoration(
                bodyTextStyle: TextStyle(fontSize: 16.0),
              ),
            ),
            PageViewModel(
              title: "Flexible Security Solutions",
              body:
                  "Customize security settings and permissions according to your organization's needs and requirements.",
              image: _buildImageWithBorder("assets/images/slide3.svg"),
              decoration: const PageDecoration(
                bodyTextStyle: TextStyle(fontSize: 16.0),
              ),
            ),
            PageViewModel(
              title: "Get Started",
              body: "Enhance your security measures today with our RFID-based access control solution.",
              image: _buildImageWithBorder("assets/images/slide4.svg"),
              decoration: const PageDecoration(
                bodyTextStyle: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
          done: Text("Start", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue[900])),
          onDone: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
            );
          },
          showSkipButton: false,
          showNextButton: false,
          dotsDecorator: DotsDecorator(
            size: const Size(10.0, 10.0),
            color: Colors.grey,
            activeSize: const Size(22.0, 10.0),
            activeColor: Colors.blue[900],
            spacing: const EdgeInsets.all(3.0),
          ),
        ),
      ),
    );
  }

  Widget _buildImageWithBorder(String imagePath) {
    return Container(
      width: 450,
      height: 450,
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        color: Colors.transparent,
      ),
      child: Center(
        child: Image(
          image: Svg(imagePath),
          width: 300,
          height: 300,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
