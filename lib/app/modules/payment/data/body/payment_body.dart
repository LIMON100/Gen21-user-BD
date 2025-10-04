class PaymentBody {
  String amount;
  String description;
  String userId;
  String paymentMethodId;
  String paymentStatusId;
  String bookingId;

  PaymentBody(
      {this.amount,
        this.description,
        this.userId,
        this.paymentMethodId,
        this.paymentStatusId, this.bookingId});

  PaymentBody.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    description = json['description'];
    userId = json['user_id'];
    paymentMethodId = json['payment_method_id'];
    paymentStatusId = json['payment_status_id'];
    bookingId = json['booking_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['description'] = this.description;
    data['user_id'] = this.userId;
    data['payment_method_id'] = this.paymentMethodId;
    data['payment_status_id'] = this.paymentStatusId;
    data['booking_id'] = this.bookingId;
    return data;
  }
}
