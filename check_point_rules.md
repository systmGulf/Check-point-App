# Check-Point Project Rules

> **MANDATORY FOR ALL AI AGENTS (Claude, Cursor, Copilot, Codex, Gemini, or any other assistant):**
> You **MUST** read this entire file before making any change to the repository.
> You **MUST NOT** skip, ignore, soften, reinterpret, or work around any rule in this file.
> If a rule conflicts with a user request, **stop and ask** — do not silently violate the rule.
> If a rule is unclear, **ask for clarification** — do not guess.
> If you find code in the repo that violates a rule, **point it out** but do not refactor it unless the user explicitly asks.

---

## 1. Tech Stack (Fixed — Do Not Replace)

- **State management:** `flutter_bloc` (Cubit) — states are **hand-written abstract classes** (NOT Freezed).
- **Networking:** `http` package via the `hr_management_system_package` local package; results are returned as `Either<Failure, T>` (Left = failure, Right = success).
- **Dependency injection:** `get_it`, registered in `lib/core/dependencyـinjection/registerـfactory.dart`.
- **Localization:** `easy_localization` with string keys, always called with `'key'.tr(context: context)`.
- **Responsive sizing:** `flutter_screenutil` — use `16.w`, `24.h`, `12.r`, `14.sp`. Never raw pixel literals.
- **Storage:** `flutter_secure_storage` for tokens; `shared_preferences` for non-sensitive flags.
- **Routing:** Navigator 1.0 with string constants in `Routes` and a single `AppRouter` switch.
- **Package split:** All API calls, models, and repo contracts live in `../Check-point-package` (`hr_management_system_package`). The app (`employee_mangement`) only contains Cubits, UI, routing, and DI wiring.
- **Animations:** `animate_do` for list/entry animations. `animations.dart` core wrapper (`AnimatedByWidgetType`, `AnimatedTextWidget`, `AnimatedListItemWidget`, `AnimatedContainerWidget`).
- **Images:** `cached_network_image` for all network images.

**Rule:** Do not introduce a new package that overlaps an existing one (e.g., do not add `go_router`, `provider`, `riverpod`, `dio`, `chopper`, `injectable`, `freezed`) without explicit approval.

---

## 2. Core Principles

1. Make the **smallest** change that solves the problem.
2. Fix **root causes**, not symptoms.
3. Do **not** refactor unrelated code unless explicitly requested.
4. Do **not** add new abstractions or dependencies without a clear, stated reason.
5. Prefer **clarity over cleverness**.
6. Code must be **simple, readable, maintainable, reusable, and scalable** — in that order.
7. Never break existing functionality, APIs, flows, or UX unless explicitly instructed.
8. Read relevant code before modifying it — state assumptions when unclear.

---

## 3. Project Structure

```
Check-point-App/                    ← app layer (this repo)
  lib/
    core/
      animations/                   ← AnimatedByWidgetType and wrappers
      common/                       ← shared helpers used across features
      contoller/                    ← global cubits (e.g. login_cubit)
      cubits/                       ← truly global cubits (e.g. upload_user_image_cubit)
      dependencyـinjection/         ← get_it setup: registerـfactory.dart
      helpers/                      ← extensions (extention.dart), app_spaces.dart
      packages/                     ← package bridge helpers
      routing/                      ← app_router.dart, routes.dart
      styles/                       ← colors.dart, styles.dart
      utils/                        ← assets_manager.dart, other utilities
      widgets/                      ← shared widgets used in 2+ features
    features/
      intro/                        ← splash, onboarding, register
      user_role/
        admin/
          admin_auth/
          admin_home/
            atomic_ui/
              atoms/                ← smallest UI pieces
              molecules/            ← composed groups of atoms
              organism/             ← fully functional sections
              pages/                ← full screens (top-level routes)
            controllers/            ← Cubits for admin features
        employee/
          employee_auth/
          employee_home/
            atomic_ui/
              atoms/
              molecules/
              organism/
              pages/
            controller/             ← Cubits for employee features
        supervisor/
          supervisor_auth/
          supervisor_home/
            atomic_ui/
            contoller/              ← Cubits for supervisor features

Check-point-package/                ← data/domain layer (separate repo)
  lib/
    admin_infrastructure/
      data/
        models/
        repo/                       ← abstract contract + implementation
    employee_infrastructure/
      data/
        models/
        repo/
    supervisor_infrastructure/
      data/
        models/
        repo/
    core/
      networking/                   ← Dio/http setup, ApiConstant, token handling
      repos/                        ← shared repos (shared_repo.dart)
```

**Rule:** Before creating a new helper, constant, color, text style, or widget, **search `core/` first**. If something similar exists, use it. Do not duplicate.

---

## 4. State Management — Cubit & State Rules

### 4.1 State Pattern — Hand-Written Abstract Classes

This project does **NOT** use Freezed for states. All states are hand-written abstract class hierarchies. Follow this pattern exactly:

```dart
// controller/tasks/tasks_state.dart
part of 'tasks_cubit.dart';

abstract class EmployeeTasksState {}

class TasksInitial extends EmployeeTasksState {}

// — Loading states —
class GetMyTasksLoading extends EmployeeTasksState {}
class UpdateTaskStatusLoading extends EmployeeTasksState {}
class DeleteEmployeeTaskLoading extends EmployeeTasksState {}

// — Success states —
class GetMyTasksSuccess extends EmployeeTasksState {
  final List<EmployeeTasks> getTaskResponse;
  GetMyTasksSuccess(this.getTaskResponse);
}
class UpdateTaskStatusSuccess extends EmployeeTasksState {}
class DeleteEmployeeTaskSuccess extends EmployeeTasksState {}

// — Error states —
class GetMyTasksError extends EmployeeTasksState {
  final String error;
  GetMyTasksError(this.error);
}
class UpdateTaskStatusError extends EmployeeTasksState {
  final String error;
  UpdateTaskStatusError(this.error);
}
class DeleteEmployeeTaskError extends EmployeeTasksState {
  final String error;
  DeleteEmployeeTaskError(this.error);
}
```

**Rules:**
- State file is always a `part of` the cubit file.
- Every operation gets its own **Loading**, **Success**, and **Error** state triplet.
- Error states always hold a `final String error` (or `errorMessage`) field.
- Success states hold only the data they need — no extra fields.
- Initial state is always empty: `class XyzInitial extends XyzState {}`.
- **Never** use Freezed for states in this project. Hand-write every class.
- **Never** hand-write `copyWith` or `==` — states are not compared, only type-checked.

### 4.2 Cubit Pattern

```dart
// controller/tasks/tasks_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/...';

part 'tasks_state.dart';

class EmployeeTasksCubit extends Cubit<EmployeeTasksState> {
  EmployeeTasksCubit({required this.employeeRepo}) : super(TasksInitial());

  final EmployeeActionRepo employeeRepo;

  Future<void> getMyTasks() async {
    emit(GetMyTasksLoading());
    final result = await employeeRepo.getEmployeeTasks();
    result.fold(
      (l) {
        if (!isClosed) emit(GetMyTasksError(l.message));
      },
      (r) {
        if (!isClosed) emit(GetMyTasksSuccess(r.value!.employeeTasks!));
      },
    );
  }
}
```

**Rules:**
- Cubit constructor always uses **named parameters**: `{required this.repo}`.
- All injected fields are **public** — no leading underscore: `final EmployeeActionRepo employeeRepo` ✅, `final EmployeeActionRepo _employeeRepo` ❌.
- Always call `if (!isClosed) emit(...)` before emitting from an async result to prevent emitting after disposal.
- Repo calls return `Either<Failure, T>`. Consume with `result.fold((l) { ... }, (r) { ... })`.
  - Left (`l`) is the failure: use `l.message` for the error string.
  - Right (`r`) is the success value.
- Emit `Loading` before the async call. Emit `Success` or `Error` after.
- Cubits **never** call APIs or Dio directly — only through repo interfaces from the package.
- Cubits **never** import Flutter widgets (`material.dart`). `foundation.dart` is fine.
- One cubit per screen/feature concern. Do not build "god cubits".
- Keep cubit methods thin: call repo → fold → emit state.

### 4.3 Result Handling — Either<Failure, T>

The package returns `Either<Failure, T>` (from `dartz` or equivalent):

```dart
result.fold(
  (l) {
    // l is Failure — use l.message
    if (!isClosed) emit(SomeOperationError(l.message));
  },
  (r) {
    // r is the success response model
    if (!isClosed) emit(SomeOperationSuccess(r.someData));
  },
);
```

**Rule:** Always guard the emit with `if (!isClosed)` in async callbacks. Never `throw`, `rethrow`, or `print` errors — fold and emit.

---

## 5. UI Rules — State Handling

### 5.1 BlocBuilder Pattern

Use `BlocBuilder` with `buildWhen` to limit rebuilds to relevant states:

```dart
BlocBuilder<EmployeeTasksCubit, EmployeeTasksState>(
  buildWhen: (previous, current) =>
      current is GetMyTasksError ||
      current is GetMyTasksSuccess ||
      current is GetMyTasksLoading,
  builder: (context, state) {
    if (state is GetMyTasksError) {
      return Text(state.error);
    }
    if (state is GetMyTasksSuccess) {
      return MyDataWidget(data: state.getTaskResponse);
    }
    // Default / loading — show skeleton
    return Skeletonizer(child: MyDataWidget(data: []));
  },
)
```

**Rules:**
- Always use `buildWhen` to restrict rebuilds to states relevant to this builder.
- Use `if (state is XState)` type checks — **never** `switch` or pattern matching (no Freezed).
- Show a `Skeletonizer` skeleton for loading, not a `CircularProgressIndicator` in the builder (unless skeleton is not applicable).
- The default (else) branch returns the loading/skeleton state.

### 5.2 BlocListener Pattern

Extract every `BlocListener` into its own named widget file:

```dart
// organism/register_account_bloc_listener.dart
class RegisterAccountBlocListener extends StatelessWidget {
  const RegisterAccountBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterAccountCubit, RegisterAccountState>(
      listenWhen: (previous, current) =>
          current is RegisterAccountSuccess ||
          current is RegisterAccountFailure ||
          current is RegisterAccountLoading,
      listener: (context, state) {
        if (state is RegisterAccountSuccess) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(message: 'Success message'.tr(context: context)),
          );
        } else if (state is RegisterAccountFailure) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(message: state.errorMessage),
          );
        } else {
          customLoadingIndicator(context);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
```

**Rules:**
- Every `BlocListener`/`BlocConsumer` lives in a **separate named file**: `*_bloc_listener.dart`.
- Always use `listenWhen` to filter only the states this listener cares about.
- Use `if (state is X)` type checks.
- Show snack bars via `showTopSnackBar` from `app_top_snack_bar.dart`.
- Show loading dialogs via `customLoadingIndicator(context)`.
- `BlocListener` child is always `const SizedBox.shrink()` — it renders nothing.

### 5.3 General UI Rules

- The UI **only** renders state, sends user actions to Cubits, and handles local UI concerns (focus, scroll, animation).
- The UI **must not** call repos or APIs directly, contain business rules, or do heavy filtering/sorting in `build()`.
- `setState` is only for **local, UI-only** state inside small leaf widgets (toggles, tab index, focus).
- Do **not** create private widget helper functions (`Widget _buildHeader()`). Extract into a separate named widget class in its own file.
- Do **not** create private widget classes (`_MyWidget`). All widgets are named public classes.
- Do **not** create widgets as functions that return `Widget`.
- Place `BlocBuilder` / `BlocListener` on the **smallest** subtree that needs to rebuild — never at the top of the tree.
- If a widget's `build()` exceeds ~80 lines, **split it** — no exceptions.
- Use `const` constructors wherever possible.
- Use `ListView.builder` / `GridView.builder` for dynamic lists — never `.children` with a spread.

---

## 6. Atomic UI Structure (Atoms → Molecules → Organism → Pages)

This project uses an atomic design hierarchy inside each feature's `atomic_ui/` folder:

| Level | Folder | Description |
|---|---|---|
| **Atoms** | `atoms/` | Smallest, single-purpose UI piece (one item widget, one card) |
| **Molecules** | `molecules/` | Composed groups of atoms (a list + header, a form section) |
| **Organism** | `organism/` | Fully functional UI sections (bloc builders, bloc listeners, screen bodies) |
| **Pages** | `pages/` | Full screens — top-level route destinations |

**Rules:**
- Bloc builders and listeners belong in `organism/`.
- Full screens (wrapped in `Scaffold`) belong in `pages/`.
- Reusable small widgets belong in `atoms/` or `molecules/` depending on complexity.
- Widgets shared across multiple features go in `lib/core/widgets/`.

---

## 7. Routing

Use `Navigator 1.0` with string constants. **Never** use anonymous routes or inline `MaterialPageRoute` inside widgets.

### 7.1 Route Constants — `lib/core/routing/routes.dart`

```dart
class Routes {
  static const String employeeHomeScreen = '/employeeHomeScreen';
  static const String adminHomeScreen = '/adminHomeScreen';
  // ... all routes as static const String
}
```

### 7.2 Router — `lib/core/routing/app_router.dart`

All route construction and Cubit provisioning happens here:

```dart
case Routes.employeeHomeScreen:
  return MaterialPageRoute(
    builder: (_) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<EmployeeTasksCubit>()..getMyTasks()),
        BlocProvider(create: (_) => getIt<AttendanceCubit>()),
      ],
      child: const EmployeeHomeScreen(),
    ),
  );
```

**Rules:**
1. Every route name lives in `Routes` as a `static const String`.
2. All route construction is in `AppRouter` — never in widgets.
3. If a screen needs a Cubit, wrap it in `BlocProvider` or `MultiBlocProvider` **inside** `AppRouter`, using `getIt<MyCubit>()`.
4. Never instantiate Cubits manually in widgets or call `MyCubit(repo)` at the call site.
5. Navigate using extension helpers from `extention.dart`: `context.pushName(Routes.x)`, `context.pushReplacementName(Routes.x)`, `context.pop()`.

---

## 8. Dependency Injection

All registration lives in `lib/core/dependencyـinjection/registerـfactory.dart`.

```dart
final getIt = GetIt.instance;

void registerFactory() {
  // ── Cubits (registerFactory — new instance per route) ──
  getIt.registerFactory<EmployeeTasksCubit>(
    () => EmployeeTasksCubit(employeeRepo: getIt<EmployeeActionRepo>()),
  );

  // ── Repos (registered in the package setup, lazySingleton) ──
  // Repos come from hr_management_system_package setup
}
```

**Rules:**
- **Cubits:** `registerFactory` — fresh instance per route push.
- **Repos / Services:** `registerLazySingleton` — one shared instance.
- Constructor injection always uses **named parameters** `{required this.field}`.
- All injected fields are **public** — no leading underscore.
- Never call `MyCubit(MyRepo())` by hand in widgets or routes. Always `getIt<MyCubit>()`.

---

## 9. Design System

Centralized under `lib/core/styles/`:

- **Colors** → `colors.dart` → `ColorsManger.primaryColor`, `ColorsManger.grey`, etc.
- **Text styles** → `styles.dart` → `AppStylesManger.font16BoldBlack`, `AppStylesManger.font14RegularBlack`, etc.
- **Assets** → `lib/core/utils/assets_manager.dart` → `Assets.bannerHomeImage`, etc.

**Rules:**
- **Never** write `Color(0xFF...)` or `TextStyle(...)` inside a feature widget. Pull from `ColorsManger` / `AppStylesManger`.
- **Never** write asset paths as raw strings. Use `Assets.x` from `assets_manager.dart`.
- If a needed color/style/asset doesn't exist, **add it to the central file** — don't inline it.

```dart
// ❌ BAD
Text('Hello', style: TextStyle(color: Color(0xFFe60000), fontSize: 16));

// ✅ GOOD
Text('Hello', style: AppStylesManger.font16BoldBlack);
```

---

## 10. Localization (Arabic + English, RTL-aware)

- **Never** hardcode user-facing strings. Always `'key'.tr(context: context)`.
- For directional layouts, use `EdgeInsetsDirectional`, `AlignmentDirectional`, and `start`/`end` instead of `left`/`right`.
- Icons implying direction (arrows, chevrons) must mirror in RTL — use `Directionality` wrapper where needed.
- Numbers and dates formatted via `intl` with the current locale.

```dart
// ❌ BAD
Padding(
  padding: const EdgeInsets.only(left: 16),
  child: Text('Departments'),
)

// ✅ GOOD
Padding(
  padding: EdgeInsetsDirectional.only(start: 16.w),
  child: Text('Departments'.tr(context: context)),
)
```

---

## 11. Animations

Use the project's animation wrappers from `lib/core/animations/animations.dart`:

| Widget | When to use |
|---|---|
| `AnimatedByWidgetType(widgetType: WidgetAnimationType.header)` | Page headers / user info sections |
| `AnimatedByWidgetType(widgetType: WidgetAnimationType.container)` | Cards, containers |
| `AnimatedByWidgetType(widgetType: WidgetAnimationType.card)` | Individual cards |
| `AnimatedByWidgetType(widgetType: WidgetAnimationType.listItem)` | List rows |
| `AnimatedByWidgetType(widgetType: WidgetAnimationType.text)` | Text sections |
| `AnimatedByWidgetType(widgetType: WidgetAnimationType.image)` | Banner/hero images |
| `AnimatedTextWidget` | Animated text labels |
| `AnimatedListItemWidget(index: n)` | Staggered list entry animations |
| `AnimatedContainerWidget` | Animated container/card backgrounds |

Use `animate_do` (`BounceInLeft`, `SlideInLeft`, `FadeInRight`, etc.) for grid/list items directly when the core wrappers don't apply.

**Rule:** Always wrap new screen sections with an appropriate animation wrapper. Do not add raw widgets without entry animation on main screens.

---

## 12. Package Split — What Goes Where

| Concern | Location |
|---|---|
| API calls, http requests | `Check-point-package` |
| Response models / DTOs | `Check-point-package` |
| Repository contracts (abstract) | `Check-point-package` |
| Repository implementations | `Check-point-package` |
| Cubit + State | `Check-point-App` (`features/.../controller/`) |
| UI widgets, screens | `Check-point-App` (`features/.../atomic_ui/`) |
| Routing, DI | `Check-point-App` (`core/`) |

**Rule:** Never add API calls or model classes directly in the app repo. All data access goes through the package. Never import raw `http` calls in the app layer.

---

## 13. Performance

- Use `const` widgets everywhere possible to prevent unnecessary rebuilds.
- Use `buildWhen` / `listenWhen` in all `BlocBuilder` / `BlocListener` to limit rebuild scope.
- Never create `TextEditingController`, `AnimationController`, `FocusNode`, or `ScrollController` inside `build()`. Create in `initState()`.
- Always dispose controllers, focus nodes, and animation controllers in `dispose()`.
- No heavy synchronous work (sorting, filtering, parsing) inside `build()`.
- Use `Skeletonizer` for loading states — not bare `CircularProgressIndicator` for content areas.
- Use `ListView.builder` / `GridView.builder` for dynamic lists — never `.children` with a large spread.
- Use `cached_network_image` for all network images.
- Use `flutter_screenutil` for all responsive sizing — never `MediaQuery.of(context).size` for fixed sizing.

---

## 14. Security

- **Never** hardcode API keys, tokens, base URLs, or credentials anywhere in code.
- Base URL lives in `ApiConstant` inside the package — never in app-layer files.
- Use `SecureCache` (wrapping `flutter_secure_storage`) for tokens — never `SharedPreferences` for sensitive data.
- Never log tokens, passwords, or PII.
- On logout: call `FlutterBackgroundService().invoke('stop')`, `SecureCache.deleteFromCache()`, then navigate to `Routes.userRoleScreen`.

---

## 15. Naming and File Conventions

| Type | Pattern | Example |
|---|---|---|
| Screen (page) | `*_screen.dart` | `admin_home_screen.dart` |
| Organism | `*_body.dart` / `*_bloc_listener.dart` / `*_bloc_builder.dart` | `employee_home_screen_body.dart` |
| Molecule | descriptive name | `management_screen_grid_view.dart` |
| Atom | `*_item.dart` / `*_widget.dart` | `user_item_grid_view.dart` |
| Cubit | `*_cubit.dart` | `tasks_cubit.dart` |
| State | `*_state.dart` (part of cubit) | `tasks_state.dart` |
| Bloc Listener | `*_bloc_listener.dart` | `register_account_bloc_listener.dart` |
| Bloc Builder | `*_bloc_builder.dart` | `employee_attendace_bloc_builder.dart` |

- One named widget/class per file.
- No private widget classes (`_MyWidget`). All widget classes are public.
- No widget-returning functions (`Widget _buildX()`). Extract to separate files.

---

## 16. Commit Message Format

When the user says **`done`** after a completed change:

```
type(scope): short summary

- bullet describing change
- bullet describing change
```

Valid types: `feat`, `fix`, `refactor`, `perf`, `style`, `docs`, `test`, `chore`, `build`, `ci`.

### Example

```
feat(admin): hide holidays and notifications from management screen

- remove Holidays grid item from management_screen_grid_view.dart
- remove Notifications list item from mangement_screen.dart
- update itemCount to match remaining items
```

---

## 17. Before Committing — Checklist

1. `dart analyze` — zero new warnings.
2. Hot reload / run the app — verify the changed flow visually.
3. No raw strings, inline colors, or inline text styles introduced.
4. No business logic added to UI layer.
5. All new cubits registered in `registerـfactory.dart`.
6. All new routes added to both `routes.dart` and `app_router.dart`.
7. `isClosed` guard on all async emits.

---

## 18. Final Reminder to AI Agents

- Do **not** use Freezed for states — hand-write every state class.
- Do **not** use `result.when(...)` — use `result.fold((l) {...}, (r) {...})`.
- Do **not** skip the `if (!isClosed)` guard before async emits.
- Do **not** put API calls in the app repo — they belong in the package.
- Do **not** create private widgets or widget functions — extract to named public classes.
- Do **not** skip `buildWhen` / `listenWhen` on Bloc widgets.
- Do **not** invent new patterns when an existing one in this file applies.
- When in doubt: **ask**.
