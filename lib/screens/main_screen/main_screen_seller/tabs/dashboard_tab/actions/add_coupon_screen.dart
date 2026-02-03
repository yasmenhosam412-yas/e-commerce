import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/utils/app_padding.dart';

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
  String _discountType = 'Percentage'; // or 'Fixed Amount'

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

  void _saveCoupon() {
    if (_formKey.currentState!.validate() && _expiryDate != null) {
      final coupon = {
        "code": _codeController.text,
        "type": _discountType,
        "value": _valueController.text,
        "expiryDate": _expiryDate!.toIso8601String(),
      };
      print("Coupon saved: $coupon");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coupon saved successfully!')),
      );
      // Clear form
      _formKey.currentState!.reset();
      setState(() {
        _expiryDate = null;
        _discountType = 'Percentage';
      });
    } else if (_expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an expiry date')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        title: const Text('Add Coupon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomFormField(
                controller: _codeController,
                hint: 'Coupon Code',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter coupon code' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _discountType,
                dropdownColor: AppColors.whiteColor,

                decoration: InputDecoration(
                  labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primaryColor,
                  ),
                  labelText: 'Discount Type',
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
                      'Percentage',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Fixed Amount',
                    child: Text(
                      'Fixed Amount',
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
                    ? 'Discount %'
                    : 'Discount Amount',
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter discount value'
                    : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _expiryDate == null
                      ? 'Select Expiry Date'
                      : 'Expiry Date: ${DateFormat('yyyy-MM-dd').format(_expiryDate!)}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickExpiryDate,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveCoupon,
                child: const Text('Save Coupon'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
