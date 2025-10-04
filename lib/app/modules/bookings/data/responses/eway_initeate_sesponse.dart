class EwayInitiateResponse {
  String sharedPaymentUrl;
  String accessCode;
  Payment payment;
  String formActionURL;
  String completeCheckoutURL;
  String errors;

  EwayInitiateResponse(
      {this.sharedPaymentUrl,
        this.accessCode,
        this.payment,
        this.formActionURL,
        this.completeCheckoutURL,
        this.errors});

  EwayInitiateResponse.fromJson(Map<String, dynamic> json) {
    sharedPaymentUrl = json['SharedPaymentUrl'];
    accessCode = json['AccessCode'];
    payment =
    json['Payment'] != null ? new Payment.fromJson(json['Payment']) : null;
    formActionURL = json['FormActionURL'];
    completeCheckoutURL = json['CompleteCheckoutURL'];
    errors = json['Errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SharedPaymentUrl'] = this.sharedPaymentUrl;
    data['AccessCode'] = this.accessCode;
    if (this.payment != null) {
      data['Payment'] = this.payment.toJson();
    }
    data['FormActionURL'] = this.formActionURL;
    data['CompleteCheckoutURL'] = this.completeCheckoutURL;
    data['Errors'] = this.errors;
    return data;
  }
}

class Payment {
  int totalAmount;
  String invoiceNumber;
  String invoiceDescription;
  String invoiceReference;
  String currencyCode;

  Payment(
      {this.totalAmount,
        this.invoiceNumber,
        this.invoiceDescription,
        this.invoiceReference,
        this.currencyCode});

  Payment.fromJson(Map<String, dynamic> json) {
    totalAmount = json['TotalAmount'];
    invoiceNumber = json['InvoiceNumber'];
    invoiceDescription = json['InvoiceDescription'];
    invoiceReference = json['InvoiceReference'];
    currencyCode = json['CurrencyCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TotalAmount'] = this.totalAmount;
    data['InvoiceNumber'] = this.invoiceNumber;
    data['InvoiceDescription'] = this.invoiceDescription;
    data['InvoiceReference'] = this.invoiceReference;
    data['CurrencyCode'] = this.currencyCode;
    return data;
  }
}
