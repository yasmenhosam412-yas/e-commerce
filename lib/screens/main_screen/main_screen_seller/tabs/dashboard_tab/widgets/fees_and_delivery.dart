import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/utils/app_padding.dart';
import '../../../../../../core/widgets/custom_form_field.dart';
import '../../../../../../l10n/app_localizations.dart';

class FeesAndDelivery extends StatefulWidget {
  final Function(String fees, String delivery) onClick;
  final String fees;
  final String deliveryPrice;
  const FeesAndDelivery({super.key, required this.onClick, required this.fees, required this.deliveryPrice});

  @override
  State<FeesAndDelivery> createState() => _FeesAndDeliveryState();
}

class _FeesAndDeliveryState extends State<FeesAndDelivery> {
  late TextEditingController fees;
  late TextEditingController deliveryPrice;
  GlobalKey<FormState> globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    fees = TextEditingController(text: widget.fees);
    deliveryPrice = TextEditingController(text: widget.deliveryPrice);
  }

  @override
  void dispose() {
    super.dispose();
    fees.dispose();
    deliveryPrice.dispose();
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
                  AppLocalizations.of(context)!.title3,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: AppPadding.medium),

                CustomFormField(
                  controller: fees,
                  hint: AppLocalizations.of(context)!.fees,
                  textInputType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.requiredField;
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppPadding.medium),
                CustomFormField(
                  controller: deliveryPrice,
                  hint: AppLocalizations.of(context)!.deliveryPrice,
                  textInputType: TextInputType.number,
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
                        widget.onClick(fees.text, deliveryPrice.text);
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
