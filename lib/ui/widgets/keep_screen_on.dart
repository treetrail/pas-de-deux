import 'package:flutter/widgets.dart';

import '../../data/services/device_service.dart';

/// Keeps the screen on while [enabled] and this widget is shown.
class KeepScreenOn extends StatefulWidget {
  const KeepScreenOn({
    super.key,
    required this.device,
    required this.enabled,
    required this.child,
  });

  final DeviceService device;
  final bool enabled;
  final Widget child;

  @override
  State<KeepScreenOn> createState() => _KeepScreenOnState();
}

class _KeepScreenOnState extends State<KeepScreenOn> {
  @override
  void initState() {
    super.initState();
    if (widget.enabled) widget.device.stayAwake();
  }

  @override
  void didUpdateWidget(KeepScreenOn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled == oldWidget.enabled) return;
    widget.enabled ? widget.device.stayAwake() : widget.device.allowSleep();
  }

  @override
  void dispose() {
    if (widget.enabled) widget.device.allowSleep();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
