// import 'package:get/get.dart';
//
// import 'parents/model.dart';
// import 'providers_model.dart';
//
// class ProvidersDataWithServiceName extends Model{
//   // List<Data> data;
//   var data = <Data>[].obs;
//
//   @override
//   String toString() {
//     return 'Providers{data: $data}';
//   }
//
//   ProvidersDataWithServiceName({this.data});
//
//   ProvidersDataWithServiceName.fromJson(Map<String, dynamic> json) {
//     if (json['data'] != null) {
//       data = new List<Data>();
//       json['data'].forEach((v) {
//         data.add(new Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.data != null) {
//       data['data'] = this.data.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data {
//   String title;
//   List<Users> providers;
//   var selectedIndex = "-1".obs;
//
//   @override
//   String toString() {
//     return 'Data{title: $title, providers: $providers, selectedIndex: $selectedIndex}';
//   }
//
//   Data({this.title, this.providers});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     if (json['providers'] != null) {
//       providers = new List<Users>();
//       json['providers'].forEach((v) {
//         providers.add(new Users.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['title'] = this.title;
//     if (this.providers != null) {
//       data['providers'] = this.providers.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
