import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileData {
  final String uid;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String dateOfBirth;
  final String avatarPath;
  final List<String> favoriteTeacherIds;
  final NotificationPreferences notificationPreferences;

  const ProfileData({
    required this.uid,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.dateOfBirth,
    required this.avatarPath,
    this.favoriteTeacherIds = const [],
    this.notificationPreferences = const NotificationPreferences(
      generalNotification: true,
      sound: true,
      soundCall: true,
      vibrate: false,
      specialOffers: false,
      payments: true,
      promoAndDiscount: false,
      cashback: true,
    ),
  });

  ProfileData copyWith({
    String? uid,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? dateOfBirth,
    String? avatarPath,
    List<String>? favoriteTeacherIds,
    NotificationPreferences? notificationPreferences,
  }) {
    return ProfileData(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      avatarPath: avatarPath ?? this.avatarPath,
      favoriteTeacherIds: favoriteTeacherIds ?? this.favoriteTeacherIds,
      notificationPreferences:
          notificationPreferences ?? this.notificationPreferences,
    );
  }

  factory ProfileData.fromFirestore(String uid, Map<String, dynamic> map) {
    return ProfileData(
      uid: uid,
      fullName: map['fullName'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      email: map['email'] as String? ?? '',
      dateOfBirth: map['dateOfBirth'] as String? ?? '',
      avatarPath: map['photoUrl'] as String? ?? '',
      favoriteTeacherIds: List<String>.from(
        map['favoriteTeacherIds'] ?? const <String>[],
      ),
      notificationPreferences: NotificationPreferences.fromMap(
        Map<String, dynamic>.from(map['notificationPreferences'] ?? const {}),
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'photoUrl': avatarPath,
      'favoriteTeacherIds': favoriteTeacherIds,
      'notificationPreferences': notificationPreferences.toMap(),
      'updatedAt': Timestamp.now(),
    };
  }
}

class NotificationPreferences {
  final bool generalNotification;
  final bool sound;
  final bool soundCall;
  final bool vibrate;
  final bool specialOffers;
  final bool payments;
  final bool promoAndDiscount;
  final bool cashback;

  const NotificationPreferences({
    required this.generalNotification,
    required this.sound,
    required this.soundCall,
    required this.vibrate,
    required this.specialOffers,
    required this.payments,
    required this.promoAndDiscount,
    required this.cashback,
  });

  factory NotificationPreferences.fromMap(Map<String, dynamic> map) {
    return NotificationPreferences(
      generalNotification: map['generalNotification'] as bool? ?? true,
      sound: map['sound'] as bool? ?? true,
      soundCall: map['soundCall'] as bool? ?? true,
      vibrate: map['vibrate'] as bool? ?? false,
      specialOffers: map['specialOffers'] as bool? ?? false,
      payments: map['payments'] as bool? ?? true,
      promoAndDiscount: map['promoAndDiscount'] as bool? ?? false,
      cashback: map['cashback'] as bool? ?? true,
    );
  }

  NotificationPreferences copyWith({
    bool? generalNotification,
    bool? sound,
    bool? soundCall,
    bool? vibrate,
    bool? specialOffers,
    bool? payments,
    bool? promoAndDiscount,
    bool? cashback,
  }) {
    return NotificationPreferences(
      generalNotification: generalNotification ?? this.generalNotification,
      sound: sound ?? this.sound,
      soundCall: soundCall ?? this.soundCall,
      vibrate: vibrate ?? this.vibrate,
      specialOffers: specialOffers ?? this.specialOffers,
      payments: payments ?? this.payments,
      promoAndDiscount: promoAndDiscount ?? this.promoAndDiscount,
      cashback: cashback ?? this.cashback,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'generalNotification': generalNotification,
      'sound': sound,
      'soundCall': soundCall,
      'vibrate': vibrate,
      'specialOffers': specialOffers,
      'payments': payments,
      'promoAndDiscount': promoAndDiscount,
      'cashback': cashback,
    };
  }
}

enum NotificationPreferenceType {
  generalNotification,
  sound,
  soundCall,
  vibrate,
  specialOffers,
  payments,
  promoAndDiscount,
  cashback,
}

class ProfileMenuEntry {
  final String title;
  final IconData icon;
  final Color? iconBackgroundColor;

  const ProfileMenuEntry({
    required this.title,
    required this.icon,
    this.iconBackgroundColor,
  });
}

class FaqArticle {
  final String title;
  final String body;

  const FaqArticle({required this.title, required this.body});
}

class ContactOption {
  final String title;
  final IconData icon;

  const ContactOption({required this.title, required this.icon});
}
