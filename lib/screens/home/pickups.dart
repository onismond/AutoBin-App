import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:autobin/controllers/api_controller.dart';
import 'package:autobin/models/pickup_model.dart';

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
      return Container(
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
      return Container(
        width: double.infinity,
        height: 500,
        child: Center(
          child: Text(
            "No pickups Yet",
            style: TextStyle(
                fontSize: 20
            ),
          ),
        ),
      );
    }
    return ListView.builder(
        itemCount: _pickups.length,
        itemBuilder: (context, index) {
          final pickup = _pickups[index];
          return Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            borderOnForeground: true,
            child: InkWell(
              splashColor: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              onTap: () {},
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                leading: Icon(
                  Icons.fire_truck_sharp,
                  color: Colors.blue[300],
                  size: 30,
                ),
                title: Text(
                  "GHS ${pickup.amount},  ${pickup.bin_name}",
                  style: TextStyle(
                      fontSize: 15
                  ),
                ),
                subtitle: Text("Date Ordered: ${pickup.date}"),
              ),
            ),
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
