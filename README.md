# Absensi App

### Tutorial menjalankan aplikasi

- Download file build apk pada link https://drive.google.com/file/d/1L91nCagZJG5Hk89KkXzjHef5r6zuaMWQ/view?usp=sharing
- Install file yang telah di download
- Buka aplikasi kemudian login dengan
    email : example@gmail.com
    password : password
- Unttuk akses izinkan akses jika diminta


### Tutorial Merubah titik Koordinat
- buka file ```lib\features\attendance\presentation\providers\attendance_provider.dart```
- kemudian ubah bagian 
```const officeLatitude = -8.176523;```
```const officeLongitude = 111.939464;```
dengan lokasi anda ketika masuk kedalam aplikasi
<img width="400" height="1000" alt="Image" src="https://github.com/user-attachments/assets/b6848d33-9943-4400-adea-8a9ce6881bef" />

### Plugin yang digunakan

cupertino_icons: ^1.0.8
firebase_core: ^4.0.0
provider: ^6.1.5+1
intl: ^0.20.2
geolocator: ^14.0.2
geocoding: ^4.0.0
image_picker: ^1.2.0
firebase_auth: ^6.0.1
cloud_firestore: ^6.0.0
cloudinary_public: ^0.23.1
permission_handler: ^12.0.1
http: ^1.5.0
flutter_dotenv: ^6.0.0
