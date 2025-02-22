import 'package:flutter/material.dart';
import 'package:skansapung_presensi/app/presentation/widgets/app_drawer.dart';
import 'package:skansapung_presensi/core/widget/app_widget.dart';

abstract class BaseScreen<T extends ChangeNotifier> extends AppWidget<T> {
  final String title;
  final bool showDrawer;
  final List<Widget>? actions;

  BaseScreen({
    required this.title,
    this.showDrawer = true,
    this.actions,
  });

  @override
  Widget bodyBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Color.fromRGBO(243, 154, 0, 0.988),
        actions: actions,
      ),
      drawer: showDrawer ? AppDrawer() : null,
      body: buildScreenContent(context),
    );
  }

  Widget buildScreenContent(BuildContext context);
}
