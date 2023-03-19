import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:one_crore_project/api/api_service.dart';
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
  int userId = 0;
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

  @override
  void initState() {
    super.initState();

    getInAppPurchase();
  }

  getInAppPurchase() async {
    log("isAvailable: ${await _inAppPurchase.isAvailable()}");
    userId = (await ApiServices.getUserDetails())?.id ?? 0;
    _inAppPurchase.purchaseStream.listen((event) {
      log("event: $event");
      // ignore: avoid_function_literals_in_foreach_calls
      event.forEach((element) async {
        await ApiServices.addPurchaseDetails(
          errorMessage: element.error?.message ?? "",
          productID: element.productID,
          purchaseID: element.purchaseID ?? "",
          userId: userId,
          transactionDate: element.transactionDate ?? "",
        );
      });
    });
    setState(() {});
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
                height: 70,
                child: Center(
                  child: Text(
                    "This service in under development\nDon't use it for now.",
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
                label: FutureBuilder(
                    future: ApiServices.getBankAccountDetails(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Add UPI Account");
                      }
                      if (snapshot.hasError) {
                        return const Text("Add UPI Account");
                      }
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        return Text(
                            "${(snapshot.data?.email?.isEmpty ?? true) ? "Add" : "Edit"} UPI Account");
                      }
                      return const Text("Add UPI Account");
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: FutureBuilder(
                    future: _inAppPurchase
                        .queryProductDetails({"50_google_opinion_rewards"}),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                            itemCount: snapshot.data?.productDetails.length,
                            itemBuilder: (context, index) {
                              final item = snapshot.data?.productDetails[index];
                              return ListTile(
                                title: Text("Redeem Pack ₹${item?.price}"),
                                subtitle: Text(
                                    "You get ₹${(double.parse(item!.price.substring(1)) * 70) / 100} in your UPI ID"),
                                leading: CircleAvatar(
                                  radius: 28,
                                  child: Text(
                                    item.price,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                trailing: const Icon(Icons.shop_2_rounded,
                                    color: Colors.white),
                                onTap: () {
                                  PurchaseParam purchaseParam = PurchaseParam(
                                      productDetails: ProductDetails(
                                    id: "${item.price.split(".")[0].substring(1)}_google_opinion_rewards",
                                    title: "Google Opinion Rewards",
                                    description: "Google Opinion Rewards",
                                    price: item.price,
                                    rawPrice: double.parse(item.price.substring(
                                      1,
                                    )),
                                    currencyCode: "INR",
                                  ));
                                  _inAppPurchase.buyConsumable(
                                      purchaseParam: purchaseParam);
                                },
                              );
                            });
                      }
                      return const SizedBox();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
