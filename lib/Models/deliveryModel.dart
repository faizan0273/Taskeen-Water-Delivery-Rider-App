import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryModel {
  String? name;
  String? quantity;
  String? total;
  String? paid;
  String? pending;
  String? id;
  String? date;
  String? returned;
  String? doc;

  DeliveryModel(
      {
        this.doc,
        this.name,
        this.quantity,
        this.returned,
        this.id,
        this.total,
        this.paid,
        this.pending,
        this.date
      });

  DeliveryModel.fromJson(Map<String, dynamic> json) {
    name = json['name']!=null?json['name']:"";
    name = json['returned']!=null?json['returned']:"";
    pending = json['pending']!=null?json['pending']:"";
    quantity = json['quantity']!=null?json['quantity']:"";
    paid = json['paid']!=null?json['paid']:"";
    total = json['total']!=null?json['total']:"";
    id = json['id']!=null?json['id']:"";
    date = json['date']!=null?json['date']:"";
    doc = json['doc']!=null?json['doc']:"";
  }

  factory DeliveryModel.fromDocumentSnapshot(DocumentSnapshot doc) => DeliveryModel(
    name:doc.data().toString().contains('name')? doc.get('name') : '',
    pending:doc.data().toString().contains('pending')? doc.get('pending') : '',
    returned:doc.data().toString().contains('returned')? doc.get('returned') : '',
    quantity: doc.data().toString().contains('quantity')? doc.get('quantity') : '',
    total: doc.data().toString().contains('total')? doc.get('total') : '',
    paid: doc.data().toString().contains('paid')? doc.get('paid') : '',
    id: doc.data().toString().contains('id')? doc.get('id') : '',
    date: doc.data().toString().contains('date')? doc.get('date') : '',
    doc: doc.data().toString().contains('doc')? doc.get('doc') : '',
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['paid'] = this.paid;
    data['quantity'] = this.quantity;
    data['total'] = this.total;
    data['returned'] = this.returned;
    data['pending'] = this.pending;
    data['doc'] = this.doc;
    return data;
  }


}
