import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselExample extends StatefulWidget {
  @override
  _CarouselExampleState createState() => _CarouselExampleState();
}

class _CarouselExampleState extends State<CarouselExample> {
  int current = 0;
  List img = [
    "https://cdn.auth0.com/blog/illustrations/flutter.png",
    "https://cdn.auth0.com/blog/illustrations/flutter.png",
    "https://cdn.auth0.com/blog/illustrations/flutter.png"
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Carousel"),
      ),
      body: new ListView(children: [
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new CarouselSlider(
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: Duration(milliseconds: 2000),
                pauseAutoPlayOnTouch: Duration(seconds: 4),
                enlargeCenterPage: true,
                height: 200.0,
                initialPage: 0,
                onPageChanged: (index) {
                  setState(() {
                    current = index;
                  });
                },
                items: img.map((imgUrl) {
                  return Builder(builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(right: 7.0, left: 7.0, top: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Image.network(
                        imgUrl,
                        fit: BoxFit.cover,
                      ),
                    );
                  });
                }).toList()),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: map<Widget>(img, (index, url) {
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: current == index ? Colors.blue : Colors.grey),
                );
              }),
            )
          ],
        ),
      ]),
    );
  }
}
