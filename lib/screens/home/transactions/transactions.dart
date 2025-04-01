import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:autobin/data/services/api_controller.dart';
import 'package:autobin/data/models/transaction_model.dart';
import 'package:autobin/widgets/transaction_card.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {

  RefreshController _refreshController =  RefreshController(initialRefresh: false);
  List<Transaction> _transactions = [];
  bool isLoading = true;

  @override @override
  void initState() {
    getPickups();
    super.initState();
  }

  void _onRefresh() async{
    await getPickups();
    _refreshController.refreshCompleted();
  }

  getPickups() async{
    await APIController().getTransactions().then(
            (Response<dynamic> response) async {
          List<Transaction> transactionList = [];
          List transactionData = APIController.decodeMapData(response);
          for (var transaction in transactionData) {
            transactionList.add(Transaction.fromMap(transaction));
          }
          setState(() {
            isLoading = false;
            _transactions = transactionList;
          });
        },
        onError: (e) {
          EasyLoading.showError(
            APIController.errorMessage(e, context).toString(),
            duration: Duration(hours: 1),
            maskType: EasyLoadingMaskType.black,
            dismissOnTap: true,
          );
          setState(() {
            isLoading = false;
            _transactions = [];
          });
        }
    );
  }

  Widget transactionListBuilder() {
    if (isLoading) {
      return const SizedBox(
        width: double.infinity,
        height: 400,
        child: Center(
          child: SpinKitThreeBounce(
            color: Colors.blue,
            size: 30.0,
          ),
        ),
      );
    }

    if (_transactions.isEmpty) {
      return const SizedBox(
        width: double.infinity,
        height: 500,
        child: Center(
          child: Text(
            "No transaction Yet",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final transaction = _transactions[index];
        return TransactionCard(
          id: transaction.id.toString(),
          date: transaction.date,
          amount: transaction.amount.toString(),
          cleared: transaction.cleared,
          onTap: () {
            print("Tapped on transaction ${transaction.id}");
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: SafeArea(
        child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            enableTwoLevel: false,
            header: WaterDropMaterialHeader(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: transactionListBuilder()
        ),
      ),
    );
  }
}
