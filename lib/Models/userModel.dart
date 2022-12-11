import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? number;
  String? address;
  String? price;
  String? payment;
  String? id;
  String? returned;


  UserModel(
      {this.name,
        this.returned,
        this.number,
        this.id,
        this.address,
        this.price,
        this.payment,
      });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name']!=null?json['name']:"";
    number = json['number']!=null?json['number']:"";
    returned = json['returned']!=null?json['returned']:"";
    // number = json['plus']!=null?json['plus']:"";
    price = json['price']!=null?json['price']:"";
    payment = json['payment']!=null?json['payment']:"";
    address = json['address']!=null?json['address']:"";
    id = json['id']!=null?json['id']:"";
  }

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) => UserModel(
    name:doc.data().toString().contains('name')? doc.get('name') : '',
    returned:doc.data().toString().contains('returned')? doc.get('returned') : '',
    // plus:doc.data().toString().contains('plus')? doc.get('plus') : '',
    payment:doc.data().toString().contains('payment')? doc.get('payment') : '',
    number: doc.data().toString().contains('number')? doc.get('number') : '',
    address: doc.data().toString().contains('address')? doc.get('address') : '',
    price: doc.data().toString().contains('price')? doc.get('price') : '',
    id: doc.data().toString().contains('id')? doc.get('id') : '',
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['payment'] = this.payment;
    data['price'] = this.price;
    data['number'] = this.number;
    data['address'] = this.address;
    data['returned'] = this.returned;
    // data['plus'] = this.plus;

    return data;
  }


}
