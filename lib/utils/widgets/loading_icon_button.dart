import 'package:flutter/material.dart';

import '../../services/notification_service.dart';

class LoadingIconButton extends StatefulWidget {
  final Future<void> Function()? onPressed;
  final Widget icon;
  final ButtonStyle? style;
  final bool enabled;
  final bool? loading;
  final void Function(dynamic err)? errorHandler;
  final String? tooltip;

  const LoadingIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.style,
    this.enabled = true,
    this.errorHandler,
    this.loading,
    this.tooltip,
  });

  @override
  State<LoadingIconButton> createState() => _LoadingIconButtonState();
}

class _LoadingIconButtonState extends State<LoadingIconButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    _loading = widget.loading ?? _loading;
    return IconButton(
      tooltip: widget.tooltip,
      style: widget.style,
      onPressed: _loading || !widget.enabled || widget.onPressed == null
          ? null
          : () async {
              setState(() => _loading = true);
              try {
                await widget.onPressed!();
              } catch (e) {
                showError(e.toString());
                if (widget.errorHandler != null) widget.errorHandler!(e);
              }
              if (context.mounted) {
                setState(() => _loading = false);
              }
            },
      icon: _loading
          ? const SizedBox(
              height: 20, width: 20, child: CircularProgressIndicator())
          : widget.icon,
    );
  }
}
