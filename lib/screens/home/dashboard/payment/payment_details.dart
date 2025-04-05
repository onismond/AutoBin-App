import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:autobin/data/services/api_controller.dart';
import 'package:autobin/utils/constants.dart';
import 'package:autobin/data/models/pickup_model.dart';
import 'package:autobin/widgets/pickup_card.dart';
import 'package:autobin/screens/home/dashboard/payment/web_payment.dart';

class PaymentDetails extends StatefulWidget {
  final String amount;
  const PaymentDetails({super.key, required this.amount});

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  var amount = "";

  @override
  void initState() {
    amount = widget.amount;
    super.initState();
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  void navigateToWebPayment() async{
    await APIController().payNow().then(
      (Response<dynamic> response) async{
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebPayment(data: response.data['data'])
            )
        );
      },
      onError: (e) {
        EasyLoading.showError(
          APIController.errorMessage(e, context).toString(),
          duration: Duration(hours: 1),
          maskType: EasyLoadingMaskType.black,
          dismissOnTap: true,
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickups'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 400.0),
                child: Row(
                  children: [
                    Text(
                      "Amount Due:",
                      style: TextStyle(
                        fontSize: 20
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text(
                      "GHS $amount",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () { navigateToWebPayment(); },
                style: ElevatedButton.styleFrom(
                    backgroundColor: bColor1,
                    foregroundColor: Colors.deepPurple
                ),
                child: Text("Proceed to Payment")
              )
            ],
          ),
        )
      ),
    );
  }
}
