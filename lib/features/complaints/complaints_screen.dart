import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../common/theme/zip_fonts.dart';
import '../../data/models/request_complaints_group_model.dart';
import '../../data/models/user_complaints_group_model.dart';
import 'bloc/complaints_admin_bloc.dart';
import 'bloc/complaints_admin_state.dart';

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
                  style: ZipFonts.big.style.copyWith(
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
                            ? _buildRequestComplaintCard(
                                requestComplaints[index],
                              )
                            : _buildUserComplaintCard(userComplaints[index]),
                  ),
                ),
              ],
            ),
        },
      );

  Widget _buildRequestComplaintCard(final RequestComplaintsGroupModel group) =>
      Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                translate('complaints.count') +
                    group.totalComplaints.toString(),
              ),
              const SizedBox(height: 8),
              ...group.complaints.map<Widget>(
                (final complaint) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('• ${complaint.reason} (${complaint.createdAt})'),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildUserComplaintCard(final UserComplaintsGroupModel group) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ID користувача: ${group.reportedUserId}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Кількість скарг: ${group.totalComplaints}'),
              const SizedBox(height: 8),
              ...group.complaints.map<Widget>(
                (final complaint) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('• ${complaint.reason} (${complaint.createdAt})'),
                ),
              ),
            ],
          ),
        ),
      );
}
