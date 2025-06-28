import 'package:flutter/cupertino.dart';

import '../../shared/widgets/custome_text.dart';

class BuildTaskSectionTitle extends StatelessWidget {
  const BuildTaskSectionTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: CustomTextWidget(
        name: 'Today Task',
        fontFamily: 'Poppins',
        fontSize: 22,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
