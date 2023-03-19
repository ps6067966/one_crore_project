import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:one_crore_project/api/api_service.dart';

class OpinionRewardTransactions extends StatefulWidget {
  const OpinionRewardTransactions({super.key});

  @override
  State<OpinionRewardTransactions> createState() =>
      _OpinionRewardTransactionsState();
}

class _OpinionRewardTransactionsState extends State<OpinionRewardTransactions> {
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
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
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
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final transaction = snapshot.data?[index];
                      log(transaction.toString());
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListTile(
                          tileColor: Colors.black,
                          title: Text(transaction?.productId ?? ""),
                          subtitle: Text(transaction?.purchaseId ?? ""),
                          trailing: Text(transaction?.transactionDate ?? ""),
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
