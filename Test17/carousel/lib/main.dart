import 'package:flutter/material.dart';
import 'carouselHome.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

int initScreen;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  runApp(MyApp());
}

void shared() async {
  SharedPreferences prefs2 = await SharedPreferences.getInstance();
  await prefs2.setInt("initScreen", 1);
  print('initScreen ${initScreen}');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: initScreen == 0 || initScreen == null
            ? OnBoardingApp()
            : CarouselExample());
  }
}

class OnBoardingApp extends StatefulWidget {
  @override
  _OnBoardingAppState createState() => _OnBoardingAppState();
}

class _OnBoardingAppState extends State<OnBoardingApp> {
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
          title: "Andri si Tua Malarangeng",
          body: "Jomblo sampai sekarang gak ada yang mau...>>>",
          image: buildImage("img/andri.jpg"),
          decoration: PageDecoration(
              titleTextStyle:
                  TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              bodyTextStyle: TextStyle(fontSize: 20),
              descriptionPadding: EdgeInsets.all(16.0),
              imagePadding: EdgeInsets.all(24.0),
              pageColor: Colors.orange)),
      PageViewModel(
        title: "Andri si Tua Malarangeng",
        body: "Jomblo sampai sekarang gak ada yang mau...>>>",
        image: buildImage("img/andri.jpg"),
        decoration: getPageDecor(),
      ),
      PageViewModel(
        title: "Andri si Tua Malarangeng",
        body: "Jomblo sampai sekarang gak ada yang mau...>>>",
        image: buildImage("img/andri.jpg"),
        decoration: getPageDecor(),
        footer: RaisedButton(
          onPressed: () {},
          color: Colors.blue,
          shape: StadiumBorder(),
          child: Text(
            "Done",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ];
  }

  Widget buildImage(String path) {
    return Center(
      child: Image.asset(
        path,
        width: 350.0,
      ),
    );
  }

  PageDecoration getPageDecor() {
    return PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        bodyTextStyle: TextStyle(fontSize: 20),
        descriptionPadding: EdgeInsets.all(16.0),
        imagePadding: EdgeInsets.all(24.0),
        pageColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new IntroductionScreen(
        pages: getPages(),
        onDone: () {
          return Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return CarouselExample();
          }));
        },
        done: RaisedButton(
          onPressed: () {
            shared();
            return Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return CarouselExample();
            }));
          },
          color: Colors.blue,
          shape: StadiumBorder(),
          child: Text(
            "Done",
            style: TextStyle(color: Colors.white),
          ),
        ),
        showSkipButton: true,
        skip: Text("Skip"),
        showNextButton: true,
        next: Icon(Icons.arrow_forward),
        dotsDecorator: DotsDecorator(
            color: Colors.grey[350],
            activeColor: Colors.blue,
            activeSize: Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    );
  }
}
