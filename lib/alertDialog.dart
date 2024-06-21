import 'package:flutter/material.dart';

class ErrorDialog extends StatefulWidget {
  final String title;
  final String hintText;

  const ErrorDialog({required this.title, required this.hintText, super.key});

  @override
  AlertDialogState createState() => AlertDialogState();
}

class AlertDialogState extends State<ErrorDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Text(widget.hintText),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
      ],
    );
  }
}

Future<String?> showErrorDialog(
    BuildContext context, String title, String hintText) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return ErrorDialog(title: title, hintText: hintText);
    },
  );
}
