import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppointmentModel {
  final String id;
  final String title;
  final String type;
  final String status;
  final DateTime? date;
  final String svgPath;
  final Color bgColor;

  AppointmentModel({
    required this.id,
    required this.title,
    required this.type,
    this.status = 'booked',
    this.date,
    required this.svgPath,
    required this.bgColor,
  });

  factory AppointmentModel.fromMap(String id, Map<String, dynamic> map) {
    final d = map['date'];
    DateTime? dt;
    if (d != null) {
      if (d is Timestamp)
        dt = d.toDate();
      else
        dt = DateTime.tryParse(d.toString());
    }
    final type = (map['type'] ?? map['title'] ?? '').toString();
    return AppointmentModel(
      id: id,
      title: map['title'] ?? '',
      type: type,
      status: map['status'] ?? 'booked',
      date: dt,
      svgPath: _svgForType(type),
      bgColor: _colorForType(type),
    );
  }
}

// helper to pick icon based on type (adjust to your assets)
String _svgForType(String type) {
  final t = type.toLowerCase();
  if (t.contains('physio') || t.contains('physiotherapy')) {
    return 'assets/svg/physio.svg';
  }
  if (t.contains('fitness')) return 'assets/svg/fitness.svg';
  if (t.contains('cancer')) return 'assets/svg/cancer_2nd.svg';
  return 'assets/svg/physio.svg';
}

Color _colorForType(String type) {
  final t = type.toLowerCase();
  if (t.contains('physio')) return Color.fromRGBO(233, 198, 255, 1);
  if (t.contains('fitness')) return Color.fromRGBO(255, 212, 198, 1);
  return Color.fromRGBO(198, 217, 255, 1);
}
