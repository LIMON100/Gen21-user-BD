import 'package:flutter/material.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';

class ImageSliderPage extends StatelessWidget {
  // List<String> sampleImages = [
  //   'assets/screens/g1-1.jpg',
  //   'assets/screens/g3.jpg',
  //   'assets/screens/g4.jpeg',
  //   'assets/screens/g7.jpeg',
  //   'assets/screens/g13.jpg',
  //   'assets/screens/g9.jpeg',
  //   'assets/screens/g10.jpeg',
  // ];

  // New List images for publish
  List<String> sampleImages = [
    'assets/screens/ga1.jpg',
    'assets/screens/ga2.jpg',
    'assets/screens/ga3.jpg',
    'assets/screens/ga4.jpg',
    'assets/screens/ga5.jpg',
    'assets/screens/g13.jpg',
    'assets/screens/g9.jpeg',
    'assets/screens/g10.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 20,
            ),
            FanCarouselImageSlider(
              imagesLink: sampleImages,
              sliderHeight: 630,
              isAssets: true,
              autoPlay: false,
              isClickable: false,
            ),
          ],
        ),
      ),
    );
  }
}