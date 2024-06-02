import 'package:flutter/material.dart';
import 'package:loading_redman_ddur/ManAnim.dart';
import 'package:logintemplate/scr/LoginGoogle.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text("Hello Login"),
      ),
      body: ManAnim(size:10)
    );
  }
}
