import 'package:flutter/cupertino.dart';

import '../../shared/widgets/custome_text.dart';

class BuildTodayLabel extends StatelessWidget {
  const BuildTodayLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: CustomTextWidget(
        name: 'Today',
        fontFamily: 'Poppins',
        fontSize: 22,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
