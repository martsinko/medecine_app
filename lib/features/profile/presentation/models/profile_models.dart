import 'package:flutter/material.dart';

class ProfileData {
  final String fullName;
  final String phoneNumber;
  final String email;
  final String dateOfBirth;
  final String avatarPath;

  const ProfileData({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.dateOfBirth,
    required this.avatarPath,
  });

  ProfileData copyWith({
    String? fullName,
    String? phoneNumber,
    String? email,
    String? dateOfBirth,
    String? avatarPath,
  }) {
    return ProfileData(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      avatarPath: avatarPath ?? this.avatarPath,
    );
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
