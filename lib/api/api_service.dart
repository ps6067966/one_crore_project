import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:one_crore_project/model/post_model/user_post_model.dart';

import '../model/get_model/bank_account_model.dart';

class ApiServices {
  static Dio dio = Dio();
  static Future<bool> addUpiAccountDetails({
    required String fullName,
    required String upiId,
    required String paytmNumber,
    required int userId,
  }) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final response = await dio.post('https://onecrore.deno.dev/banks', data: {
        "email": auth.currentUser?.email,
        "full_name": fullName,
        "paytm_number": paytmNumber,
        "upi_id": upiId,
        "user_id": userId,
      });
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      log("$e");
    }
    return false;
  }

  // static Future<bool> editAccountDetails({
  //   required String fullName,
  //   required String upiId,
  //   required String paytmNumber,
  //   required int userId,
  // }) async {
  //   try {
  //     final FirebaseAuth auth = FirebaseAuth.instance;
  //     final response =
  //         await dio.put('https://onecrore.deno.dev/banks/2', data: {
  //       "email": auth.currentUser?.email,
  //       "full_name": fullName,
  //       "paytm_number": paytmNumber,
  //       "upi_id": upiId,
  //       "user_id": userId,
  //     });
  //     if (response.statusCode == 200) {
  //       return true;
  //     }
  //   } catch (e) {
  //     log("$e");
  //   }
  //   return false;
  // }

  static Future<UserModel?> getUserDetails() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final response = await dio.get(
        'https://onecrore.deno.dev/users/${auth.currentUser?.email}',
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }
    } catch (e) {
      log("$e");
    }
    return null;
  }

  static Future<BankAccountDetailsModel?> getBankAccountDetails() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final response = await dio.get(
        'https://onecrore.deno.dev/banks/${auth.currentUser?.email}',
      );
      if (response.statusCode == 200) {
        return BankAccountDetailsModel.fromJson(response.data);
      }
    } catch (e) {
      log("$e");
    }
    return null;
  }

  static Future<bool> editAccountDetails({
    required String fullName,
    required String upiId,
    required String paytmNumber,
    required int userId,
  }) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final response =
          await dio.put('https://onecrore.deno.dev/banks/2', data: {
        "email": auth.currentUser?.email,
        "full_name": fullName,
        "paytm_number": paytmNumber,
        "upi_id": upiId,
        "user_id": userId,
      });
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      log("$e");
    }
    return false;
  }

  static Future<bool> addPurchaseDetails({
    required String errorMessage,
    required String productID,
    required String purchaseID,
    required int userId,
    required String transactionDate,
  }) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final response =
          await dio.put('https://onecrore.deno.dev/transactions', data: {
        "email": auth.currentUser?.email,
        "error_message": errorMessage,
        "product_id": productID,
        "purchase_id": purchaseID,
        "user_id": userId,
        "transaction_date": transactionDate,
      });
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      log("$e");
    }
    return false;
  }
}
