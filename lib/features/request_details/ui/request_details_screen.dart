import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

import '../../../common/theme/zip_fonts.dart';
import '../bloc/request_details_bloc.dart';
import '../bloc/request_details_state.dart';
import '../bloc/request_detatils_event.dart';

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
                      ],
                    ),
                  ),
                ),
            },
          ),
        ),
      );
}
