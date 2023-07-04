// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:one_crore_project/api/api_service.dart';
import 'package:one_crore_project/routing/route_const.dart';
import 'package:one_crore_project/util/utils.dart';
import 'package:one_crore_project/widgets/prefetch_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constant/color.dart';

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
  late StreamSubscription<List<PurchaseDetails>> _subscription;
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
  String purchaseID = "";

  @override
  void initState() {
    super.initState();
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () async {
      await ApiServices.addPurchaseDetails(
        errorMessage: "",
        productID: purchaseID,
        purchaseID: purchaseID,
        userId: userId,
        transactionDate: DateTime.now().toString(),
      );
    }, onError: (error) {
      // handle error here.
    });
    getInAppPurchase();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          await ApiServices.addPurchaseDetails(
            errorMessage: purchaseDetails.error?.message ?? "",
            productID: purchaseDetails.productID,
            purchaseID: purchaseDetails.purchaseID ?? "",
            userId: userId,
            transactionDate: purchaseDetails.transactionDate ?? "",
          );
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await ApiServices.addPurchaseDetails(
            errorMessage: purchaseDetails.error?.message ?? "",
            productID: purchaseDetails.productID,
            purchaseID: purchaseDetails.purchaseID ?? "",
            userId: userId,
            transactionDate: purchaseDetails.transactionDate ?? "",
          );
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  getInAppPurchase() async {
    log("isAvailable: ${await _inAppPurchase.isAvailable()}");
    userId = (await ApiServices.getUserDetails())?.id ?? 0;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Google Opinion Reward",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: const Text("How to use this service?"),
                      content:
                          Column(mainAxisSize: MainAxisSize.min, children: [
                        const Text(
                          "1. Download Google Opinion Rewards App from Play Store",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
                            onPressed: () {
                              launchUrl(
                                  Uri.parse(
                                    "https://play.google.com/store/apps/details?id=com.google.android.apps.paidtasks",
                                  ),
                                  mode:
                                      LaunchMode.externalNonBrowserApplication);
                            },
                            icon: const Icon(Icons.download),
                            label: const Text("Download")),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "2. Complete the surveys and earn Google Play Balance",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "3. Select the amount you want to redeem and pay from play balance",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "4. You will get the amount in your UPI ID within some days",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ]));
                },
              );
            },
            child: const Icon(Icons.info),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
            child: const PrefetchImage(
              imageUrl: "https://img.icons8.com/color/96/null/whatsapp--v1.png",
              width: 60,
              height: 60,
            ),
            onPressed: () {
              // show Dialog
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: const Text("We Care that's why We Build"),
                      content:
                          Column(mainAxisSize: MainAxisSize.min, children: [
                        const Text(
                          "To provide better service and support, We are making a group on WhatsApp. If you want to join the group, please click on the button below.",
                        ),
                        ElevatedButton(
                          onPressed: () {
                            launchUrl(
                                Uri.parse(
                                  "https://chat.whatsapp.com/BG8VXtKvKjyAKPN9IuKk4N",
                                ),
                                mode: LaunchMode.externalNonBrowserApplication);
                          },
                          child: const Text("Join"),
                        )
                      ]));
                },
              );
            }),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
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
                style: GoogleFonts.robotoFlex(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        GoRouter.of(context).push(RouteNames.addUPIAccount);
                      },
                      icon: const Icon(
                        Icons.account_balance,
                      ),
                      label: FutureBuilder(
                          future: ApiServices.getBankAccountDetails(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text("Add UPI Account");
                            }
                            if (snapshot.hasError) {
                              return const Text("Add UPI Account");
                            }
                            if (snapshot.hasData &&
                                snapshot.connectionState ==
                                    ConnectionState.done) {
                              return Text(
                                  "${(snapshot.data?.email?.isEmpty ?? true) ? "Add" : "Edit"} UPI Account");
                            }
                            return const Text("Add UPI Account");
                          }),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        GoRouter.of(context).push(RouteNames.transactions);
                      },
                      icon: const Icon(
                        Icons.receipt_long_rounded,
                      ),
                      label: const Text("Transactions"),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: FutureBuilder(
                    future: _inAppPurchase.queryProductDetails({
                      "10_google_opinion_rewards",
                      "25_google_opinion_rewards",
                      "35_google_opinion_rewards",
                      "50_google_opinion_rewards",
                      "70_google_opinion_rewards",
                      "100_google_opinion_rewards"
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData) {
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
                                title: Text("Redeem Pack ${item?.price}"),
                                subtitle: Text(
                                    "You get ₹${(double.parse(item!.price.substring(1)) * 70) / 100} in your UPI ID"),
                                leading: CircleAvatar(
                                  radius: 28,
                                  child: Text(
                                    item.price,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                trailing: Icon(Icons.shop_2_rounded,
                                    color: context.isDarkMode
                                        ? Colors.white
                                        : primaryColor),
                                onTap: () {
                                  purchaseID = item.id;
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
                      return const Center(child: CircularProgressIndicator());
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
