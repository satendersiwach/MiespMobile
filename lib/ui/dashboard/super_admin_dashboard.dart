import 'package:flutter/material.dart';
import 'package:scanner/theme/custom_colors.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/ui/components/custom_drawer.dart';
import 'package:scanner/ui/components/element_button.dart';
import 'package:scanner/ui/components/element_common_widget.dart';
import 'package:scanner/ui/supervisor/assigned_pick_list_screen.dart';

class SuperAdminDashboard extends StatefulWidget {
  const SuperAdminDashboard({super.key});

  @override
  State<SuperAdminDashboard> createState() => _SuperAdminDashboardState();
}

class _SuperAdminDashboardState extends State<SuperAdminDashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return screenWithAppBar(
        title: 'Scanner App',
        drawer: const CustomDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              appVersionWidget(),
              getPoppinsText(
                  text: 'Welcome, Supervisor',
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
              //todo: add filter based on status
              //todo: implement search
              const AssignedPickListScreen(),
            ],
          ),
        ),
        bottomNavigationBar: _buttonContainer());
  }

  Widget _buttonContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: loadingButton(
          isLoading: false,
          btnText: 'Assign',
          onPress: () {},
          backColor: appPrimary),
    );
  }
}
