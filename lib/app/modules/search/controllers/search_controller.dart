import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/search_suggestion_model.dart';

import '../../../repositories/search_repository.dart';

class SearchController extends GetxController {
  final heroTag = "".obs;
  TextEditingController textEditingController;
  final searchedData = "".obs;
  final searchSuggestions = <SearchSuggestion>[].obs;
  final trendingSuggestions = <SearchSuggestion>[].obs;
  SearchRepository _searchRepository;
  // final isHaveToHideTrending = false.obs;

  SearchController() {
    _searchRepository = new SearchRepository();
    textEditingController = new TextEditingController();
    print("sdnkjsna called0");
  }

  @override
  void onInit() async {
    print("sdnkjsna called1");
    await refreshSearch();
    super.onInit();
  }

  @override
  void onReady() {
    heroTag.value = Get.arguments as String;
    super.onReady();
  }

  Future refreshSearch({bool showMessage}) async {
    print("sdnkjsna refreshSearch called");
    await getTrending();
    if (showMessage == true) {
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Search list refreshed successfully".tr));
    }
  }

  Future getSearchSuggestions({String searchedData}) async {
    print("sdnkjsna getSearchSuggestions called");
    try {
      searchSuggestions
          .assignAll(await _searchRepository.getSearchSuggestions(searchedData: searchedData));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getTrending() async {
    print("jnfjsanfdakj getTrending called");
    // try {
      trendingSuggestions
          .assignAll(await _searchRepository.getSearchSuggestions());
    // } catch (e) {
    //   print("jnfjsanfdakj e:${e.toString()}");
    //   Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    // }
  }

  Timer searchOnStoppedTyping;

  void onChangeHandler(String searchedData) {
    print("fhhabhfa ${searchedData.toString()}");
    const duration = Duration(
        milliseconds:
            800); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping.cancel(); // clear timer
    }

    // searchOnStoppedTyping = new Timer(duration, () => search(value));

    searchOnStoppedTyping = new Timer(duration, () {
      this.searchedData.value =  searchedData;
      if(searchedData != "") {
        getSearchSuggestions(searchedData:searchedData);
      }
    });

  }

// search(value) {
  // print('hello world from search . the value is $value');
  // searchData = value;
  // if (value != "" && value != lastSearched) {
  //   isFirstData = true;
  //   getSearchData(isRefresh: true);
  // }
  // setState(() {});
// }

// void switchSuggestions() {
//   if (isHaveToHideTrending == true) {
//     searchSuggestions.value = searchSuggestions;
//   } else {
//     searchSuggestions.value = trendingSuggestions;
//   }
// }
}
