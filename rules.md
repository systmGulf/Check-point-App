# Check-point App AI Rules

> Mandatory for AI agents working in this repository.
> Read this file before making code changes. If a user request conflicts with these rules, pause and ask for confirmation.

This file adapts Osama's Flutter config and the Haseem rules to the current Check-point App codebase.

## 1. Project Context

- App name/package: `employee_mangement`.
- Product domain: employee management, attendance check-in/out, admin operations, supervisor planning/tasks, leave requests, notifications, and role-based dashboards.
- Main roles: admin, employee, supervisor.
- Shared business/data package: `hr_management_system_package` from `../Check-point-package`.
- Local app code should mainly compose UI, Cubits, routing, DI, localization, and feature-specific presentation behavior.

## 2. Current Tech Stack

- State management: `flutter_bloc` Cubit/Bloc.
- Dependency injection: `get_it` in `lib/core/dependencyـinjection/registerـfactory.dart`.
- Routing: Navigator 1.0 style, centralized in `lib/core/routing/app_router.dart` and `lib/core/routing/routes.dart`.
- Localization: `easy_localization` with `assets/translations/ar-AE.json` and `assets/translations/en-US.json`.
- Responsive sizing: `flutter_screenutil` (`16.w`, `12.h`, `8.r`, `14.sp`).
- Styling: `lib/core/styles/colors.dart`, `lib/core/styles/styles.dart`, and `lib/core/utils/assets_manager.dart`.
- Networking/repositories/models mostly come from `hr_management_system_package`.
- Local storage: `shared_preferences` is available; do not store sensitive tokens/secrets there.

Do not add overlapping architecture packages such as Provider, Riverpod, GetX, go_router, injectable, chopper, or a second HTTP/network stack unless the user explicitly approves.

## 3. Change Discipline

- Make the smallest change that solves the problem.
- Fix root causes, not symptoms.
- Do not refactor unrelated code.
- Preserve existing routes, UX, translations, and package APIs unless the task explicitly requires a change.
- Read nearby files before editing.
- Respect user changes already in the worktree. Do not revert files you did not change.
- If generated files are involved, do not edit them by hand.

## 4. Architecture

Preferred direction:

```text
UI/widgets -> Cubit -> use case or repository -> package/API/storage
```

Rules:

- UI renders state and sends user actions to Cubit.
- Cubit coordinates a feature flow and emits states.
- Business decisions, validation, multi-step orchestration, and reusable transformations should move out of widgets. Prefer a use case when the flow grows.
- Repositories/API services must not be called directly from widgets.
- Do not import Flutter widgets into pure business classes.
- New shared code used by two or more places goes under `lib/core/`.
- Search `lib/core/` before creating a helper, style, asset constant, validator, or shared widget.

Legacy note:

- Existing code has `controller/`, `contoller/`, `atomic_ui/atoms`, `atomic_ui/molecules`, and `atomic_ui/organism` folders. Do not rename or move legacy folders during unrelated work.
- For new files inside an existing feature, follow the local folder style unless the user asks for a larger cleanup.

## 5. Cubit Rules

- Use Cubit by default. Use Bloc only when event streams/transformers are actually needed.
- Cubits depend on repositories from `hr_management_system_package` or a use case, not on UI widgets or API clients directly.
- Keep Cubit constructors injectable through `get_it`.
- Prefer named parameters for new injectable classes:

```dart
class PlanCubit extends Cubit<PlanState> {
  PlanCubit({required this.supervisorPlanRepo}) : super(PlanInitial());

  final SupervisorPlanRepo supervisorPlanRepo;
}
```

- Legacy positional constructors may remain during unrelated work, but do not copy them into new code.
- Cubit methods should follow this shape: emit loading -> call dependency -> fold/when result -> emit success/error.
- Do not call `getIt<T>()` inside Cubit methods. Inject the dependency in the constructor.
- Do not put notification loops, filtering rules, role decisions, date validation, or request construction branches in widgets.
- Avoid keeping `TextEditingController`, `FocusNode`, `GlobalKey<FormState>`, or other UI lifecycle objects in Cubits for new code. Keep them in StatefulWidgets and pass plain values into Cubit methods.
- If an existing Cubit already owns controllers, avoid expanding that pattern; clean it up only when the task touches that flow.
- Override `close()` when a Cubit owns disposable resources.
- Use explicit states for loading, success, and error. Add empty/no-data states when the UI needs them.
- Error states should carry user-safe messages or translation keys, not raw exception dumps.

### Cubit Example

Bad:

```dart
class AddPlanBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomAppButton(
      textButton: 'Save',
      buttonColor: ColorsManger.primaryColor,
      onPressed: () async {
        final cubit = context.read<PlanCubit>();
        if (cubit.dropdownItems.isEmpty) {
          showToast('Please Select Employees');
          return;
        }
        await getIt<NotificationRepo>().sendSingleNotification(...);
        await cubit.supervisorRepo.setSubPlan(...);
      },
    );
  }
}
```

Good:

```dart
class SetSubPlanButtonWidget extends StatelessWidget {
  const SetSubPlanButtonWidget({
    super.key,
    required this.planId,
    required this.customerId,
    required this.employeeIds,
    required this.note,
  });

  final int planId;
  final String customerId;
  final List<int> employeeIds;
  final String note;

  @override
  Widget build(BuildContext context) {
    return CustomAppButton(
      textButton: 'supervisor.plan.save'.tr(),
      buttonColor: ColorsManger.primaryColor,
      onPressed: () => context.read<PlanCubit>().setSubPlan(
            planId: planId,
            customerId: customerId,
            employeeIds: employeeIds,
            note: note,
          ),
    );
  }
}
```

```dart
class PlanCubit extends Cubit<PlanState> {
  PlanCubit({
    required this.supervisorPlanRepo,
    required this.notificationRepo,
  }) : super(PlanInitial());

  final SupervisorPlanRepo supervisorPlanRepo;
  final NotificationRepo notificationRepo;

  Future<void> setSubPlan({
    required int planId,
    required String customerId,
    required List<int> employeeIds,
    required String note,
  }) async {
    if (employeeIds.isEmpty) {
      emit(SetSubPlanError(error: 'supervisor.plan.selectEmployees'));
      return;
    }

    if (customerId.isEmpty) {
      emit(SetSubPlanError(error: 'supervisor.plan.selectCustomer'));
      return;
    }

    emit(SetSubPlanLoading());
    final result = await supervisorPlanRepo.setSubPlan(
      setSubPlansRequestBody: setSubPlansRequestBody(
        planId: planId,
        customerIdOrSiteId: customerId,
        note: note,
        employeeIds: employeeIds,
      ),
    );

    result.fold(
      (failure) {
        if (!isClosed) emit(SetSubPlanError(error: failure.message));
      },
      (_) {
        if (!isClosed) emit(SetSubPlanSuccess());
      },
    );
  }
}
```

## 6. State Rules

- State files stay next to their Cubit: `*_cubit.dart` and `*_state.dart`.
- Existing manual state classes are allowed.
- For new larger state models, prefer immutable explicit classes or Freezed only if the dependency already exists or the user approves adding it.
- Do not hand-write complex equality/copyWith boilerplate when a generated approach is approved.
- Keep state names clear:

```dart
abstract class EmployeeTasksState {}

class EmployeeTasksInitial extends EmployeeTasksState {}
class EmployeeTasksLoading extends EmployeeTasksState {}
class EmployeeTasksSuccess extends EmployeeTasksState {
  EmployeeTasksSuccess({required this.tasks});
  final List<TaskModel> tasks;
}
class EmployeeTasksError extends EmployeeTasksState {
  EmployeeTasksError({required this.message});
  final String message;
}
```

## 7. UI Rules

UI may only:

- Render state.
- Send user actions to Cubit.
- React to state changes with navigation, snackbars, dialogs, or toasts.
- Manage small local UI-only state such as selected tab, focus, animation, and text controllers.

UI must not:

- Call repositories, package APIs, or storage directly.
- Contain business rules or role permission decisions.
- Filter/sort/process large lists in `build()`.
- Own save/submit branching flows.
- Create private widget helper methods like `Widget _buildHeader()`.
- Create widget-returning functions for structured UI.

Rules:

- Extract meaningful UI into named widgets.
- Keep `BlocBuilder`, `BlocListener`, and `BlocConsumer` as low in the widget tree as possible.
- A Bloc listener/builder with meaningful logic should live in a separate named file, following existing examples such as `admin_login_bloc_listener.dart`.
- Use `const` constructors where possible.
- Do not create `TextEditingController`, `FocusNode`, `AnimationController`, `ScrollController`, or `GlobalKey` inside `build()`.
- Dispose controllers/focus nodes in `dispose()`.
- Use `ListView.builder`/`GridView.builder` for dynamic lists.
- Use `flutter_screenutil` sizes instead of raw layout pixels.
- Use directional APIs for RTL support: `EdgeInsetsDirectional`, `AlignmentDirectional`, `start`, `end`.

### UI Example

Bad:

```dart
class SupervisorPlansScreen extends StatelessWidget {
  const SupervisorPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = context
        .read<PlanCubit>()
        .cachedPlans
        .where((plan) => plan.isActive)
        .toList();

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        children: plans.map((plan) => Text(plan.name)).toList(),
      ),
    );
  }
}
```

Good:

```dart
class SupervisorPlansScreen extends StatelessWidget {
  const SupervisorPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SupervisorPlansBlocBuilder(),
    );
  }
}
```

```dart
class SupervisorPlansBlocBuilder extends StatelessWidget {
  const SupervisorPlansBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanCubit, PlanState>(
      builder: (context, state) {
        if (state is GetPlanLoading) {
          return const SupervisorSetPlanLoadingSkeleton();
        }

        if (state is GetPlanError) {
          return ErrorViewWidget(error: state.error.tr());
        }

        if (state is GetPlanSuccess) {
          return SetSubPlanListView(plans: state.planModel.plans);
        }

        return const SizedBox.shrink();
      },
    );
  }
}
```

## 8. Forms and Validation

- Use `CustomAppTextFormField` instead of raw `TextFormField` in app UI.
- Keep form controllers and focus nodes in the widget State, not in new Cubits.
- Submit buttons should remain tappable except during an in-flight request.
- On invalid submit, show a general message and inline field errors.
- Validation logic that is reused or business-specific belongs outside the widget, preferably in `core/helpers` or a use case.
- Pass plain values to Cubit methods:

```dart
context.read<LoginCubit>().doLogin(
  email: emailController.text.trim(),
  password: passwordController.text,
  role: Role.employee,
  mobileId: mobileId,
);
```

## 9. Design System and Assets

- Use `ColorsManger` from `lib/core/styles/colors.dart`.
- Use `AppStylesManger` from `lib/core/styles/styles.dart`.
- Use generated asset constants from `AssetsManager` where available.
- Do not scatter repeated `Color(0xFF...)`, `TextStyle(...)`, or asset path strings across feature widgets.
- If a style/asset is reused, add or use a central constant.

## 10. Localization

- Do not hardcode user-facing strings in new UI.
- Add keys to both translation files:
  - `assets/translations/en-US.json`
  - `assets/translations/ar-AE.json`
- Use feature-style keys such as:

```text
supervisor.plan.selectEmployees
employee.attendance.checkIn
admin.users.deleteSuccess
```

- UI translates with `.tr()`.
- Prefer emitting translation keys from Cubit for predictable messages.

## 11. Routing and DI

- Add route names to `lib/core/routing/routes.dart`.
- Add route construction to `lib/core/routing/app_router.dart`.
- Wrap screens with Cubits in `BlocProvider`/`MultiBlocProvider` inside `app_router.dart`.
- Resolve Cubits through `getIt`, not by manually constructing dependency graphs in widgets.
- Register new Cubits in `registerFactory()`.
- Keep route argument handling safe and clear. Avoid blind casts when adding new routes.

Example:

```dart
getIt.registerFactory<PlanCubit>(
  () => PlanCubit(
    supervisorPlanRepo: getIt<SupervisorPlanRepo>(),
    notificationRepo: getIt<NotificationRepo>(),
  ),
);
```

```dart
case Routes.subPlansScreen:
  final args = settings.arguments;
  if (args is! SubPlansArgs) {
    return BaseRoute(page: const NoRouteScreen());
  }

  return BaseRoute(
    page: BlocProvider(
      create: (_) => getIt<PlanCubit>()..getPlanById(id: args.planId),
      child: SubPlansScreen(args: args),
    ),
  );
```

## 12. Performance

- Keep build methods small. Split widgets when a build method becomes hard to scan.
- Do not do heavy list filtering, sorting, parsing, or network calls in `build()`.
- Use `BlocSelector` when a widget needs only one small part of a state.
- Use cached network image widgets for remote images.
- Avoid storing very large lists in multiple places.
- Guard pagination with loading/completion flags before requesting the next page.

## 13. Security and Logging

- Never hardcode tokens, secrets, OTPs, passwords, or private URLs.
- Never log tokens, passwords, OTPs, full Authorization headers, or PII.
- Do not show raw exception text to users.
- Use secure storage for sensitive values if/when token storage is introduced locally.
- `shared_preferences` is only for non-sensitive flags/preferences.

## 14. Checks Before Done

Run the relevant checks for the change:

```bash
dart analyze
flutter test
```

If generated files are introduced later, run the appropriate generator command before finishing.

## 15. How To Use This File

For Codex, Claude, Cursor, Copilot Chat, or any AI assistant, start prompts like this:

```text
Read ./rules.md first, then update the supervisor plan UI.
Follow the Cubit and UI rules. Do not refactor unrelated files.
```

```text
Read ./rules.md first. Add a new employee attendance filter.
Keep filtering logic out of widgets and use the existing route/DI style.
```

```text
Review this PR against ./rules.md.
Focus on Cubit responsibilities, UI business logic, localization, DI, and routing.
```

When the user says `done`, respond with a conventional commit message:

```text
type(scope): short summary

- describe the actual change
- describe the verification
```
