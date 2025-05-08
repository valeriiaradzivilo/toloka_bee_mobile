import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../../common/theme/zip_color.dart';
import '../../../../common/theme/zip_fonts.dart';
import '../../../../common/widgets/app_text_editing_field.dart';
import '../../bloc/request_details_bloc.dart';
import '../../bloc/request_details_event.dart';
import '../../bloc/request_details_state.dart';

class CancelRequestHelpingButton extends StatefulWidget {
  const CancelRequestHelpingButton(this.state, {super.key});
  final RequestDetailsLoaded state;

  @override
  State<CancelRequestHelpingButton> createState() => _CancelRequestState();
}

class _CancelRequestState extends State<CancelRequestHelpingButton> {
  final TextEditingController _reasonController = TextEditingController();
  bool _isReasonValid = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (final context) => AlertDialog(
              title: Text(
                translate(
                  widget.state.isCurrentUsersRequest
                      ? 'request.details.cancel'
                      : 'request.details.cancel_volunteer',
                ),
                style: ZipFonts.medium.style,
              ),
              content: Column(
                children: [
                  Text(
                    translate(
                      widget.state.isCurrentUsersRequest
                          ? 'request.details.cancel_confirm'
                          : 'request.details.cancel_volunteer_confirm',
                    ),
                  ),
                  if (widget.state.isCurrentUsersRequest)
                    AppTextField(
                      controller: _reasonController,
                      label: translate('request.details.cancel_reason'),
                      maxLines: 3,
                      maxSymbols: 100,
                      isRequired: true,
                      onValidate: (final p0) {
                        setState(() {
                          _isReasonValid = p0;
                        });
                      },
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    translate('common.cancel'),
                  ),
                ),
                ElevatedButton(
                  onPressed: switch (
                      widget.state.isCurrentUserVolunteerForRequest) {
                    true => () {
                        context.read<RequestDetailsBloc>().add(
                              CancelHelpingEvent(
                                widget.state.volunteerWorks
                                    .firstWhere(
                                      (final e) =>
                                          e.volunteerId ==
                                          FirebaseAuth
                                              .instance.currentUser?.uid,
                                    )
                                    .id,
                              ),
                            );
                        Navigator.of(context).pop();
                      },
                    false when _isReasonValid => () {
                        context.read<RequestDetailsBloc>().add(
                              CancelRequestEvent(
                                requestId:
                                    widget.state.requestNotificationModel.id,
                                reason: _reasonController.text,
                              ),
                            );
                        Navigator.of(context).pop();
                      },
                    _ => null
                  },
                  child: Text(
                    translate('common.delete'),
                  ),
                ),
              ],
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ZipColor.errorContainer,
        ),
        label: Text(
          translate(
            widget.state.isCurrentUsersRequest
                ? 'request.details.cancel'
                : 'request.details.cancel_volunteer',
          ),
          style: ZipFonts.small.style.copyWith(
            color: ZipColor.onErrorContainer,
          ),
        ),
        icon: const Icon(
          Icons.cancel_presentation_rounded,
          color: ZipColor.onErrorContainer,
        ),
      );
}
