import 'package:sqflite/sqflite.dart';

import 'local_db.dart';
import 'package:flutter_task/model/assesment_card_model.dart';
import 'package:flutter_task/model/appointment_card_model.dart';

class LocalRepository {
  // Save assessments
  static Future<void> saveAssessments(List<AssesmentCardModel> items) async {
    final db = await LocalDB.database;
    for (var item in items) {
      await db.insert("assessments", {
        "id": item.id,
        "title": item.title,
        "description": item.description,
        "isFavourite": item.isFavourite ? 1 : 0,
        "imagePath": item.imagePath,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // Load assessments
  static Future<List<AssesmentCardModel>> getAssessments() async {
    final db = await LocalDB.database;
    final res = await db.query("assessments");
    return res
        .map((e) => AssesmentCardModel.fromMap(e['id'] as String, e))
        .toList();
  }

  // Save appointments
  static Future<void> saveAppointments(List<AppointmentModel> items) async {
    final db = await LocalDB.database;
    for (var item in items) {
      await db.insert("appointments", {
        "id": item.id,
        "title": item.title,
        "svgPath": item.svgPath,
        // ignore: deprecated_member_use
        "bgColor": item.bgColor.value,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // Load appointments
  static Future<List<AppointmentModel>> getAppointments() async {
    final db = await LocalDB.database;
    final res = await db.query("appointments");
    return res
        .map((e) => AppointmentModel.fromMap(e['id'] as String, e))
        .toList();
  }
}
