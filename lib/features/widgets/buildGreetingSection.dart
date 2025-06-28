import 'package:flutter/cupertino.dart';

import '../../shared/styles/app_colors.dart';
import '../../shared/widgets/custome_text.dart';

class BuildGreetingSection extends StatelessWidget {
  const BuildGreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.customAppbarColor,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CustomTextWidget(
              name: 'Daily reflection',
              fontFamily: 'Poppins',
              fontSize: 9,
              fontWeight: FontWeight.w300,
            ),
            const SizedBox(height: 5),
            const CustomTextWidget(
              name: 'Hi user, \nhave a great day!',
              fontFamily: 'Poppins',
              fontSize: 26,
              fontWeight: FontWeight.w300,
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
