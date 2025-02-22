import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skansapung_presensi/app/presentation/widgets/app_drawer.dart';

abstract class BaseScreen<T extends ChangeNotifier> extends StatefulWidget {
  final String title;
  final List<Widget>? actions;

  const BaseScreen({
    Key? key,
    required this.title,
    this.actions,
  }) : super(key: key);

  Widget buildScreenContent(BuildContext context, T notifier);

  @override
  State<BaseScreen<T>> createState() => _BaseScreenState<T>();
}

class _BaseScreenState<T extends ChangeNotifier> extends State<BaseScreen<T>> {
  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, notifier, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: widget.actions,
          ),
          drawer: AppDrawer(),
          body: widget.buildScreenContent(context, notifier),
        );
      },
    );
  }
}
