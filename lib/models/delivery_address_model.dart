import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryAddressModel {
  String? title;
  String? mobileNumber;
  String? alternateNumber;
  String? pincode;
  String? state;
  String? addressMain;
  String? locality;
  String? city;

  DeliveryAddressModel({
    this.title,
    this.mobileNumber,
    this.alternateNumber,
    this.pincode,
    this.state,
    this.addressMain,
    this.locality,
    this.city,
  });
   factory DeliveryAddressModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return DeliveryAddressModel(
      title: data["Name"],
      mobileNumber: data["MobileNumber"],
      alternateNumber: data["AlternateNumber"],
      pincode: data["pincode"],
      state: data["State"],
      addressMain: data["Address"],
      locality: data["Locality"],
      city: data["city"],
    );
  }
}
