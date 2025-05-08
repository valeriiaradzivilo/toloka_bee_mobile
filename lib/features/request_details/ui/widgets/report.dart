import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../../common/theme/zip_fonts.dart';
import '../../../../data/models/ui/e_predefined_report_message.dart';
import '../../bloc/request_details_bloc.dart';
import '../../bloc/request_details_event.dart';

enum _EReportTarget { request, user }

Future<void> showReportDialog(
  final BuildContext context,
  final String userId,
  final String requestId,
  final RequestDetailsBloc requestDetailsBloc,
) async {
  await showDialog(
    context: context,
    builder: (final context) => BlocProvider.value(
      value: requestDetailsBloc,
      child: _ReportDialog(
        userId: userId,
        requestId: requestId,
      ),
    ),
  );
}

class _ReportDialog extends StatefulWidget {
  const _ReportDialog({
    required this.userId,
    required this.requestId,
  });
  final String userId;
  final String requestId;

  @override
  State<_ReportDialog> createState() => __ReportDialogState();
}

class __ReportDialogState extends State<_ReportDialog> {
  _EReportTarget? selectedTarget;
  EPredefinedReportMessage? selectedReason;
  final TextEditingController additionalInfoController =
      TextEditingController();

  @override
  void dispose() {
    additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => AlertDialog(
        title: Text(
          translate('report.dialog.title'),
          style: ZipFonts.big.style,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<_EReportTarget>(
                decoration: InputDecoration(
                  labelText: translate('report.dialog.select_target'),
                ),
                items: _EReportTarget.values
                    .map(
                      (final target) => DropdownMenuItem(
                        value: target,
                        child: Text(
                          switch (target) {
                            _EReportTarget.request =>
                              translate('report.dialog.target_request'),
                            _EReportTarget.user =>
                              translate('report.dialog.target_user'),
                          },
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (final value) => selectedTarget = value,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<EPredefinedReportMessage>(
                decoration: InputDecoration(
                  labelText: translate('report.dialog.select_reason'),
                ),
                items: EPredefinedReportMessage.values
                    .map(
                      (final reason) => DropdownMenuItem(
                        value: reason,
                        child: Text(reason.text),
                      ),
                    )
                    .toList(),
                onChanged: (final value) => selectedReason = value,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: additionalInfoController,
                decoration: InputDecoration(
                  labelText: translate('report.dialog.additional_info'),
                ),
                maxLines: 3,
                maxLength: 100,
              ),
              const SizedBox(height: 16),
              Text(
                translate('report.dialog.only_one_report'),
                style: ZipFonts.small.error,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(translate('common.cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedTarget != null && selectedReason != null) {
                switch (selectedTarget) {
                  case _EReportTarget.request:
                    context.read<RequestDetailsBloc>().add(
                          ReportRequestEvent(
                            requestId: widget.requestId,
                            message:
                                '${selectedReason!.text}  :  ${additionalInfoController.text}',
                          ),
                        );
                  case _EReportTarget.user:
                    context.read<RequestDetailsBloc>().add(
                          ReportUserEvent(
                            userId: widget.userId,
                            message:
                                '${selectedReason!.text}  :  ${additionalInfoController.text}',
                          ),
                        );
                  case null:
                    break;
                }
                Navigator.of(context).pop();
              }
            },
            child: Text(translate('report.dialog.send')),
          ),
        ],
      );

//TODO: Implement ability to confirm request completion by requester and volunteer
//TODO: Додай можливість скасувати запит, якщо він вже був прийнятий, то requester має вказати причину скасування
}
