import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../common/routing/routes.dart';
import '../../../common/theme/zip_fonts.dart';
import '../../../data/models/request_complaints_group_model.dart';
import '../../../data/models/user_complaints_group_model.dart';
import 'bloc/complaints_admin_bloc.dart';
import 'bloc/complaints_admin_event.dart';
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
                            ? _RequestComplaintCard(
                                requestComplaints[index],
                              )
                            : _UserComplaintCard(userComplaints[index]),
                  ),
                ),
              ],
            ),
        },
      );
}

class _UserComplaintCard extends StatefulWidget {
  const _UserComplaintCard(this.group);
  final UserComplaintsGroupModel group;

  @override
  State<_UserComplaintCard> createState() => _UserComplaintCardState();
}

class _UserComplaintCardState extends State<_UserComplaintCard> {
  final MenuController _menuAnchorController = MenuController();

  @override
  void dispose() {
    _menuAnchorController.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        Clipboard.setData(
                          ClipboardData(text: widget.group.reportedUserId),
                        ).then((final _) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(translate('common.copied')),
                              ),
                            );
                          }
                        });
                      },
                      child: Text(
                        'ID: ${widget.group.reportedUserId}',
                        style: ZipFonts.small.style.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${translate('complaints.count')}${widget.group.totalComplaints}',
                      style: ZipFonts.small.style,
                    ),
                    Text(
                      translate('complaints.comments'),
                      style: ZipFonts.small.style.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...widget.group.complaints.map<Widget>(
                      (final complaint) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '• ${complaint.reason} (${complaint.createdAt})',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              MenuAnchor(
                controller: _menuAnchorController,
                menuChildren: [
                  ListTile(
                    title: Text(translate('admin.complaint.open_user_profile')),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        Routes.adminUserProfile,
                        arguments: widget.group.reportedUserId,
                      );
                    },
                  ),
                  ListTile(
                    title: Text(translate('admin.complaint.block_user')),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (final context) => AlertDialog(
                          title: Text(translate('admin.complaint.block_user')),
                          content: Text(
                            translate('admin.complaint.block_user_message'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(translate('common.cancel')),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<ComplaintsAdminBloc>().add(
                                      BlockUserAdminEvent(
                                        userId: widget.group.reportedUserId,
                                        months: 1,
                                      ),
                                    );
                                Navigator.of(context).pop();
                              },
                              child: Text(translate('common.confirm')),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title:
                        Text(translate('admin.complaint.block_user_forever')),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (final context) => AlertDialog(
                          title: Text(
                            translate('admin.complaint.block_user_forever'),
                          ),
                          content: Text(
                            translate(
                              'admin.complaint.block_user_message',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(translate('common.cancel')),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<ComplaintsAdminBloc>().add(
                                      BlockUserForeverEvent(
                                        widget.group.reportedUserId,
                                      ),
                                    );
                                Navigator.of(context).pop();
                              },
                              child: Text(translate('common.confirm')),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
                style: MenuStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.surface,
                  ),
                  shadowColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primary,
                  ),
                  elevation: const WidgetStatePropertyAll(10),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                        width: 5,
                      ),
                    ),
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    if (_menuAnchorController.isOpen) {
                      _menuAnchorController.close();
                    } else {
                      _menuAnchorController.open();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
}

class _RequestComplaintCard extends StatefulWidget {
  const _RequestComplaintCard(this.group);
  final RequestComplaintsGroupModel group;

  @override
  State<_RequestComplaintCard> createState() => _RequestComplaintCardState();
}

class _RequestComplaintCardState extends State<_RequestComplaintCard> {
  final MenuController _menuAnchorController = MenuController();

  @override
  void dispose() {
    _menuAnchorController.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        Clipboard.setData(
                          ClipboardData(text: widget.group.requestId),
                        ).then((final _) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(translate('common.copied')),
                              ),
                            );
                          }
                        });
                      },
                      child: Text(
                        'ID: ${widget.group.requestId}',
                        style: ZipFonts.small.style.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${translate('complaints.count')}${widget.group.totalComplaints}',
                      style: ZipFonts.small.style,
                    ),
                    Text(
                      translate('complaints.comments'),
                      style: ZipFonts.small.style.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...widget.group.complaints.map<Widget>(
                      (final complaint) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '• ${complaint.reason} (${complaint.createdAt})',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              MenuAnchor(
                controller: _menuAnchorController,
                menuChildren: [
                  ListTile(
                    title: Text(translate('admin.complaint.open_request')),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        Routes.requestDetailsScreen,
                        arguments: widget.group.requestId,
                      );
                    },
                  ),
                  ListTile(
                    title: Text(translate('admin.complaint.delete_request')),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (final context) => AlertDialog(
                          title:
                              Text(translate('admin.complaint.delete_request')),
                          content: Text(
                            translate('admin.complaint.delete_request_message'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(translate('common.cancel')),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<ComplaintsAdminBloc>().add(
                                      DeleteRequestEvent(
                                        widget.group.requestId,
                                      ),
                                    );
                                Navigator.of(context).pop();
                              },
                              child: Text(translate('common.confirm')),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text(
                      translate(
                        'admin.complaint.delete_request_and_block_user',
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (final context) => AlertDialog(
                          title: Text(
                            translate(
                              'admin.complaint.delete_request_and_block_user',
                            ),
                          ),
                          content: Text(
                            translate('admin.complaint.delete_request_message'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(translate('common.cancel')),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<ComplaintsAdminBloc>().add(
                                      DeleteRequestAndBlockUserEvent(
                                        widget.group.requestId,
                                      ),
                                    );
                                Navigator.of(context).pop();
                              },
                              child: Text(translate('common.confirm')),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
                style: MenuStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.surface,
                  ),
                  shadowColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primary,
                  ),
                  elevation: const WidgetStatePropertyAll(10),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                        width: 5,
                      ),
                    ),
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    if (_menuAnchorController.isOpen) {
                      _menuAnchorController.close();
                    } else {
                      _menuAnchorController.open();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
