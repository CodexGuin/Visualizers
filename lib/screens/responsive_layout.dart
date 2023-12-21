import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget? mobileScaffold;
  final Widget? desktopScaffold;
  final Widget? tabletScaffold;
  const ResponsiveLayout(
      {super.key,
      this.mobileScaffold,
      this.desktopScaffold,
      this.tabletScaffold});

  // * Returns if it's mobile, tablet or desktop
  // * based on the width of the screen
  bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 500;
  }

  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 500 &&
        MediaQuery.of(context).size.width < 1100;
  }

  bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1100;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 500) {
        return mobileScaffold!;
      } else if (constraints.maxWidth < 1100) {
        return tabletScaffold!;
      } else {
        return desktopScaffold!;
      }
    });
  }
}
