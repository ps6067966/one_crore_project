import 'dart:developer';

import 'package:bottom_bar_matu/utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:one_crore_project/api/api_service.dart';
import 'package:one_crore_project/constant/color.dart';

import '../../../widgets/custom_circular_indicator.dart';

class OpinionRewardTransactions extends StatelessWidget {
  const OpinionRewardTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transactions")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FutureBuilder(
                future: ApiServices.getTransactions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CustomCircularIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("No Transactions"),
                    );
                  }
                  if (snapshot.data?.isEmpty ?? true) {
                    return const Center(
                      child: Text("No Transactions"),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data?.toSet().toList().length ?? 0,
                    itemBuilder: (context, index) {
                      final transaction =
                          snapshot.data?.toSet().toList()[index];
                      log(transaction.toString());
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListTile(
                          tileColor: primaryBlackColor,
                          title: Text(
                            transaction?.productId ?? "",
                            style: const TextStyle(color: Colors.white),
                          ),
                          isThreeLine: true,
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transaction?.purchaseId ?? "",
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                Timestamp.fromMillisecondsSinceEpoch(
                                        transaction?.transactionDate.toInt() ??
                                            0)
                                    .toDate()
                                    .toString(),
                                style: const TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
