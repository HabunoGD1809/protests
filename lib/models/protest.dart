import 'package:flutter/material.dart';

class Protest {
  final String uuid;
  final int userId;
  final String natureName;
  final IconData natureIcon;
  final Color natureColor;
  final String province;
  final String summary;
  final DateTime dateTime;

  Protest({
    required this.uuid,
    required this.userId,
    required this.natureName,
    required this.natureIcon,
    required this.natureColor,
    required this.province,
    required this.summary,
    required this.dateTime,
  });

  factory Protest.fromMap(Map<String, dynamic> map) {
    return Protest(
      uuid: map['uuid'],
      userId: map['userId'],
      natureName: map['natureName'],
      natureIcon: IconData(map['natureIcon'], fontFamily: 'MaterialIcons'),
      natureColor: Color(map['natureColor']),
      province: map['province'],
      summary: map['summary'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'userId': userId,
      'natureName': natureName,
      'natureIcon': natureIcon.codePoint,
      'natureColor': natureColor.value,
      'province': province,
      'summary': summary,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
