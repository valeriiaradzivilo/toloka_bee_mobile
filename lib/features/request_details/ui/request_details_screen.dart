import 'package:flutter/material.dart';

import '../../../common/theme/zip_fonts.dart';
import '../../../data/models/request_notification_model.dart';

class RequestDetailsScreen extends StatelessWidget {
  const RequestDetailsScreen(
    this.requestNotificationModel, {
    super.key,
  });
  final RequestNotificationModel requestNotificationModel;

  @override
  Widget build(final BuildContext context) => Column(
        children: [
          Text(
            requestNotificationModel.description,
            style: ZipFonts.medium.style,
          ),
          Text(
            requestNotificationModel.price.toString(),
            style: ZipFonts.medium.style,
          ),
          Text(
            requestNotificationModel.deadline.toString(),
            style: ZipFonts.medium.style,
          ),
          Text(
            requestNotificationModel.isRemote.toString(),
            style: ZipFonts.medium.style,
          ),
          Text(
            requestNotificationModel.requiresPhysicalStrength.toString(),
            style: ZipFonts.medium.style,
          ),
        ],
      );
}
