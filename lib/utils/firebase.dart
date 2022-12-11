import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
final Uuid uuid = Uuid();
CollectionReference usersRef = firestore.collection('customer');
CollectionReference deliveriesRef = firestore.collection('deliveries');


