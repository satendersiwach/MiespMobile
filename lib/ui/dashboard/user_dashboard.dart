import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scanner/models/customer_model.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/ui/components/custom_drawer.dart';
import 'package:scanner/ui/components/element_common_widget.dart';
import 'package:scanner/ui/user_app/user_outbound_delivery_window.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
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
                text: 'Welcome, ${UserModel.getLoginCustomer().username}',
                fontWeight: FontWeight.w700,
                fontSize: 20),
            const UserOutboundDeliveryWindow(),
          ],
        ),
      ),
    );
  }
}
