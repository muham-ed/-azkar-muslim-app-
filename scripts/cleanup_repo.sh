#!/usr/bin/env bash
# شغّله من جذر المشروع. بيشيل الملفات الزايدة من git (مش بيمسحها من جهازك لو عدّلت -r --cached).
set -e

git rm -r --cached .gradle 2>/dev/null || true
git rm -f server.js setup_db.js flutter.create 2>/dev/null || true
git rm -f "هيكل المشروع" 2>/dev/null || true

# فولدر app/ في الجذر: افتحه الأول وشوف فيه ايه. لو مجرد وحدة Gradle زيادة احذفه بنفسك:
#   git rm -r app

# ضيف ignore
cat gitignore_additions.txt >> .gitignore
git add .gitignore
echo "تم. راجع: git status ثم commit."
