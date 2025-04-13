import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

import '../../../common/theme/zip_fonts.dart';
import '../../../data/models/request_notification_model.dart';

class RequestDetailsScreen extends StatelessWidget {
  const RequestDetailsScreen(
    this.requestNotificationModel, {
    super.key,
  });
  final RequestNotificationModel requestNotificationModel;

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            spacing: 20,
            children: [
              Text(
                requestNotificationModel.description,
                style: ZipFonts.medium.style,
              ),
              if (requestNotificationModel.price != null)
                Text(
                  requestNotificationModel.price.toString(),
                  style: ZipFonts.medium.style,
                ),
              Text(
                translate(
                  'request.details.deadline',
                  args: {
                    'date': DateFormat.yMMMMEEEEd()
                        .format(requestNotificationModel.deadline),
                  },
                ),
                style: ZipFonts.medium.style,
              ),
              Text(
                requestNotificationModel.isRemote.toString(),
                style: ZipFonts.medium.style,
              ),
              if (requestNotificationModel.requiresPhysicalStrength)
                Text(
                  translate('request.details.physical'),
                  style: ZipFonts.medium.style,
                ),
            ],
          ),
        ),
      );
}
