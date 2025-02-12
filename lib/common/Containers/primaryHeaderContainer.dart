
import 'package:crumbles/common/Containers/circular_container.dart';
import 'package:crumbles/common/Containers/curvedEdgesWidget.dart';
import 'package:crumbles/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    super.key, required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TCurvedEdgesWidget(
      child: Container(color: TColors.primary, 
          padding: const EdgeInsets.all(0),
          child: Stack( 
            children: [ 
              Positioned(
                top: -150 ,
                right: -250,
                child: TCircularContainer(backgroundColor: TColors.textWhite.withOpacity(0.1),)),
          
              Positioned(
                top: 100,
                right: -300,
                child: TCircularContainer(backgroundColor: TColors.textWhite.withOpacity(0.1),)),
                child,
                
          
              
            ],
          ),
           ),
    );
  }
}
