import 'package:crumbles/common/appbar/appbar.dart';
import 'package:crumbles/features/authentication/Screens_NGO/NGO%20Profle/subprofile/Ngo_type_controller.dart';

import 'package:crumbles/utils/constants/sizes.dart';
import 'package:crumbles/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ChangeNGOType extends StatelessWidget {
  const ChangeNGOType({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNGOTypeController());
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Change NGO Type', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update the type of your NGO.',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Form(
              key: controller.updateNGOTypeFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.ngoType,
                    validator: (value) => TValidators.validateEmptyText('NGO Type', value),
                    decoration: const InputDecoration(labelText: 'NGO Type', prefixIcon: Icon(Icons.category)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateNGOType(),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
