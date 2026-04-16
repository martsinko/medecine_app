import 'package:flutter/material.dart';
import 'package:medicity_app/core/constants/app_images.dart';

import '../models/profile_models.dart';

final ProfileData initialProfileData = ProfileData(
  fullName: 'John Doe',
  phoneNumber: '+123 567 89000',
  email: 'johndoe@example.com',
  dateOfBirth: 'DD / MM / YYYY',
  avatarPath: AppImages.tryAvatarImage,
);

const NotificationPreferences initialNotificationPreferences =
    NotificationPreferences(
      generalNotification: true,
      sound: true,
      soundCall: true,
      vibrate: false,
      specialOffers: false,
      payments: true,
      promoAndDiscount: false,
      cashback: true,
    );

const List<ProfileMenuEntry> profileMenuEntries = [
  ProfileMenuEntry(title: 'Profile', icon: Icons.person_outline_rounded),
  ProfileMenuEntry(title: 'Favorite', icon: Icons.favorite_border_rounded),
  ProfileMenuEntry(
    title: 'Payment Method',
    icon: Icons.account_balance_wallet_outlined,
  ),
  ProfileMenuEntry(title: 'Privacy Policy', icon: Icons.privacy_tip_outlined),
  ProfileMenuEntry(title: 'Settings', icon: Icons.settings_outlined),
  ProfileMenuEntry(title: 'Help', icon: Icons.help_outline_rounded),
  ProfileMenuEntry(title: 'Logout', icon: Icons.logout_rounded),
];

const List<FaqArticle> faqArticles = [
  FaqArticle(
    title: 'Lorem ipsum dolor sit amet?',
    body:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent pellentesque congue lorem, vel tincidunt tortor placerat a. Proin ac diam quam. Aenean in sagittis magna, ut feugiat diam.',
  ),
  FaqArticle(
    title: 'How do I make an appointment?',
    body:
        'Open a doctor card, review the available schedule, and confirm a suitable time slot. You can return later to reschedule from your profile.',
  ),
  FaqArticle(
    title: 'Can I save favorite doctors?',
    body:
        'Yes. Tap the favorite icon on a doctor card or in doctor details. Saved doctors appear in the Favorite section together with saved services.',
  ),
  FaqArticle(
    title: 'How do notifications work?',
    body:
        'Notification preferences can be adjusted from Settings. You can independently enable reminders, payments, promo offers, and cashback messages.',
  ),
  FaqArticle(
    title: 'What if I need support quickly?',
    body:
        'Use the Contact Us tab in Help Center to reach customer service, website support, WhatsApp, Facebook, or Instagram.',
  ),
  FaqArticle(
    title: 'How can I edit my profile?',
    body:
        'Go to My Profile, tap Profile, update your information, and press Update Profile. The changes are reflected immediately in the profile section.',
  ),
];

const List<String> faqTags = ['Popular Topic', 'General', 'Services'];

const List<ContactOption> contactOptions = [
  ContactOption(title: 'Customer Service', icon: Icons.headset_mic_outlined),
  ContactOption(title: 'Website', icon: Icons.language_rounded),
  ContactOption(title: 'Whatsapp', icon: Icons.chat_bubble_outline_rounded),
  ContactOption(title: 'Facebook', icon: Icons.facebook_rounded),
  ContactOption(title: 'Instagram', icon: Icons.camera_alt_outlined),
];

const List<String> privacyParagraphs = [
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent pellentesque congue lorem, vel tincidunt tortor placerat a. Proin ac diam quam. Aenean in sagittis magna, ut feugiat diam. Fusce scelerisque neque, sed accumsan metus.',
  'Nunc auctor tortor in dolor luctus, quis euismod nunc tincidunt. Aenean arcu metus, bibendum at rhoncus at, volutpat ut lacus. Morbi pellentesque malesuada eros semper ultrices. Vestibulum lobortis enim vel neque auctor, a ultrices ex placerat. Mauris ut lacinia justo, sed suscipit tortor. Nam egestas nulla posuere neque tincidunt porta.',
];

const List<String> privacyTerms = [
  'Ut lacinia justo sit amet lorem sodales accumsan. Proin malesuada eleifend fermentum. Donec condimentum, nunc at rhoncus faucibus, ex nisi laoreet ipsum, eu pharetra eros est vitae orci. Morbi quis rhoncus mi. Nullam lacinia ornare accumsan. Duis laoreet, ex eget rutrum pharetra, lectus nisl posuere risus, vel facilisis nisl tellus ac turpis.',
  'Ut lacinia justo sit amet lorem sodales accumsan. Proin malesuada eleifend fermentum. Donec condimentum, nunc at rhoncus faucibus, ex nisi laoreet ipsum, eu pharetra eros est vitae orci. Morbi quis rhoncus mi. Nullam lacinia ornare accumsan. Duis laoreet, ex eget rutrum pharetra, lectus nisl tellus ac turpis.',
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent pellentesque congue lorem, vel tincidunt tortor placerat a. Proin ac diam quam. Aenean in sagittis magna, ut feugiat diam.',
  'Nunc auctor tortor in dolor luctus, quis euismod nunc tincidunt. Aenean arcu metus, bibendum at rhoncus at, volutpat ut lacus. Morbi pellentesque malesuada eros semper ultrices. Vestibulum lobortis enim vel neque auctor, a ultrices ex placerat. Mauris ut lacinia justo, sed suscipit tortor. Nam egestas nulla posuere neque.',
];
