import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../../common/routing/routes.dart';
import '../../../../common/theme/toloka_fonts.dart';
import '../../../../data/models/complaints/user_complaints_group_model.dart';
import '../bloc/complaints_admin_bloc.dart';
import '../bloc/complaints_admin_event.dart';
import 'admin_cancel_button.dart';

class UserComplaintCard extends StatefulWidget {
  const UserComplaintCard(this.group, {super.key});
  final UserComplaintsGroupModel group;

  @override
  State<UserComplaintCard> createState() => _UserComplaintCardState();
}

class _UserComplaintCardState extends State<UserComplaintCard> {
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
                        style: TolokaFonts.small.style.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${translate('complaints.count')}${widget.group.totalComplaints}',
                      style: TolokaFonts.small.style,
                    ),
                    Text(
                      translate('complaints.comments'),
                      style: TolokaFonts.small.style.copyWith(
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
                        builder: (final ctx) => AlertDialog(
                          title: Text(translate('admin.complaint.block_user')),
                          content: Text(
                            translate('admin.complaint.block_user_message'),
                          ),
                          actions: [
                            const AdminCancelButton(),
                            TextButton(
                              onPressed: () async {
                                final blockUntil = await showDatePicker(
                                  context: ctx,
                                  firstDate: DateTime.now().add(
                                    const Duration(days: 1),
                                  ),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 100000),
                                  ),
                                );
                                if (blockUntil == null) {
                                  return;
                                }

                                if (context.mounted) {
                                  context.read<ComplaintsAdminBloc>().add(
                                        BlockUserEvent(
                                          userId: widget.group.reportedUserId,
                                          blockUntil: blockUntil,
                                        ),
                                      );

                                  Navigator.of(ctx).pop();
                                }
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
                      showAdminConfirmDialog(
                        context: context,
                        title: translate('admin.complaint.block_user_forever'),
                        content: translate(
                          'admin.complaint.block_user_message',
                        ),
                        onConfirm: () {
                          context.read<ComplaintsAdminBloc>().add(
                                BlockUserForeverEvent(
                                  widget.group.reportedUserId,
                                ),
                              );
                        },
                      );
                    },
                  ),
                  ListTile(
                    title: Text(translate('admin.complaint.delete_complaint')),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (final context) => AlertDialog(
                          title: Text(
                            translate('admin.complaint.delete_complaint'),
                          ),
                          content: Text(
                            translate(
                              'admin.complaint.delete_complaint_message',
                            ),
                          ),
                          actions: [
                            const AdminCancelButton(),
                            TextButton(
                              onPressed: () {
                                context.read<ComplaintsAdminBloc>().add(
                                      DeleteUserComplaintEvent(
                                        complaintId: widget.group.complaints
                                            .map(
                                              (final complaint) => complaint.id,
                                            )
                                            .toList(),
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
