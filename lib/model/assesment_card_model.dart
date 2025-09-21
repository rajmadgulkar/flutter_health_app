import 'package:flutter/material.dart';

class AssesmentCardModel {
  final String id;
  String title;
  String description;
  bool isFavourite;
  List<Color> gradientColors;
  String imagePath;

  AssesmentCardModel({
    required this.id,
    required this.title,
    required this.description,
    this.isFavourite = false,
    required this.gradientColors,
    required this.imagePath,
  });

  factory AssesmentCardModel.fromMap(String id, Map<String, dynamic> map) {
    return AssesmentCardModel(
      id: id,
      title: map['type'] ?? map['title'] ?? '',
      description: map['description'] ?? '',
      isFavourite: map['isFavourite'] ?? false,
      gradientColors: [
        Color.fromRGBO(105, 245, 187, 0.5),
        Color.fromRGBO(145, 182, 85, 0.5),
      ],
      imagePath: 'assets/image/boy_exe.png',
    );
  }

  Map<String, dynamic> toMap() => {
    'type': title,
    'description': description,
    'isFavourite': isFavourite,
  };
}
