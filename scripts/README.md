# 📜 Scripts untuk Import Data

## 🚀 Import Data HP ke Firestore

### Cara Pakai:

1. **Pastikan Firebase sudah setup**
   - Firebase project sudah dibuat
   - `firebase_options.dart` sudah ada
   - Firestore sudah diaktifkan

2. **Jalankan script:**
   ```bash
   dart run scripts/import_to_firestore.dart
   ```

3. **Script akan:**
   - Membaca file `assets/data/smartphones.json`
   - Import semua data ke Firestore collection `smartphones`
   - Menampilkan progress dan hasil

### Troubleshooting:

**Error: "File not found"**
- Pastikan menjalankan dari project root directory
- Pastikan file `assets/data/smartphones.json` ada

**Error: "Firebase not initialized"**
- Pastikan `firebase_options.dart` sudah ada
- Pastikan Firebase project sudah setup dengan benar

**Error: "Permission denied"**
- Cek Firestore rules di Firebase Console
- Untuk development, gunakan test mode:
  ```javascript
  rules_version = '2';
  service cloud.firestore {
    match /databases/{database}/documents {
      match /{document=**} {
        allow read, write: if true; // Hanya untuk development!
      }
    }
  }
  ```

---

## 📝 Format JSON

File `assets/data/smartphones.json` harus dalam format:
```json
{
  "smartphones": [
    {
      "id": "phone-id",
      "name": "Phone Name",
      "brand": "Brand",
      ...
    }
  ]
}
```

---

## 💡 Tips

- **Backup dulu** data yang sudah ada di Firestore (jika ada)
- **Test dengan 1-2 data dulu** sebelum import banyak
- **Cek hasil** di Firebase Console setelah import

