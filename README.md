# Azkar Muslim

Flutter app: daily azkar, digital tasbeeh, offline prayer times, Qibla compass, Quran audio.

## Status (honest)

| Feature | Status |
|---|---|
| Azkar (morning/evening) | Data schema ready; **only 6 entries, none religiously reviewed yet** |
| Tasbeeh counter | Implemented |
| Prayer times (offline, `adhan_dart`, Egyptian method) | Code written, **needs device verification** |
| Adhan notifications (background) | Code written, **needs real-device tests** (see docs/TESTING.md) |
| Qibla compass | Code written, math unit-tested, **sensor needs device test** |
| Quran audio (streaming) | Code written, **server URL and terms need verification** |
| Quran text reader | Surah list only. Full text not included yet |

## Run

```bash
git clone https://github.com/muham-ed/azkar-muslim-app.git
cd azkar-muslim-app
flutter pub get
flutter test
flutter run
```

## Notes
- Azkar entries carry `source` and `reviewed`. Do not ship entries with `reviewed: false`.
- Quran text must come from a verified source (e.g. Tanzil) **unmodified**, with its license terms.
- License: MIT.
