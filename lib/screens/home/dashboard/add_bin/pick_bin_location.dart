import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:autobin/utils/constants.dart';
import 'package:autobin/data/services/api_controller.dart';
import 'package:autobin/screens/home/dashboard/add_bin/add_bin_success.dart';


class PickBinLocation extends StatefulWidget {
  final String qrValue;
  final String binName;
  final String binColor;
  const PickBinLocation({
    super.key,
    required this.qrValue,
    required this.binName,
    required this.binColor
  });

  @override
  State<PickBinLocation> createState() => _PickBinLocationState();
}

class _PickBinLocationState extends State<PickBinLocation> {

  GoogleMapController? mapController;
  late LatLng _currentPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15,
  );

  @override void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Bin Location'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: Set<Marker>.of(markers.values),
        onCameraMove: (CameraPosition position) {
          _currentPosition = position.target;
        },
        onCameraIdle: () {
          _addMarker();
        },
        onTap: (LatLng currentPosition) {
          _currentPosition = currentPosition;
          _addMarker();
          mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition));
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () => _submit(),
          style: ElevatedButton.styleFrom(
              backgroundColor: bColor1,
              foregroundColor: Colors.deepPurple
          ),
          child: Text("Set As Bin Location"),
        )
      ),
    );
  }

  void _addMarker() {
    markers.clear();
    final MarkerId markerId = MarkerId(markers.length.toString());
    final Marker marker = Marker(
      markerId: markerId,
      position: _currentPosition,
      infoWindow: InfoWindow(
          title: 'Bin Location',
          snippet: 'Where you have placed the bin'
      )
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  void _submit() async {
    EasyLoading.show(
      status: 'Adding Bin...',
      maskType: EasyLoadingMaskType.black
    );
    await APIController().addBin(
        qrValue: widget.qrValue,
        binName: widget.binName,
        binColor: widget.binColor,
        latitude: _currentPosition.latitude.toString(),
        longitude: _currentPosition.longitude.toString()
    ).then((Response<dynamic> response) async {
      EasyLoading.dismiss();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AddBinSuccess()
        )
      );
    }, onError: (e) {
      EasyLoading.dismiss();
      EasyLoading.showInfo(
        APIController.errorMessage(e, context),
        duration: Duration(hours: 1),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true,
      );
    }
    );
  }
}









