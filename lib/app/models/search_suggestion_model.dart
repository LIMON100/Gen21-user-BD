
import 'package:flutter/material.dart';

import 'e_service_model.dart';
import 'media_model.dart';
import 'parents/model.dart';

class SearchSuggestion extends Model {
  String id;
  String name;
  String description;
  Color color;
  Media image;
  bool featured;

  SearchSuggestion({this.id, this.name, this.description, this.color, this.image, this.featured});


  @override
  String toString() {
    return 'Category{id: $id, name: $name, description: $description, color: $color, image: $image, featured: $featured}';
  }

  SearchSuggestion.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    color = colorFromJson(json, 'color');
    description = transStringFromJson(json, 'description');
    image = mediaFromJson(json, 'image');
    featured = boolFromJson(json, 'featured');

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['color'] = '#${this.color.value.toRadixString(16)}';
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other &&
              other is SearchSuggestion &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              description == other.description &&
              color == other.color &&
              image == other.image &&
              featured == other.featured;


  @override
  int get hashCode =>
      super.hashCode ^ id.hashCode ^ name.hashCode ^ description.hashCode ^ color.hashCode ^ image.hashCode ^ featured.hashCode;


  @override
  bool get hasData {
    return id != null && name != null && description != null;
  }

}



// import 'parents/model.dart';
//
// class SearchSuggestion extends Model {
//   String id;
//   String category;
//
//   SearchSuggestion({
//     this.id,
//     this.category,
//   });
//
//   SearchSuggestion.fromJson(Map<String, dynamic> json) {
//     id = transStringFromJson(json, 'id');
//     category = transStringFromJson(json, 'category');
//     super.fromJson(json);
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     if (id != null) data['id'] = this.id;
//     if (category != null) data['category'] = this.category;
//
//     return data;
//   }
//
//   @override
//   bool get hasData {
//     return id != null && category != null;
//   }
// }
