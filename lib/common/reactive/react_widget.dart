import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../theme/zip_fonts.dart';

class ReactWidget<T> extends StatelessWidget {
  const ReactWidget({super.key, required this.stream, required this.builder});
  final Stream<T> stream;
  final Function(T data) builder;

  @override
  Widget build(final BuildContext context) {
    return StreamBuilder(
        stream: stream,
        builder: (final context, final data) {
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

class ReactWidget2<T, A> extends StatelessWidget {
  const ReactWidget2(
      {super.key,
      required this.stream1,
      required this.stream2,
      required this.builder});
  final Stream<T> stream1;
  final Stream<A> stream2;
  final Function(T data1, A data2) builder;

  @override
  Widget build(final BuildContext context) {
    return StreamBuilder(
      stream: stream1,
      builder: (final context, final data1) {
        if (data1.hasData) {
          if (data1.data case final T d1) {
            return ReactWidget<A>(
                stream: stream2, builder: (final a) => builder(d1, a));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
        if (data1.hasError) {
          return Center(
              child: Text(
            translate('oops.error.occurred'),
            style: ZipFonts.small.error,
          ));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
