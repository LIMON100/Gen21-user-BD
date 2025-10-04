import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../global_widgets/filter_bottom_sheet_widget.dart';
import '../controllers/search_controller.dart';
import '../widgets/search_services_list_widget.dart';
import '../widgets/search_suggestion_list_widget.dart';

class SearchView extends GetView<SearchController> {
  @override
  Widget build(BuildContext context) {

    return Obx( (){
      var searchSuggestions = controller.searchSuggestions;
      var trendingSearchSuggestions = controller.trendingSuggestions;
      print("sdnkjsna searchSuggestions: ${searchSuggestions.toString()} trendingSearchSuggestions : ${trendingSearchSuggestions.toString()}");
     return Scaffold(
        body: ListView(
          children: [
            buildSearchBar(),
            SearchSuggestionListWidget(  searchSuggestions : controller.searchedData.toString().length <=0 ?  trendingSearchSuggestions : searchSuggestions, isTrendingSearch: controller.searchedData.toString().length <=0? true : false)
          ],
        ),
      );
    }
    );
  }

  Widget buildSearchBar() {
    return Hero(
      tag: Get.arguments ?? '',
      child: Container(
        // margin: EdgeInsets.only(left: 20, right: 20, bottom: 16),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            border: Border.all(
              color: Get.theme.focusColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: (){
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12, left: 0),
                child: Icon(Icons.arrow_back_ios, color: Get.theme.colorScheme.secondary, size: 20,),
              ),
            ),
            Expanded(
              child: Material(
                color: Get.theme.primaryColor,
                child: TextField(
                  controller: controller.textEditingController,
                  onChanged:  controller.onChangeHandler,
                  // clipBehavior: HitTestBehavior.translucent,
                  style: Get.textTheme.bodyText2,
                  onSubmitted: (value) {
                    // controller.searchEServices(keywords: value);
                  },
                  autofocus: true,
                  cursorColor: Get.theme.focusColor,
                  decoration: Ui.getInputDecoration(hintText: "What are you looking for...".tr),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
