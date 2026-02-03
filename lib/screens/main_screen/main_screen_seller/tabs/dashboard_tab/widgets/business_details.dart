import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/utils/app_padding.dart';
import '../../../../../../core/widgets/custom_form_field.dart';
import '../../../../../../l10n/app_localizations.dart';

class BusinessDetails extends StatefulWidget {
  final Function(String phone, String email, String address) onClick;
  final String email;
  final String phone;
  final String address;

  const BusinessDetails({
    super.key,
    required this.onClick,
    required this.email,
    required this.phone,
    required this.address,
  });

  @override
  State<BusinessDetails> createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetails> {
  late TextEditingController businessPhone;
  late TextEditingController businessEmail;
  late TextEditingController businessAddress;
  GlobalKey<FormState> globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    businessPhone = TextEditingController(text: widget.phone);
    businessEmail = TextEditingController(text: widget.email);
    businessAddress = TextEditingController(text: widget.address);
  }

  @override
  void dispose() {
    super.dispose();
    businessPhone.dispose();
    businessEmail.dispose();
    businessAddress.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return SingleChildScrollView(
          child: Form(
            key: globalKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.title2,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: AppPadding.medium),

                CustomFormField(
                  controller: businessPhone,
                  hint: AppLocalizations.of(context)!.phoneNumber,
                  textInputType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.requiredField;
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppPadding.medium),
                CustomFormField(
                  controller: businessEmail,
                  hint: AppLocalizations.of(context)!.email,
                  textInputType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.requiredField;
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppPadding.medium),
                CustomFormField(
                  controller: businessAddress,
                  hint: AppLocalizations.of(context)!.address,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.requiredField;
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppPadding.xxlarge),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (globalKey.currentState!.validate()) {
                        widget.onClick(
                          businessPhone.text,
                          businessEmail.text,
                          businessAddress.text,
                        );
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.save,
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: AppPadding.xxlarge),
              ],
            ),
          ),
        );
      },
    );
  }
}
