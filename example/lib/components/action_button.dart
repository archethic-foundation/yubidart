import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:yubidart/yubidart.dart';
import 'package:yubikit_android_example/components/snackbar.dart';
import 'package:yubikit_android_example/failure_message.dart';

class ActionButton<T> extends StatefulWidget {
  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
  });
  final String text;
  final Future<T> Function() onPressed;

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool isOperationRunning = false;

  @override
  Widget build(BuildContext context) {
    if (isOperationRunning) {
      return const TextButton(
        onPressed: null,
        child: CircularProgressIndicator(),
      );
    }

    return TextButton(
      onPressed: _runOperation,
      child: Text(widget.text),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      ResultSnackbar.error(message),
    );
  }

  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      ResultSnackbar.success(message),
    );
  }

  Future<void> _runOperation() async {
    if (isOperationRunning) return;
    setState(() {
      isOperationRunning = true;
    });

    try {
      final resultMessage = await widget.onPressed();
      log('Success : $resultMessage');
      if (mounted) {
        _showSuccess(context, resultMessage);
      }
    } on YKFailure catch (e) {
      log('YKFailure : ${e.message}');
      if (mounted) {
        _showError(context, e.message);
      }
    } catch (e) {
      log('Failure : ${e.toString()}');
      if (mounted) {
        _showError(context, e.toString());
      }
    }
    setState(() {
      isOperationRunning = false;
    });
  }
}
