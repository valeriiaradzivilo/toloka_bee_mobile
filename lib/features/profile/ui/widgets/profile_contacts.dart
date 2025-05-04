import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/theme/zip_color.dart';
import '../../../../common/theme/zip_fonts.dart';
import '../../../../data/models/contact_info_model.dart';
import '../../../registration/ui/widget/steps/fourth_step_create_account.dart';
import '../../bloc/profile_cubit.dart';

class ProfileContacts extends StatelessWidget {
  const ProfileContacts({super.key, this.contactInfo});
  final ContactInfoModel? contactInfo;

  @override
  Widget build(final BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    return Column(
      spacing: 10,
      children: [
        Text(
          translate('profile.contacts.title'),
          style: ZipFonts.medium.style,
        ),
        Text(
          translate('profile.contacts.subtitle'),
          style: ZipFonts.tiny.style.copyWith(
            color: ZipColor.onSurfaceVariant.withValues(
              alpha: 0.7,
            ),
          ),
        ),
        if (contactInfo == null) ...[
          Text(
            translate('profile.contacts.no'),
            style: ZipFonts.small.error,
            textAlign: TextAlign.center,
          ),
        ] else ...[
          Column(
            children: [
              ContactDataText(
                method: ContactMethod.phone,
                value: contactInfo!.phone,
              ),
              ContactDataText(
                method: ContactMethod.viber,
                value: contactInfo!.viber,
              ),
              ContactDataText(
                method: ContactMethod.telegram,
                value: contactInfo!.telegram,
              ),
              ContactDataText(
                method: ContactMethod.whatsapp,
                value: contactInfo!.whatsapp,
              ),
              ContactDataText(
                method: ContactMethod.email,
                value: contactInfo!.email,
              ),
            ],
          ),
          Text(
            "${translate(
              'contacts.preferred',
            )}: ${contactInfo!.preferredMethod.text.toLowerCase()}",
            style: ZipFonts.small.style,
          ),
        ],
        ElevatedButton.icon(
          onPressed: () async {
            String? phone = contactInfo?.phone;
            String? viber = contactInfo?.viber;
            String? telegram = contactInfo?.telegram;
            String? whatsapp = contactInfo?.whatsapp;
            String? email = contactInfo?.email;
            ContactMethod? preferredMethod = contactInfo?.preferredMethod;
            final change = await showDialog<bool?>(
              context: context,
              builder: (final context) => Dialog(
                insetPadding: const EdgeInsets.all(2),
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        FourthStepCreateAccount(
                          onPhoneChanged: (final value) => phone = value,
                          onViberChanged: (final value) => viber = value,
                          onTelegramChanged: (final value) => telegram = value,
                          onWhatsAppChanged: (final value) => whatsapp = value,
                          onEmailChanged: (final value) => email = value,
                          onPreferredMethodChanged: (final value) =>
                              preferredMethod = value,
                          showNextBackButton: false,
                          phone: contactInfo?.phone,
                          viber: contactInfo?.viber,
                          telegram: contactInfo?.telegram,
                          whatsApp: contactInfo?.whatsapp,
                          email: contactInfo?.email,
                          preferredMethod: contactInfo?.preferredMethod,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => Navigator.pop(context, false),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ZipColor.onSurfaceVariant,
                              ),
                              icon: const Icon(
                                Icons.cancel,
                                color: ZipColor.onPrimary,
                              ),
                              label: Text(
                                translate('common.cancel'),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => Navigator.pop(context, true),
                              label: Text(translate('profile.contacts.save')),
                              icon: const Icon(
                                Icons.save,
                                color: ZipColor.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
            if (change == null || !change) {
              return;
            }

            if (preferredMethod == null) {
              return;
            }

            cubit.addContactInfo(
              phone: phone,
              viber: viber,
              telegram: telegram,
              whatsapp: whatsapp,
              email: email,
              preferredMethod: preferredMethod!,
            );
          },
          label: Text(translate('profile.contacts.edit')),
          icon: const Icon(
            Icons.contact_mail_rounded,
            color: ZipColor.onPrimary,
          ),
        ),
      ],
    );
  }
}

class ContactDataText extends StatelessWidget {
  const ContactDataText({super.key, required this.method, this.value});
  final ContactMethod method;
  final String? value;

  @override
  Widget build(final BuildContext context) => Visibility(
        visible: value != null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: GestureDetector(
            onTap: () async {
              if (value == null) {
                return;
              }
              final uri = method.uri(value!);
              if (uri == null) {
                return;
              }
              final bool canLaunch = await canLaunchUrl(uri);

              if (canLaunch) {
                await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
              } else {
                await Clipboard.setData(
                  ClipboardData(
                    text: value!,
                  ),
                );
              }
            },
            onLongPress: () {
              Clipboard.setData(
                ClipboardData(
                  text: value!,
                ),
              );
            },
            child: Row(
              spacing: 10,
              children: [
                Text(
                  '${method.text}:',
                  style: ZipFonts.small.style,
                ),
                if (value != null)
                  Flexible(
                    child: Text(
                      value!,
                      style: ZipFonts.small.style.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
