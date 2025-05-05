import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

import '../../../common/list_extension.dart';
import '../../../common/theme/zip_color.dart';
import '../../../common/theme/zip_fonts.dart';
import '../../../data/models/contact_info_model.dart';
import '../../../data/models/ui/e_predefined_report_message.dart';
import '../../profile/ui/widgets/profile_contacts.dart';
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
                        if (state.isCurrentUsersRequest)
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: ZipColor.secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                translate('request.details.your_request'),
                                style: ZipFonts.big.style.copyWith(
                                  color: ZipColor.secondary,
                                ),
                              ),
                            ),
                          ),
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
                                          'name': state.requester.name,
                                          'surname': state.requester.surname,
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
                                          'about': state.requester.about,
                                        },
                                      ),
                                      style: ZipFonts.medium.style,
                                    ),
                                  ),
                                  if (state.requestNotificationModel
                                      .requiresPhysicalStrength)
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: ZipColor.onPrimaryFixed,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          translate('request.details.physical'),
                                          style: ZipFonts.medium.style.copyWith(
                                            color: ZipColor.onTertiary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (state.requestNotificationModel.isRemote)
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: ZipColor.onTertiaryFixed,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          translate('request.details.remote'),
                                          style: ZipFonts.medium.style.copyWith(
                                            color: ZipColor.onTertiary,
                                          ),
                                        ),
                                      ),
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
                                  Text(
                                    translate(
                                      'request.details.status',
                                      args: {
                                        'status': state.requestNotificationModel
                                            .status.text
                                            .toLowerCase(),
                                      },
                                    ),
                                    style: ZipFonts.small.style.copyWith(
                                      color: state.requestNotificationModel
                                          .status.color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          state.requestNotificationModel.description,
                          style: ZipFonts.medium.style.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        if (state.requestNotificationModel.price != null)
                          Row(
                            spacing: 20,
                            children: [
                              Tooltip(
                                message: translate(
                                  'request.details.price_hint',
                                ),
                                triggerMode: TooltipTriggerMode.tap,
                                child: const Icon(
                                  Icons.info_outline,
                                  color: ZipColor.primary,
                                ),
                              ),
                              Text(
                                '${translate(
                                  'request.details.price',
                                )} : ${state.requestNotificationModel.price}',
                                style: ZipFonts.medium.style,
                              ),
                            ],
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
                        if (!state.isCurrentUsersRequest &&
                            state.requestNotificationModel.status
                                .canBeHelped) ...[
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context
                                    .read<RequestDetailsBloc>()
                                    .add(const AcceptRequest());
                                Navigator.of(context).pop();
                              },
                              label: Text(
                                translate(
                                  'request.details.help',
                                  args: {
                                    'user':
                                        '${state.requester.name} ${state.requester.surname}',
                                  },
                                ),
                              ),
                              icon: const Icon(
                                Icons.volunteer_activism_rounded,
                                color: ZipColor.onPrimary,
                              ),
                            ),
                          ),
                        ],
                        if (state.requesterContactInfo == null)
                          Text(
                            translate('request.details.no_contacts'),
                            style: ZipFonts.medium.style.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (state.isCurrentUserVolunteerForRequest &&
                            state.requesterContactInfo != null)
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (final context) => AlertDialog(
                                    title: Text(
                                      translate('request.details.contacts'),
                                      style: ZipFonts.big.style,
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 10,
                                      children: [
                                        Text(
                                          translate(
                                            'request.details.contacts_hint',
                                          ),
                                          style: ZipFonts.small.style,
                                        ),
                                        ContactDataText(
                                          method: ContactMethod.phone,
                                          value:
                                              state.requesterContactInfo!.phone,
                                        ),
                                        ContactDataText(
                                          method: ContactMethod.viber,
                                          value:
                                              state.requesterContactInfo!.viber,
                                        ),
                                        ContactDataText(
                                          method: ContactMethod.telegram,
                                          value: state
                                              .requesterContactInfo!.telegram,
                                        ),
                                        ContactDataText(
                                          method: ContactMethod.whatsapp,
                                          value: state
                                              .requesterContactInfo!.whatsapp,
                                        ),
                                        ContactDataText(
                                          method: ContactMethod.email,
                                          value:
                                              state.requesterContactInfo!.email,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              label: Text(
                                translate('request.details.see_contacts'),
                              ),
                              icon: const Icon(
                                Icons.phone,
                                color: ZipColor.onError,
                              ),
                            ),
                          ),
                        if (state.isCurrentUsersRequest)
                          Text(
                            '${translate('request.details.volunteers')} : ${state.volunteers.map((final e) => '${e.name} ${e.surname}').join(', ')}',
                            style: ZipFonts.small.style,
                          ),
                        if (state.isCurrentUserVolunteerForRequest ||
                            state.isCurrentUsersRequest)
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.read<RequestDetailsBloc>().add(
                                      state.isCurrentUserVolunteerForRequest
                                          ? ConfirmRequestIsCompletedVolunteerEvent(
                                              requestId: state
                                                  .requestNotificationModel.id,
                                              workId: state.volunteerWorks
                                                  .firstWhereOrNull(
                                                    (final e) =>
                                                        e.volunteerId ==
                                                        FirebaseAuth.instance
                                                            .currentUser?.uid,
                                                  )
                                                  ?.id,
                                            )
                                          : ConfirmRequestIsCompletedRequesterEvent(
                                              requestId: state
                                                  .requestNotificationModel.id,
                                              workId: state.volunteerWorks
                                                  .firstWhereOrNull(
                                                    (final e) =>
                                                        e.volunteerId ==
                                                        FirebaseAuth.instance
                                                            .currentUser?.uid,
                                                  )
                                                  ?.id,
                                            ),
                                    );
                                Navigator.of(context).pop();
                              },
                              label: Text(
                                translate('request.details.confirm_done'),
                              ),
                              icon: const Icon(
                                Icons.done_all,
                                color: ZipColor.onPrimary,
                              ),
                            ),
                          ),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () => _showReportDialog(
                              context,
                              state.requester.id,
                              state.requestNotificationModel.id,
                              context.read<RequestDetailsBloc>(),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ZipColor.onErrorContainer,
                            ),
                            label: Text(
                              translate('request.details.report'),
                            ),
                            icon: const Icon(
                              Icons.report,
                              color: ZipColor.onError,
                            ),
                          ),
                        ),
                        if (state.isCurrentUsersRequest)
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // dialog to confirm
                                showDialog(
                                  context: context,
                                  builder: (final context) => AlertDialog(
                                    title: Text(
                                      translate('request.details.remove'),
                                      style: ZipFonts.big.style,
                                    ),
                                    content: Text(
                                      translate(
                                        'request.details.remove_confirm',
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text(
                                          translate('common.cancel'),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<RequestDetailsBloc>()
                                              .add(
                                                RemoveRequest(
                                                  state.requestNotificationModel
                                                      .id,
                                                ),
                                              );
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          translate('common.delete'),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              label: Text(
                                translate('request.details.remove'),
                              ),
                              icon: const Icon(
                                Icons.delete_forever_rounded,
                                color: ZipColor.onError,
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

//TODO: Implement ability to confirm request completion by requester and volunteer
//TODO: Add a list for completed or in progress requests for volunteers
}
