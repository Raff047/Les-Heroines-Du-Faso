// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/features/admin/screens/add_admin.dart';
import 'package:health_app/features/admin/screens/professional_management.dart';
import 'package:health_app/features/auth/controller/auth_controller.dart';
import 'package:health_app/models/admin_user_model.dart';
import '../../../core/common/widgets/custom_button.dart';
import '../../../theme/pallete.dart';
import '../../auth/screens/login.dart';
import 'managers_management.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  String? name;
  String? email;
  String? password;

  var listScrollController = new ScrollController();
  var scrollDirection = ScrollDirection.idle;
  @override
  void initState() {
    listScrollController.addListener(() {
      setState(() {
        scrollDirection = listScrollController.position.userScrollDirection;
      });
    });
    super.initState();
  }

  bool _scrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      setState(() {
        scrollDirection = ScrollDirection.idle;
      });
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final admin = ref.watch(adminUserProvider);

    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Center(
          child: Column(children: [
            AdminPanel(size: size, admin: admin, greeting: 'Bienvenue'),
            Container(
              height: 400,
              padding: EdgeInsets.symmetric(vertical: 16),
              child: NotificationListener<ScrollNotification>(
                onNotification: _scrollNotification,
                child: ListView(
                    controller: listScrollController,
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfessionalsManagementScreen()));
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 100),
                          transform: Matrix4.rotationZ(
                              scrollDirection == ScrollDirection.forward
                                  ? 0.07
                                  : scrollDirection == ScrollDirection.reverse
                                      ? -0.07
                                      : 0),
                          width: 200,
                          margin: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                              color: Pallete.bgDarkerShade,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.green.shade300,
                                    offset: Offset(-6, 4),
                                    blurRadius: 10)
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/images/doctor.svg',
                                width: 200,
                                height: 200,
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16)),
                              Text(
                                'Gestion des professionnels',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      // 2222222222222222222222
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ManagersManagementScreen()));
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 100),
                          transform: Matrix4.rotationZ(
                              scrollDirection == ScrollDirection.forward
                                  ? 0.07
                                  : scrollDirection == ScrollDirection.reverse
                                      ? -0.07
                                      : 0),
                          width: 200,
                          margin: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                              color: Pallete.bgDarkerShade,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.lightBlue.withOpacity(0.6),
                                    offset: Offset(-6, 4),
                                    blurRadius: 10)
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/images/manager.svg',
                                width: 200,
                                height: 200,
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16)),
                              Text(
                                'Gestionnaires',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      //////33333333333333333333333
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddAdminScreen()));
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 100),
                          transform: Matrix4.rotationZ(
                              scrollDirection == ScrollDirection.forward
                                  ? 0.07
                                  : scrollDirection == ScrollDirection.reverse
                                      ? -0.07
                                      : 0),
                          width: 200,
                          margin: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                              color: Pallete.bgDarkerShade,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.lightBlue.withOpacity(0.6),
                                    offset: Offset(-6, 4),
                                    blurRadius: 10)
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/images/admin.svg',
                                width: 200,
                                height: 200,
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16)),
                              Text(
                                'Ajouter administrateur',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: size.width * 0.4,
                    height: size.height * 0.05,
                    child: CustomButton(
                        onPressed: () {
                          ref
                              .watch(authControllerProvider.notifier)
                              .signUserOut();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                              (route) => false);
                        },
                        text: 'Se deconnecter'),
                  ),
                )
              ],
            ),
          ]),
        ));
  }
}

class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
    this.onTap,
  });

  final String title;
  final Color color;
  final IconData icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 2,
          color: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 60,
                  color: Colors.white.withOpacity(.8),
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdminPanel extends StatelessWidget {
  const AdminPanel({
    super.key,
    required this.size,
    required this.admin,
    required this.greeting,
  });

  final Size size;
  final Admin? admin;
  final String greeting;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      width: double.infinity,
      margin: EdgeInsets.zero,
      height: size.height * .3,
      decoration: BoxDecoration(
        color: Colors.black38,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 26.0,
                      ),
                      Text(
                        greeting,
                        style: TextStyle(fontSize: 22.0, letterSpacing: 2.0),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text('${admin!.name}!',
                          style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5)),
                    ],
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/logo.jpg'),
                    radius: 55.0,
                  ),
                ],
              ),
            ),
            Text(
              'Que voulez vous faire aujourd\'hui? ',
              style: const TextStyle(
                fontSize: 20.0,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ManagementCard extends StatelessWidget {
  ManagementCard(
      {super.key,
      required this.color,
      required this.option,
      required this.height,
      required this.width,
      required this.onTap});

  String option;
  Color color;
  double height;
  double width;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        width: width,
        height: height,
        child: Center(
            child: Text(
          option,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22.0,
          ),
        )),
      ),
    );
  }
}
