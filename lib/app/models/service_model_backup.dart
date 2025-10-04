import 'package:get/get.dart';
import 'parents/model.dart';

class GService extends Model{
  Data data;

  GService({this.data});

  GService.fromJson(Map<String, dynamic> json) {
    print("fsjfsads9 json: ${json.toString()}  data: ${json['data']}");

    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      print("fsjfsads7 ${this.data.toString()}");
      data['data'] = this.data.toJson();
      print("fsjfsads8 ${data['data'].toString()}");

    }else{
      print("fsjfsads9 data is null!");
    }
    return data;
  }
}

class Data {
  String id;
  String isFavourite;
  String name;
  String avgRating;
  String reviewCount;
  String price;
  String minPrice;
  String maxPrice;
  String details;
  String faq;
  List<Images> images;
  List<Services> services;

  Data(
      {this.id,
      this.isFavourite,
      this.name,
      this.avgRating,
      this.reviewCount,
      this.price,
      this.minPrice,
      this.maxPrice,
      this.details,
      this.faq,
      this.images,
      this.services});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    isFavourite = json['is_favourite'] as String;
    name = json['name']as String;
    avgRating = json['avg_rating']as String;
    reviewCount = json['review_count']as String;
    price = json['price']as String;
    minPrice = json['min_price']as String;
    maxPrice = json['max_price']as String;
    details = json['details']as String;
    faq = json['faq']as String;
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services.add(new Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id ;
    data['is_favourite'] = this.isFavourite;
    data['name'] = this.name;
    data['avg_rating'] = this.avgRating;
    data['review_count'] = this.reviewCount;
    data['price'] = this.price;
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    data['details'] = this.details;
    data['faq'] = this.faq;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    if (this.services != null) {
      data['services'] = this.services.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String imageUrl;

  Images({this.imageUrl});

  Images.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class Services {
  String id;
  String name;
  String price;
  String minPrice;
  String maxPrice;
  String details;
  String imageUrl;
  String hasSubType;
  String minimumUnit;

  Services(
      {this.id,
      this.name,
      this.price,
      this.minPrice,
      this.maxPrice,
      this.details,
      this.imageUrl,
      this.hasSubType,
      this.minimumUnit});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    name = json['name'] as String;
    price = json['price'] as String;
    minPrice = json['min_price'] as String;
    maxPrice = json['max_price'] as String;
    details = json['details'] as String;
    imageUrl = json['image_url'] as String;
    hasSubType = json['has_sub_type'] as String;
    minimumUnit = json['minimum_unit'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    data['details'] = this.details;
    data['image_url'] = this.imageUrl;
    data['has_sub_type'] = this.hasSubType;
    data['minimum_unit'] = this.minimumUnit;
    return data;
  }



}
