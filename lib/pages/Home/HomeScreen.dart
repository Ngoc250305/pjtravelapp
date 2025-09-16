import 'package:flutter/material.dart';
import 'package:pjtravelapp/entities/account.dart';
import 'package:pjtravelapp/pages/Home/Footer.dart';
import 'package:pjtravelapp/pages/Home/HomePage.dart';
import 'package:pjtravelapp/pages/Home/MainPage.dart';
import 'package:pjtravelapp/pages/navbar/Navbar.dart';

class HomeScreen extends StatelessWidget {
  final Account? account;
  final Function onLogout;
  final Function onLogin;

  const HomeScreen({
    super.key,
    this.account,
    required this.onLogout,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavbarDrawer(
        account: account,
        onLogout: onLogout,
        onLogin: onLogin,
      ),
      appBar: AppBar(
        title: const Text("GlobleTrip"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HomePage(),
            MainPage(),
            Footer(),
          ],
        ),
      ),
    );
  }
}
