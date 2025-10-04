import 'package:home_services/app/models/parents/model.dart';

import 'service_model.dart';

class ServiceDetails extends Model {
  bool success;
  List<Data> data;
  String message;

  ServiceDetails({this.success, this.data, this.message});

  ServiceDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data extends Model {
  String id;
  Name name;
  double price;
  String discountPrice;
  String priceUnit;
  int minimumUnit;

  // QuantityUnit quantityUnit;
  String duration;
  String subtypeHeading;
  Name description;
  Name faq;
  bool featured;
  bool enableBooking;
  bool available;
  String eProviderId;
  bool hasMedia;
  int totalReviews;
  bool isFavorite;
  double rate;
  String minPrice;
  String maxPrice;
  bool hasSubType;
  List<Options> options;
  List<EProvider> eProvider;
  List<Media> media;

  Data({
    this.id,
    this.name,
    this.price,
    this.discountPrice,
    this.priceUnit,
    this.minimumUnit,
    // this.quantityUnit,
    this.duration,
    this.subtypeHeading,
    this.description,
    this.faq,
    this.featured,
    this.enableBooking,
    this.available,
    this.eProviderId,
    this.hasMedia,
    this.totalReviews,
    this.isFavorite,
    this.rate,
    this.minPrice,
    this.maxPrice,
    this.hasSubType,
    this.options,
    this.eProvider,
    this.media,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = stringFromJson(json, "id");
    name = json['name'] != null ? objectFromJson(json, 'name', (v) => Name.fromJson(v)) : null;
    price = doubleFromJson(json, 'price');
    discountPrice = stringFromJson(json, 'discount_price');
    priceUnit = stringFromJson(json, 'price_unit');
    minimumUnit = intFromJson(json, 'minimum_unit');
    // quantityUnit = json['quantity_unit'] != null ? objectFromJson(json, 'quantity_unit', (v) => QuantityUnit.fromJson(v)) : null;
    duration = stringFromJson(json, 'duration');
    subtypeHeading = stringFromJson(json, 'subtype_heading');
    description = json['description'] != null ? objectFromJson(json, 'description', (v) => Name.fromJson(v)) : null;
    faq = json['faq'] != null ? objectFromJson(json, 'faq', (v) => Name.fromJson(v)) : null;
    featured = boolFromJson(json, 'featured');
    enableBooking = boolFromJson(json, 'enable_booking');
    available = boolFromJson(json, 'available');
    eProviderId = stringFromJson(json, 'e_provider_id');
    hasMedia = boolFromJson(json, 'has_media');
    totalReviews = intFromJson(json, 'total_reviews');
    isFavorite = boolFromJson(json, 'is_favorite');
    rate = doubleFromJson(json, 'rate');
    minPrice = stringFromJson(json, 'min_price');
    maxPrice = stringFromJson(json, 'max_price');
    hasSubType = boolFromJson(json, 'has_sub_type');
    if (json['options'] != null) {
      options = new List<Options>();
      json['options'].forEach((v) {
        options.add(new Options.fromJson(v));
      });
    }
    if (json['e_provider'] != null) {
      eProvider = new List<EProvider>();
      json['e_provider'].forEach((v) {
        eProvider.add(new EProvider.fromJson(v));
      });
    }
    if (json['media'] != null) {
      media = new List<Media>();
      json['media'].forEach((v) {
        media.add(new Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    data['price'] = this.price;
    data['discount_price'] = this.discountPrice;
    data['price_unit'] = this.priceUnit;
    data['minimum_unit'] = this.minimumUnit;
    // if (this.quantityUnit != null) {
    //   data['quantity_unit'] = this.quantityUnit.toJson();
    // }
    data['duration'] = this.duration;
    data['subtype_heading'] = this.subtypeHeading;
    if (this.description != null) {
      data['description'] = this.description.toJson();
    }
    data['faq'] = this.faq;
    data['featured'] = this.featured;
    data['enable_booking'] = this.enableBooking;
    data['available'] = this.available;
    data['e_provider_id'] = this.eProviderId;
    data['has_media'] = this.hasMedia;
    data['total_reviews'] = this.totalReviews;
    data['is_favorite'] = this.isFavorite;
    data['rate'] = this.rate;
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    data['has_sub_type'] = this.hasSubType;
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    if (this.eProvider != null) {
      data['e_provider'] = this.eProvider.map((v) => v.toJson()).toList();
    }
    if (this.media != null) {
      data['media'] = this.media.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Name {
  String en;

  Name({this.en});

  Name.fromJson(Map<String, dynamic> json) {
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    return data;
  }
}

// class QuantityUnit {
//   Null en;
//
//   QuantityUnit({this.en});
//
//   QuantityUnit.fromJson(Map<String, dynamic> json) {
//     en = json['en'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['en'] = this.en;
//     return data;
//   }
// }

class Options extends Model {
  String id;
  Name name;
  Name description;
  double price;
  int minimumUnit;
  int eServiceId;
  int optionGroupId;

  // List<Null> customFields;

  Options({
    this.id,
    this.name,
    this.description,
    this.price,
    this.minimumUnit,
    this.eServiceId,
    this.optionGroupId,
    // this.customFields
  });

  Options.fromJson(Map<String, dynamic> json) {
    id = stringFromJson(json, 'id');
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    description = json['description'] != null ? new Name.fromJson(json['description']) : null;
    price = doubleFromJson(json, 'price');
    minimumUnit = intFromJson(json, 'minimum_unit');
    eServiceId = intFromJson(json, 'e_service_id');
    optionGroupId = intFromJson(json, 'option_group_id');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    if (this.description != null) {
      data['description'] = this.description.toJson();
    }
    data['price'] = this.price;
    data['minimum_unit'] = this.minimumUnit;
    data['e_service_id'] = this.eServiceId;
    data['option_group_id'] = this.optionGroupId;
    return data;
  }
}

class EProvider extends Model {
  String id;
  Name name;
  int eProviderTypeId;
  Name description;
  String phoneNumber;
  String mobileNumber;
  double availabilityRange;
  bool available;
  bool featured;
  bool accepted;
  bool hasMedia;
  double rate;
  int totalReviews;
  List<Users> users;
  List<AvailabilityHours> availabilityHours;
  List<Media> media;

  EProvider({this.id, this.name, this.eProviderTypeId, this.description, this.phoneNumber, this.mobileNumber, this.availabilityRange, this.available, this.featured, this.accepted, this.hasMedia, this.rate, this.totalReviews, this.users, this.availabilityHours, this.media});

  EProvider.fromJson(Map<String, dynamic> json) {
    id = stringFromJson(json, 'id');
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    eProviderTypeId = json['e_provider_type_id'];
    description = json['description'] != null ? new Name.fromJson(json['description']) : null;
    phoneNumber = json[''];
    stringFromJson(json, 'phone_number');
    mobileNumber = stringFromJson(json, 'mobile_number');
    availabilityRange = doubleFromJson(json, 'availability_range');
    available = boolFromJson(json, 'available');
    featured = boolFromJson(json, 'featured');
    accepted = boolFromJson(json, 'accepted');
    hasMedia = boolFromJson(json, 'has_media');
    rate = doubleFromJson(json, 'rate');
    totalReviews = intFromJson(json, 'total_reviews');
    if (json['users'] != null) {
      users = new List<Users>();
      json['users'].forEach((v) {
        users.add(new Users.fromJson(v));
      });
    }
    if (json['availability_hours'] != null) {
      availabilityHours = new List<AvailabilityHours>();
      json['availability_hours'].forEach((v) {
        availabilityHours.add(new AvailabilityHours.fromJson(v));
      });
    }
    if (json['media'] != null) {
      media = new List<Media>();
      json['media'].forEach((v) {
        media.add(new Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    data['e_provider_type_id'] = this.eProviderTypeId;
    if (this.description != null) {
      data['description'] = this.description.toJson();
    }
    data['phone_number'] = this.phoneNumber;
    data['mobile_number'] = this.mobileNumber;
    data['availability_range'] = this.availabilityRange;
    data['available'] = this.available;
    data['featured'] = this.featured;
    data['accepted'] = this.accepted;

    data['has_media'] = this.hasMedia;
    data['rate'] = this.rate;
    data['total_reviews'] = this.totalReviews;

    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    if (this.availabilityHours != null) {
      data['availability_hours'] = this.availabilityHours.map((v) => v.toJson()).toList();
    }
    if (this.media != null) {
      data['media'] = this.media.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users extends Model {
  String id;
  String name;
  String email;
  String phoneNumber;
  String phoneVerifiedAt;
  String emailVerifiedAt;
  String apiToken;
  String deviceToken;
  String stripeId;
  String cardBrand;
  String cardLastFour;
  String trialEndsAt;
  String paypalEmail;
  String createdAt;
  String updatedAt;
  // CustomFields customFields;
  bool hasMedia;
  Pivot pivot;
  List<Media> media;

  Users({this.id, this.name, this.email, this.phoneNumber, this.phoneVerifiedAt, this.emailVerifiedAt, this.apiToken, this.deviceToken, this.stripeId, this.cardBrand, this.cardLastFour, this.trialEndsAt, this.paypalEmail, this.createdAt, this.updatedAt, this.hasMedia, this.pivot, this.media});

  Users.fromJson(Map<String, dynamic> json) {
    id = stringFromJson(json, 'id');
    name = stringFromJson(json, 'name');
    email = stringFromJson(json, 'email');
    phoneNumber = stringFromJson(json, 'phone_number');
    phoneVerifiedAt = stringFromJson(json, 'phone_verified_at');
    emailVerifiedAt = stringFromJson(json, 'email_verified_at');
    apiToken = stringFromJson(json, 'api_token');
    deviceToken = stringFromJson(json, 'device_token');
    stripeId = stringFromJson(json, 'stripe_id');
    cardBrand = stringFromJson(json, 'card_brand');
    cardLastFour = stringFromJson(json, 'card_last_four');
    trialEndsAt = stringFromJson(json, 'trial_ends_at');
    paypalEmail = stringFromJson(json, 'paypal_email');
    createdAt = stringFromJson(json, 'created_at');
    updatedAt = stringFromJson(json, 'updated_at');
    // customFields = json['custom_fields'] != null ? new CustomFields.fromJson(json['custom_fields']) : null;
    hasMedia = boolFromJson(json, 'has_media');
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
    if (json['media'] != null) {
      media = new List<Media>();
      json['media'].forEach((v) {
        media.add(new Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['phone_verified_at'] = this.phoneVerifiedAt;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['api_token'] = this.apiToken;
    data['device_token'] = this.deviceToken;
    data['stripe_id'] = this.stripeId;
    data['card_brand'] = this.cardBrand;
    data['card_last_four'] = this.cardLastFour;
    data['trial_ends_at'] = this.trialEndsAt;
    data['paypal_email'] = this.paypalEmail;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    // if (this.customFields != null) {
    //   data['custom_fields'] = this.customFields.toJson();
    // }
    data['has_media'] = this.hasMedia;
    if (this.pivot != null) {
      data['pivot'] = this.pivot.toJson();
    }
    if (this.media != null) {
      data['media'] = this.media.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomFields {
  Bio bio;
  Bio address;

  CustomFields({this.bio, this.address});

  CustomFields.fromJson(Map<String, dynamic> json) {
    bio = json['bio'] != null ? new Bio.fromJson(json['bio']) : null;
    address = json['address'] != null ? new Bio.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bio != null) {
      data['bio'] = this.bio.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    return data;
  }
}

class Bio extends Model {
  String value;
  String view;
  String name;

  Bio({this.value, this.view, this.name});

  Bio.fromJson(Map<String, dynamic> json) {
    value = stringFromJson(json, 'value');
    view = stringFromJson(json, 'view');
    name = stringFromJson(json, 'name');
    ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['view'] = this.view;
    data['name'] = this.name;
    return data;
  }
}

class Media extends Model {
  String id;
  String modelType;
  String modelId;
  String collectionName;
  String name;
  String fileName;
  String mimeType;
  String disk;
  String size;
  CustomProperties customProperties;
  String url;
  String thumb;
  String icon;
  String formatedSize;

  Media({this.id, this.modelType, this.modelId, this.collectionName, this.name, this.fileName, this.mimeType, this.disk, this.size, this.customProperties, this.url, this.thumb, this.icon, this.formatedSize});

  Media.fromJson(Map<String, dynamic> json) {
    id = stringFromJson(json, 'id');
    modelType = stringFromJson(json, 'model_type');
    modelId = stringFromJson(json, 'model_id');
    collectionName = stringFromJson(json, 'collection_name');
    name = stringFromJson(json, 'name');
    fileName = stringFromJson(json, 'file_name');
    mimeType = stringFromJson(json, 'mime_type');
    disk = stringFromJson(json, 'disk');
    size = stringFromJson(json, 'size');
    customProperties = json['custom_properties'] != null ? new CustomProperties.fromJson(json['custom_properties']) : null;
    url = stringFromJson(json, 'url');
    thumb = stringFromJson(json, 'thumb');
    icon = stringFromJson(json, 'icon');
    formatedSize = stringFromJson(json, 'formated_size');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['model_type'] = this.modelType;
    data['model_id'] = this.modelId;
    data['collection_name'] = this.collectionName;
    data['name'] = this.name;
    data['file_name'] = this.fileName;
    data['mime_type'] = this.mimeType;
    data['disk'] = this.disk;
    data['size'] = this.size;

    if (this.customProperties != null) {
      data['custom_properties'] = this.customProperties.toJson();
    }
    data['url'] = this.url;
    data['thumb'] = this.thumb;
    data['icon'] = this.icon;
    data['formated_size'] = this.formatedSize;
    return data;
  }
}

class CustomProperties extends Model {
  String uuid;
  int userId;
  GeneratedConversions generatedConversions;

  CustomProperties({this.uuid, this.userId, this.generatedConversions});

  CustomProperties.fromJson(Map<String, dynamic> json) {
    uuid = stringFromJson(json, 'uuid');
    userId = intFromJson(json, 'user_id');
    generatedConversions = json['generated_conversions'] != null ? new GeneratedConversions.fromJson(json['generated_conversions']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['user_id'] = this.userId;
    if (this.generatedConversions != null) {
      data['generated_conversions'] = this.generatedConversions.toJson();
    }
    return data;
  }
}

class GeneratedConversions extends Model {
  bool thumb;
  bool icon;

  GeneratedConversions({this.thumb, this.icon});

  GeneratedConversions.fromJson(Map<String, dynamic> json) {
    thumb = boolFromJson(json, 'thumb');
    icon = boolFromJson(json, 'icon');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['thumb'] = this.thumb;
    data['icon'] = this.icon;
    return data;
  }
}

class AvailabilityHours extends Model {
  String id;
  String day;
  String startAt;
  String endAt;
  Name data;
  int eProviderId;

  // List<Null> customFields;

  AvailabilityHours({
    this.id,
    this.day,
    this.startAt,
    this.endAt,
    this.data,
    this.eProviderId,
    // this.customFields,
  });

  AvailabilityHours.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    id = stringFromJson(json, "id");
    day = stringFromJson(json, "day");
    startAt = stringFromJson(json, "start_at");
    endAt = stringFromJson(json, "end_at");
    // data = json['data'] != null ? new Name.fromJson(json['data']) : null;
    eProviderId = intFromJson(json, "e_provider_id");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['day'] = this.day;
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['e_provider_id'] = this.eProviderId;

    return data;
  }
}

// class Media {
//   int id;
//   String modelType;
//   String modelId;
//   String collectionName;
//   String name;
//   String fileName;
//   String mimeType;
//   String disk;
//   String size;
//   List<Null> manipulations;
//   String url;
//   String thumb;
//   String icon;
//   String formatedSize;
//
//   Media(
//       {this.id,
//         this.modelType,
//         this.modelId,
//         this.collectionName,
//         this.name,
//         this.fileName,
//         this.mimeType,
//         this.disk,
//         this.size,
//         this.manipulations,
//         this.url,
//         this.thumb,
//         this.icon,
//         this.formatedSize});
//
//   Media.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     modelType = json['model_type'];
//     modelId = json['model_id'];
//     collectionName = json['collection_name'];
//     name = json['name'];
//     fileName = json['file_name'];
//     mimeType = json['mime_type'];
//     disk = json['disk'];
//     size = json['size'];
//     if (json['manipulations'] != null) {
//       manipulations = new List<Null>();
//       json['manipulations'].forEach((v) {
//         manipulations.add(new Null.fromJson(v));
//       });
//     }
//     url = json['url'];
//     thumb = json['thumb'];
//     icon = json['icon'];
//     formatedSize = json['formated_size'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['model_type'] = this.modelType;
//     data['model_id'] = this.modelId;
//     data['collection_name'] = this.collectionName;
//     data['name'] = this.name;
//     data['file_name'] = this.fileName;
//     data['mime_type'] = this.mimeType;
//     data['disk'] = this.disk;
//     data['size'] = this.size;
//     if (this.manipulations != null) {
//       data['manipulations'] =
//           this.manipulations.map((v) => v.toJson()).toList();
//     }
//     data['url'] = this.url;
//     data['thumb'] = this.thumb;
//     data['icon'] = this.icon;
//     data['formated_size'] = this.formatedSize;
//     return data;
//   }
// }
