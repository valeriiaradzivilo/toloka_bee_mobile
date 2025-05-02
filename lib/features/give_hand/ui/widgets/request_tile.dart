import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

import '../../../../common/routing/routes.dart';
import '../../../../common/theme/zip_fonts.dart';
import '../../../../data/models/request_notification_model.dart';

class RequestTile extends StatelessWidget {
  const RequestTile({super.key, required this.request, this.distance});
  final RequestNotificationModel request;
  final String? distance;

  @override
  Widget build(final BuildContext context) => ListTile(
        title: Text(
          request.description,
          style: ZipFonts.small.style.copyWith(
            fontWeight: FontWeight.w900,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\u2981 ${translate(
                  'give.hand.deadline',
                  args: {
                    'date': DateFormat.yMMMMEEEEd().format(request.deadline),
                    'days': request.deadline
                        .difference(DateTime.now())
                        .inDays
                        .toString(),
                  },
                )}',
                style: ZipFonts.tiny.style,
              ),
              if (request.price != null && request.price != 0)
                Text(
                  '\u2981 ${translate(
                    'give.hand.price',
                    args: {
                      'price': request.price.toString(),
                    },
                  )}',
                  style: ZipFonts.tiny.style,
                ),
              if (request.isRemote == false && distance != null)
                Text(
                  '\u2981 ${translate(
                    'give.hand.distance',
                    args: {
                      'distance': distance,
                    },
                  )}',
                  style: ZipFonts.tiny.style,
                ),
            ],
          ),
        ),
        trailing: ElevatedButton(
          onPressed: () => Navigator.of(context).pushNamed(
            Routes.requestDetailsScreen,
            arguments: request.id,
          ),
          child: Text(translate('common.action.learn')),
        ),
        onTap: () => Navigator.of(context).pushNamed(
          Routes.requestDetailsScreen,
          arguments: request.id,
        ),
      );
}
