import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/e_service_model.dart';
import '../../../models/search_suggestion_model.dart';
import '../../category/widgets/services_list_item_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import 'search_suggestions_list_item_widget.dart';

class SearchSuggestionListWidget extends StatelessWidget {
  final List<SearchSuggestion> searchSuggestions;
  final bool isTrendingSearch;

  SearchSuggestionListWidget(
      {Key key,
      this.isTrendingSearch,
      List<SearchSuggestion> this.searchSuggestions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print(
          "sdnkjsna in SearchSuggestionListWidget ${searchSuggestions.toString()}");
      if (this.searchSuggestions.isEmpty) {
        return Container();
      } else {
        return Container(
          padding: EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isTrendingSearch)
                Text("Trending".tr,
                    style: Get.textTheme.bodyText1.merge(
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    )),
              SizedBox(height: 10,),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: searchSuggestions.length,
                itemBuilder: ((_, index) {
                  var _searchSuggestion = searchSuggestions.elementAt(index);
                  return SearchSuggestionsListItemWidget(
                      isTrendingSearch: isTrendingSearch,
                      searchSuggestion: _searchSuggestion);
                }),
              )
            ],
          ),
        );
      }
    });
  }
}
