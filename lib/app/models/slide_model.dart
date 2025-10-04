import 'package:flutter/material.dart';
import 'package:home_services/app/models/category_model.dart';

import 'e_provider_model.dart';
import 'e_service_model.dart';
import 'media_model.dart';
import 'parents/model.dart';

class Slide extends Model {
  int order;
  String text;
  String button;
  String textPosition;
  Color textColor;
  Color buttonColor;
  Color backgroundColor;
  Color indicatorColor;
  Media image;
  String imageFit;
  EService eService;
  EProvider eProvider;
  Category category;
  bool enabled;

  Slide({
    this.order,
    this.text,
    this.button,
    this.textPosition,
    this.textColor,
    this.buttonColor,
    this.backgroundColor,
    this.indicatorColor,
    this.image,
    this.imageFit,
    this.eService,
    this.eProvider,
    this.category,
    this.enabled,
  });


  @override
  String toString() {
    return 'Slide{order: $order, text: $text, button: $button, textPosition: $textPosition, textColor: $textColor, buttonColor: $buttonColor, backgroundColor: $backgroundColor, indicatorColor: $indicatorColor, image: $image, imageFit: $imageFit, eService: $eService, eProvider: $eProvider, category: $category, enabled: $enabled}';
  }

  Slide.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    order = intFromJson(json, 'order');
    text = transStringFromJson(json, 'text');
    button = transStringFromJson(json, 'button');
    textPosition = stringFromJson(json, 'text_position');
    textColor = colorFromJson(json, 'text_color');
    buttonColor = colorFromJson(json, 'button_color');
    backgroundColor = colorFromJson(json, 'background_color');
    indicatorColor = colorFromJson(json, 'indicator_color');
    image = mediaFromJson(json, 'image');
    imageFit = stringFromJson(json, 'image_fit');
    eService = json['e_service_id'] != null ? EService(id: json['e_service_id'].toString()) : null;
    eProvider = json['e_provider_id'] != null ? EProvider(id: json['e_provider_id'].toString()) : null;
    category = json['categorie_id'] != null ? Category(id: json['categorie_id'].toString()) : null;
    enabled = boolFromJson(json, 'enabled');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }
}
