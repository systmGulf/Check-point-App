# Check-Point (Art Attack) HR & Attendance Management System
## Complete Application Specifications, Feature Catalog & UX/UI Redesign Blueprint

> **Document Version:** 1.0.0  
> **Target Audience:** UI/UX Designers, Frontend Developers, Mobile Engineers, Product Managers  
> **Workspace:** `/home/osama/Desktop/Projects-live/Check-point-App`  

---

## 1. Executive Summary & App Overview

**Check-Point (Art Attack HR & Attendance Management System)** is an enterprise-grade mobile solution built with Flutter for Android and iOS. It delivers real-time attendance verification, biometric and GPS location validation, anti-spoofing security, multi-role task management, multi-branch policy controls, leave/claim processing, and comprehensive workforce analytics.

### Key Objectives of the App:
1. **Workforce Geofencing & Time Tracking:** Secure employee check-in and check-out with GPS geolocation, office bounds verification, site visits, and mock location prevention.
2. **Multi-Role Governance:** Distinct interfaces, permissions, and features tailored for three primary personas: **Admin**, **Supervisor**, and **Employee**.
3. **Task & Sub-Plan Execution:** End-to-end task assignment, priority tagging, structured sub-plans, feedback loops, and deadline tracking.
4. **Leave & Expense Management:** Streamlined workflow for leave applications, schedules, planner calendars, holiday tracking, and claim request reviews.
5. **Offline & Resilience Security:** Background offline sync queuing for field workers without connectivity, biometric authentication, and hardware device binding.
6. **Data Export & Reporting:** Interactive analytics graphs and automated Excel (`.xlsx`) export for HR management and payroll processing.

---

## 2. Technical Stack & Architectural Overview

```
+-----------------------------------------------------------------------+
|                           Check-point-App                             |
|  (UI Layer, Atomic Design Components, Hand-Written Cubits, Routing)   |
+-----------------------------------+-----------------------------------+
                                    |
                                    | Repositories & HTTP Services
                                    v
+-----------------------------------------------------------------------+
|                      Check-point-package                              |
|           (hr_management_system_package - Data & Domain)             |
|   Dio / HTTP Clients, API Endpoints, DTO Models, Repository Contracts |
+-----------------------------------------------------------------------+
```

| Layer / Technology | Specification & Framework |
| :--- | :--- |
| **Framework** | Flutter (SDK `>=3.4.0 <4.0.0`) |
| **Architecture** | Atomic UI Design Pattern (`atoms`, `molecules`, `organism`, `pages`) + Clean Architecture package split |
| **State Management** | `flutter_bloc` (Explicit hand-written Cubit states — strictly **NO Freezed**) |
| **Networking & API** | `http` / `Dio` via `hr_management_system_package`, returning `Either<Failure, T>` |
| **Dependency Injection** | `get_it` service locator (`registerFactory` for Cubits, `registerLazySingleton` for repos) |
| **Localization** | `easy_localization` (Full Arabic `ar-AE` and English `en-US` with RTL-aware layouts) |
| **Responsive Sizing** | `flutter_screenutil` (`w`, `h`, `r`, `sp` units) |
| **Location & Maps** | `location`, `geocoding`, `google_maps_flutter` |
| **Storage & Security** | `flutter_secure_storage` (Tokens), `shared_preferences` (Settings/Flags), `biometric_login_service` |
| **Data & Visualization** | `fl_chart`, `pie_chart`, `excel`, `spreadsheet_decoder` |
| **UI Components** | `skeletonizer`, `animate_do`, `easy_date_timeline`, `timeline_tile`, `flutter_swipe_button` |

---

## 3. User Personas & Role-Based Access Control (RBAC)

```
                            +--------------------+
                            | User Role Selection|
                            +---------+----------+
                                      |
         +----------------------------+----------------------------+
         |                            |                            |
         v                            v                            v
+------------------+         +------------------+         +------------------+
|  Employee Persona |         |Supervisor Persona|         |   Admin Persona  |
+------------------+         +------------------+         +------------------+
| Field/Office Check|         | Team Live Map    |         | Company Setup    |
| Tasks & Subplans |         | Task Assignment  |         | Shift & Policies |
| Leave Requests   |         | Attendance Review|         | User & Dept Mgmt |
| Claim Requests   |         | Leave Approvals  |         | Excel Export     |
| Incidents & Logs |         | Gamification     |         | Broadcast Alerts |
+------------------+         +------------------+         +------------------+
```

---

## 4. Complete Feature Breakdown by Role

### 4.1 Employee Persona

#### 4.1.1 Authentication & Profile Management
* **Biometric Sign-In:** Fingerprint and Face ID authentication for rapid login.
* **Device ID Lock & Binding:** Tied to a single smartphone hardware ID. If changed, triggers `AskAdminToChangeDeviceIdDialog`.
* **Profile Photo Management:** Capture camera snapshot or choose from gallery with base64 conversion and compression (`UploadUserImageCubit`).
* **Password Change:** Secure password update screen (`employeeChangePasswordScreen`).

#### 4.1.2 Check-In & Check-Out Subsystem
* **Triple Attendance Modes:**
  1. **Office Check-In:** Validates proximity to predefined branch coordinates.
  2. **Customer Check-In:** Geofenced check-in at assigned client locations.
  3. **Site Check-In:** Geofenced check-in at temporary project/construction sites.
* **Anti-Spoofing & Fake GPS Defense:** `AntiSpoofingService` checks for mock location apps and flags unauthorized attendance.
* **Live Camera Verification:** Attendance can require real-time camera photo capture.
* **Swipe-to-Check Widget:** Smooth interactive swipe button (`flutter_swipe_button`).
* **Offline Attendance Sync:** When network connection drops, check-ins/outs are queued locally by `OfflineSyncManager` and auto-pushed once connection is restored.
* **Attendance History:** Chronological log of check-in time, check-out time, total worked hours, overtime, and status (On Time, Late, Early Departure).

#### 4.1.3 Task & Sub-Plan Execution
* **My Tasks View (`myTasksScreen`):** Filterable list of assigned tasks categorized by status (*To Do*, *In Progress*, *Completed*).
* **Priority Identifiers:** Visual badges for *High*, *Medium*, and *Low* priority tasks.
* **Sub-Plan Management (`myPlansScreen`):** View structured workflow sub-plans with step-by-step action items.
* **Plan Feedback Submission:** Submit progress notes, status updates, and issue reports on active sub-plans (`PlanFeedBackBlocListener`).

#### 4.1.4 Leaves, Holidays & Claims
* **Leave Application Submission (`leaveApplicationScreen`):** Request annual, casual, sick, or emergency leave with date pickers and reason documentation.
* **Leave Request History (`myLeaveRequestsScreen`):** Real-time status tracking (*Pending*, *Approved*, *Rejected*) with manager notes.
* **Leave Schedule & Planner (`leaveSchedule`, `leavePlanner`):** Calendar view of upcoming team and personal leaves.
* **Claim & Expense Application (`requestClaimApplicationScreen`):** Submit financial, medical, or travel expense claims with photo receipt attachments.

#### 4.1.5 Workflows, Incidents & Customers
* **Workflow Submission (`workflowSubmission`):** Form for requesting formal business approvals and submitting document review requests.
* **Incident Reporting (`incidentMyself`, `incidentTeam`):** Log workplace incidents, safety issues, or field emergencies for self or team.
* **Add New Customer (`employeeAddNewCustomerScreen`):** Field agents can register new client locations with GPS coordinates and client profiles on the go.

---

### 4.2 Supervisor Persona

#### 4.2.1 Team Dashboard & Live Map Tracking
* **Supervisor Home Dashboard (`supervisorHomeScreen`):** Overview banners, daily attendance metrics, and quick action shortcuts.
* **Live Employee Tracking Diagram Map (`employee_tracking_diagram_map.dart`):** Google Maps widget displaying real-time GPS locations and active status of field team members.
* **Employee Preview (`employeePreview`):** Detailed performance card per employee showing working hours, task completion rate, attendance percentage, and current location.

#### 4.2.2 Attendance Administration
* **Manual Attendance Overrides (`supervisorAttendSomeEmployeeScreen`):** Supervisor can log attendance manually on behalf of field workers facing smartphone issues or battery depletion.
* **Late Comers Monitor (`lateComers`):** Dedicated live feed of team members who checked in past the grace period.
* **Early Leavers Monitor (`earyLeavers`):** Live feed of employees who checked out prior to official shift conclusion.

#### 4.2.3 Task & Sub-Plan Dispatcher
* **Task Creator (`supervisorAddTasksScreen`):** Create tasks with title, detailed description, due dates, priority, and select target employees.
* **Assign Task Interface (`assignTaskScreen`):** Assign or reassign tasks across team members with notification alerts.
* **Sub-Plan Builder (`subPlansScreen`):** Create multi-step operational sub-plans (`AddSubPlanBottomSheet`) with sub-tasks and step dependencies.

#### 4.2.4 Request & Approval Workflows
* **Leave Applications Review (`recentLeaveApplication`):** List of pending leave requests with one-tap *Approve* or *Reject* actions and feedback comment inputs.
* **Supervisor Requests Center (`supervisorRequestsScreen`):** Centralized hub for leave, claim, and shift swap requests.
* **Supervisor Notifications (`supervisorNotificationsScreen`):** Alert history for task completions, late arrivals, and emergency requests.

#### 4.2.5 Gamification & Leaderboards
* **Team Gamification Center (`gamficationRoute`):** Gamified point system rewarding on-time attendance, task streaks, and flawless monthly records to boost employee morale.

---

### 4.3 Admin Persona

#### 4.3.1 Enterprise Control Center (`mangementScreen`)
* Central navigation grid providing access to all organizational configuration tools.

#### 4.3.2 Employee Directory & User Management
* **All Users Directory (`allUsersScreen`):** Filterable table/list of all employees across all branches.
* **User Creator & Editor (`editUser`):** Modify employee profiles, reset credentials, assign primary role (*Admin*, *Supervisor*, *Employee*), change department, and reset Device IDs.

#### 4.3.3 Organizational Governance & Permissions
* **Department Management (`departmentsScreen`):** Create and edit corporate departments (e.g., Sales, Engineering, Field Maintenance).
* **Department Permissions (`departmentPermission`):** Define role rights per department.
* **Supervisor Permission Control (`supervisorPermission`):** Granular permission toggles controlling what supervisor roles can view, edit, or approve.

#### 4.3.4 Shifts, Policies & Holidays
* **Shift Management (`shiftsScreen`):** Define work shifts with custom start times, end times, flexible grace periods, and late penalty rules.
* **Add Branches to Shift (`addBranchesToShiftScreen`):** Link company branches to specific shift schedules.
* **Policy Management (`policeScreen`):** Configure organizational rules for attendance, overtime calculation, and leave entitlements.
* **Holiday Management (`holidaysScreen`):** Set official national and company holiday calendars.

#### 4.3.5 Multi-Branch & Client Management
* **Company Branches (`companyBranchesScreen`, `companyBranchDetails`):** Register physical company locations with GPS coordinates, allowed geofence radii, and address details.
* **Clients & Sites (`clientsScreen`, `sitesScreen`):** Manage client locations and project sites for field worker check-ins.

#### 4.3.6 Enterprise Attendance Matrix & Excel Export
* **Global Attendance Dashboard (`adminAttendanceScreen`):** Comprehensive view of company-wide attendance filtered by date, department, or branch.
* **Attendance Selection Filters (`adminAttendSelectionScreen`):** Filter parameters for customized attendance reporting.
* **Excel Export Service (`excel_export_service.dart`):** One-click generation of `.xlsx` spreadsheets for monthly payroll and compliance audits.
* **Company Leaves Management (`adminLeavesScreen`):** High-level view of company-wide leave balances and historical trends.

#### 4.3.7 Communication & System Settings
* **Push Notification Dispatcher (`notifyUsersScreen`):** Broadcast custom push notifications to individual employees, whole departments, or all app users.
* **Admin Notifications Hub (`adminNotificationScreen`):** Audit trail of system alerts and approval histories.

---

## 5. Core Services, Utilities & System Architecture Details

### 5.1 Anti-Spoofing & Geofencing Engine
* **`AntiSpoofingService` (`lib/core/improvements/anti_spoofing_service.dart`):** Detects mock location providers, developer options flags, and suspicious coordinate jumps.
* **`GooglePlacesSearchService` (`lib/core/common/google_places_search_service.dart`):** Provides location searching and autocomplete via Google Maps API.
* **`LocationLinkParser` (`lib/core/common/location_link_parser.dart`):** Converts Google Maps URLs into latitude/longitude coordinates.

### 5.2 Offline Synchronization Manager
* **`OfflineSyncManager` (`lib/core/improvements/offline_sync_manager.dart`):** Intercepts check-in/out requests when device connectivity is lost, stores payload safely in encrypted local storage, and syncs automatically when network state flips to active.

### 5.3 Dynamic Theme & UI Customization
* **`DynamicThemeCubit` (`lib/core/improvements/dynamic_theme_cubit.dart`):** Manages dynamic palette changes.
* **`ThemePickerDialog` (`lib/core/improvements/theme_picker_dialog.dart`):** Allows users/admins to choose custom color themes and dark/light modes.

### 5.4 Localization System
* Dual support for Arabic (`ar-AE`) and English (`en-US`).
* String keys formatted as `'key'.tr()`.
* RTL layout flipping using `EdgeInsetsDirectional` and directional alignments.

---

## 6. Complete Route Catalog (Screen Index)

Below is the complete inventory of all routes registered in `lib/core/routing/routes.dart` and `lib/core/routing/app_router.dart`:

| Route String Constant | Screen Class | User Role | Description |
| :--- | :--- | :--- | :--- |
| `Routes.splash` (`/`) | `SplashScreen` | All | App launch & splash animation |
| `Routes.onboardingscreen` (`/onboardingscreen`) | `OnboardingScreen` | Guest | Introductory onboarding slides |
| `Routes.userRoleScreen` (`/userRoleScreen`) | `UserRoleScreen` | Guest | Role selection gateway (Admin/Supervisor/Employee) |
| `Routes.employeeLoginScreen` (`/employeeLoginScreen`) | `EmployeeLoginScreen` | Employee | Employee login form with credentials/biometrics |
| `Routes.adminLoginScreen` (`/adminLoginScreen`) | `AdminLoginScreen` | Admin | Admin credential login screen |
| `Routes.supervisorLoginScreen` (`/supervisorLoginScreen`) | `SupervisorLoginScreen` | Supervisor | Supervisor credential login screen |
| `Routes.employeeHomeScreen` (`/employeeHomeSCreen`) | `EmployeeHomeScreen` | Employee | Main dashboard for employee persona |
| `Routes.employeeCheckInScreen` (`/employeeCheckInScreen`) | `EmployeeCheckInScreen` | Employee | GPS / Office / Customer / Site Check-In view |
| `Routes.employeeCheckOutScreen` (`/employeeCheckOutScreen`) | `EmployeeCheckOutScreen` | Employee | Check-Out screen with worked duration |
| `Routes.employeeAttendanceHistoryScreen` (`/employeeAttendanceHistoryScreen`) | `EmployeeAttendanceHistoryScreen` | Employee | Personal historical attendance records |
| `Routes.myTasksScreen` (`/myTasksScreen`) | `MyTasksScreen` | Employee / Supervisor | Task management list |
| `Routes.myPlansScreen` (`/myPlansScreen`) | `MyPlansScreen` | Employee | Structured sub-plans list |
| `Routes.leaveApplicationScreen` (`/leaveApplicationScreen`) | `LeaveApplicationScreen` | Employee | New leave request submission form |
| `Routes.myLeaveRequestsScreen` (`/myLeaveRequestsScreen`) | `MyLeaveRequestsScreen` | Employee | Personal leave request status history |
| `Routes.leavePlanner` (`/leavePlanner`) | `LeavePlannerScreen` | Employee | Calendar leave planning tool |
| `Routes.leaveSchedule` (`/leaveSchedule`) | `LeaveScheduleScreen` | Employee | Schedule overview of team leaves |
| `Routes.requestClaimApplicationScreen` (`/requestClaimApplicationScreen`) | `RequestClaimApplicationScreen` | Employee | Claim & expense request form |
| `Routes.workflowSubmission` (`/workflowSubmission`) | `WorkflowSubmissionScreen` | Employee | Business workflow approval request |
| `Routes.incidentMyself` (`/incidentMyself`) | `IncidentMyselfScreen` | Employee | Personal incident logging |
| `Routes.incidentTeam` (`/incidentTeam`) | `IncidentTeamScreen` | Employee | Team incident reporting |
| `Routes.employeeAddNewCustomerScreen` (`/employeeAddNewCustomerScreen`) | `EmployeeAddNewCustomerScreen` | Employee | Field registration of new clients |
| `Routes.employeeChangePasswordScreen` (`/employeeChangePasswordScreen`) | `EmployeeChangePasswordScreen` | Employee | Security credentials update |
| `Routes.supervisorHomeScreen` (`/supervisorHomeScreen`) | `SupervisorHomeScreen` | Supervisor | Main supervisor dashboard |
| `Routes.supervisorAddTasksScreen` (`/supervisorAddTasksScreen`) | `SupervisorAddTasksScreen` | Supervisor | Create new task for employees |
| `Routes.assignTaskScreen` (`/assignTaskScreen`) | `AssignTaskScreen` | Supervisor | Task assignment & employee selection |
| `Routes.subPlansScreen` (`/SubPLansScreen`) | `SubPlansScreen` | Supervisor | Sub-plan builder & manager |
| `Routes.supervisorAttendSomeEmployeeScreen` (`/supervisorAttendSomeEmployeeScreen`) | `SupervisorAttendSomeEmployeeScreen` | Supervisor | Manual attendance override for team members |
| `Routes.lateComers` (`/lateComers`) | `LateComersScreen` | Supervisor | Late arrival monitor feed |
| `Routes.earyLeavers` (`/earyLeavers`) | `EaryLeaversScreen` | Supervisor | Early departure monitor feed |
| `Routes.recentLeaveApplication` (`/recentLeaveApplication`) | `RecentLeaveApplicationScreen` | Supervisor | Leave approval & review workflow |
| `Routes.supervisorRequestsScreen` (`/supervisorRequestsScreen`) | `SupervisorRequestsScreen` | Supervisor | Centralized request approvals |
| `Routes.employeePreview` (`/employeePreview`) | `EmployeePreviewScreen` | Supervisor | Individual employee performance detail |
| `Routes.gamficationRoute` (`/gamficationRoute`) | `GamficationScreen` | Supervisor | Team gamification & streak points |
| `Routes.supervisorNotificationsScreen` (`/supervisorNotificationScreen`) | `SupervisorNotificationScreen` | Supervisor | Supervisor alert notification center |
| `Routes.adminHomeScreen` (`/adminHomeScreen`) | `AdminHomeScreen` | Admin | Main administration control center |
| `Routes.allUsersScreen` (`/AllUsersScreen`) | `AllUsersScreen` | Admin | Comprehensive employee directory |
| `Routes.editUser` (`/editUser`) | `EditUserScreen` | Admin | User account editor & role manager |
| `Routes.departmentPermission` (`/departmentPermission`) | `DepartmentUsersAndPermissionScreen` | Admin | Department setup & access rights |
| `Routes.supervisorPermission` (`/supervisorPermission`) | `SupervisorPermissionScreen` | Admin | Supervisor privilege editor |
| `Routes.shiftsScreen` (`/shiftsScreen`) | `ShiftsScreen` | Admin | Work shift & grace period setup |
| `Routes.addBranchesToShiftScreen` (`/addBranchsToShiftScreen`) | `AddBranchesToShiftScreen` | Admin | Link branches to work shifts |
| `Routes.policeScreen` (`/policeScreen`) | `PoliceScreen` | Admin | HR policies & penalty rule editor |
| `Routes.holidaysScreen` (`/holidaysScreen`) | `HolidaysScreen` | Admin | Company & public holiday setup |
| `Routes.companyBranchesScreen` (`/companyBranchesScreen`) | `CompanyBranshesScreen` | Admin | Physical branch location manager |
| `Routes.companyBranchDetails` (`/companyBranchDetails`) | `CompanyBranchesDetailsScreen` | Admin | Geofence & detail configuration for branch |
| `Routes.clientsScreen` (`/clientsScreen`) | `ClientsScreen` | Admin | Client & customer list |
| `Routes.sitesScreen` (`/documentScreen`) | `SitesScreen` | Admin | Project site location manager |
| `Routes.adminAttendanceScreen` (`/adminAttendanceScreen`) | `AdminAttendanceScreen` | Admin | Global company attendance matrix |
| `Routes.adminAttendSelectionScreen` (`/adminAttendSelectionScreen`) | `AdminAttendSelectionScreen` | Admin | Custom attendance report filters |
| `Routes.adminLeavesScreen` (`/adminLeavesScreen`) | `AdminLeavesScreen` | Admin | Corporate leave history analytics |
| `Routes.notifyUsersScreen` (`/notifyUsersScreen`) | `NotifyUsersScreen` | Admin | Push notification broadcast center |
| `Routes.adminNotificationScreen` (`/adminNotificationScreen`) | `AdminNotificationScreen` | Admin | Admin audit log & notifications |
| `Routes.termsAndConditionsScreen` (`/termsAndConditionsScreen`) | `TermsAndConditionsScreen` | All | Legal terms and compliance text |

---

## 7. UX/UI Redesign Roadmap & Blueprint

To elevate **Check-Point (Art Attack)** into a modern, world-class enterprise web/mobile experience, the following redesign strategy is recommended across **5 Core Pillars**:

```
+-----------------------------------------------------------------------------------+
|                            CHECK-POINT REDESIGN BLUEPRINT                         |
+---------------------+---------------------+------------------+--------------------+
|  1. Visual System   |  2. Dashboard & UX  |  3. Attendance   | 4. Task & Workflow |
|  - Glassmorphic UI  |  - Unified Shell    |  - Quick-Swipe   | - Kanban View      |
|  - Modern Dark Mode |  - Role Workspace   |  - Live Map View | - Timeline View    |
|  - Inter / Cairo    |  - Modular Cards    |  - Offline Chip  | - Step Wizards     |
+---------------------+---------------------+------------------+--------------------+
```

### Pillar 1: Visual Design System & Branding Modernization
1. **Curated Color Palettes & Dark Mode:**
   - Replace default high-contrast reds/blues with an elevated palette (e.g., Deep Slate `#0F172A`, Electric Indigo `#6366F1`, Emerald Teal `#10B981`, and Warm Amber `#F59E0B`).
   - Full native Dark Mode support with subtle background glassmorphism (`BackdropFilter` translucent cards).
2. **Typography & Layout Hierarchy:**
   - Standardize on modern Google Fonts (**Inter** for English, **Cairo** or **Tajawal** for Arabic).
   - Enforce consistent typographic scaling using `flutter_screenutil` (Display 24sp, Heading 18sp, Body 14sp, Caption 12sp).
3. **Micro-Animations & Visual Feedback:**
   - Incorporate fluid transitions using `animate_do` and Lottie animations for success states (check-in complete, task assigned).
   - Use skeleton shimmer loaders (`Skeletonizer`) instead of basic circular progress bars.

### Pillar 2: Navigation & Information Architecture Overhaul
1. **Role-Adaptive Dynamic Shell:**
   - Replace disconnected navigation flows with a unified Bottom Navigation Bar / Navigation Rail that adapts instantly based on active user role.
2. **Role Workspace Dashboards:**
   - **Employee:** Focus on immediate daily actions: big check-in status card, today's schedule, pending tasks progress ring, and leave balance summary.
   - **Supervisor:** Focus on live field map, team attendance donut chart (`fl_chart`), pending approvals counter, and high-priority alerts.
   - **Admin:** Executive dashboard featuring attendance rate trends, branch compliance meters, department breakdowns, and system audit logs.

### Pillar 3: Attendance & Check-In Experience Modernization
1. **Interactive Geo-Fence Visualizer:**
   - Display an interactive mini Google Map centered on the user with a glowing radius circle indicating the valid check-in perimeter.
2. **One-Touch Biometric Check-In:**
   - Integrate instant fingerprint/Face ID trigger directly on the check-in screen for seamless 2-second attendance logging.
3. **Offline Sync Status Banner:**
   - Provide an ambient status pill (e.g., *"3 offline check-ins queued — syncing automatically"*), eliminating user uncertainty during poor connectivity.

### Pillar 4: Task & Workflow Management Enhancements
1. **Kanban Board & List View Toggles:**
   - Enable Supervisors and Employees to switch between list view and Kanban board view (*To Do*, *In Progress*, *Done*).
2. **Step-by-Step Sub-Plan Timelines:**
   - Utilize `timeline_tile` components to visualize sub-plan milestones clearly with status indicators.
3. **Guided Request Wizards:**
   - Convert long forms (Leave Application, Claim Expense, Incident Report) into 2-step guided wizards with inline photo upload previews and automatic validation.

### Pillar 5: Data Visualization & Reporting Upgrade
1. **Interactive Analytical Charts:**
   - Upgrade flat statistics into dynamic `fl_chart` bar graphs (weekly worked hours), pie charts (department attendance distribution), and line charts (lateness trends).
2. **One-Tap Customized PDF & Excel Reports:**
   - Provide pre-formatted PDF summary previews alongside Excel (`.xlsx`) downloads for manager sign-offs.

---

## 8. Summary Checklist for Redesign Implementation

- [ ] Update `ColorsManger` and `AppStylesManger` to reflect the new design system tokens.
- [ ] Refactor role home screens to adopt unified layout shells.
- [ ] Enhance check-in screens with interactive map geofence overlays and biometric quick triggers.
- [ ] Upgrade list items and card components with `Skeletonizer` and custom micro-animations.
- [ ] Implement `fl_chart` interactive analytics across Supervisor and Admin dashboards.
- [ ] Verify localized RTL layouts and strings for Arabic (`ar-AE`) and English (`en-US`).
