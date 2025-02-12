import 'package:crumbles/common/appbar/appbar.dart';
import 'package:crumbles/features/authentication/Screens_NGO/NGO%20Profle/subprofile/change_ngo_type_controller.dart';

import 'package:crumbles/utils/constants/sizes.dart';
import 'package:crumbles/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ChangeNGODescription extends StatelessWidget {
  const ChangeNGODescription({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNGODescriptionController());
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Change NGO Description', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update the description of your NGO.',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Form(
              key: controller.updateNGODescriptionFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.ngoDescription,
                    validator: (value) => TValidators.validateEmptyText('NGO Description', value),
                    decoration: const InputDecoration(labelText: 'NGO Description', prefixIcon: Icon(Icons.description)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateNGODescription(),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
