import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smartclass_fyp_2024/constants/color_constants.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: ColorConstants.primaryColor,
          size: 30,
        ),
      ),
    );
  }
}
