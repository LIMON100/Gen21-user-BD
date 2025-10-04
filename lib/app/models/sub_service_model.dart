import 'parents/model.dart';

class SubService {
  bool success;
  Data data;
  String message;


  SubService({this.success, this.data, this.message});

  SubService.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String subtypeHeading;
  Description description;
  List<ESubService> eSubService;
  Name name;
  List<Media> media;

  Data({this.subtypeHeading, this.description, this.eSubService});

  Data.fromJson(Map<String, dynamic> json) {
    subtypeHeading = json['subtype_heading'];
    name = Name.fromJson( json['name']);
    description = json['description'] != null
        ? new Description.fromJson(json['description'])
        : null;
    if (json['options'] != null) {
      eSubService = <ESubService>[];
      json['options'].forEach((v) {
        eSubService.add(new ESubService.fromJson(v));
      });
    }

    print("dfmkasfsd ${json['media']}");
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media.add(new Media.fromJson(v));
      });
    }
    print("sdnfjsdna Data processing done");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subtype_heading'] = this.subtypeHeading;
    data['name'] = this.name.toJson();

    if (this.description != null) {
      data['description'] = this.description.toJson();
    }
    if (this.eSubService != null) {
      data['options'] = this.eSubService.map((v) => v.toJson()).toList();
    }
    if (this.media != null) {
      data['media'] = this.media.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Description {
  String en;

  Description({this.en});

  Description.fromJson(Map<String, dynamic> json) {
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    return data;
  }
}

class ESubService extends Model{
  String id;
  int eServiceId;
  double price;
  // String priceUnit;
  int minimumUnit;
  Name title;
  Name description;
  // Null createdAt;
  // Null updatedAt;

  ESubService(
      {
        this.id,
        this.eServiceId,
        this.price,
        // this.priceUnit,
        this.minimumUnit,
        this.title,
        this.description,
        // this.createdAt,
        // this.updatedAt
  });

  ESubService.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    id = stringFromJson(json, "id");
    eServiceId = json['e_service_id'];
    // price = json['price'];
    price = doubleFromJson(json, "price");
    // priceUnit = json['price_unit'];
    // minimumUnit = json['minimum_unit'];
    minimumUnit = intFromJson(json, "minimumUnit");

    title = Name.fromJson(json['name']);
    description = Name.fromJson(json['description']);

    // description = json['description'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
    print("sdnfjsdna Data processing done");

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['e_service_id'] = this.eServiceId;
    data['price'] = this.price;
    // data['price_unit'] = this.priceUnit;
    data['minimum_unit'] = this.minimumUnit;
    data['title'] = this.title;
    data['description'] = this.description;
    // data['created_at'] = this.createdAt;
    // data['updated_at'] = this.updatedAt;
    return data;
  }

}

class Name {
  String en;

  Name({this.en});

  Name.fromJson(Map<String, dynamic> json) {
    print("Name.fromJson ${json.toString()}}");
    en = json['en']?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    return data;
  }
}

class Media extends Model{
  String id;
  String modelType;
  int modelId;
  String collectionName;
  String name;
  String fileName;
  String mimeType;
  String disk;
  int size;
  List<Null> manipulations;
  // CustomProperties customProperties;
  String url;
  String thumb;
  String icon;
  String formatedSize;

  Media(
      {this.id,
        this.modelType,
        this.modelId,
        this.collectionName,
        this.name,
        this.fileName,
        this.mimeType,
        this.disk,
        this.size,
        this.manipulations,
        // this.customProperties,
        this.url,
        this.thumb,
        this.icon,
        this.formatedSize});

  Media.fromJson(Map<String, dynamic> json) {
    id = stringFromJson(json, 'id');
    modelType = json['model_type'];
    modelId = intFromJson(json, 'id');
    collectionName = json['collection_name'];
    name = json['name'];
    fileName = json['file_name'];
    mimeType = json['mime_type'];
    disk = json['disk'];
    size = intFromJson(json, 'size');
    url = json['url'];
    thumb = json['thumb'];
    icon = json['icon'];
    formatedSize = json['formated_size'];
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
    // if (this.manipulations != null) {
    //   data['manipulations'] =
    //       this.manipulations.map((v) => v.toJson()).toList();
    // }
    // if (this.customProperties != null) {
    //   data['custom_properties'] = this.customProperties!.toJson();
    // }
    data['url'] = this.url;
    data['thumb'] = this.thumb;
    data['icon'] = this.icon;
    data['formated_size'] = this.formatedSize;
    return data;
  }

}