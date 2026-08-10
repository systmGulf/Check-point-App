# Check Point Monorepo Rules

> Mandatory for all AI agents working on this codebase.
> Read this file before making changes.
> Do not skip, reinterpret, or work around any rule here.
> If a rule conflicts with a request, stop and ask.

These rules apply to the production monorepo that contains:

- `apps/check_point_app`
- `packages/hr_management_system_package`

The goal is to keep the app shippable while the shared package is moved into the monorepo and hardened for long-term production use.

## 1. Core Principles

1. Make the smallest change that solves the problem.
2. Fix root causes, not symptoms.
3. Do not refactor unrelated code unless the task explicitly asks for it.
4. Do not add new abstractions or dependencies without a clear reason.
5. Prefer clarity, stability, and testability over cleverness.
6. Never break an existing user flow unless the task explicitly changes it.
7. If something is unclear in the codebase, inspect the actual files first.

### Full Package Refactor Override

If the user explicitly requests a package-wide refactor, hardening pass, or
system-wide unit-test effort, the agent is allowed and expected to work across
all package folders and layers in a staged manner. In that mode:

- Refactor all package files that need cleanup for architecture, consistency,
  naming, safety, and public API quality.
- Add or expand unit tests across shared core, models, repositories, use cases,
  and other pure/package-owned logic.
- Fix analyzer, typing, serialization, error-handling, null-safety, and
  dependency issues across the package.
- Improve security-sensitive areas such as token handling, storage boundaries,
  unsafe logging, and transport failure handling.
- Preserve working behavior unless a breaking change is intentionally requested.
- Execute the work feature by feature or layer by layer, but do not stop at a
  single-file fix when the explicit task is whole-package refactor and
  hardening.

## 2. Monorepo Structure

The repository must be organized by app and package:

```text
repo/
  apps/
    check_point_app/
  packages/
    hr_management_system_package/
  tooling/
  docs/
  melos.yaml
  pubspec.yaml
  analysis_options.yaml
  check_point_rules.md
```

Rules:

- `melos` is the monorepo orchestrator.
- The package name must stay `hr_management_system_package` initially to avoid breaking consumers.
- Shared code must live in the package, not copied into the app.
- App-specific UI, screens, and Cubits must stay in the app.
- The app may depend only on approved public package entrypoints, not package internals.

### Example

```dart
// Good
import 'package:hr_management_system_package/hr_management_system_package.dart';

// Avoid in app code after migration
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/supervisor_tasks_repo/supervisor_tasks_repo_impl.dart';
```

## 3. Tech Stack

Use these tools and patterns only:

- State management: `flutter_bloc`
- Dependency injection: `get_it`
- Networking: `dio`
- Models and unions: `freezed` and `json_serializable`
- Storage: `shared_preferences` for non-sensitive data and secure storage for secrets
- Localization: `easy_localization`
- Responsive sizing: `flutter_screenutil` in the app, and `flutter_screenutil_plus` only if already used in the package
- Routing: centralized named routes

Do not introduce overlapping replacements such as:

- `provider`
- `riverpod`
- `go_router`
- `chopper`
- `injectable`
- `retrofit`

`retrofit` is explicitly not part of this plan.

## 4. Architecture Boundaries

Use strict feature boundaries with layer separation:

```text
presentation -> domain -> data
```

Rules:

- Presentation renders state and dispatches actions only.
- Domain contains repository contracts, use cases, and pure business rules.
- Data contains API services, DTOs/models, repository implementations, and persistence details.
- Domain must not import Flutter.
- Data must not contain UI logic.
- UI must not talk to Dio, repositories, or services directly.

### Example

```dart
// domain/repos/attendance_repo.dart
abstract class AttendanceRepo {
  Future<Either<Failure, UserAttendanceValue>> checkIn(EmployeeCheckInRequestBody body);
}

// data/repos/attendance_repo_impl.dart
class AttendanceRepoImpl implements AttendanceRepo {
  AttendanceRepoImpl({required this.apiService});

  final ApiService apiService;

  @override
  Future<Either<Failure, UserAttendanceValue>> checkIn(EmployeeCheckInRequestBody body) async {
    try {
      final response = await apiService.post(endPoint: ApiConstant.checkIn, body: body.toJson());
      return Right(UserAttendanceValue.fromJson(response));
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
```

## 5. Public API Rules

The package must expose a curated public surface.

Rules:

- Create stable public entrypoints for each feature.
- Prefer import paths such as:
  - `package:hr_management_system_package/hr_management_system_package.dart`
  - `package:hr_management_system_package/auth.dart`
  - `package:hr_management_system_package/attendance.dart`
  - `package:hr_management_system_package/tasks.dart`
- Do not require app code to import deep `data/` or `domain/` internals.
- If a public export is missing, add it to the package API instead of asking the app to reach into internals.

### Example

```dart
// Good public package import
import 'package:hr_management_system_package/attendance.dart';

// Bad deep import from app code
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_attendance_model/employee_check_in_request_body.dart';
```

## 6. State, Results, and Errors

Rules:

- Use `Either<Failure, T>` consistently until a deliberate migration plan replaces it.
- Do not invent a second result type in the same layer without a migration bridge.
- Do not let exceptions leak past the repository layer.
- Map transport and parsing failures to app-friendly failures.
- Return localized or user-safe messages at the UI boundary, not raw stack traces.

### Example

```dart
try {
  final result = await apiService.get(endPoint: ApiConstant.profile);
  return Right(ProfileModel.fromJson(result));
} catch (e) {
  return Left(ErrorHandler.handle(e).failure);
}
```

## 7. Dependency Injection

Rules:

- Register everything in one place per app/package boundary.
- Order should be: external clients -> data sources/services -> repositories -> use cases -> Cubits.
- Use named parameters for all injected constructors.
- Keep injected fields public.
- Do not manually construct long dependency chains inside widgets or screens.

### Example

```dart
class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.loginUseCase}) : super(const LoginState.initial());

  final LoginUseCase loginUseCase;
}
```

## 8. UI Rules for the App

These rules apply to `apps/check_point_app` only.

Rules:

- UI renders state, sends actions, and handles local UI-only concerns.
- Do not put repository calls, validation rules, or business decisions in screens.
- Do not use private widget helper methods for non-trivial UI blocks.
- Extract named widgets into separate files.
- Every `BlocBuilder`, `BlocListener`, `BlocConsumer`, and `BlocSelector` should live in its own named widget file.
- Use `const` where possible.
- Use `TextEditingController`, `FocusNode`, and similar objects in `initState`, not in `build()`.
- Dispose controllers properly.
- Use responsive sizing instead of raw pixel literals.

### Example

```dart
// Good
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) => state.when(
        initial: () => const LoginFormWidget(),
        loading: () => const LoadingWidget(),
        success: () => const HomeWidget(),
        error: (message) => ErrorWidget(message: message),
      ),
    );
  }
}
```

## 9. Feature Rules

Use feature-first organization inside both app and package.

Required feature areas:

- auth
- attendance
- tasks
- plans
- leave
- employees
- branches
- departments
- notifications
- shared profile/media

Rules:

- Keep a feature's domain, data, and presentation code together under that feature.
- Do not mix unrelated features in one cubit, repo, or service.
- Move feature-specific logic to the owning feature, not to shared core unless it is truly cross-cutting.

## 10. Networking and API Rules

Rules:

- Keep `dio` as the HTTP client.
- Keep API access behind services/data sources.
- Every feature should have a clear API service boundary.
- Request and response shapes must come from backend contracts and real payloads.
- Do not guess field names when the API contract is known.
- Preserve environment-specific base URLs in config files, not hard-coded in screens.

### Example

```dart
final response = await apiService.post(
  endPoint: ApiConstant.login,
  body: requestBody.toJson(),
);
```

## 11. Models and Code Generation

Rules:

- Use `freezed` for state unions and immutable data where it fits.
- Use `json_serializable` for request and response models.
- Generated files must be committed or reproducible in CI.
- After touching any generated-model file, rerun build generation for the affected package.
- Do not hand-write `copyWith`, equality, or serialization logic when code generation is already used.

### Example

```dart
@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loading() = _Loading;
  const factory LoginState.success(UserModel user) = _Success;
  const factory LoginState.error(String message) = _Error;
}
```

## 12. Validation and Business Rules

Rules:

- Validation belongs in domain or use cases.
- Screens should not decide business policy.
- Cubits may trigger validation, but they should not own the full rule set.
- For multi-step flows, use a use case or orchestration service.

### Example

```dart
class LoginUseCase {
  LoginUseCase({required this.loginRepo});

  final LoginRepo loginRepo;

  Future<Either<Failure, RoleLoginModel>> call(RoleLoginRequestBody body) {
    return loginRepo.roleLogin(body);
  }
}
```

## 13. Storage and Session Rules

Rules:

- Keep secrets in secure storage.
- Keep non-sensitive preferences in shared preferences.
- Do not let repositories mutate global runtime state unless that state is a deliberate shared session cache.
- If a repo must update session values, isolate that behavior into a dedicated session or cache service where possible.

### Example

```dart
class SessionStore {
  SessionStore({required this.secureStorage});

  final FlutterSecureStorage secureStorage;
}
```

## 14. Routing Rules

Rules:

- App routing must stay centralized.
- Use named routes and a single routing entrypoint.
- Do not create feature-local route builders that bypass the router.
- Use `BlocProvider` or equivalent inside the router, not inside the screen for route-level dependencies.

### Example

```dart
case AppRoutes.login:
  return MaterialPageRoute(
    settings: const RouteSettings(name: AppRoutes.login),
    builder: (_) => BlocProvider<LoginCubit>(
      create: (_) => sl<LoginCubit>(),
      child: const LoginScreen(),
    ),
  );
```

## 15. Testing Rules

Required test coverage:

- Package unit tests for models, parsing, failure mapping, and repository behavior.
- App unit tests for Cubits and orchestration.
- App widget tests for critical screens.
- Integration tests for the highest-risk flows.
- Contract tests for request and response shapes.
- When the task is an explicit full-package refactor or hardening request,
  expand package unit coverage across every package feature area that contains
  testable non-UI logic, not only the touched file.

Required smoke gates for every PR:

- bootstrap the monorepo
- run code generation
- run analysis
- run tests

### Example

```bash
melos bootstrap
melos run build_runner
melos run analyze
melos run test
```

## 16. Monorepo Migration Rules

Rules:

- Migrate the package into the monorepo first, then tighten public APIs.
- Keep the app working during migration.
- Do not rewrite everything at once.
- Migrate feature-by-feature.
- Keep old imports alive only as long as they are tracked and intentional.
- If a feature is moved, its tests must move with it.

Recommended migration order:

1. Auth and session bootstrapping
2. Attendance
3. Shared profile/media
4. Leave
5. Tasks
6. Plans
7. Employees
8. Branches
9. Departments
10. Notifications

## 17. Production Readiness Rules

Rules:

- Every migrated feature must preserve current behavior unless a change is explicitly planned.
- Add CI checks for generated files, linting, analysis, and tests.
- Add compatibility checks for public package exports.
- Track breaking public API changes in docs.
- Keep rollback paths for cross-app/package changes.
- For explicit package-wide hardening requests, include security review items in
  scope: secret storage usage, token propagation, exception leakage, unsafe
  logs, and request/response boundary validation.

## 18. Bad vs Good

### Bad

```dart
class AttendanceScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final repo = AttendanceRepoImpl(apiService: ApiService(dio: Dio()));
    return ElevatedButton(
      onPressed: () async {
        await repo.checkIn(...);
      },
      child: const Text('Check in'),
    );
  }
}
```

### Good

```dart
class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      builder: (context, state) => state.when(
        initial: () => const AttendanceActionView(),
        loading: () => const LoadingWidget(),
        success: (data) => AttendanceSuccessView(data: data),
        error: (message) => ErrorView(message: message),
      ),
    );
  }
}
```

## 19. Default Assumptions

- The monorepo uses `melos`.
- The package name stays `hr_management_system_package` initially.
- The app remains the primary UI app.
- `retrofit` is not used in this plan.
- Existing `Either<Failure, T>` patterns remain until a planned migration changes them.
- Shared package internals must not become app dependencies.
