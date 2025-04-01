import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:autobin/data/services/api_controller.dart';
import 'package:autobin/data/models/pickup_model.dart';
import 'package:autobin/widgets/pickup_card.dart';

class Pickups extends StatefulWidget {
  @override
  State<Pickups> createState() => _PickupsState();
}

class _PickupsState extends State<Pickups> {
  RefreshController _refreshController =  RefreshController(initialRefresh: false);
  List<Pickup> _pickups = [];
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
    await APIController().getPickups().then(
      (Response<dynamic> response) async {
        List<Pickup> pickupList = [];
        List pickupData = APIController.decodeMapData(response);
        for (var pickup in pickupData) {
          pickupList.add(Pickup.fromMap(pickup));
        }
        setState(() {
          isLoading = false;
          _pickups = pickupList;
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
          _pickups = [];
        });
      }
    );
  }


  Widget pickupListBuilder() {
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

    if (_pickups.isEmpty) {
      return const SizedBox(
        width: double.infinity,
        height: 500,
        child: Center(
          child: Text(
            "No pickups Yet",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _pickups.length,
      itemBuilder: (context, index) {
        final pickup = _pickups[index];
        return PickupCard(
          amount: pickup.amount.toString(),
          binName: pickup.bin_name,
          dateOrdered: pickup.date,
          onTap: () {
            print("Tapped on pickup ${pickup.bin_name}");
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickups'),
      ),
      body: SafeArea(
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          enableTwoLevel: false,
          header: WaterDropMaterialHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: pickupListBuilder()
        ),
      ),
    );
  }

}
