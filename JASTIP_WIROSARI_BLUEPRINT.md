# JASTIP WIROSARI — PROJECT BLUEPRINT

> Mobile app layanan personal shopper / jastip dan delivery area Wirosari dan sekitarnya.
>
> **Mobile:** Flutter  
> **Backend:** NestJS  
> **Database:** PostgreSQL  
> **ORM:** Prisma  
> **Admin:** Next.js  
> **Cache:** Redis  
> **Storage:** MinIO / S3  
> **Notification:** Firebase Cloud Messaging  
> **Deployment:** Docker

---

## 1. Konsep Produk

Jastip Wirosari adalah aplikasi yang memungkinkan customer:

1. Memilih kebutuhan dari toko.
2. Memasukkan barang ke keranjang.
3. Melakukan custom request jika barang tidak tersedia di katalog.
4. Menentukan alamat pengantaran.
5. Melakukan checkout.
6. Memantau status pesanan.
7. Menerima barang melalui mitra Jastip.

Konsep utama:

```text
Customer
   |
   v
Pilih Produk / Custom Jastip
   |
   v
Checkout
   |
   v
Order
   |
   v
Mitra menerima order
   |
   v
Belanja
   |
   v
Delivery
   |
   v
Customer menerima barang
```

---

# 2. Aktor Sistem

## Customer

Fitur:

- Register / Login
- Melihat toko
- Melihat produk
- Search produk
- Keranjang
- Checkout
- Custom Jastip
- Mengelola alamat
- Melihat riwayat order
- Melihat detail order
- Melihat status delivery
- Profile

## Mitra Jastip

Fitur:

- Login
- Online / Offline
- Melihat order masuk
- Menerima order
- Melihat detail belanja
- Update status order
- Menangani custom Jastip
- Delivery
- Melihat riwayat pekerjaan

> Pada MVP, shopper dan driver dapat digabung menjadi satu role: `MITRA`.

## Admin

Fitur:

- Dashboard
- Customer management
- Mitra management
- Store management
- Product management
- Category management
- Order management
- Area management
- Promo management
- Report

---

# 3. Arsitektur Sistem

```text
                         JASTIP WIROSARI
                                |
             +------------------+------------------+
             |                  |                  |
             v                  v                  v
       Flutter Customer   Flutter Mitra       Next.js Admin
             |                  |                  |
             +------------------+------------------+
                                |
                              HTTPS
                                |
                                v
                         NestJS REST API
                                |
              +-----------------+-----------------+
              |                 |                 |
              v                 v                 v
        PostgreSQL            Redis           MinIO/S3
          + Prisma            Cache             Images
              |
              v
          Application Data

Firebase FCM
      |
      +----> Customer notifications
      |
      +----> Mitra notifications
```

---

# 4. Technology Stack

| Layer | Technology |
|---|---|
| Mobile | Flutter |
| State Management | Riverpod |
| Navigation | GoRouter |
| Backend | NestJS |
| API | REST API |
| Database | PostgreSQL |
| ORM | Prisma |
| Cache | Redis |
| Authentication | JWT |
| Notification | Firebase FCM |
| File Storage | MinIO / S3 |
| Admin | Next.js |
| Container | Docker |
| Reverse Proxy | Nginx / Caddy |

---

# 5. Flutter Architecture

Gunakan feature-based architecture.

```text
mobile/
└── lib/
    ├── core/
    │   ├── config/
    │   ├── constants/
    │   ├── network/
    │   ├── storage/
    │   ├── theme/
    │   ├── utils/
    │   └── widgets/
    │
    ├── features/
    │   ├── auth/
    │   │   ├── data/
    │   │   ├── domain/
    │   │   └── presentation/
    │   │
    │   ├── home/
    │   ├── stores/
    │   ├── categories/
    │   ├── products/
    │   ├── cart/
    │   ├── checkout/
    │   ├── orders/
    │   ├── tracking/
    │   ├── jastip/
    │   ├── addresses/
    │   └── profile/
    │
    ├── routes/
    └── main.dart
```

### Pola data

```text
UI
 |
 v
Riverpod
 |
 v
Repository
 |
 v
API Client
 |
 v
NestJS API
```

---

# 6. Backend Architecture

```text
backend/
└── src/
    ├── auth/
    ├── users/
    ├── addresses/
    ├── stores/
    ├── categories/
    ├── products/
    ├── carts/
    ├── orders/
    ├── payments/
    ├── deliveries/
    ├── mitras/
    ├── notifications/
    ├── promotions/
    ├── areas/
    ├── reports/
    ├── common/
    │   ├── guards/
    │   ├── decorators/
    │   ├── filters/
    │   ├── interceptors/
    │   └── utils/
    │
    ├── app.module.ts
    └── main.ts
```

---

# 7. Database

Database utama:

**PostgreSQL**

ORM:

**Prisma**

## Relasi utama

```text
users
 |
 +---- addresses
 |
 +---- orders
         |
         +---- order_items
         |
         +---- payments
         |
         +---- deliveries

stores
 |
 +---- products
        |
        +---- categories

mitras
 |
 +---- orders
 |
 +---- deliveries
```

---

# 8. Database Schema

## users

```text
id
name
phone
email
password_hash
role
status
created_at
updated_at
```

Role:

```text
CUSTOMER
MITRA
ADMIN
```

---

## addresses

```text
id
user_id
label
recipient_name
phone
address
latitude
longitude
note
is_default
created_at
updated_at
```

---

## stores

```text
id
name
description
address
latitude
longitude
image
status
created_at
updated_at
```

---

## categories

```text
id
name
image
status
created_at
updated_at
```

---

## products

```text
id
store_id
category_id
name
description
price
image
stock
status
created_at
updated_at
```

---

## orders

```text
id
order_number
user_id
mitra_id
address_id
order_type
status
subtotal
service_fee
delivery_fee
discount
total
customer_note
created_at
updated_at
```

Order type:

```text
PRODUCT
CUSTOM_JASTIP
```

---

## order_items

```text
id
order_id
product_id
product_name
qty
estimated_price
actual_price
subtotal
note
```

---

## payments

```text
id
order_id
method
amount
status
transaction_id
paid_at
created_at
```

---

## deliveries

```text
id
order_id
mitra_id
status
pickup_lat
pickup_lng
destination_lat
destination_lng
picked_up_at
delivered_at
note
```

---

## mitras

Jika mitra dipisahkan dari `users`:

```text
id
user_id
vehicle_type
vehicle_number
is_online
rating
created_at
updated_at
```

---

# 9. Order State Machine

Status order:

```text
PENDING
    |
    v
CONFIRMED
    |
    v
SHOPPING
    |
    v
READY_TO_DELIVER
    |
    v
ON_DELIVERY
    |
    v
DELIVERED
```

Cancellation:

```text
PENDING ------> CANCELLED
CONFIRMED ----> CANCELLED
```

Untuk custom Jastip:

```text
CUSTOMER REQUEST
       |
       v
WAITING_QUOTE
       |
       v
WAITING_APPROVAL
       |
       v
CONFIRMED
       |
       v
SHOPPING
```

---

# 10. Customer Flow

## Login

```text
Splash
  |
  v
Onboarding
  |
  +---- Login
  |
  +---- Register
  |
  v
Home
```

## Product Order

```text
Home
 |
 v
Store
 |
 v
Product
 |
 v
Cart
 |
 v
Checkout
 |
 +---- Address
 +---- Note
 +---- Delivery fee
 +---- Payment
 |
 v
Order Created
 |
 v
Order Tracking
```

---

# 11. Custom Jastip

Customer dapat membuat request barang yang tidak ada di katalog.

Contoh:

```text
Barang:
Minyak Bimoli 2 Liter

Toko:
Indomaret Wirosari

Jumlah:
2

Catatan:
Jika merek tidak tersedia,
boleh diganti dengan merek lain.

Foto:
optional
```

Flow:

```text
Customer
   |
   v
Custom Request
   |
   v
Mitra/Admin
   |
   v
Cek barang
   |
   v
Actual price / quote
   |
   v
Customer approval
   |
   v
Shopping
   |
   v
Delivery
```

---

# 12. Pricing

Gunakan formula:

```text
TOTAL =
SUBTOTAL
+ SERVICE_FEE
+ DELIVERY_FEE
- DISCOUNT
```

Untuk custom order:

```text
ESTIMATED TOTAL
       |
       v
Mitra melakukan pembelian
       |
       v
ACTUAL TOTAL
       |
       v
Customer approval jika diperlukan
```

---

# 13. Delivery Area

Karena layanan awal fokus pada Wirosari dan sekitarnya, gunakan sistem area/zona.

Contoh:

```text
areas
├── id
├── name
├── description
├── base_fee
├── max_distance
└── status
```

Contoh konfigurasi:

```text
Zone A
0 - 2 km
Rp5.000

Zone B
2 - 5 km
Rp8.000

Zone C
5 - 8 km
Rp12.000
```

Nilai di atas adalah contoh dan dapat diubah melalui Admin Dashboard.

---

# 14. Payment

MVP:

```text
COD
```

Tahap berikutnya:

```text
QRIS
Transfer Bank
E-Wallet
Payment Gateway
```

Payment status:

```text
PENDING
PAID
FAILED
REFUNDED
```

---

# 15. Notification

Gunakan Firebase Cloud Messaging.

Event:

```text
ORDER_CREATED
ORDER_ACCEPTED
ORDER_SHOPPING
ORDER_READY
ORDER_ON_DELIVERY
ORDER_DELIVERED
ORDER_CANCELLED
PAYMENT_SUCCESS
CUSTOM_REQUEST_QUOTE
CUSTOM_REQUEST_APPROVAL
```

Contoh:

```text
🔔 Pesanan diterima
Mitra sedang memproses pesanan kamu.
```

---

# 16. Tracking

## MVP

Gunakan tracking berbasis status.

```text
Order Created
     ↓
Confirmed
     ↓
Shopping
     ↓
Ready
     ↓
On Delivery
     ↓
Delivered
```

## Future

Tambahkan realtime GPS:

```text
Mitra GPS
    |
    v
NestJS
    |
    v
WebSocket
    |
    v
Flutter Customer
```

---

# 17. REST API

## Auth

```http
POST /auth/register
POST /auth/login
POST /auth/refresh
POST /auth/logout
```

## Users

```http
GET    /users/me
PUT    /users/me
```

## Addresses

```http
GET    /addresses
POST   /addresses
GET    /addresses/:id
PUT    /addresses/:id
DELETE /addresses/:id
```

## Stores

```http
GET /stores
GET /stores/:id
```

## Categories

```http
GET /categories
GET /categories/:id
```

## Products

```http
GET /products
GET /products/:id
```

## Cart

```http
GET    /cart
POST   /cart/items
PUT    /cart/items/:id
DELETE /cart/items/:id
```

## Orders

```http
POST /orders
GET  /orders
GET  /orders/:id
POST /orders/:id/cancel
```

## Custom Jastip

```http
POST /orders/custom
GET  /orders/custom
POST /orders/:id/quote
POST /orders/:id/approve
```

## Mitra

```http
PUT  /mitras/status
GET  /mitras/orders
POST /mitras/orders/:id/accept
PUT  /mitras/orders/:id/status
```

---

# 18. Admin Dashboard

Gunakan Next.js.

```text
admin/
├── dashboard
├── users
├── mitras
├── stores
├── categories
├── products
├── orders
├── deliveries
├── payments
├── promotions
├── areas
├── reports
└── settings
```

Dashboard menampilkan:

```text
Total Order
Order Hari Ini
Revenue
Customer
Mitra Aktif
Order Pending
Order Delivery
```

---

# 19. Folder Project

Recommended monorepo:

```text
jastip-wirosari/
│
├── mobile/
│   └── Flutter
│
├── backend/
│   └── NestJS
│
├── admin/
│   └── Next.js
│
├── infrastructure/
│   ├── docker/
│   ├── nginx/
│   └── postgres/
│
├── docs/
│   ├── API.md
│   ├── DATABASE.md
│   ├── ERD.md
│   └── DEPLOYMENT.md
│
├── docker-compose.yml
└── README.md
```

---

# 20. MVP Scope

## Customer

- [ ] Register / Login
- [ ] Home
- [ ] Categories
- [ ] Stores
- [ ] Products
- [ ] Search
- [ ] Cart
- [ ] Checkout
- [ ] Address
- [ ] Custom Jastip
- [ ] Order history
- [ ] Order detail
- [ ] Order status
- [ ] Profile

## Mitra

- [ ] Login
- [ ] Online / Offline
- [ ] Incoming orders
- [ ] Accept order
- [ ] Shopping
- [ ] Update order
- [ ] Delivery
- [ ] Order history

## Admin

- [ ] Login
- [ ] Dashboard
- [ ] Customer
- [ ] Mitra
- [ ] Store
- [ ] Product
- [ ] Category
- [ ] Order
- [ ] Area
- [ ] Report

---

# 21. Fitur Setelah MVP

Jangan langsung dibuat pada versi pertama.

```text
[ ] Live GPS tracking
[ ] Rating & review
[ ] Promo / voucher
[ ] Loyalty point
[ ] Wallet
[ ] Subscription
[ ] Referral
[ ] Multi-store checkout
[ ] Advanced analytics
[ ] Automated commission
[ ] Payment gateway
[ ] Chat customer-mitra
[ ] Scheduled delivery
```

---

# 22. Development Roadmap

## Phase 1 — Foundation

```text
Flutter project
NestJS project
PostgreSQL
Prisma
JWT
Docker
Environment configuration
```

## Phase 2 — Authentication

```text
Register
Login
Refresh token
Role
Authorization
```

## Phase 3 — Catalog

```text
Store
Category
Product
Search
```

## Phase 4 — Customer Order

```text
Cart
Address
Checkout
Order
Order history
```

## Phase 5 — Custom Jastip

```text
Custom request
Quote
Approval
Actual price
```

## Phase 6 — Mitra

```text
Mitra dashboard
Order assignment
Accept order
Shopping
Delivery
```

## Phase 7 — Notification

```text
Firebase FCM
Order notification
Status notification
```

## Phase 8 — Admin

```text
Dashboard
CRUD
Order management
Mitra management
Reports
```

## Phase 9 — Production

```text
Docker
Reverse proxy
SSL
Backup
Monitoring
Logging
CI/CD
```

---

# 23. Database Recommendation

Untuk project ini gunakan:

## PostgreSQL

Alasan:

- Relational data sangat kuat.
- Cocok untuk transaksi order.
- Cocok untuk reporting.
- Foreign key dan constraint kuat.
- Cocok dengan Prisma.
- Mudah di-deploy menggunakan Docker.
- Bisa dikembangkan untuk geospatial menggunakan PostGIS jika nanti membutuhkan fitur lokasi yang lebih kompleks.

Alternatif:

### Supabase

Cocok jika ingin MVP lebih cepat karena sudah menyediakan:

```text
PostgreSQL
Auth
Storage
Realtime
API
```

### Firebase

Cocok untuk prototype cepat, tetapi struktur order Jastip akan lebih nyaman dikelola menggunakan relational database seperti PostgreSQL.

---

# 24. Recommended Final Stack

```text
                    ┌─────────────────┐
                    │ Flutter Customer│
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │   Flutter Mitra │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │   NestJS API    │
                    └────────┬────────┘
                             │
          ┌──────────────────┼──────────────────┐
          ▼                  ▼                  ▼
    PostgreSQL             Redis              MinIO
       Prisma              Cache              Storage
          │
          ▼
     Application DB

          +
    Firebase FCM

          +

      Next.js Admin
```

**Final recommendation:**

```text
Flutter
+
Riverpod
+
NestJS
+
PostgreSQL
+
Prisma
+
Redis
+
MinIO
+
Firebase FCM
+
Next.js Admin
+
Docker
```

---

# 25. Prinsip Pengembangan

1. Jadikan `Order` sebagai pusat bisnis, bukan hanya `Product`.
2. Pisahkan `estimated_price` dan `actual_price`.
3. Support `PRODUCT` dan `CUSTOM_JASTIP`.
4. Gunakan role-based authorization.
5. Jangan implementasi live GPS pada MVP.
6. Gunakan PostgreSQL sebagai source of truth.
7. Gunakan Redis hanya untuk cache/session/temporary data.
8. Gunakan object storage untuk foto produk dan foto custom request.
9. Semua perubahan status order dicatat secara konsisten.
10. Siapkan struktur agar nantinya bisa berkembang dari layanan Wirosari menjadi layanan multi-area.

---

## Target MVP

```text
Customer
   ↓
Browse Store
   ↓
Select Product
   ↓
Cart
   ↓
Checkout
   ↓
Order
   ↓
Mitra
   ↓
Shopping
   ↓
Delivery
   ↓
Customer

+

Custom Jastip
```

Setelah alur ini stabil, baru tambahkan payment gateway, GPS tracking, promo, rating, dan fitur bisnis lainnya.
