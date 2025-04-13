import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../common/theme/zip_color.dart';
import '../../../common/theme/zip_fonts.dart';
import '../bloc/give_hand_bloc.dart';
import '../bloc/give_hand_state.dart';

class GiveHandScreen extends StatelessWidget {
  const GiveHandScreen({super.key});

  @override
  Widget build(final BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height,
        child: BlocBuilder<GiveHandBloc, GiveHandState>(
          builder: (final context, final state) => switch (state) {
            GiveHandLoading() =>
              const Center(child: CircularProgressIndicator()),
            GiveHandLoaded(:final requests) => ListView.separated(
                itemCount: requests.length,
                itemBuilder: (final context, final index) {
                  final request = requests[index];
                  return Badge(
                    backgroundColor: ZipColor.onTertiaryFixed,
                    isLabelVisible: request.isRemote,
                    label: Text(
                      'Remote',
                      style: ZipFonts.medium.style.copyWith(
                        color: ZipColor.onTertiary,
                      ),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://thumb.ac-illust.com/30/30fa090868a2f8236c55ef8c1361db01_t.jpeg',
                        ),
                      ),
                      title: Text(
                        request.description,
                        style: ZipFonts.medium.style,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\u2981 Deadline: ${DateFormat.yMMMMEEEEd().format(request.deadline)}',
                            ),
                            if (request.price != null && request.price != 0)
                              Text('\u2981 Price: ${request.price}'),
                          ],
                        ),
                      ),
                      onTap: () {
                        // Navigate to request details screen
                      },
                    ),
                  );
                },
                separatorBuilder:
                    (final BuildContext context, final int index) =>
                        const Divider(),
              ),
            GiveHandError() =>
              const Center(child: Text('Error loading requests')),
          },
        ),
      );
}
