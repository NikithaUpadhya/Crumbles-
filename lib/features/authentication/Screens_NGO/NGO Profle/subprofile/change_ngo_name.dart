import 'package:crumbles/common/appbar/appbar.dart';
import 'package:crumbles/features/authentication/Screens_NGO/NGO%20Profle/subprofile/ngo_name_controller.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:crumbles/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ChangeNGOName extends StatelessWidget {
  const ChangeNGOName({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNGONameController());
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Change NGO Name', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update the name of your NGO.',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Form(
              key: controller.updateNGONameFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.ngoName,
                    validator: (value) => TValidators.validateEmptyText('NGO Name', value),
                    decoration: const InputDecoration(labelText: 'NGO Name', prefixIcon: Icon(Icons.business)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateNgoName(),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
