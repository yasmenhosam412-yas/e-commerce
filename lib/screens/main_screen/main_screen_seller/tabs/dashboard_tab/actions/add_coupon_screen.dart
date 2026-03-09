import 'package:boo/controllers/stores_cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:boo/controllers/stores_cubit/dashboard_cubit/dashboard_state.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/utils/app_padding.dart';
import '../../../../../../l10n/app_localizations.dart';

class AddCouponScreen extends StatefulWidget {
  const AddCouponScreen({super.key});

  @override
  State<AddCouponScreen> createState() => _AddCouponScreenState();
}

class _AddCouponScreenState extends State<AddCouponScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  DateTime? _expiryDate;
  String _discountType = 'Percentage';

  void _pickExpiryDate() async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)!.addCoupon),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomFormField(
                controller: _codeController,
                hint: AppLocalizations.of(context)!.couponCode,
                validator: (value) => value == null || value.isEmpty
                    ? AppLocalizations.of(context)!.enterCouponCode
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _discountType,
                dropdownColor: AppColors.whiteColor,

                decoration: InputDecoration(
                  labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primaryColor,
                  ),
                  labelText: AppLocalizations.of(context)!.discountType,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.primaryColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(AppPadding.medium),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.primaryColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(AppPadding.medium),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.primaryColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(AppPadding.medium),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.primaryColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(AppPadding.medium),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'Percentage',
                    child: Text(
                      AppLocalizations.of(context)!.percentage,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Fixed Amount',
                    child: Text(
                      AppLocalizations.of(context)!.fixedAmount,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _discountType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              CustomFormField(
                controller: _valueController,
                textInputType: TextInputType.number,
                hint: _discountType == 'Percentage'
                    ? AppLocalizations.of(context)!.discount
                    : AppLocalizations.of(context)!.discountAmount,
                validator: (value) => value == null || value.isEmpty
                    ? AppLocalizations.of(context)!.enterDiscountValue
                    : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _expiryDate == null
                      ? AppLocalizations.of(context)!.selectExpiryDate
                      : '${AppLocalizations.of(context)!.expiryDate}: ${DateFormat('yyyy-MM-dd').format(_expiryDate!)}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickExpiryDate,
              ),
              const SizedBox(height: 32),
              BlocConsumer<DashboardCubit, DashboardState>(
                listener: (context, state) {
                  if (state.isLoaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.couponSaved),
                      ),
                    );

                    _codeController.clear();
                    _valueController.clear();
                  }

                  if (state.error != "") {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: (state.isLoading)
                        ? null
                        : () {
                            if (_formKey.currentState!.validate() &&
                                _expiryDate != null) {
                              context.read<DashboardCubit>().addCoupon(
                                _codeController.text,
                                _valueController.text,
                                DateFormat('yyyy-MM-dd').format(_expiryDate!),
                                _discountType,
                              );
                            } else if (_expiryDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.selectExpiryDateError,
                                  ),
                                ),
                              );
                            }
                          },
                    child: Text(
                      (state.isLoading)
                          ? AppLocalizations.of(context)!.loading
                          : AppLocalizations.of(context)!.saveCoupon,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
