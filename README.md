# Azkar Muslim & Islamic Companion App 🌙📱

A comprehensive, elegant, and high-performance Islamic companion application built with **Flutter** and **Dart**. Designed with a modern human-centric UI/UX, warm Islamic typography, dark/light theme support, 100% offline prayer calculations, live Qibla compass, audio recitations, and local data persistence.

---

## ✨ Core Features

- 🤲 **Authentic Daily Azkar (أذكار المسلم)**:
  - Complete Morning & Evening Azkar, Sleep Azkar, and Post-Prayer supplications.
  - Fully diacritized text (التشكيل التام) with verified Hadith gradings and authentic sources (البخاري، مسلم، أبو داود، الترمذي).
  - Daily completion progress bars and local state persistence.

- 📿 **Digital Tasbeeh Counter (المسبحة الرقمية)**:
  - Interactive circular gauge counter with tactile haptic feedback (Vibration).
  - Preset phrase selection (*SubhanAllah*, *Alhamdulillah*, *Allahu Akbar*, *Astaghfirullah*, etc.).
  - Target counters (33, 100, 1000) and lifetime cumulative count tracker.

- 📖 **Holy Quran Reader & Recitation (القرآن الكريم والتلاوة الصوتيّة)**:
  - Clean reading view with traditional Amiri font typography.
  - Surah search filter, verse count, and revelation types (مكيّة / مدنيّة).
  - High-quality audio streaming player for Surah recitations.

- 🕋 **100% Offline Prayer Times & Live Qibla Compass (مواقيت الصلاة والقبلة)**:
  - Accurate offline prayer calculation using the official `adhan` engine (Egyptian General Authority of Survey parameters).
  - Live dynamic countdown timer to the upcoming prayer.
  - Interactive real-time Qibla compass using device magnetometer sensors (`flutter_compass`).

- 🔔 **Local Notifications (التنبيهات والإشعارات)**:
  - Native local notification engine (`flutter_local_notifications`) for daily Azkar and prayer time reminders.

- 🎨 **Human-Centric UI/UX & Dark Mode**:
  - Custom Muted Emerald (`#0D2818`) & Muted Gold (`#D4AF37`) palette.
  - Full Dark/Light mode toggle with instant persistence via `shared_preferences`.

---

## 🛠 Tech Stack & Dependencies

- **Framework**: [Flutter](https://flutter.dev) (Dart)
- **State Management**: Provider (`MultiProvider`)
- **Offline Prayer Engine**: `adhan` (Offline astronomical calculation)
- **Compass Sensors**: `flutter_compass` & `geolocator`
- **Notifications**: `flutter_local_notifications` & `timezone`
- **Audio Engine**: `audioplayers`
- **Persistence**: `shared_preferences`
- **Haptics**: `vibration`
- **Typography**: Google Fonts (`Cairo`, `Amiri`)

---

## 🚀 Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/muham-ed/-azkar-muslim-app-.git
   cd -azkar-muslim-app-
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

---

## 📜 License

This project is open-source and available under the [MIT License](LICENSE).
