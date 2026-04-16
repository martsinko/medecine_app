import 'package:medicity_app/core/constants/app_images.dart';

import '../models/doctor_profile.dart';

final List<DoctorProfile> doctorsMock = [
  DoctorProfile(
    id: 'olivia-turner',
    name: 'Dr. Olivia Turner, M.D.',
    specialty: 'Dermato-Endocrinology',
    rating: 5.0,
    reviews: 54,
    experienceYears: 11,
    availability: 'Mon-Sat / 8:30AM - 4:30PM',
    imagePath: AppImages.exampleAvatar,
    focus:
        'Specializes in hormonal skin conditions, inflammatory flare-ups, and personalized long-term care plans.',
    profile:
        'Olivia Turner combines dermatology and endocrine expertise to treat chronic skin conditions with a precise diagnostic approach and patient-centered follow-up.',
    careerPath:
        'She trained in internal medicine before completing a dermatology fellowship focused on endocrine-related skin disorders and complex case coordination.',
    highlights:
        'Known for structured treatment plans, detailed education during appointments, and strong outcomes for chronic acne and autoimmune skin conditions.',
    isFavorite: true,
    gender: DoctorGender.female,
  ),
  DoctorProfile(
    id: 'alexander-bennett',
    name: 'Dr. Alexander Bennett, Ph.D.',
    specialty: 'Dermato-Genetics',
    rating: 5.0,
    reviews: 40,
    experienceYears: 15,
    availability: 'Mon-Sat / 9:00AM - 5:00PM',
    imagePath: AppImages.tryAvatarImage,
    focus:
        'Focus: the impact of hormonal imbalances on skin conditions, specializing in acne, hirsutism, and other skin disorders.',
    profile:
        'Alexander Bennett works at the intersection of genetics and dermatology, helping patients understand inherited risk factors and tailored prevention plans.',
    careerPath:
        'His research background in molecular dermatology led into clinical practice where he now treats hereditary and treatment-resistant skin conditions.',
    highlights:
        'Combines evidence-based diagnostics with clear patient communication and is frequently consulted for second opinions on rare dermato-genetic cases.',
    isFavorite: true,
    gender: DoctorGender.male,
  ),
  DoctorProfile(
    id: 'sophia-martinez',
    name: 'Dr. Sophia Martinez, Ph.D.',
    specialty: 'Cosmetic Bioengineering',
    rating: 4.9,
    reviews: 28,
    experienceYears: 9,
    availability: 'Tue-Sat / 10:00AM - 6:00PM',
    imagePath: AppImages.exampleAvatar,
    focus:
        'Builds restorative skin-care protocols using regenerative materials, scar revision methods, and cosmetic device planning.',
    profile:
        'Sophia Martinez brings together cosmetic dermatology and bioengineering to improve texture, healing, and visible skin quality after procedures.',
    careerPath:
        'After completing biomedical engineering research, she specialized in aesthetic dermatology and treatment design for post-procedure recovery.',
    highlights:
        'Patients value her detailed recovery guidance, conservative treatment sequencing, and strong focus on measurable cosmetic outcomes.',
    isFavorite: true,
    gender: DoctorGender.female,
  ),
  DoctorProfile(
    id: 'michael-davidson',
    name: 'Dr. Michael Davidson, M.D.',
    specialty: 'Solar Dermatology',
    rating: 4.8,
    reviews: 32,
    experienceYears: 12,
    availability: 'Mon-Fri / 9:30AM - 4:00PM',
    imagePath: AppImages.tryAvatarImage,
    focus:
        'Treats sun-induced skin damage, pigmentation disorders, and prevention planning for high-exposure lifestyles.',
    profile:
        'Michael Davidson focuses on prevention, early detection, and treatment of photoaging and other sun-related skin concerns.',
    careerPath:
        'He has worked in preventive dermatology clinics with a strong emphasis on UV damage screening, dermoscopy, and skin cancer prevention.',
    highlights:
        'Provides practical routines for daily protection and long-term monitoring, especially for patients with extensive outdoor exposure.',
    isFavorite: true,
    gender: DoctorGender.male,
  ),
];

const List<FavoriteServiceCategory> favoriteServicesMock = [
  FavoriteServiceCategory(
    title: 'Dermato-Endocrinology',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent pellentesque congue lorem, vel tincidunt tortor placerat a. Proin ac diam quam. Aenean in sagittis magna, ut feugiat diam.',
  ),
  FavoriteServiceCategory(
    title: 'Cosmetic Bioengineering',
    description:
        'Advanced aesthetic recovery planning, regenerative skin protocols, and treatment mapping for long-term texture improvement.',
  ),
  FavoriteServiceCategory(
    title: 'Dermato-Genetics',
    description:
        'Genetic risk evaluation, personalized prevention plans, and guidance for inherited dermatological conditions.',
  ),
  FavoriteServiceCategory(
    title: 'Solar Dermatology',
    description:
        'Photoaging prevention, sun-damage treatment, pigmentation correction, and high-exposure skin monitoring.',
  ),
  FavoriteServiceCategory(
    title: 'Dermato-Immunology',
    description:
        'Consultations for chronic inflammatory conditions with treatment planning focused on flare management and quality of life.',
  ),
];

DoctorProfile getDoctorById(String id) {
  return doctorsMock.firstWhere(
    (doctor) => doctor.id == id,
    orElse: () => doctorsMock.first,
  );
}

List<DoctorProfile> getFavoriteDoctorsByGender(DoctorGender? gender) {
  final favorites = doctorsMock.where((doctor) => doctor.isFavorite);
  if (gender == null) {
    return favorites.toList();
  }

  return favorites.where((doctor) => doctor.gender == gender).toList();
}
