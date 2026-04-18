import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/core/routing/routes.dart';
import 'package:employee_mangement/core/widgets/build_custom_app_bar.dart';
import 'package:employee_mangement/core/widgets/custom_new_floating_action_button.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/attendence/attendence_cubit.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/feedback/feedback_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../contoller/feedback/feedback_cubit.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FeedbackCubit>()..getFeedback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, "Feedback"),
      floatingActionButton: CustomNewFloatingActionButton(
        onPressed: () {
          context.pushName(Routes.addFeedback);
        },
      ),
      body: BlocBuilder<FeedbackCubit, FeedbackState>(
        builder: (context, state) {
          return switch (state) {
            GetFeedbackLoadingState() => const Center(
                child: CircularProgressIndicator(),
              ),
            GetFeedbackSuccessState(feedbackModel: final model) =>
              RefreshIndicator(
                onRefresh: () async {
                  context.read<FeedbackCubit>()..getFeedback();
                },
                child: model.value == null || model.value!.isEmpty
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: const Center(
                            child: Text("No feedbacks available"),
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: model.value!.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = model.value![index];
                          return ListTile(
                            title: Text(item.subject ?? "No subject"),
                            subtitle: Text(item.message ?? "No message"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${item.rating ?? 0} ⭐",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            GetFeedBackStatusFailureState(:final error) => RefreshIndicator(
                onRefresh: () async {
                  context.read<FeedbackCubit>()..getFeedback();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Failed to load feedbacks",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            error,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () =>
                                context.read<FeedbackCubit>()..getFeedback(),
                            icon: const Icon(Icons.refresh),
                            label: const Text("Retry"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
