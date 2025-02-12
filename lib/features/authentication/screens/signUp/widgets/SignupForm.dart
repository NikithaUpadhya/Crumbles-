import 'package:crumbles/features/authentication/screens/signUp/signup_controller.dart';
import 'package:crumbles/features/authentication/screens/signUp/widgets/TermsandConditions.dart';
import 'package:crumbles/utils/constants/sizes.dart';
import 'package:crumbles/utils/constants/text_strings.dart';
import 'package:crumbles/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class TSignupForm extends StatefulWidget {
  const TSignupForm({super.key});

  @override
  _TSignupFormState createState() => _TSignupFormState();
}

class _TSignupFormState extends State<TSignupForm> {
  final controller = Get.put(SignupController());

  final List<String> ngoTypes = [
    'Private Sector',
    'Societies (NGO)',
    'Trusts (NGO)',
    'Other Entities (NGO)',
    'Academic (Private)',
    'Academic (Gov)',
    'Human Rights',
    'Environmental',
    'Health',
    'Educational',
    'Women',
    'Child Welfare',
    'Community',
    'Disability',
    'Animal Welfare',
    'Relief & Humanitarian',
    'International',
  ];

  @override
  void initState() {
    super.initState();
    // Ensure the initial value is part of the ngoTypes list
    if (!ngoTypes.contains(controller.selectedNgoType.value)) {
      controller.selectedNgoType.value = ngoTypes.first;
    }
    print("Initial NGO Type: ${controller.selectedNgoType.value}");
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstname,
                  validator: (value) => TValidators.validateEmptyText("First name", value),
                  decoration: const InputDecoration(
                    labelText: TTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: controller.lastname,
                  validator: (value) => TValidators.validateEmptyText("Last name", value),
                  decoration: const InputDecoration(
                    labelText: TTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          // Username
          TextFormField(
            controller: controller.username,
            validator: (value) => TValidators.validateEmptyText("Username", value),
            decoration: const InputDecoration(
              labelText: TTexts.username,
              prefixIcon: Icon(Iconsax.user),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          // Email
          TextFormField(
            controller: controller.email,
            validator: (value) => TValidators.validateEmail(value),
            decoration: const InputDecoration(
              labelText: TTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          // Phone Number
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => TValidators.validatePhoneNumber(value),
            decoration: const InputDecoration(
              labelText: TTexts.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          // Password
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => TValidators.validatePassword(value),
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: TTexts.password,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                  icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                ),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          // Role Dropdown
          Obx(
            () => DropdownButtonFormField<String>(
              value: controller.selectedRole.value,
              items: <String>['NGO', 'Donator'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                controller.selectedRole.value = newValue!;
              },
              decoration: const InputDecoration(
                labelText: 'Role',
                prefixIcon: Icon(Iconsax.user_tag),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          // Additional NGO Fields
          Obx(() {
            if (controller.selectedRole.value == 'NGO') {
              return Column(
                children: [
                  // NGO Name
                  TextFormField(
                    controller: controller.ngoName,
                    validator: (value) => TValidators.validateEmptyText("NGO Name", value),
                    decoration: const InputDecoration(
                      labelText: "NGO Name",
                      prefixIcon: Icon(Iconsax.buildings),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  // NGO Type Dropdown
                  Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.selectedNgoType.value,
                      items: ngoTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        controller.selectedNgoType.value = newValue!;
                      },
                      decoration: const InputDecoration(
                        labelText: 'NGO Type',
                        prefixIcon: Icon(Iconsax.building_3),
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  // Short Description
                  TextFormField(
                    controller: controller.ngoDescription,
                    validator: (value) => TValidators.validateEmptyText("Short Description", value),
                    decoration: const InputDecoration(
                      labelText: "Short Description",
                      prefixIcon: Icon(Iconsax.info_circle),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                ],
              );
            }
            return Container();
          }),
          const SizedBox(height: TSizes.spaceBtwSections),
          // Terms and conditions
          const TTermsandConditionsCheckbox(),
          const SizedBox(height: TSizes.spaceBtwSections),
          // Sign up button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.signup(),
              child: const Text(TTexts.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}
