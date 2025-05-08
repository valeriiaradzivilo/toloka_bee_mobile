import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../../common/theme/zip_color.dart';
import '../../../../common/theme/zip_fonts.dart';
import '../../../../data/models/contact_info_model.dart';
import '../../../profile/ui/widgets/profile_contacts.dart';

class SeeContactsButton extends StatelessWidget {
  const SeeContactsButton(this.requesterContactInfo, {super.key});
  final ContactInfoModel requesterContactInfo;

  @override
  Widget build(final BuildContext context) => ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (final context) => AlertDialog(
              title: Text(
                translate('request.details.contacts'),
                style: ZipFonts.big.style,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  Text(
                    translate(
                      'request.details.contacts_hint',
                    ),
                    style: ZipFonts.small.style,
                  ),
                  ContactDataText(
                    method: ContactMethod.phone,
                    value: requesterContactInfo.phone,
                  ),
                  ContactDataText(
                    method: ContactMethod.viber,
                    value: requesterContactInfo.viber,
                  ),
                  ContactDataText(
                    method: ContactMethod.telegram,
                    value: requesterContactInfo.telegram,
                  ),
                  ContactDataText(
                    method: ContactMethod.whatsapp,
                    value: requesterContactInfo.whatsapp,
                  ),
                  ContactDataText(
                    method: ContactMethod.email,
                    value: requesterContactInfo.email,
                  ),
                ],
              ),
            ),
          );
        },
        label: Text(
          translate('request.details.see_contacts'),
        ),
        icon: const Icon(
          Icons.phone,
          color: ZipColor.onPrimary,
        ),
      );
}
