import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:one_crore_project/api/api_service.dart';
import 'package:one_crore_project/model/get_model/bank_account_model.dart';
import 'package:one_crore_project/routing/route_const.dart';

class GoogleOpinionReward {
  final String amount;
  final String amountThatUserGet;
  GoogleOpinionReward({
    required this.amount,
    required this.amountThatUserGet,
  });
}

class GoogleOpinionRewardScreen extends ConsumerStatefulWidget {
  const GoogleOpinionRewardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GoogleOpinionRewardScreenState();
}

class _GoogleOpinionRewardScreenState
    extends ConsumerState<GoogleOpinionRewardScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  List<GoogleOpinionReward> opinionRewards = [
    GoogleOpinionReward(amount: "50", amountThatUserGet: "32.5"),
    GoogleOpinionReward(amount: "95", amountThatUserGet: "61.75"),
    GoogleOpinionReward(amount: "100", amountThatUserGet: "65"),
    GoogleOpinionReward(amount: "110", amountThatUserGet: "71.5"),
    GoogleOpinionReward(amount: "125", amountThatUserGet: "81.25"),
    GoogleOpinionReward(amount: "154", amountThatUserGet: "100"),
    GoogleOpinionReward(amount: "185", amountThatUserGet: "120.25"),
    GoogleOpinionReward(amount: "200", amountThatUserGet: "130"),
    GoogleOpinionReward(amount: "308", amountThatUserGet: "200"),
    GoogleOpinionReward(amount: "500", amountThatUserGet: "325"),
    GoogleOpinionReward(amount: "1000", amountThatUserGet: "650"),
    GoogleOpinionReward(amount: "2000", amountThatUserGet: "1300"),
    GoogleOpinionReward(amount: "3077", amountThatUserGet: "2000"),
    GoogleOpinionReward(amount: "5000", amountThatUserGet: "3250"),
  ];

  BankAccountDetailsModel? bankAccountDetailsModel;

  @override
  void initState() {
    super.initState();
    getInAppPurchase();
    getBankAccountDetails();
  }

  getInAppPurchase() async {
    log("isAvailable: ${await _inAppPurchase.isAvailable()}");
    _inAppPurchase.purchaseStream.listen((event) {
      log("event: $event");
    });
    final data = await _inAppPurchase.queryProductDetails({""}).then((value) {
      log("value: $value");
    });
    log("data: $data");
  }

  getBankAccountDetails() async {
    final bankAccountDetailsModel = await ApiServices.getBankAccountDetails();
    if (bankAccountDetailsModel != null) {
      if (mounted) {
        setState(() {
          this.bankAccountDetailsModel = bankAccountDetailsModel;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Opinion Reward"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                color: Colors.amber,
                width: double.infinity,
                height: 25,
                child: Center(
                  child: Text(
                    "This service in under development",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Redeem Your Play Rewards directly to your UPI ID",
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoFlex(
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Notice: This service can be used to convert your Google Play Balance to your UPI ID. It usually takes 1-2 days to process your request.",
                textAlign: TextAlign.start,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  GoRouter.of(context).push(RouteNames.addUPIAccount);
                },
                icon: const Icon(
                  Icons.account_balance,
                ),
                label: Text(
                    "${bankAccountDetailsModel?.email?.isEmpty ?? true ? "Add" : "Edit"} UPI Account"),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: opinionRewards.length,
                    itemBuilder: (context, index) {
                      final item = opinionRewards[index];
                      return ListTile(
                        title: Text("Redeem Pack ₹${item.amount}"),
                        subtitle: Text(
                            "You get ₹${item.amountThatUserGet} in your UPI ID"),
                        leading: CircleAvatar(
                          radius: 28,
                          child: Text("₹${item.amount}"),
                        ),
                        trailing: const Icon(Icons.shop_2_rounded,
                            color: Colors.white),
                        onTap: () {
                          PurchaseParam purchaseParam = PurchaseParam(
                              productDetails: ProductDetails(
                            id: "${item.amount} Google Opinion Rewards",
                            title: "Google Opinion Rewards",
                            description: "Google Opinion Rewards",
                            price: item.amount,
                            rawPrice: double.parse(item.amount),
                            currencyCode: "INR",
                          ));
                          _inAppPurchase.buyNonConsumable(
                              purchaseParam: purchaseParam);
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
