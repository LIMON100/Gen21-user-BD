import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/laravel_provider.dart';
import '../../routes/theme1_app_pages.dart';
import '../cart/controller/add_to_cart_controller.dart';
import '../service_request/controllers/RequestController.dart';
import 'SizeConfig.dart';
import 'TextPage.dart';
import 'onboarding_contents.dart';
// import '../home/controllers/home_controller.dart';

class OnboardingScreen extends StatefulWidget {

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    // _getBookigId();
    super.initState();
  }
  // HomeController controller = HomeController();
  // await controller.refreshHome(showMessage: true);

  RequestController controller = RequestController();
  LaravelApiClient _laravelApiClient = Get.find<LaravelApiClient>();
  int bookingId = 0;
  int orderId = 0;
  final AddToCartController _addToCartController = Get.put(AddToCartController());


  Future<void> _getBookigId()async{
    var response = await controller.submitBookingRequest2(_addToCartController.addToCartData);
    bookingId = _laravelApiClient.valueForResponse;
    orderId = _laravelApiClient.valueForOrderId;
    // setState(() {});

    if(bookingId == 0){
      await controller.submitBookingRequest2(_addToCartController.addToCartData);
      bookingId = _laravelApiClient.valueForResponse;
      orderId = _laravelApiClient.valueForOrderId;
      setState(() {});
    }
    else{
      bookingId = _laravelApiClient.valueForResponse;
      orderId = _laravelApiClient.valueForOrderId;
      setState(() {});
    }
  }

  int _currentPage = 0;
  List<Color> colors = [
    Color(0xffDAD3C8),
    Color(0xffFFE5DE),
    Color(0xffE6DCC3),
    Color(0xffFFDAB9),
    Color(0xffE6B8AF),
    Color(0xffFFD1DC),
    Color(0xffDAD3C8),
  ];

  AnimatedContainer _buildDots({
    int index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: Color(0xFF000000),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW;
    double height = SizeConfig.screenH;

    // controller.refreshHome(showMessage: true);

    return Scaffold(
      backgroundColor: colors[_currentPage],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Image.asset(
                          contents[i].image,
                          height: SizeConfig.blockV * 35,
                        ),
                        SizedBox(
                          height: (height >= 820) ? 60 : 30,
                        ),
                        Text(
                          contents[i].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Mulish",
                            fontWeight: FontWeight.w600,
                            fontSize: (width <= 550) ? 30 : 35,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          contents[i].desc,
                          style: TextStyle(
                            fontFamily: "Mulish",
                            fontWeight: FontWeight.w300,
                            fontSize: (width <= 550) ? 17 : 25,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      contents.length,
                          (int index) => _buildDots(
                        index: index,
                      ),
                    ),
                  ),
                  _currentPage + 1 == contents.length
                      ? Padding(
                    padding: const EdgeInsets.all(30),
                    child: ElevatedButton(
                      onPressed: ()async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('hasSeenOnboarding', true);
                        // controller.refreshHome(showMessage: true);
                        Get.offAllNamed(Theme1AppPages.INITIAL);
                      },
                      child: const Text("START"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: (width <= 550)
                            ? const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 20)
                            : EdgeInsets.symmetric(
                            horizontal: width * 0.2, vertical: 25),
                        textStyle:
                        TextStyle(fontSize: (width <= 550) ? 13 : 17),
                      ),
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          // onPressed: () {
                          //   _controller.jumpToPage(6);
                          // },
                          onPressed:(){},
                          child: const Text(
                            "SKIP",
                            style: TextStyle(color: Colors.black),
                          ),
                          style: TextButton.styleFrom(
                            elevation: 0,
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: (width <= 550) ? 13 : 17,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                            );
                          },
                          child: const Text("NEXT"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            elevation: 0,
                            padding: (width <= 550)
                                ? const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20)
                                : const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 25),
                            textStyle: TextStyle(
                                fontSize: (width <= 550) ? 13 : 17),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}