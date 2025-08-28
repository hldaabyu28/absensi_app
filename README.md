# Absensi App

Fitur Utama
✅ Autentikasi Firebase - Login/Register dengan email & password
✅ Validasi Lokasi - Harus berada dalam radius 100m dari kantor
✅ Foto Selfie - Wajib mengambil selfie sebagai bukti kehadiran
✅ Riwayat Absensi - Melihat history absensi dengan foto thumbnail
✅ State Management - Provider pattern untuk state management
✅ Real-time Clock - Menampilkan waktu real-time
Tech Stack

Flutter 3.x dengan Dart
Firebase Auth - Autentikasi pengguna
Cloud Firestore - Database untuk menyimpan data absensi
Cloudinary - Storage untuk menyimpan foto selfie
Provider - State management
Geolocator - GPS dan validasi lokasi
Image Picker - Akses kamera untuk selfie

Setup Project
1. Clone Repository
bashgit clone <repository-url>
cd absensi_app
2. Install Dependencies
bashflutter pub get
3. Setup Firebase
a. Buat Project Firebase

Buka Firebase Console
Klik "Create a project" atau "Add project"
Masukkan nama project (contoh: "absensi-app")
Enable Google Analytics (opsional)
Klik "Create project"

b. Setup Authentication

Di Firebase Console, pilih "Authentication"
Klik tab "Sign-in method"
Enable "Email/Password"
Klik "Save"

c. Setup Firestore Database

Di Firebase Console, pilih "Firestore Database"
Klik "Create database"
Pilih "Start in test mode" (untuk development)
Pilih lokasi server (pilih yang terdekat dengan user)
Klik "Done"

d. Setup Cloudinary Storage

Buat akun di Cloudinary
Dapatkan Cloud Name dan buat Upload Preset
Ikuti panduan lengkap di CLOUDINARY_SETUP.md
