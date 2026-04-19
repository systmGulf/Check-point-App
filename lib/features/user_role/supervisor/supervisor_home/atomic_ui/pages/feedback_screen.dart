import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/core/routing/routes.dart';
import 'package:employee_mangement/core/widgets/build_custom_app_bar.dart';
import 'package:employee_mangement/core/widgets/custom_new_floating_action_button.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/feedback/feedback_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/feedbacks/feedback_model.dart';

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
        onPressed: () async {
          final result = await context.pushName(Routes.addFeedback);
          if (!mounted) return;
          if (result == true) {
            context.read<FeedbackCubit>().getFeedback();
          }
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
                            child: Text("No feedback available yet"),
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
                        itemCount: model.value!.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = model.value![index];
                          return _FeedbackCard(item: item);
                        },
                      ),
              ),
            GetFeedbackFilureState(:final errorMessage) => RefreshIndicator(
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
                            "Failed to load feedback",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            errorMessage,
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

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.item});

  final FeedbackItem item;

  @override
  Widget build(BuildContext context) {
    final rating = item.rating ?? 0;
    final reviewed = item.isReviewed ?? false;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.subject?.trim().isNotEmpty == true
                        ? item.subject!
                        : "No subject",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _StatusChip(isReviewed: reviewed),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.message?.trim().isNotEmpty == true
                  ? item.message!
                  : "No message",
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF4B5563),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                if (item.employeeName?.trim().isNotEmpty == true)
                  Expanded(
                    child: Text(
                      "By: ${item.employeeName}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  )
                else
                  const Spacer(),
                _RatingBadge(rating: rating),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.isReviewed});

  final bool isReviewed;

  @override
  Widget build(BuildContext context) {
    final color =
        isReviewed ? const Color(0xFF059669) : const Color(0xFF6B7280);
    final bgColor =
        isReviewed ? const Color(0xFFECFDF5) : const Color(0xFFF3F4F6);
    final label = isReviewed ? "Reviewed" : "Not reviewed";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            size: 14,
            color: Color(0xFFF59E0B),
          ),
          const SizedBox(width: 4),
          Text(
            "$rating",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}
