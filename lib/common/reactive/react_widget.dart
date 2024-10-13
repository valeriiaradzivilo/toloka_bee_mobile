import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../theme/zip_fonts.dart';

class ReactWidget<T> extends StatelessWidget {
  const ReactWidget({super.key, required this.stream, required this.builder});
  final Stream<T> stream;
  final Function(T data) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: stream,
        builder: (context, data) {
          if (data.hasData) {
            if (data.data case final T d) {
              return builder(d);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
          if (data.hasError) {
            return Center(
                child: Text(
              translate('oops.error.occurred'),
              style: ZipFonts.small.error,
            ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
