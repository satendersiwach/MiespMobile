import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/ui/components/custom_drawer.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
        title: 'Om Soft Bill',
        drawer: CustomDrawer(),
        body: const SingleChildScrollView(
          child: Column(
            children: [],
          ),
        ));
  }
}
