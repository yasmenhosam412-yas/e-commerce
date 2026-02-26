import 'package:boo/controllers/stores_cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:boo/controllers/stores_cubit/dashboard_cubit/dashboard_state.dart';
import 'package:boo/core/utils/app_colors.dart';
import 'package:boo/core/widgets/custom_form_field.dart';
import 'package:boo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/services/get_init.dart';
import '../../../../../../core/services/navigation_service.dart';

class AddCollectionScreen extends StatefulWidget {
  final Map<String, dynamic>? collection;

  const AddCollectionScreen({super.key, this.collection});

  @override
  State<AddCollectionScreen> createState() => _AddCollectionScreenState();
}

class _AddCollectionScreenState extends State<AddCollectionScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  bool get isEditing => widget.collection != null;
  String? collectionId;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      collectionId = widget.collection!['id'];
      _nameController.text = widget.collection!['name'] ?? "";
      _descController.text = widget.collection!['desc'] ?? "";
    }
  }

  void _submit() {
    if (_nameController.text.isEmpty) {
      getIt<NavigationService>().showToast(
        AppLocalizations.of(context)!.enterAllData,
      );
      return;
    }

    if (isEditing) {
      context.read<DashboardCubit>().updateCollection(
        collectionId!,
        _nameController.text,
        _descController.text,
      );
    } else {
      context.read<DashboardCubit>().addCollection(
        _nameController.text,
        _descController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          isEditing
              ? AppLocalizations.of(context)!.editCollection
              : AppLocalizations.of(context)!.addCollection,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomFormField(
              controller: _nameController,
              hint: AppLocalizations.of(context)!.collectionName,
            ),
            const SizedBox(height: 16),
            CustomFormField(
              controller: _descController,
              maxLines: 4,
              hint: AppLocalizations.of(context)!.collectionDesc,
            ),
            const SizedBox(height: 16),
            BlocConsumer<DashboardCubit, DashboardState>(
              listener: (context, state) {
                if (state.isLoaded == true) {
                  getIt<NavigationService>().showToast(
                    isEditing
                        ? AppLocalizations.of(context)!.collectionUpdated
                        : AppLocalizations.of(context)!.added,
                  );

                  if (!isEditing) {
                    _nameController.clear();
                    _descController.clear();
                  }else{
                    context.read<DashboardCubit>().getCollection();
                    Navigator.pop(context);
                  }
                }

                if (state.error != "") {
                  getIt<NavigationService>().showToast(state.error);
                }
              },
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.isLoading ? null : _submit,
                    child: Text(
                      state.isLoading
                          ? AppLocalizations.of(context)!.loading
                          : (isEditing
                                ? AppLocalizations.of(context)!.editCollection
                                : AppLocalizations.of(context)!.save),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
