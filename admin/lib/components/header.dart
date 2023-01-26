import 'package:admin/constants.dart';
import 'package:admin/controllers/side_menu_controller.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'profile_card.dart';
import 'search_field.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: context.read<SideMenuController>().controlMenu,
          ),
        if (!Responsive.isMobile(context)) ...[
          Text(
            "Dashboard",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1)
        ],
        const Expanded(child: SearchField()),
        const SizedBox(width: defaultPadding),
        const ProfileCard()
      ],
    );
  }
}
