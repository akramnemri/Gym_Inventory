# Gym Inventory Management System

[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Express.js](https://img.shields.io/badge/Express.js-4.x-000000?style=for-the-badge&logo=express&logoColor=white)](https://expressjs.com/)
[![Node.js](https://img.shields.io/badge/Node.js-18+-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)](https://nodejs.org/)

A full-stack inventory app for managing gym components and assembled products, with role-based access, BOM tracking, and a complete audit trail.

---

## Walkthrough Guide

### 1. Admin: Add Components & Build Products
- Log in as **admin** and open the **Components** screen.
- Add parts (e.g. "M8 Bolt") with type, dimensions, stock, and specs.
- Go to **Components Screen** to create a **Final Product** (e.g. "Treadmill Frame") and define its **Bill of Materials** by linking required components with quantities.
- The system validates every reference and calculates material needs automatically.

### 2. User: Log Stock Movements
- Log in as a **user** and open **Stock Movements**.
- Record **stock-in** on receipt (e.g. +50 bolts) or **stock-out** during assembly (e.g. -4 bolts per unit).
- Movements are saved permanently with user, timestamp, and component/product reference.

### 3. Everyone: Track Sessions & Audit History
- Every login creates a **session log** with login/logout times.
- All actions (creations, movements, updates) are tied to the active user.
- Use **Session Logs** to review activity, peak hours, and accountability.

### 4. Admins: Manage Users & Security
- Create accounts with **User** or **Admin** roles.
- Send password-reset links via the built-in **Secure Password Reset** system (tokens expire automatically).
- Use **Low Stock** and **Account Settings** to monitor thresholds and profile data.

---

## Tech Stack

| Layer | Tech | Purpose |
|-------|------|---------|
| Database | MySQL 8.0 | Persistent storage |
| Backend | Node.js + Express | REST API + auth middleware |
| Frontend | Flutter (Desktop) | Cross-platform UI |
| Auth | JWT | Secure sessions |
| Uploads | Multer | Image handling |
| Email | Nodemailer | Password resets |

---

## Setup

### Prerequisites
- Node.js 18+
- MySQL 8.0+
- Flutter SDK 3.0+

### Backend
```bash
cd Backend
npm install
cp .env.example .env          # add DB credentials
mysql -u root -p < database/schema.sql
npm start
```

### Frontend
```bash
cd Frontend/gym_frontend
flutter pub get
flutter run -d windows        # or -d macos / -d linux
```

---

## Future Ideas
- Low-stock alerts & auto-reorder
- Barcode / QR scanning
- Reporting dashboard & analytics
- Multi-warehouse support
- Supplier integration
