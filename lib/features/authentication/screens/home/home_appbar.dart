import 'package:crumbles/common/appbar/appbar.dart';
import 'package:crumbles/common/styles/shimmer.dart';
import 'package:crumbles/data/repositories/authencation/user_controller.dart';
import 'package:crumbles/features/authentication/screens/chat/conversationTab.dart';
import 'package:crumbles/utils/constants/colors.dart';
import 'package:crumbles/utils/constants/text_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return TAppBar(title: Column( 
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ 
        Text(TTexts.homeAppbarTitle, style: Theme.of(context).textTheme.labelMedium!.apply(color: TColors.grey), ),
        Obx(() { 
          if(controller.profileLoading.value){
            return const TShimmerEffect(width: 80, height: 18);
          } else{
            return Text(controller.user.value.fullName, style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.white),);

          }
          }),
      ],
    ),
    
     actions: [
        Obx(() {
          return Stack(
            children: [
              IconButton(
                onPressed: () => Get.to(() => const ConversationsTab()),
                icon: const Icon(Icons.chat, color: TColors.white),
              ),
              if (controller.unreadMessagesCount.value > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}
