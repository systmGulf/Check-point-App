# Check Point - Employee Management System

![systm gulf](https://github.com/user-attachments/assets/b076e4e2-4e12-4c04-af1c-ce4b41c6775d)

A comprehensive **HR & Employee Management System** built with Flutter, supporting three user roles with real-time attendance tracking, leave management, task assignment, and more.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Environment Configuration](#environment-configuration)
- [Screenshots](#screenshots)

---

## Overview

Check Point is a multi-role mobile application designed for organizations to manage employee attendance, leave requests, task assignments, and workforce operations. The app uses **GPS-based geofencing** to validate employee check-ins and supports **real-time location tracking**.

### Supported Roles

| Role | Description |
|------|-------------|
| **Admin** | Full control over employees, departments, shifts, branches, clients, and policies |
| **Employee** | Check-in/out, leave requests, claims, incidents, tasks, and plan feedback |
| **Supervisor** | Team attendance, task assignment, request approval, plans, and leaderboard |

---

## Features

### Authentication & Onboarding
- Role-based login (Admin, Employee, Supervisor)
- Animated onboarding flow
- Account registration with device binding
- Multi-language support (English & Arabic with RTL)

### Admin Panel
- **Employee Management** - Add, edit, delete, search with pagination
- **Department Management** - CRUD operations with supervisor permission control
- **Shift & Policy Management** - Create shifts, define clock-in/out policies, assign branches
- **Branch Management** - Map-based branch creation with geofence polygons
- **Client & Site Management** - Manage customer locations and work sites
- **Holiday Management** - Define company holidays
- **Notification Broadcasting** - Send push notifications to users
- **Account Request Approval** - Review and approve new account registrations

### Employee Features
- **Attendance** - GPS-validated check-in/out at office, customer, or site locations with photo capture
- **Leave Management** - Submit leave requests, view planner & schedule
- **Claims & Incidents** - Submit claims and report personal/team incidents
- **Tasks** - View assigned tasks, update status
- **Plans** - View customer visit plans with feedback submission
- **Workflow** - Document submission with file attachments
- **Profile** - Image upload, password change, notification preferences

### Supervisor Features
- **Team Attendance** - View department attendance, check-in on behalf of employees
- **Late Comers & Early Leavers** - Track attendance violations
- **Task Management** - Create, assign, edit, delete tasks with priority levels
- **Request Approval** - Approve/reject leave requests, claims, and incidents
- **Plan Management** - Create plans, assign customers, review feedback
- **Leaderboard** - Gamification with employee rankings and achievements
- **Excel Export** - Export attendance reports to Excel and share

### Cross-Platform
- Infinite scroll pagination
- Skeleton loading animations
- Offline detection with retry
- Background location tracking service
- Pull-to-refresh on list screens

---

## Architecture

```
Clean Architecture + BLoC Pattern
```

```
lib/
├── core/                          # Shared utilities & configuration
│   ├── contoller/                 # Global cubits (login, etc.)
│   ├── cubits/                    # Shared cubits (image upload, etc.)
│   ├── dependency_injection/      # GetIt service locator setup
│   ├── routing/                   # App router & route definitions
│   ├── utils/                     # Constants, styles, colors, assets
│   ├── widgets/                   # Reusable UI components
│   └── common/                    # Services (Excel export, etc.)
│
├── features/
│   ├── intro/                     # Onboarding & registration
│   ├── splash/                    # Splash screen
│   └── user_role/
│       ├── admin/
│       │   ├── admin_auth/        # Admin login
│       │   └── admin_home/
│       │       ├── atomic_ui/     # Atomic design (atoms → molecules → organisms → pages)
│       │       └── controllers/   # Admin cubits (employee, department, branch, etc.)
│       │
│       ├── employee/
│       │   ├── employee_auth/     # Employee login
│       │   └── employee_home/
│       │       ├── atomic_ui/     # UI components & pages
│       │       └── controller/    # Employee cubits (attendance, leave, tasks, etc.)
│       │
│       └── supervisor/
│           ├── supervisor_auth/   # Supervisor login
│           └── supervisor_home/
│               ├── atomic_ui/     # UI components & pages
│               └── contoller/     # Supervisor cubits (tasks, plans, attendance, etc.)
│
└── l10n/                          # Localization files
```

---

## Tech Stack

| Category | Libraries |
|----------|-----------|
| **State Management** | `flutter_bloc`, `get_it` |
| **Networking** | `http`, `dio` (via HR package), `connectivity_plus` |
| **Maps & Location** | `google_maps_flutter`, `location`, `geocoding`, `geolocator` |
| **UI & Animation** | `flutter_screenutil`, `flutter_svg`, `lottie`, `animate_do`, `skeletonizer` |
| **Charts** | `fl_chart`, `pie_chart`, `percent_indicator` |
| **Images** | `image_picker`, `cached_network_image` |
| **Files & Export** | `excel`, `spreadsheet_decoder`, `share_plus` |
| **Storage** | `shared_preferences`, `flutter_secure_storage` |
| **Localization** | `easy_localization`, `intl` |
| **Pagination** | `infinite_scroll_pagination` |
| **Permissions** | `permission_handler`, `device_info_plus` |
| **Web** | `url_launcher`, `webview_flutter` |
| **Notifications** | `fluttertoast`, `top_snackbar_flutter` |

### Core Package

The app relies on a custom HR management package:

```yaml
hr_management_system_package:
  path: <local_path>
  # or
  git:
    url: https://github.com/systmGulf/Check-point-package
    ref: TOT
```

This package provides:
- Dio HTTP client configuration
- Repository layer (Employee, Department, Branch, Customer, Attendance, etc.)
- Data models & entities
- API endpoint definitions

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.4.0 <4.0.0`
- Android Studio / VS Code
- Google Maps API key
- Clone the [Check-point-package](https://github.com/systmGulf/Check-point-package) locally

### Installation

```bash
# Clone the repository
git clone https://github.com/systmGulf/Check-point-App.git

# Navigate to project directory
cd Check-point-App

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Google Maps Setup

**Android** - Add your API key in `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY"/>
```

**iOS** - Add your API key in `ios/Runner/AppDelegate.swift`:
```swift
GMSServices.provideAPIKey("YOUR_API_KEY")
```

---

## Environment Configuration

The app supports two environments:

| Environment | Base URL |
|-------------|----------|
| **Development** | `http://emsdemo.runasp.net/api/` |
| **Production** | `http://ems.runasp.net/api/` |

Environment is configured in `main.dart` via `EnvironmentType`.

---

## API Endpoints

| Module | Key Endpoints |
|--------|--------------|
| **Auth** | `POST Auth/Login`, `PUT Auth/ChangePassword`, `DELETE Auth/DeleteUser/{id}` |
| **Employee** | `GET/POST/PUT/DELETE Employee`, `GET Employee/search/{key}` |
| **Attendance** | `POST Attendance/in`, `POST Attendance/out`, `GET Attendance/attendanceSummary` |
| **Department** | `GET/POST/PUT/DELETE Department` |
| **Shift** | `GET/POST/DELETE Shift`, `POST Shift/assignShift` |
| **Policy** | `GET/POST/PUT/DELETE Policy`, `POST Policy/assignPolicy` |
| **Leave** | `POST/GET/DELETE LeaveRequest`, `PUT LeaveRequest/leaveRequestStatus` |
| **Task** | `POST/GET/DELETE Task`, `POST Task/assignTask`, `PUT Task/updateStatus` |
| **Plan** | `POST/GET/DELETE Plan`, `POST customerPlan` |
| **Customer** | `GET/POST/PUT/DELETE Customer` |
| **Branch** | `GET/POST/DELETE Branch` |
| **Notification** | `POST Notification/sendSingle`, `POST Notification/sendMulti` |
| **Feedback** | `POST Feedback`, `GET Feedback/feedbackStatus` |

---

## Screenshots

<!-- Add your screenshots here -->
<!-- | Admin Home | Employee Check-in | Supervisor Dashboard | -->
<!-- |:---:|:---:|:---:| -->
<!-- | ![admin](url) | ![employee](url) | ![supervisor](url) | -->

---

## License

This project is proprietary software developed by **Systm Gulf**.

---

> Built with Flutter & Dart
