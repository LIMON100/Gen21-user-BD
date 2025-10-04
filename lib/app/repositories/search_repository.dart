import 'package:get/get.dart';

import '../models/category_model.dart';
import '../models/search_suggestion_model.dart';
import '../providers/laravel_provider.dart';

class SearchRepository {
  LaravelApiClient _laravelApiClient;

  SearchRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<SearchSuggestion>> getSearchSuggestions({String searchedData}) {
    print("sdnkjsna getSearchSuggestions called");

    return _laravelApiClient.getSearchSuggestions(searchedData: searchedData);
  }

  // Future<List<SearchSuggestion>> getTrending() {
  //   // return _laravelApiClient.getTrendingSuggestions();
  //    return dummyData();
  // }
  //
  // Future<List<SearchSuggestion>> dummyData() async {
  //   List<SearchSuggestion> testarray = List<SearchSuggestion>();
  //   testarray.add(SearchSuggestion(id: "1", category: "Home Cleaning"));
  //   testarray.add(SearchSuggestion(id: "2", category: "Ac Servicing"));
  //   testarray.add(SearchSuggestion(id: "3", category: "Party Space"));
  //   testarray.add(SearchSuggestion(id: "4", category: "Water Tank Cleaning"));
  //   testarray.add(SearchSuggestion(id: "5", category: "Cooking"));
  //   print("sdnkjsna called");
  //   return testarray;
  // }
}
