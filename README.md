# 🎨 ColorMate

**ColorMate – Explore Colors, Create Palettes, and Save Your Creativity.**

ColorMate merupakan aplikasi mobile berbasis Flutter yang dikembangkan untuk membantu pengguna mengeksplorasi warna, melihat informasi detail warna, membuat kombinasi palet warna, serta menyimpan koleksi palet warna digital.

Project ini dibuat untuk memenuhi tugas **Ujian Tengah Semester (UTS) Pemrograman Mobile**.

## 👩‍💻 Identitas Pengembang

| Keterangan | Detail |
|---|---|
| Nama | Ni Komang Trisna Cahyani |
| NIM | 2415051072 |
| Kelas | PTI 5 B |
| Program Studi | Pendidikan Teknik Informatika |
| Universitas | Universitas Pendidikan Ganesha |
| Dosen Pengampu | Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom |

## ✨ Fitur Aplikasi

- **Explore Colors:** Menjelajahi berbagai pilihan warna.
- **Color Detail:** Melihat informasi dan kode warna.
- **Color Picker:** Memilih warna serta melihat kode HEX dan RGB.
- **Palette Generator:** Membuat kombinasi palet warna digital.
- **Color Collection:** Mengelola koleksi warna.
- **Palette Collection:** Menyimpan dan mengelola palet warna.
- **CRUD Database:** Menambahkan, melihat, mengubah, dan menghapus koleksi palet warna.

## 🛠️ Teknologi yang Digunakan

- Flutter
- Dart
- Provider
- Material Design 3
- REST API
- Supabase
- PostgreSQL
- Git & GitHub

## 🌐 REST API

ColorMate menggunakan **The Color API** untuk memperoleh informasi dan kombinasi warna.

- API: The Color API
- Endpoint: `https://www.thecolorapi.com/scheme`
- Method: GET
- Format data: JSON

## 🗄️ Backend dan Database

ColorMate menggunakan Supabase sebagai backend dengan PostgreSQL sebagai database.

Operasi database yang diterapkan:
- Create: Menambahkan koleksi palet warna.
- Read: Menampilkan data palet tersimpan.
- Update: Mengubah data palet.
- Delete: Menghapus data palet.

## 🏗️ Arsitektur Aplikasi

Project menggunakan arsitektur berlapis dengan Provider, Repository, dan Service.

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

**UI → Provider → Repository → Service → API / Supabase**

## 📸 Screenshots Aplikasi

### Home / Explore
![Home](screenshots/home.png)

### Explore Colors
![Explore Colors](screenshots/explore.png)

### Color Detail
![Color Detail](screenshots/detail.png)

### Create Palette
![Create Palette](screenshots/create.png)

### Edit Palette
![Edit Palette](screenshots/edit.png)

### Collection
![Collection](screenshots/collection.png)

### Responsive Layout
![Responsive Layout](screenshots/responsive.png)

## 🚀 Cara Menjalankan Project

Clone repository:

```bash
git clone https://github.com/trisnacahyani-ops/colormate.git
```

Masuk ke folder project:

```bash
cd colormate
```

Install dependencies:

```bash
flutter pub get
```

Pastikan konfigurasi Supabase sudah disesuaikan dengan project.

Jalankan aplikasi:

```bash
flutter run
```

## 📦 Build APK

Untuk membuat APK release:

```bash
flutter build apk --release
```

File APK akan tersedia di:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## 🔗 Repository

GitHub: https://github.com/trisnacahyani-ops/colormate

---

**ColorMate – Explore Colors, Create Palettes, and Save Your Creativity.**

Developed by Ni Komang Trisna Cahyani  
Ujian Tengah Semester – Pemrograman Mobile  
Universitas Pendidikan Ganesha