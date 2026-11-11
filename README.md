# 🎨 ColorMate

**Explore Colors, Create Palettes, and Save Your Creativity.**

ColorMate merupakan aplikasi berbasis Flutter yang membantu pengguna mengeksplorasi warna, melihat informasi detail warna, membuat kombinasi palet, serta menyimpan warna dan palet favorit.

## 👩‍💻 Project Identity

| Keterangan | Informasi |
|---|---|
| Nama | Ni Komang Trisna Cahyani |
| NIM | 2415051072 |
| Kelas | PTI 5 B |
| Program Studi | Pendidikan Teknik Informatika |
| Jurusan | Teknik Informatika |
| Fakultas | Teknik dan Kejuruan |
| Universitas | Universitas Pendidikan Ganesha |
| Mata Kuliah | Pemrograman Mobile |
| Dosen Pengampu | Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom. |

## ✨ Features

- **Explore Colors** – Menjelajahi berbagai pilihan warna.
- **Color Detail** – Melihat informasi detail dari warna yang dipilih.
- **Color Picker** – Memilih dan mendapatkan informasi warna.
- **Palette Generator** – Membuat kombinasi palet warna.
- **Color Collection** – Menyimpan dan mengelola koleksi warna.
- **Palette Collection** – Menyimpan dan mengelola koleksi palet.
- **CRUD Operations** – Menambahkan, melihat, memperbarui, dan menghapus data koleksi.
- **Responsive Design** – Mendukung tampilan desktop dan perangkat mobile.

## 🛠️ Technologies

- Flutter
- Dart
- Material Design 3
- Provider
- REST API
- Supabase
- PostgreSQL
- Git & GitHub

## 🌐 API Integration

ColorMate menggunakan **The Color API** untuk mendapatkan informasi dan kombinasi warna.

API Endpoint:

`https://www.thecolorapi.com/scheme`

Metode yang digunakan adalah GET dengan format respons JSON.

## 🗄️ Database

ColorMate menggunakan Supabase sebagai backend dan PostgreSQL sebagai database.

Database digunakan untuk menyimpan serta mengelola data koleksi warna dan palet melalui operasi CRUD.

## 🏗️ Project Architecture

Project menggunakan pemisahan tanggung jawab dengan pola Provider, Repository, dan Service.

```text
lib/
├── config/
├── models/
├── providers/
├── repositories/
├── screens/
├── services/
├── widgets/
└── main.dart
```

Alur arsitektur:

```text
Screens
   ↓
Providers
   ↓
Repositories
   ↓
Services
   ↓
REST API / Supabase
```

## 📸 Application Screenshots

### 1. Home
![Home](screenshots/HOME.png)

### 2. Explore Colors
![Explore Colors](screenshots/EXPLORE_COLORS.png)

### 3. Color Detail
![Color Detail](screenshots/COLOR_DETAIL.png)

### 4. Color Picker
![Color Picker](screenshots/COLOR_PICKER.png)

### 5. Palette Generator
![Palette Generator](screenshots/PALETTE_GENERATOR.png)

### 6. Color Collection
![Color Collection](screenshots/COLOR_COLLECTION.png)

### 7. Palette Collection
![Palette Collection](screenshots/PALETTE_COLLECTION.png)

### 8. Responsive Design

**Desktop View**

![Desktop](screenshots/RESPONSIVE_DESKTOP.png)

**Mobile View**

![Mobile](screenshots/RESPONSIVE_MOBILE.png)

### 9. API Integration
![API Integration](screenshots/API_INTEGRATION.png)

### 10. Supabase Database
![Supabase Database](screenshots/SUPABASE_DATABASE.png)

## 🚀 How to Run

Pastikan Flutter dan Dart sudah terpasang di perangkat.

1. Clone repository:

```bash
git clone https://github.com/trisnacahyani-ops/colormate.git
```

2. Masuk ke folder project:

```bash
cd colormate
```

3. Install dependencies:

```bash
flutter pub get
```

4. Jalankan aplikasi:

```bash
flutter run
```

## 📱 Build APK

Untuk membuat APK release, jalankan:

```bash
flutter build apk --release
```

Hasil APK tersedia di:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## 🌍 Live Demo

Aplikasi versi web dapat diakses melalui:

https://inquisitive-crisp-18e26b.netlify.app/

## 🔗 GitHub Repository

https://github.com/trisnacahyani-ops/colormate

---

**ColorMate — Explore Colors, Create Palettes, and Save Your Creativity.**