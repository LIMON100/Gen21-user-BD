import 'package:flutter/cupertino.dart';

class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    @required this.title,
    @required this.image,
    @required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Step-1",
    // image: "assets/screens/g0.jpg",
    image: "assets/screens/ga1.jpg",
    desc: "First select your current Location",
  ),
  OnboardingContents(
    title: "Step-2",
    // image: "assets/screens/g3.jpg",
    image: "assets/screens/ga2.jpg",
    desc: "Select your order",
  ),
  OnboardingContents(
    title: "Step-3",
    // image: "assets/screens/g5.jpg",
    image: "assets/screens/ga4.jpg",
    desc: "Select your location & go to payment option",
  ),
  OnboardingContents(
    title: "Step-4",
    // image: "assets/screens/g7.jpeg",
    image: "assets/screens/ga5.jpg",
    desc: "Make payment and send request",
  ),
  OnboardingContents(
    title: "Step-5",
    image: "assets/screens/g8.jpg",
    desc: "Wait for Partner ready to work.",
  ),
  OnboardingContents(
    title: "Step-6",
    image: "assets/screens/g9.jpeg",
    desc: "Finish the job",
  ),
  OnboardingContents(
    title: "Step-7",
    image: "assets/screens/g10.jpeg",
    desc: "Give review and tips.",
  ),
];