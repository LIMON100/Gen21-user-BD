import 'package:flutter/material.dart';
import '../../home/views/home2_view.dart';

class AfterTipsPayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        body: Column(
          children:[
            SizedBox(height: 350),
            Center(
              child: Text(
                "Tips Pay Successfully",
                style: TextStyle(fontSize: 23, color: Colors.green),
              ),
             ),

            SizedBox(height: 250),
            IconButton(
              icon: Icon(
                Icons.home,
                size: 35, // Adjust the size as needed
                color: Colors.orange, // Change the color to orange
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Home2View(),
                  ),
                );
                // Get.find<RootController>().changePage(1);
              },
            ),
          ],
        ),
      ),
    );
  }
}
