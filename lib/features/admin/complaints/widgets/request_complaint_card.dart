import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../../common/routing/routes.dart';
import '../../../../common/theme/toloka_fonts.dart';
import '../../../../data/models/complaints/request_complaints_group_model.dart';
import '../bloc/complaints_admin_bloc.dart';
import '../bloc/complaints_admin_event.dart';

class RequestComplaintCard extends StatefulWidget {
  const RequestComplaintCard(this.group, {super.key});
  final RequestComplaintsGroupModel group;

  @override
  State<RequestComplaintCard> createState() => _RequestComplaintCardState();
}

class _RequestComplaintCardState extends State<RequestComplaintCard> {
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
                        builder: (final _) => BlocProvider.value(
                          value: context.read<ComplaintsAdminBloc>(),
                          child: AlertDialog(
                            title: Text(
                              translate('admin.complaint.delete_request'),
                            ),
                            content: Text(
                              translate(
                                'admin.complaint.delete_request_message',
                              ),
                            ),
                            actions: [
                              const _CancelButton(),
                              TextButton(
                                onPressed: () {
                                  context.read<ComplaintsAdminBloc>().add(
                                        DeleteRequestEvent(
                                          requestId: widget.group.requestId,
                                          complaintIds: widget.group.complaints
                                              .map(
                                                (final complaint) =>
                                                    complaint.id,
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
                            const _CancelButton(),
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
                  ListTile(
                    title: Text(translate('admin.complaint.delete_complaint')),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (final ctx) => AlertDialog(
                          title: Text(
                            translate('admin.complaint.delete_complaint'),
                          ),
                          content: Text(
                            translate(
                              'admin.complaint.delete_complaint_message',
                            ),
                          ),
                          actions: [
                            const _CancelButton(),
                            TextButton(
                              onPressed: () {
                                context.read<ComplaintsAdminBloc>().add(
                                      DeleteRequestComplaintEvent(
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

class _CancelButton extends StatelessWidget {
  const _CancelButton();

  @override
  Widget build(final BuildContext context) => TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(translate('common.cancel')),
      );
}
