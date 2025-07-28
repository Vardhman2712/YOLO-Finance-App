# 💳 YOLO-Finace-APP

A complete full-stack Payment Dashboard system with role-based login (Admin/Viewer) using NestJS for the backend, MongoDB for the database, and Flutter for the frontend.

---

## ✨ Features

- 🔐 JWT-based secure authentication
- 👥 Role-based access (Admin / Viewer)
- 📊 Admin dashboard with:
  - Total Payments Summary
  - Total Transactions Count
  - Revenue Line Chart
- 📄 Transaction listing for all users
- ➕ Add new payments (Admin only)
- 🚪 Logout functionality with JWT clearing

---

## 🧱 Tech Stack

### 🔧 Backend
- [NestJS](https://nestjs.com/)
- MongoDB (via Mongoose)
- Passport.js & JWT for authentication

### 📱 Frontend
- [Flutter](https://flutter.dev/)
- RESTful API integration (http)
- State management with StatefulWidgets
- Role-based UI rendering
- Local storage using SharedPreferences
- Data visualization with `fl_chart`

---

## 📁 Project Structure

```bash
payment-dashboard/
├── payment-backend/            # NestJS Backend (API, Auth, MongoDB)
└── payment_dashboard_app/      # Flutter Frontend (UI, API Integration)
```

## ⚙️ Functionality Overview

| Feature                       | Admin | Viewer |
|------------------------------|:-----:|:------:|
| View Total Payments          | ✅     | ✅      |
| View Transactions List       | ✅     | ✅      |
| Add New Payment              | ✅     | ❌      |
| Revenue Line Chart           | ✅     | ❌      |
| Role-based Login             | ✅     | ✅      |
| Logout                       | ✅     | ✅      |

---

## 📌 Notes

- Responsive UI built with Flutter
- Backend and frontend run independently
- MongoDB Atlas used for cloud database
- Emphasizes clean architecture and reusable widgets

---

## 👨‍💻 Author

Built with ❤️ by Vardhman Jain  
📬 Reach out: vardhmanjain525@gmail.com  
☎️ +91-9990455542
