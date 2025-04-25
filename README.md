
# 🏡 Samsar

**Your smart companion for discovering and managing real estate in Tunisia.**  
Built with ❤️ in Flutter and Firebase.

---

## 📱 About Samsar

**Samsar** is a feature-rich mobile application designed to streamline the property renting and selling experience in Tunisia. Whether you're a house hunter, property owner, or agent, Samsar provides the tools to find, list, and manage homes — with an intuitive user experience and powerful map-based features.

This project reflects a full-stack mobile app journey — from building a polished UI to managing multilingual support, real-time data, map integration, and persistent preferences.

---

## ✨ Features

- 🧭 **Map-Based Search** with drawing functionality to find houses in a custom-drawn area.
- 🔎 **Advanced Filtering** to narrow down listings based on location, size, and more.
- 🏠 **Add, Edit & Manage Listings** — with image upload and metadata support.
- 🌐 **Multilingual Support** (Arabic 🇹🇳, French 🇫🇷, English 🇬🇧)
- 🔒 **User Authentication** (Signup/Login, Auth Wrapper)
- 💬 **Chat System** between users and property owners
- 🧾 **Favorites, Notifications, Ratings** — everything a modern user expects
- 🗺️ **Reverse Geocoding** using [Nominatim API](https://nominatim.org/)
- 🌙 **Dark Mode Ready** 🎨

---

## 🧠 Tech Stack

| Layer         | Technologies                          |
|--------------|---------------------------------------|
| **Frontend**  | Flutter (Dart), Firebase Auth, Firestore |
| **Backend**   | Firebase, Nominatim API (for maps)    |
| **State Mgmt**| Provider (implicit), custom managers  |
| **Localization** | Flutter Intl, ARB files             |
| **Mapping**   | Flutter Map + Custom Tile Caching     |

---

## 📁 Project Structure Highlights

```
lib/
├── main.dart                    # Entry point
├── firebase_options.dart        # Firebase initialization
├── routes.dart                  # App routing
├── helpers/                     # Custom logic (e.g., house/user manager)
├── l10n/                        # Localization (arb + generated files)
├── screens/                     # UI screens (main, settings, auth, etc.)
├── values/                      # Constants, structures, models
└── Widgets/                     # Custom widgets and dialogs
```

> Full Android project is scaffolded inside `android/` with native support and Firebase integration.

---

## 🌍 Localization

Language files are stored in `assets/langs/`, supporting:
- 🇹🇳 Arabic (`ar.json`)
- 🇫🇷 French (`fr.json`)
- 🇬🇧 English (`en.json`)
- 🇹🇳 Tunisian Dialect (`tn.json`)

---

## 🧪 Cool Code Bits

- `finds_houses_in_drawing.dart`: Detect houses within custom polygon on the map
- `house_struct.dart`: Data structure for house listings
- `auth_wrapper.dart`: Auto-login mechanism with Firebase
- `randomDataGenerator.dart`: Used for development testing and mock data

---

## 📸 Screenshots

> _Coming soon — mockup designs or screenshots of the app interface._

---

## 🧑‍💻 Made with Passion by

**Chater Marzougui**  
📍 Tunisia · Software Engineer · Tech Leader · RAS Chapter President  
🔗 [LinkedIn](https://linkedin.com/in/chatermarzougui) · [GitHub](https://github.com/chatermarzougui)

---

## 🛠️ Run the App

To run the app locally:

```bash
git clone https://github.com/chatermarzougui/samsar.git
cd samsar
flutter pub get
flutter run
```

> Make sure to add your own `google-services.json` file in `android/app/`.

---

## 📌 Future Roadmap

- AI-powered property recommendations
- Heatmap-based demand analytics
- Smart alerts for new listings
- Admin dashboard for property moderation

---

## 📃 License

MIT License — free to use, modify, and build upon.

---

🏗️ _Samsar: Because house-hunting should be smart, fast, and localized._
