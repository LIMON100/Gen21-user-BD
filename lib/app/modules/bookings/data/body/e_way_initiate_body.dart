class EwayInitiateBody {
  Customer customer;
  ShippingAddress shippingAddress;
  Payment payment;
  String redirectUrl;
  String cancelUrl;
  String method;
  String deviceID;
  String customerIP;
  String partnerID;
  String transactionType;
  String logoUrl;
  String headerText;
  String language;
  bool customerReadOnly;
  String customView;
  bool verifyCustomerPhone;
  bool verifyCustomerEmail;

  EwayInitiateBody(
      {this.customer,
        this.shippingAddress,
        this.payment,
        this.redirectUrl,
        this.cancelUrl,
        this.method,
        this.deviceID,
        this.customerIP,
        this.partnerID,
        this.transactionType,
        this.logoUrl,
        this.headerText,
        this.language,
        this.customerReadOnly,
        this.customView,
        this.verifyCustomerPhone,
        this.verifyCustomerEmail});

  EwayInitiateBody.fromJson(Map<String, dynamic> json) {
    customer = json['Customer'] != null
        ? new Customer.fromJson(json['Customer'])
        : null;
    shippingAddress = json['ShippingAddress'] != null
        ? new ShippingAddress.fromJson(json['ShippingAddress'])
        : null;
    payment =
    json['Payment'] != null ? new Payment.fromJson(json['Payment']) : null;
    redirectUrl = json['RedirectUrl'];
    cancelUrl = json['CancelUrl'];
    method = json['Method'];
    deviceID = json['DeviceID'];
    customerIP = json['CustomerIP'];
    partnerID = json['PartnerID'];
    transactionType = json['TransactionType'];
    logoUrl = json['LogoUrl'];
    headerText = json['HeaderText'];
    language = json['Language'];
    customerReadOnly = json['CustomerReadOnly'];
    customView = json['CustomView'];
    verifyCustomerPhone = json['VerifyCustomerPhone'];
    verifyCustomerEmail = json['VerifyCustomerEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customer != null) {
      data['Customer'] = this.customer.toJson();
    }
    if (this.shippingAddress != null) {
      data['ShippingAddress'] = this.shippingAddress.toJson();
    }
    if (this.payment != null) {
      data['Payment'] = this.payment.toJson();
    }
    data['RedirectUrl'] = this.redirectUrl;
    data['CancelUrl'] = this.cancelUrl;
    data['Method'] = this.method;
    data['DeviceID'] = this.deviceID;
    data['CustomerIP'] = this.customerIP;
    data['PartnerID'] = this.partnerID;
    data['TransactionType'] = this.transactionType;
    data['LogoUrl'] = this.logoUrl;
    data['HeaderText'] = this.headerText;
    data['Language'] = this.language;
    data['CustomerReadOnly'] = this.customerReadOnly;
    data['CustomView'] = this.customView;
    data['VerifyCustomerPhone'] = this.verifyCustomerPhone;
    data['VerifyCustomerEmail'] = this.verifyCustomerEmail;
    return data;
  }
}

class Customer {
  String reference;
  String title;
  String firstName;
  String lastName;
  String companyName;
  String jobDescription;
  String street1;
  String street2;
  String city;
  String state;
  String postalCode;
  String country;
  String mobile;
  String phone;
  String email;

  Customer(
      {this.reference,
        this.title,
        this.firstName,
        this.lastName,
        this.companyName,
        this.jobDescription,
        this.street1,
        this.street2,
        this.city,
        this.state,
        this.postalCode,
        this.country,
        this.mobile,
        this.phone,
        this.email});

  Customer.fromJson(Map<String, dynamic> json) {
    reference = json['Reference'];
    title = json['Title'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    companyName = json['CompanyName'];
    jobDescription = json['JobDescription'];
    street1 = json['Street1'];
    street2 = json['Street2'];
    city = json['City'];
    state = json['State'];
    postalCode = json['PostalCode'];
    country = json['Country'];
    mobile = json['Mobile'];
    phone = json['phone'];
    email = json['Email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Reference'] = this.reference;
    data['Title'] = this.title;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['CompanyName'] = this.companyName;
    data['JobDescription'] = this.jobDescription;
    data['Street1'] = this.street1;
    data['Street2'] = this.street2;
    data['City'] = this.city;
    data['State'] = this.state;
    data['PostalCode'] = this.postalCode;
    data['Country'] = this.country;
    data['Mobile'] = this.mobile;
    data['phone'] = this.phone;
    data['Email'] = this.email;
    return data;
  }
}

class ShippingAddress {
  String shippingMethod;
  String firstName;
  String lastName;
  String street1;
  String street2;
  String city;
  String state;
  String country;
  String postalCode;
  String phone;

  ShippingAddress(
      {this.shippingMethod,
        this.firstName,
        this.lastName,
        this.street1,
        this.street2,
        this.city,
        this.state,
        this.country,
        this.postalCode,
        this.phone});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    shippingMethod = json['ShippingMethod'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    street1 = json['Street1'];
    street2 = json['Street2'];
    city = json['City'];
    state = json['State'];
    country = json['Country'];
    postalCode = json['PostalCode'];
    phone = json['Phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ShippingMethod'] = this.shippingMethod;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['Street1'] = this.street1;
    data['Street2'] = this.street2;
    data['City'] = this.city;
    data['State'] = this.state;
    data['Country'] = this.country;
    data['PostalCode'] = this.postalCode;
    data['Phone'] = this.phone;
    return data;
  }
}

class Payment {
  double totalAmount;
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
