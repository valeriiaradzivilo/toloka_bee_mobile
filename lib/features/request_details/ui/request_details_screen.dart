import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

import '../../../common/theme/zip_color.dart';
import '../../../common/theme/zip_fonts.dart';
import '../../../data/models/ui/e_predefined_report_message.dart';
import '../bloc/request_details_bloc.dart';
import '../bloc/request_details_event.dart';
import '../bloc/request_details_state.dart';

class RequestDetailsScreen extends StatelessWidget {
  const RequestDetailsScreen({
    super.key,
  });

  @override
  Widget build(final BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: BlocBuilder<RequestDetailsBloc, RequestDetailsState>(
            builder: (final context, final state) => switch (state) {
              RequestDetailsLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              RequestDetailsError() => Center(
                  child: Column(
                    children: [
                      Text(
                        translate('common.error.title'),
                        style: ZipFonts.medium.error,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        translate('common.error.message'),
                        style: ZipFonts.small.error,
                      ),
                    ],
                  ),
                ),
              RequestDetailsLoaded() => SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (state.image.isNotEmpty)
                              SizedBox(
                                width: 200,
                                height: 200,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: MemoryImage(
                                        state.image,
                                      ),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              ),
                            Flexible(
                              child: Column(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      translate(
                                        'request.details.user.name',
                                        args: {
                                          'name': state.user.name,
                                          'surname': state.user.surname,
                                        },
                                      ),
                                      style: ZipFonts.big.style.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      translate(
                                        'request.details.user.about',
                                        args: {
                                          'about': state.user.about,
                                        },
                                      ),
                                      style: ZipFonts.medium.style,
                                    ),
                                  ),
                                  if (state.requestNotificationModel.isRemote)
                                    Text(
                                      translate('request.details.remote'),
                                      style: ZipFonts.medium.style,
                                    )
                                  else
                                    Text(
                                      translate(
                                        'request.details.distance',
                                        args: {
                                          'distance':
                                              state.distance.toStringAsFixed(2),
                                        },
                                      ),
                                      style: ZipFonts.medium.style,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          state.requestNotificationModel.description,
                          style: ZipFonts.medium.style,
                        ),
                        if (state.requestNotificationModel.price != null)
                          Text(
                            state.requestNotificationModel.price.toString(),
                            style: ZipFonts.medium.style,
                          ),
                        Text(
                          translate(
                            'request.details.deadline',
                            args: {
                              'date': DateFormat.yMMMMEEEEd().format(
                                state.requestNotificationModel.deadline,
                              ),
                            },
                          ),
                          style: ZipFonts.small.style,
                        ),
                        if (state
                            .requestNotificationModel.requiresPhysicalStrength)
                          Text(
                            translate('request.details.physical'),
                            style: ZipFonts.small.style,
                          ),
                        Text(
                          translate(
                            'request.details.status',
                            args: {
                              'status':
                                  state.requestNotificationModel.status.text,
                            },
                          ),
                        ),
                        if (!state.isCurrentUsersRequest) ...[
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                context
                                    .read<RequestDetailsBloc>()
                                    .add(const AcceptRequest());
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                translate('request.details.help'),
                              ),
                            ),
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () => _showReportDialog(
                                context,
                                state.user.id,
                                state.requestNotificationModel.id,
                                context.read<RequestDetailsBloc>(),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ZipColor.onErrorContainer,
                              ),
                              child: Text(
                                translate('request.details.report'),
                              ),
                            ),
                          ),
                        ],
                        if (state.isCurrentUsersRequest)
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<RequestDetailsBloc>().add(
                                      RemoveRequest(
                                        state.requestNotificationModel.id,
                                      ),
                                    );
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                translate('request.details.remove'),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            },
          ),
        ),
      );
}

enum _EReportTarget { request, user }

Future<void> _showReportDialog(
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
}
