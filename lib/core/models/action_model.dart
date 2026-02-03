import 'dart:ui';

class ActionModel {
  final String title;
  final Color color;
  final VoidCallback onTab;

  ActionModel({required this.title, required this.color, required this.onTab});
}
