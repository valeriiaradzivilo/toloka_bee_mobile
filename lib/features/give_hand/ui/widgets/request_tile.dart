import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

import '../../../../common/routing/routes.dart';
import '../../../../common/theme/toloka_color.dart';
import '../../../../common/theme/toloka_fonts.dart';
import '../../../../data/models/e_request_hand_type.dart';
import '../../../../data/models/request_notification_model.dart';

class RequestTile extends StatelessWidget {
  const RequestTile({
    super.key,
    required this.request,
    this.distance,
    this.showStatus = true,
    this.width = double.infinity,
    this.maxDescriptionLines = 3,
  });
  final RequestNotificationModel request;
  final String? distance;
  final bool showStatus;
  final double width;
  final int maxDescriptionLines;

  @override
  Widget build(final BuildContext context) => SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
              Routes.requestDetailsScreen,
              arguments: request.id,
            ),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: TolokaColor.primary,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 20,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              request.description,
                              style: TolokaFonts.small.style.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                              maxLines: maxDescriptionLines,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            if (request.requestType != ERequestHandType.other)
                              Text(
                                '\u2981 ${translate(
                                  'give.hand.type',
                                  args: {
                                    'type': request.requestType.text,
                                  },
                                )}',
                                style: TolokaFonts.tiny.style,
                                overflow: TextOverflow.clip,
                              ),
                            Text(
                              '\u2981 ${translate(
                                'give.hand.deadline',
                                args: {
                                  'date': DateFormat.yMMMMEEEEd()
                                      .format(request.deadline),
                                  'days': request.deadline
                                      .difference(DateTime.now())
                                      .inDays
                                      .toString(),
                                },
                              )}',
                              style: TolokaFonts.tiny.style,
                              overflow: TextOverflow.clip,
                            ),
                            if (request.price != null && request.price != 0)
                              Text(
                                '\u2981 ${translate(
                                  'give.hand.price',
                                  args: {
                                    'price': request.price.toString(),
                                  },
                                )}',
                                style: TolokaFonts.tiny.style,
                                overflow: TextOverflow.clip,
                              ),
                            if (distance != null && !request.isRemote)
                              Text(
                                '\u2981 ${translate(
                                  'give.hand.distance',
                                  args: {
                                    'distance': distance,
                                  },
                                )}',
                                style: TolokaFonts.tiny.style,
                                overflow: TextOverflow.clip,
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pushNamed(
                            Routes.requestDetailsScreen,
                            arguments: request.id,
                          ),
                          label: Text(
                            translate('common.action.learn'),
                            style: TolokaFonts.tiny.style.copyWith(
                              color: TolokaColor.onPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 15,
                            color: TolokaColor.onPrimary,
                          ),
                          iconAlignment: IconAlignment.end,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showStatus)
                  Transform.rotate(
                    angle: 0.2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: request.status.color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        request.status.text,
                        style: TolokaFonts.small.style.copyWith(
                          color: TolokaColor.onPrimary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
