class AppConstants {
  AppConstants._(); // private constructor to prevent instantiation

  static const ContactInfo contactInfo = ContactInfo(
    phoneNumber: '+216 28356927',
    email: 'chater.marzougui@supcom.com',
    location: 'Cité Technologique des Communications Rte de Raoued Km 3,5 - 2083, Ariana Tunisie',
  );
}

class ContactInfo {
  final String phoneNumber;
  final String email;
  final String location;

  const ContactInfo({required this.phoneNumber, required this.email, required this.location});
}