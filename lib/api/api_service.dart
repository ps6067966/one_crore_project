import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:one_crore_project/model/get_model/transaction_model.dart';

import '../model/get_model/bank_account_model.dart';

final bankCollection = FirebaseFirestore.instance.collection('bank');
final transactionCollection =
    FirebaseFirestore.instance.collection('transaction');

class ApiServices {
  static Future<bool> addUpiAccountDetails({
    required String fullName,
    required String upiId,
    required String paytmNumber,
  }) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      await bankCollection.doc().set({
        "full_name": fullName,
        "paytm_number": paytmNumber,
        "upi_id": upiId,
        "email": auth.currentUser?.email ?? "",
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      log("$e");
    }
    return false;
  }

  static Future<BankAccountDetailsModel?> getBankAccountDetails() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final data = await bankCollection
          .where('email', isEqualTo: auth.currentUser?.email)
          .get();
      return BankAccountDetailsModel.fromJson(data.docs.first.data());
    } catch (e) {
      log("$e");
    }
    return null;
  }

  static Future<bool> editAccountDetails({
    required String fullName,
    required String upiId,
    required String paytmNumber,
  }) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      bankCollection
          .where('email', isEqualTo: auth.currentUser?.email)
          .get()
          .then((value) {
        for (var element in value.docs) {
          element.reference.update({
            "full_name": fullName,
            "paytm_number": paytmNumber,
            "upi_id": upiId,
            "email": auth.currentUser?.email ?? ""
          });
        }
      });
      return true;
    } catch (e) {
      log("$e");
    }
    return false;
  }

  static Future<bool> addPurchaseDetails({
    required String errorMessage,
    required String productID,
    required String purchaseID,
    required String transactionDate,
  }) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      await transactionCollection.doc().set({
        "email": auth.currentUser?.email,
        "error_message": errorMessage,
        "product_id": productID,
        "purchase_id": purchaseID,
        "transaction_date": transactionDate,
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      log("$e");
    }
    return false;
  }

  static Future<List<TransactionModel>> getTransactions() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final data = await transactionCollection
          .where('email', isEqualTo: auth.currentUser?.email)
          .get();
      return List<TransactionModel>.from(
          data.docs.map((x) => TransactionModel.fromJson(x.data())));
    } catch (e) {
      log("$e");
    }
    return [];
  }

  // Chat Push Notification

  static Future<void> sendChatNotification({
    String? deviceToken,
    String? senderName,
  }) async {
    const postUrl = 'https://fcm.googleapis.com/fcm/send';

    final data = {
      "notification": {
        "body": "You have new message from $senderName",
        "title": "Message",
        "sound": 'customsound',
        'android_channel_id': 'one_crore_project'
        // "default_sound": false
      },
      'android': {
        'notification': {
          'channel_id': 'secondlife',
          "sound": 'customsound',
          // "default_sound": false
        },
      },
      "priority": "high",
      "data": {
        "name": senderName,
        "to_user_id": '',
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "sound": 'customsound',
      },
      "to": deviceToken
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAdfVpt30:APA91bE3n-Mld1LMCB3CQRlWGjEQDtMENaDoUWf0jBwIUBVoGVF6geIw-GEZd5D6iVYVSjHtDLiwkg6eNBVeKV3yXbkg4HZczFEvmBCtYbn8d4ou37X4Y35owv4LBXlr58gHuuReosW1'
    };
    var url = Uri.parse(postUrl);

    final response = await http.post(url,
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      log("sent notification with data: ${response.body}");
      log("true");
    } else {
      log("failed notification with data: ${response.body}");

      log("false");
    }
  }
}
