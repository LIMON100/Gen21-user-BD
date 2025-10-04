/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../models/search_suggestion_model.dart';
import '../../../routes/app_routes.dart';

class SearchSuggestionsListItemWidget extends StatelessWidget {
  const SearchSuggestionsListItemWidget({
    Key key,
    this.isTrendingSearch,
    @required SearchSuggestion searchSuggestion,
  })  : _searchSuggestion = searchSuggestion,
        super(key: key);

  final SearchSuggestion _searchSuggestion;
  final bool isTrendingSearch;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // Get.toNamed(Routes.E_SERVICE, arguments: {
          //   'searchSuggestion': _searchSuggestion,
          //   'heroTag': 'search_list'
          // });
          print("shbsdhbfas search item clicked");
          FocusManager.instance.primaryFocus?.unfocus();
          Get.toNamed(Routes.SERVICE, arguments: {
            'category_id': _searchSuggestion.id,
            'heroTag': 'search_list'
          });
        },
        child: Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      isTrendingSearch ? Icons.trending_up : Icons.search,
                      color: Get.theme.colorScheme.secondary,
                      size: 16,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(_searchSuggestion.name,
                        style: Get.textTheme.bodyText1
                            .merge(TextStyle(fontSize: 14))),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Divider(height: 1, color: Colors.grey.shade300,)
              ],
            )));
  }
}
