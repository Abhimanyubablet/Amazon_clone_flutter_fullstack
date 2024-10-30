import 'package:amazon_flutter_tutorial/features/address/services/address_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/custom_textfield.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../providers/user_provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;

  const AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();

  String addressToBeUsed = "";
  final AddressServices addressServices = AddressServices();

  @override
  void dispose() {
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
    super.dispose();
  }

  void Buy(Map<String, dynamic> paymentResult) {
    if (paymentResult['status'] == 'success') {
      if (Provider.of<UserProvider>(context, listen: false).user.address.isEmpty) {
        addressServices.saveUserAddress(
          context: context,
          address: addressToBeUsed,
        );
      }

      addressServices.placeOrder(
        context: context,
        address: addressToBeUsed,
        totalSum: double.parse(widget.totalAmount),
      );
    } else {
      showSnackBar(context, "Payment failed. Please try again.");
    }
  }

  void payPressed(String addressFromProvider, String username) {
    addressToBeUsed = "";

    bool isFormFilled = flatBuildingController.text.isNotEmpty &&
        areaController.text.isNotEmpty &&
        pincodeController.text.isNotEmpty &&
        cityController.text.isNotEmpty;

    if (isFormFilled) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
        '${flatBuildingController.text}, ${areaController.text}, ${cityController.text} - ${pincodeController.text}';
      } else {
        showSnackBar(context, 'Please fill all the fields correctly!');
        return;
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackBar(context, 'Please enter a valid address!');
      return;
    }

    _showPaymentConfirmationDialog(username, addressToBeUsed);
  }

  void _showPaymentConfirmationDialog(String username, String address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Order Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Username: $username'),
              const SizedBox(height: 8),
              Text('Address: $address'),
              const SizedBox(height: 8),
              Text('Total Amount: \$${widget.totalAmount}'),
              const SizedBox(height: 10),
              const Text('Do you want to proceed with the order?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Map<String, dynamic> paymentResult = {"status": "success"};
                Buy(paymentResult);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (user.address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          user.address,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('OR', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 20),
                  ],
                ),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: flatBuildingController,
                      hintText: 'Flat, House no, Building',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: areaController,
                      hintText: 'Area, Street',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: pincodeController,
                      hintText: 'Pincode',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: cityController,
                      hintText: 'Town/City',
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    payPressed(user.address, user.name);
                  },
                  child: const Text("Buy"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
