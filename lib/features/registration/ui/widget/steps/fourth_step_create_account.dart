import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';

import '../../../../../common/theme/zip_fonts.dart';
import '../../../../../common/widgets/lin_number_editing_field.dart';
import '../../../../../common/widgets/lin_text_editing_field.dart';
import '../../../../../data/models/contact_info_model.dart';
import '../../../../../data/models/country.dart';
import '../../data/e_steps.dart';
import '../next_back_button_row.dart';
import '../phone_code_dropdown.dart';

class FourthStepCreateAccount extends StatefulWidget {
  const FourthStepCreateAccount({
    super.key,
    required this.onPreferredMethodChanged,
    required this.onPhoneChanged,
    required this.onEmailChanged,
    required this.onViberChanged,
    required this.onTelegramChanged,
    required this.onWhatsAppChanged,
    this.showNextBackButton = true,
    this.preferredMethod,
    this.phone,
    this.email,
    this.viber,
    this.telegram,
    this.whatsApp,
  });

  final ContactMethod? preferredMethod;
  final String? phone;
  final String? email;
  final String? viber;
  final String? telegram;
  final String? whatsApp;

  final void Function(ContactMethod) onPreferredMethodChanged;
  final void Function(String) onPhoneChanged;
  final void Function(String) onEmailChanged;
  final void Function(String) onViberChanged;
  final void Function(String) onTelegramChanged;
  final void Function(String) onWhatsAppChanged;
  final bool showNextBackButton;

  @override
  State<FourthStepCreateAccount> createState() =>
      _FourthStepCreateAccountState();
}

class _FourthStepCreateAccountState extends State<FourthStepCreateAccount> {
  final _menuController = MenuController();
  final _dropdownKey = GlobalKey<PhoneCodeDropdownState>();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _viberController = TextEditingController();
  final _telegramController = TextEditingController();
  final _whatsAppController = TextEditingController();
  bool _isPreferredValid = false;
  bool _numberInitialized = false;
  ContactMethod? _preferredMethod;
  Country? _selectedCountry;

  final _icons = {
    ContactMethod.phone: Icons.smartphone_outlined,
    ContactMethod.email: Icons.email,
    ContactMethod.viber: Icons.chat,
    ContactMethod.telegram: Icons.send,
    ContactMethod.whatsapp: Icons.call_outlined,
  };

  @override
  void initState() {
    super.initState();
    _preferredMethod = widget.preferredMethod;
    _isPreferredValid = _preferredMethod != null;
    _emailController.text = widget.email ?? '';
    _viberController.text = widget.viber ?? '';
    _telegramController.text = widget.telegram ?? '';
    _whatsAppController.text = widget.whatsApp ?? '';
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _viberController.dispose();
    _telegramController.dispose();
    _whatsAppController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    WidgetsBinding.instance.addPostFrameCallback((final _) {
      if (!_numberInitialized && widget.phone != null) {
        final rem = _dropdownKey.currentState?.remainder;
        if (rem != null) {
          _phoneController.text = rem;
          _numberInitialized = true;
        }
      }
    });

    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.contact_phone, color: primary),
                  const Gap(8),
                  Flexible(
                    child: Text(
                      translate('create.account.contact.title'),
                      style: ZipFonts.medium.style.copyWith(color: primary),
                    ),
                  ),
                ],
              ),
              const Gap(4),
              Text(
                translate('create.account.contact.subtitle'),
                style: ZipFonts.small.style.copyWith(color: Colors.black54),
              ),
              const Gap(24),
              MenuAnchor(
                controller: _menuController,
                menuChildren: [
                  for (final m in ContactMethod.values)
                    ListTile(
                      leading: Icon(_icons[m], color: primary),
                      title: Text(m.text),
                      onTap: () {
                        widget.onPreferredMethodChanged(m);
                        _menuController.close();
                        setState(() {
                          _preferredMethod = m;
                          _isPreferredValid = true;
                        });
                      },
                    ),
                ],
                builder: (final ctx, final ctrl, final child) => InkWell(
                  onTap: () => ctrl.isOpen ? ctrl.close() : ctrl.open(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _preferredMethod == null
                              ? Icons.help_outline
                              : _icons[_preferredMethod]!,
                          color: primary,
                        ),
                        const Gap(8),
                        Expanded(
                          child: Text(
                            _preferredMethod == null
                                ? translate('contacts.preferred')
                                : _preferredMethod!.text,
                            style: ZipFonts.medium.style,
                          ),
                        ),
                        Icon(
                          ctrl.isOpen
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(24),
              Row(
                children: [
                  PhoneCodeDropdown(
                    key: _dropdownKey,
                    initialValue: widget.phone,
                    onChanged: (final c) {
                      setState(() => _selectedCountry = c);
                    },
                  ),
                  const Gap(12),
                  Expanded(
                    child: LinNumberEditingField(
                      controller: _phoneController,
                      label: translate('contacts.phone'),
                      onChanged: (final value) {
                        final full =
                            '${_selectedCountry?.dialCode ?? ''}$value';
                        widget.onPhoneChanged(full);
                      },
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Row(
                children: [
                  Icon(_icons[ContactMethod.email], color: primary),
                  const Gap(12),
                  Expanded(
                    child: LinTextField(
                      controller: _emailController,
                      option: TextFieldOption.email,
                      label: translate('contacts.email'),
                      onChanged: widget.onEmailChanged,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Row(
                children: [
                  Icon(_icons[ContactMethod.viber], color: primary),
                  const Gap(12),
                  Expanded(
                    child: LinTextField(
                      controller: _viberController,
                      label: translate('contacts.viber'),
                      onChanged: widget.onViberChanged,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Row(
                children: [
                  Icon(_icons[ContactMethod.telegram], color: primary),
                  const Gap(12),
                  Expanded(
                    child: LinTextField(
                      controller: _telegramController,
                      label: translate('contacts.telegram'),
                      onChanged: widget.onTelegramChanged,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Row(
                children: [
                  Icon(_icons[ContactMethod.whatsapp], color: primary),
                  const Gap(12),
                  Expanded(
                    child: LinTextField(
                      controller: _whatsAppController,
                      label: translate('contacts.whatsapp'),
                      onChanged: widget.onWhatsAppChanged,
                    ),
                  ),
                ],
              ),
              const Gap(20),
              Center(
                child: Text(
                  translate('contacts.hint'),
                  style: ZipFonts.small.style.copyWith(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
              const Gap(20),
              if (widget.showNextBackButton)
                NextBackButtonRow(
                  step: ESteps.addContactInfo,
                  areFieldsValid: _isPreferredValid,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
