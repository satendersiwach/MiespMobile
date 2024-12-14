import 'package:flutter/material.dart';
import 'package:scanner/models/customer_model.dart';
import 'package:scanner/theme/custom_text_widgets.dart';
import 'package:scanner/theme/elements_screen.dart';
import 'package:scanner/theme/get_text_field.dart';
import 'package:scanner/ui/components/custom_drawer.dart';
import 'package:scanner/ui/components/element_common_widget.dart';
import 'package:scanner/ui/user_app/user_outbound_delivery_window.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  List l=['Not Picked','Picked','All'];
  //todo remove manual
  Map m={
    "Not Picked":'A',
    "Picked":'P',
    "All":'All',
  };
  @override
  void initState() {
    //todo: call getPickListByUser method
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
            //todo: implement refresh
            //IconButton(
            //             onPressed: () {},
            //             icon: Icon(
            //               MdiIcons.refresh,
            //               color: Colors.white,
            //             ))
            const UserOutboundDeliveryWindow(),
          ],
        ),
      ),
    );
  }

}
