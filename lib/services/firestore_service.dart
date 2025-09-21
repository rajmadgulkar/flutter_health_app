import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Streams
  Stream<QuerySnapshot<Map<String, dynamic>>> userAppointmentsStream() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _db
        .collection('users')
        .doc(uid)
        .collection('appointments')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> userAssessmentsStream() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _db
        .collection('users')
        .doc(uid)
        .collection('assessments')
        .orderBy('bookedOn', descending: true)
        .snapshots();
  }

  // Writes
  Future<void> addAppointment(Map<String, dynamic> data) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _db.collection('users').doc(uid).collection('appointments').add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addAssessment(Map<String, dynamic> data) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _db.collection('users').doc(uid).collection('assessments').add({
      ...data,
      'bookedOn': FieldValue.serverTimestamp(),
    });
  }

  // Ensure user doc exists (call from signup)
  Future<void> createOrUpdateUserDoc(
    String uid,
    Map<String, dynamic> userData,
  ) async {
    await _db
        .collection('users')
        .doc(uid)
        .set(userData, SetOptions(merge: true));
  }
}
