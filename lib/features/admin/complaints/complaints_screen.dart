import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../common/theme/toloka_fonts.dart';
import 'bloc/complaints_admin_bloc.dart';
import 'bloc/complaints_admin_state.dart';
import 'widgets/request_complaint_card.dart';
import 'widgets/user_complaint_card.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  bool showRequestComplaints = true;

  @override
  Widget build(final BuildContext context) =>
      BlocBuilder<ComplaintsAdminBloc, ComplaintsAdminState>(
        builder: (final context, final state) => switch (state) {
          ComplaintsAdminLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          ComplaintsAdminError(:final message) => Center(
              child: Text(message),
            ),
          RequestComplaintsLoaded(
            :final requestComplaints,
            :final userComplaints,
          ) =>
            Column(
              spacing: 16,
              children: [
                Text(
                  translate('complaints.title'),
                  style: TolokaFonts.big.style.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ToggleButtons(
                  borderRadius: BorderRadius.circular(12),
                  isSelected: [showRequestComplaints, !showRequestComplaints],
                  onPressed: (final index) {
                    setState(() {
                      showRequestComplaints = index == 0;
                    });
                  },
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(translate('complaints.requests')),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(translate('complaints.users')),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: showRequestComplaints
                        ? requestComplaints.length
                        : userComplaints.length,
                    itemBuilder: (final context, final index) =>
                        showRequestComplaints
                            ? RequestComplaintCard(
                                requestComplaints[index],
                              )
                            : UserComplaintCard(userComplaints[index]),
                  ),
                ),
              ],
            ),
        },
      );
}
