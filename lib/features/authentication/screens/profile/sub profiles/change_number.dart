import 'package:crumbles/common/appbar/appbar.dart';
import 'package:crumbles/features/authentication/screens/profile/sub%20profiles/number_controller.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:crumbles/utils/constants/text_strings.dart';
import 'package:crumbles/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ChangeNumber extends StatelessWidget {
  const ChangeNumber({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNumberController());
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Change Phone Number', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please enter your phone number',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Form(
              key: controller.updateUserNameFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.phoneNumber,
                    validator: (value) => TValidators.validateEmptyText('Phone number', value),
                    expands: false,
                    decoration: const InputDecoration(labelText: TTexts.username, prefixIcon: Icon(Iconsax.call)),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateNumber(),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}