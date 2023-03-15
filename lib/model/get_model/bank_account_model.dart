class BankAccountDetailsModel {
  int? id;
  int? userId;
  String? fullName;
  String? email;
  String? upiId;
  String? paytmNumber;

  BankAccountDetailsModel({
    this.id,
    this.userId,
    this.fullName,
    this.email,
    this.upiId,
    this.paytmNumber,
  });

  BankAccountDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    userId = json['user_id'] as int?;
    fullName = json['full_name'] as String?;
    email = json['email'] as String?;
    upiId = json['upi_id'] as String?;
    paytmNumber = json['paytm_number'] as String?;
  }
}
