class TransactionModel {
  int? id;
  int? userId;
  String? emailId;
  String? productId;
  String? purchaseId;
  String? errorMessage;
  String? transactionDate;

  TransactionModel(
      {this.id,
      this.userId,
      this.emailId,
      this.productId,
      this.purchaseId,
      this.errorMessage,
      this.transactionDate});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    emailId = json['email_id'];
    productId = json['product_id'];
    purchaseId = json['purchase_id'];
    errorMessage = json['error_message'];
    transactionDate = json['transaction_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['email_id'] = emailId;
    data['product_id'] = productId;
    data['purchase_id'] = purchaseId;
    data['error_message'] = errorMessage;
    data['transaction_date'] = transactionDate;
    return data;
  }
}
