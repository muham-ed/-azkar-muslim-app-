# إعداد Android (لازم قبل ما الإشعارات والبوصلة والموقع تشتغل)

## 1) `android/app/src/main/AndroidManifest.xml`

داخل `<manifest>` وقبل `<application>`:

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

داخل `<application>`:

```xml
<receiver android:exported="false"
    android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver android:exported="false"
    android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.QUICKBOOT_POWERON" />
        <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
    </intent-filter>
</receiver>
```

ملاحظة Google Play: `SCHEDULE_EXACT_ALARM` يتطلب إذن المستخدم من أندرويد 14.
`USE_EXACT_ALARM` بيتمنح تلقائياً لكن Google Play بتقيّد استخدامه لتطبيقات المنبه/التقويم؛
تطبيق الأذان بيدخل غالباً تحت "تقويم/منبه ديني" لكن **راجع سياسة Play الحالية قبل النشر**.

## 2) `android/app/build.gradle` (أو `build.gradle.kts`)

الإضافة تحتاج core library desugaring:

```gradle
android {
    compileOptions {
        coreLibraryDesugaringEnabled true
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}
dependencies {
    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4'
}
```

لو بتستخدم `.kts` التركيب مختلف (`isCoreLibraryDesugaringEnabled = true` و`coreLibraryDesugaring("...")`).

## 3) صوت الأذان المخصص (اختياري)

- ضع ملف صوت تملك حق استخدامه في `android/app/src/main/res/raw/adhan.mp3` (أسماء صغيرة بلا مسافات).
- مرّر `customSound: true` في `scheduleAdhan`.
- لو غيّرت الصوت بعدين غيّر `_channelId` (مثلاً `adhan_v2`).

## 4) في `main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrapAdhan(); // من lib/bootstrap.dart
  runApp(const MyApp());
}
```
