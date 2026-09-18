# Panduan Setup Jastip Wirosari

Dokumen ini berisi panduan langkah demi langkah untuk melakukan *setup* dan menjalankan proyek **Jastip Wirosari** di lingkungan lokal Anda. Proyek ini terdiri dari Backend (NestJS), Frontend Web Admin (Next.js/React), dan Aplikasi Mobile (Flutter).

---

## 1. Prasyarat Sistem

Pastikan Anda telah menginstal *software* berikut di perangkat Anda:
- **Node.js** (v18 atau lebih baru)
- **Flutter SDK** (v3.24.x)
- **PostgreSQL** (v15 atau lebih baru)
- **Docker** & **Docker Compose** (Untuk Redis dan MinIO)

---

## 2. Setup Database, Storage & Cache

Proyek ini menggunakan PostgreSQL untuk database, Redis untuk *caching*, dan MinIO untuk penyimpanan file (S3-compatible).

### a. Menjalankan Redis
Gunakan `docker-compose` bawaan di folder `backend` untuk menjalankan Redis (dan MinIO jika Anda tidak menginstal MinIO secara terpisah).
```bash
cd backend
docker compose up -d
```
*(Catatan: Jika Anda menggunakan PostgreSQL dan MinIO versi Anda sendiri, file `docker-compose.yml` telah disesuaikan agar hanya menjalankan container Redis saja).*

### b. Menyiapkan PostgreSQL
Buat database lokal baru bernama `jastip_db`.
Anda bisa membuatnya menggunakan pgAdmin, DBeaver, atau lewat CLI:
```sql
CREATE DATABASE jastip_db;
```

---

## 3. Setup Backend (NestJS)

Backend menangani API, koneksi database, dan autentikasi.

1. Buka terminal baru dan masuk ke folder `backend`:
   ```bash
   cd backend
   ```
2. Instal dependensi:
   ```bash
   npm install
   ```
3. Sesuaikan file `.env`. Pastikan kredensial `DATABASE_URL` dan `MINIO` sesuai dengan server Anda:
   ```env
   # Contoh:
   DATABASE_URL="postgresql://postgres:password_anda@localhost:5432/jastip_db"
   
   MINIO_ENDPOINT=localhost
   MINIO_PORT=9000
   MINIO_ACCESS_KEY=admin
   MINIO_SECRET_KEY=MinioPassword123!
   MINIO_BUCKET=jastip-media
   ```
4. Jalankan migrasi Prisma untuk membuat tabel-tabel di database:
   ```bash
   npx prisma migrate dev --name init
   ```
   *(Atau `npx prisma db push --accept-data-loss` jika tidak ingin riwayat migrasi)*
5. Jalankan *Seeding* untuk mengisi data awal (Kategori, Produk, User, dll):
   ```bash
   npm run prisma:seed
   ```
6. Jalankan server Backend (akan aktif di port `3000`):
   ```bash
   npm run start:dev
   ```

---

## 4. Setup Frontend Web Admin (Next.js)

Web admin digunakan oleh admin jastip untuk memantau pesanan dan produk.

1. Buka terminal baru dan masuk ke folder `admin`:
   ```bash
   cd admin
   ```
2. Instal dependensi:
   ```bash
   npm install
   ```
3. Sesuaikan file `.env` (Jika belum ada, buat `.env.local` yang menunjuk ke API backend):
   ```env
   NEXT_PUBLIC_API_URL=http://localhost:3000/api
   ```
4. Jalankan server Web Admin (akan aktif di port `3001` atau port acak lainnya):
   ```bash
   npm run dev
   ```

---

## 5. Setup Mobile App (Flutter)

Aplikasi mobile (Android/iOS) digunakan oleh Customer dan Mitra.

1. Buka terminal baru dan masuk ke direktori utama (folder Flutter):
   ```bash
   cd jastip_application
   ```
2. Unduh semua *packages*:
   ```bash
   flutter pub get
   ```
3. Konfigurasi alamat IP API. Buka file `lib/core/config/app_config.dart` dan sesuaikan IP dengan perangkat yang Anda gunakan (misalnya `10.0.2.2` untuk Android Emulator, atau `localhost` untuk Web/Chrome).
4. Jalankan aplikasi:
   - Menggunakan emulator Android/iOS:
     ```bash
     flutter run
     ```
   - Menggunakan Chrome (Web):
     ```bash
     flutter run -d chrome
     ```

---

## 6. Kredensial Login Default

Setelah proses *seeding* database berhasil, gunakan kredensial berikut untuk menguji coba login di aplikasi Flutter:

| Role | Nomor Telepon | Password |
| :--- | :--- | :--- |
| **Admin** | `081111111111` | `admin123` |
| **Mitra** | `082222222222` | `mitra123` |
| **Customer** | `083333333333` | `customer123` |

Selamat! Aplikasi Jastip Wirosari sudah siap digunakan di perangkat lokal Anda.
