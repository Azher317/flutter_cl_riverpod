import 'package:app/core/widgets/state_ui/state_message.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  final String title;
  final String? message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return StateMessage(
      icon: icon,
      title: title,
      message: message,
      action: action,
    );
  }
}
