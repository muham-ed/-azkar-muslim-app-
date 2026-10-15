# خطوات Git (نفّذها بنفسك وابعتلي المخرجات)

```bash
# 1) انسخ ملفات الحزمة فوق مشروعك (lib/, assets/, test/, pubspec.yaml, LICENSE, README.md)
# 2) نظّف
bash scripts/cleanup_repo.sh
# 3) أضف إعدادات Android حسب docs/ANDROID_SETUP.md
flutter pub get && flutter analyze && flutter test
# 4) commit + push
git add -A
git commit -m "feat: offline prayer times, qibla, notifications, audio; cleanup repo"
git push origin main
# 5) (اختياري) أعد تسمية المستودع بدون الشرطة
gh repo rename azkar-muslim-app    # أو من Settings على GitHub
git log --oneline -5
```
