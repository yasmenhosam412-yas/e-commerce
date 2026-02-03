import 'package:boo/controllers/stores_cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:boo/controllers/stores_cubit/dashboard_cubit/dashboard_state.dart';
import 'package:boo/core/services/get_init.dart';
import 'package:boo/core/services/navigation_service.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/widgets/custom_form_field.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddDiscountScreen extends StatefulWidget {
  const AddDiscountScreen({super.key});

  @override
  State<AddDiscountScreen> createState() => _AddDiscountScreenState();
}

class _AddDiscountScreenState extends State<AddDiscountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _pickDate(TextEditingController controller, bool isStart) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2100);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
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
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)!.addDiscount),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomFormField(
                controller: _nameController,
                hint: AppLocalizations.of(context)!.discountName,
                validator: (value) => value == null || value.isEmpty
                    ? AppLocalizations.of(context)!.enterDiscountName
                    : null,
              ),
              const SizedBox(height: 16),
              CustomFormField(
                controller: _valueController,
                textInputType: TextInputType.number,
                hint: AppLocalizations.of(context)!.discountValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.enterDiscountValue;
                  }
                  final val = double.tryParse(value);
                  if (val == null || val <= 0 || val > 100) {
                    return AppLocalizations.of(context)!.invalidDiscountValue;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomFormField(
                controller: _startDateController,
                readOnly: true,
                hint: AppLocalizations.of(context)!.startDate,
                onTap: () => _pickDate(_startDateController, true),
                validator: (value) => value == null || value.isEmpty
                    ? AppLocalizations.of(context)!.selectStartDate
                    : null,
              ),
              const SizedBox(height: 16),
              CustomFormField(
                controller: _endDateController,
                readOnly: true,
                hint: AppLocalizations.of(context)!.endDate,
                onTap: () => _pickDate(_endDateController, false),
                validator: (value) => value == null || value.isEmpty
                    ? AppLocalizations.of(context)!.selectEndDate
                    : null,
              ),
              const SizedBox(height: 32),
              BlocConsumer<DashboardCubit, DashboardState>(
                listener: (context, state) {
                  if (state.isLoaded) {
                    getIt<NavigationService>().showToast(
                      AppLocalizations.of(context)!.discountAddedSuccess,
                    );

                    _nameController.clear();
                    _valueController.clear();
                    _startDateController.clear();
                    _endDateController.clear();
                    _startDate = null;
                    _endDate = null;
                  }

                  if (state.error != "") {
                    getIt<NavigationService>().showToast(state.error);
                  }
                },
                builder: (context, state) {
                  return SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (state.isLoading)
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<DashboardCubit>().addDiscount(
                                  _nameController.text,
                                  _valueController.text,
                                  _startDateController.text,
                                  _endDateController.text,
                                );
                              }
                            },
                      child: Text(
                        (state.isLoading)
                            ? AppLocalizations.of(context)!.loading
                            : AppLocalizations.of(context)!.addDiscount,
                        style: TextStyle(fontSize: 18),
                      ),
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
