import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_crore_project/api/api_service.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../model/get_model/bank_account_model.dart';

class AddUPIAccountScreen extends ConsumerStatefulWidget {
  const AddUPIAccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddUPIAccountScreenState();
}

class _AddUPIAccountScreenState extends ConsumerState<AddUPIAccountScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();
  final TextEditingController _paytmNumberController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  BankAccountDetailsModel? bankAccountDetailsModel;

  @override
  void initState() {
    super.initState();
    _nameController.text = _auth.currentUser!.displayName ?? "";
    _emailController.text = _auth.currentUser!.email ?? "";
    getBankAccountDetails();
  }

  getBankAccountDetails() async {
    final bankAccountDetailsModel = await ApiServices.getBankAccountDetails();
    if (bankAccountDetailsModel != null) {
      if (mounted) {
        setState(() {
          this.bankAccountDetailsModel = bankAccountDetailsModel;
          _nameController.text = bankAccountDetailsModel.fullName ?? "";
          _upiIdController.text = bankAccountDetailsModel.upiId ?? "";
          _paytmNumberController.text =
              bankAccountDetailsModel.paytmNumber ?? "";
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _upiIdController.dispose();
    _paytmNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${bankAccountDetailsModel?.email?.isEmpty ?? true ? "Add" : "Edit"} UPI Account",),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(200, 50),
          ),
          onPressed: () async {
            bool result = false;
            if (bankAccountDetailsModel?.email?.isEmpty ?? true) {
              result = await ApiServices.addUpiAccountDetails(
                fullName: _nameController.text,
                upiId: _upiIdController.text,
                paytmNumber: _paytmNumberController.text,
              );
            } else {
              result = await ApiServices.editAccountDetails(
                fullName: _nameController.text,
                upiId: _upiIdController.text,
                paytmNumber: _paytmNumberController.text,
              );
            }
            if (result) {
              if (mounted) {
                showTopSnackBar(
                  Overlay.of(context),
                  const CustomSnackBar.success(
                    message: "Your Account Details Saved Successfully",
                  ),
                );

                GoRouter.of(context).pop();
              }
            }
          },
          child: const Text(
            "Save",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ],
      persistentFooterAlignment: AlignmentDirectional.center,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Please fill Account Details",
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    prefixIcon: Icon(Icons.person_2_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  enabled: false,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email ID",
                    prefixIcon: Icon(Icons.email_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _upiIdController,
                  decoration: const InputDecoration(
                    labelText: "UPI ID",
                    prefixIcon: Icon(Icons.account_balance_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _paytmNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Paytm Number (Optional)",
                    prefixIcon: Icon(Icons.phone_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
