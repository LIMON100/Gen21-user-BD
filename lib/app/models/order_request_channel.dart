// class OrderRequestChannel {
//   String message;
//   String channelName;
//   List<EventData> eventData;
//
//   OrderRequestChannel({this.message, this.channelName, this.eventData});
//
//   OrderRequestChannel.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     channelName = json['channel_name'];
//     if (json['eventData'] != null) {
//       eventData = <EventData>[];
//       json['eventData'].forEach((v) {
//         eventData.add(new EventData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['message'] = this.message;
//     data['channel_name'] = this.channelName;
//     if (this.eventData != null) {
//       data['eventData'] = this.eventData.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class EventData {
//   String serviceType;
//   int userId;
//   int eServiceId;
//   int orderId;
//   String status;
//   String updatedAt;
//   String createdAt;
//   int id;
//
//   EventData(
//       {this.serviceType,
//         this.userId,
//         this.eServiceId,
//         this.orderId,
//         this.status,
//         this.updatedAt,
//         this.createdAt,
//         this.id});
//
//   EventData.fromJson(Map<String, dynamic> json) {
//     serviceType = json['service_type'];
//     userId = json['user_id'];
//     eServiceId = json['e_service_id'];
//     orderId = json['order_id'];
//     status = json['status'];
//     updatedAt = json['updated_at'];
//     createdAt = json['created_at'];
//     id = json['id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['service_type'] = this.serviceType;
//     data['user_id'] = this.userId;
//     data['e_service_id'] = this.eServiceId;
//     data['order_id'] = this.orderId;
//     data['status'] = this.status;
//     data['updated_at'] = this.updatedAt;
//     data['created_at'] = this.createdAt;
//     data['id'] = this.id;
//     return data;
//   }
// }