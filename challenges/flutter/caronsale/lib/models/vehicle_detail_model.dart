import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleDetailModel {
  String id = '';
  DateTime date = DateTime.now();
  String vin = '';
  String vehicleMake = '';
  String vehicleModel = '';
  String vehiclePhotoUrl = '';

  VehicleDetailModel() {
    id = '';
    date = DateTime.now();
    vin = '';
    vehicleMake = '';
    vehicleModel = '';
    vehiclePhotoUrl = '';
  }

  VehicleDetailModel.fromDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    var json = snapshot.data() as Map<String, dynamic>;
    var timestamp = json['date'] as Timestamp;

    id = snapshot.id;
    date = timestamp.toDate();
    vin = json['vin'];
    vehicleMake = json['vehicleMake'];
    vehicleModel = json['vehicleModel'];
    vehiclePhotoUrl = json['vehiclePhotoUrl'];
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> data = {};

    data['date'] = Timestamp.fromDate(date);
    data['vin'] = vin;
    data['vehicleMake'] = vehicleMake;
    data['vehicleModel'] = vehicleModel;
    data['vehiclePhotoUrl'] = vehiclePhotoUrl;

    return data;
  }
}

class VehicleList {
  List<VehicleDetailModel> vehicleList = [];

  VehicleList() {
    vehicleList = [];
  }

  VehicleList.fromSnapshotList(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> vehicleDetailList) {
    for (var vehicleDetail in vehicleDetailList) {
      var vehicleDetailModel =
          VehicleDetailModel.fromDocumentSnapshot(vehicleDetail);
      vehicleList.add(vehicleDetailModel);
    }
  }
}
