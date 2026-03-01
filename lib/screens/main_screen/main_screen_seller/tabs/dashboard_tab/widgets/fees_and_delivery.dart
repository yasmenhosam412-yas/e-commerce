import 'package:flutter/material.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../../../core/utils/app_padding.dart';
import '../../../../../../core/utils/constants.dart';
import '../../../../../../core/widgets/custom_form_field.dart';
import '../../../../../../l10n/app_localizations.dart';

class FeesAndDelivery extends StatefulWidget {
  final Function(
    String fees,
    String delivery,
    bool isDelivery,
    List<String>? governorates,
    String? time,
    String? info,
  )
  onClick;
  final String fees;
  final String deliveryPrice;
  final bool isDelivery;
  final List<String>? governorates;
  final String? time;
  final String? info;

  const FeesAndDelivery({
    super.key,
    required this.onClick,
    required this.fees,
    required this.deliveryPrice,
    this.isDelivery = false,
    this.governorates,
    this.time,
    this.info,
  });

  @override
  State<FeesAndDelivery> createState() => _FeesAndDeliveryState();
}

class _FeesAndDeliveryState extends State<FeesAndDelivery> {
  late TextEditingController fees;
  late TextEditingController deliveryPrice;
  late TextEditingController governoratesController;
  List<String> governorates = [];
  late TextEditingController time;
  late TextEditingController info;
  late bool isDelivery;
  GlobalKey<FormState> globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    fees = TextEditingController(text: widget.fees);
    deliveryPrice = TextEditingController(text: widget.deliveryPrice);
    time = TextEditingController(text: widget.time ?? "");
    info = TextEditingController(text: widget.info ?? "");

    isDelivery = widget.isDelivery;

    governorates = widget.governorates ?? [];

    governoratesController = TextEditingController(
      text: governorates.join(", "),
    );
  }

  @override
  void dispose() {
    fees.dispose();
    deliveryPrice.dispose();
    time.dispose();
    info.dispose();
    governoratesController.dispose();
    super.dispose();
  }

  void _showGovernoratesDialog(
    BuildContext context,
    StateSetter setModalState,
  ) {
    List<String> selectedList = List.from(governorates);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                AppLocalizations.of(context)!.deliveryGovernorates,
                style: const TextStyle(color: AppColors.primaryColor),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: AppConstants.egyptGovernorates.length,
                  itemBuilder: (context, index) {
                    final gov = AppConstants.egyptGovernorates[index];
                    final isSelected = selectedList.contains(gov);
                    return CheckboxListTile(
                      title: Text(gov),
                      value: isSelected,
                      activeColor: AppColors.primaryColor,
                      onChanged: (bool? value) {
                        setStateDialog(() {
                          if (value == true) {
                            selectedList.add(gov);
                          } else {
                            selectedList.remove(gov);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setModalState(() {
                      governorates = selectedList;
                      governoratesController.text = governorates.join(", ");
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.save,
                    style: const TextStyle(color: AppColors.whiteColor),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
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

                SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.isDelivery),
                  value: isDelivery,
                  activeColor: AppColors.primaryColor,
                  onChanged: (val) {
                    setModalState(() {
                      isDelivery = val;
                    });
                    setState(() {
                      isDelivery = val;
                    });
                  },
                ),
                if (isDelivery) ...[
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
                  SizedBox(height: AppPadding.medium),
                  CustomFormField(
                    controller: deliveryPrice,
                    hint: AppLocalizations.of(context)!.deliveryPrice,
                    textInputType: TextInputType.number,
                    validator: (value) {
                      if (isDelivery && value!.isEmpty) {
                        return AppLocalizations.of(context)!.requiredField;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppPadding.medium),
                  CustomFormField(
                    controller: governoratesController,
                    hint: AppLocalizations.of(context)!.deliveryGovernorates,
                    readOnly: true,
                    onTap: () => _showGovernoratesDialog(context, setModalState),
                    validator: (value) {
                      if (isDelivery && governorates.isEmpty) {
                        return AppLocalizations.of(context)!.requiredField;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppPadding.medium),
                  CustomFormField(
                    controller: time,
                    hint: AppLocalizations.of(context)!.deliveryTime,
                    validator: (value) {
                      if (isDelivery && value!.isEmpty) {
                        return AppLocalizations.of(context)!.requiredField;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppPadding.medium),
                  CustomFormField(
                    controller: info,
                    hint: AppLocalizations.of(context)!.deliveryInfo,
                  ),
                ],
                SizedBox(height: AppPadding.xxlarge),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (globalKey.currentState!.validate()) {
                        widget.onClick(
                          fees.text,
                          deliveryPrice.text,
                          isDelivery,
                          governorates,
                          time.text,
                          info.text,
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
