import 'package:flutter/material.dart';
import 'package:medicity_app/core/constants/app_images.dart';

import '../models/profile_models.dart';

final ProfileData initialProfileData = ProfileData(
  uid: '',
  fullName: '',
  phoneNumber: '',
  email: '',
  dateOfBirth: 'DD / MM / YYYY',
  avatarPath: AppImages.tryAvatarImage,
  notificationPreferences: initialNotificationPreferences,
);

const NotificationPreferences initialNotificationPreferences =
    NotificationPreferences(
      generalNotification: true,
      sound: true,
      soundCall: true,
      vibrate: false,
      specialOffers: false,
      promoAndDiscount: false,
    );

const List<ProfileMenuEntry> profileMenuEntries = [
  ProfileMenuEntry(title: 'profile', icon: Icons.person_outline_rounded),
  ProfileMenuEntry(title: 'favorite', icon: Icons.favorite_border_rounded),
  ProfileMenuEntry(title: 'privacyPolicy', icon: Icons.privacy_tip_outlined),
  ProfileMenuEntry(title: 'settings', icon: Icons.settings_outlined),
  ProfileMenuEntry(title: 'help', icon: Icons.help_outline_rounded),
  ProfileMenuEntry(title: 'logout', icon: Icons.logout_rounded),
];

const List<FaqArticle> faqArticles = [
  FaqArticle(title: 'faqPrepareTitle', body: 'faqPrepareBody'),
  FaqArticle(title: 'faqAppointmentTitle', body: 'faqAppointmentBody'),
  FaqArticle(title: 'faqFavoriteTitle', body: 'faqFavoriteBody'),
  FaqArticle(title: 'faqNotificationsTitle', body: 'faqNotificationsBody'),
  FaqArticle(title: 'faqSupportTitle', body: 'faqSupportBody'),
  FaqArticle(title: 'faqEditProfileTitle', body: 'faqEditProfileBody'),
];

const List<String> faqTags = ['popularTopic', 'general', 'services'];

const List<ContactOption> contactOptions = [
  ContactOption(title: 'customerService', icon: Icons.headset_mic_outlined),
  ContactOption(title: 'website', icon: Icons.language_rounded),
  ContactOption(title: 'whatsapp', icon: Icons.chat_bubble_outline_rounded),
  ContactOption(title: 'facebook', icon: Icons.facebook_rounded),
  ContactOption(title: 'instagram', icon: Icons.camera_alt_outlined),
];

const List<String> privacyParagraphs = [
  'privacyParagraph1',
  'privacyParagraph2',
];

const List<String> privacyTerms = [
  'privacyTerm1',
  'privacyTerm2',
  'privacyTerm3',
  'privacyTerm4',
];
