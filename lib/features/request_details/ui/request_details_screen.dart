import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

import '../../../common/list_extension.dart';
import '../../../common/theme/zip_color.dart';
import '../../../common/theme/zip_fonts.dart';
import '../../../data/models/e_request_hand_type.dart';
import '../bloc/request_details_bloc.dart';
import '../bloc/request_details_event.dart';
import '../bloc/request_details_state.dart';
import 'widgets/cancel_request_helping_button.dart';
import 'widgets/report.dart';
import 'widgets/see_contacts_button.dart';

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
                        if (state.requestNotificationModel.requestType !=
                            ERequestHandType.other)
                          Text(
                            translate(
                              'give.hand.type',
                              args: {
                                'type': state
                                    .requestNotificationModel.requestType.text,
                              },
                            ),
                            style: ZipFonts.small.style,
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
                            state.requestNotificationModel.status.canBeHelped &&
                            !state.isCurrentUserVolunteerForRequest) ...[
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
                            child:
                                SeeContactsButton(state.requesterContactInfo!),
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (state.requestNotificationModel
                                .requiredVolunteersCount >
                            1)
                          Text(
                            translate(
                              'request.details.volunteers_needed',
                              args: {
                                'present': state.volunteers.length.toString(),
                                'need': state.requestNotificationModel
                                    .requiredVolunteersCount
                                    .toString(),
                              },
                            ),
                            style: ZipFonts.small.style,
                          ),
                        if (state.isCurrentUsersRequest ||
                            state.isCurrentUserVolunteerForRequest)
                          _ControlRequestCompletionRow(state),
                        if (!state.isCurrentUsersRequest)
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () => showReportDialog(
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
                      ],
                    ),
                  ),
                ),
            },
          ),
        ),
      );
}

class _ControlRequestCompletionRow extends StatelessWidget {
  const _ControlRequestCompletionRow(this.state);
  final RequestDetailsLoaded state;

  @override
  Widget build(final BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          if (state.isCurrentUsersRequest)
            Text(
              '${translate('request.details.volunteers')} : ${state.volunteers.map((final e) => '${e.name} ${e.surname}').join(', ')}',
              style: ZipFonts.small.style,
            ),
          Row(
            spacing: 20,
            children: [
              Flexible(
                child: CancelRequestHelpingButton(state),
              ),
              Flexible(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<RequestDetailsBloc>().add(
                          state.isCurrentUserVolunteerForRequest
                              ? ConfirmRequestIsCompletedVolunteerEvent(
                                  requestId: state.requestNotificationModel.id,
                                  workId: state.volunteerWorks
                                      .firstWhereOrNull(
                                        (final e) =>
                                            e.volunteerId ==
                                            FirebaseAuth
                                                .instance.currentUser?.uid,
                                      )
                                      ?.id,
                                )
                              : ConfirmRequestIsCompletedRequesterEvent(
                                  requestId: state.requestNotificationModel.id,
                                  workId: state.volunteerWorks
                                      .firstWhereOrNull(
                                        (final e) =>
                                            e.volunteerId ==
                                            FirebaseAuth
                                                .instance.currentUser?.uid,
                                      )
                                      ?.id,
                                ),
                        );
                    Navigator.of(context).pop();
                  },
                  label: Text(
                    translate('request.details.confirm_done'),
                    style: ZipFonts.small.style.copyWith(
                      color: ZipColor.onPrimary,
                    ),
                  ),
                  icon: const Icon(
                    Icons.done_all,
                    color: ZipColor.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
}
