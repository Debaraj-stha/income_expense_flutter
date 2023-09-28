import 'package:flutter/material.dart';

import 'smallText.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({Key? key, required this.title, this.showLeading = false})
      : super(key: key);
  final String title;
  final bool showLeading;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showLeading ? const BackButton() : null,
      elevation: 0,
      shadowColor: Colors.transparent,
      title: SmallText(text: title),
      actions: const [],
    );
  }
}
