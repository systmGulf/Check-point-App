import 'dart:async';

import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/styles.dart';

enum AppTopSnackBarType { success, warning, failure, info }

class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar.success({
    super.key,
    required this.message,
  })  : type = AppTopSnackBarType.success,
        duration = const Duration(seconds: 3);

  const CustomSnackBar.warning({
    super.key,
    required this.message,
  })  : type = AppTopSnackBarType.warning,
        duration = const Duration(seconds: 3);

  const CustomSnackBar.error({
    super.key,
    required this.message,
  })  : type = AppTopSnackBarType.failure,
        duration = const Duration(seconds: 3);

  const CustomSnackBar.info({
    super.key,
    required this.message,
  })  : type = AppTopSnackBarType.info,
        duration = const Duration(seconds: 3);

  final String message;
  final AppTopSnackBarType type;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return _SnackBarCard(message: message, type: type);
  }
}

_SnackBarPalette _snackBarPaletteForType(AppTopSnackBarType type) {
  switch (type) {
    case AppTopSnackBarType.success:
      return _SnackBarPalette(
        backgroundColor: ColorsManger.lightGreen,
        borderColor: ColorsManger.darkGreen.withValues(alpha: 0.45),
        foregroundColor: ColorsManger.darkGreen,
        icon: Icons.check_circle_outline_rounded,
      );
    case AppTopSnackBarType.warning:
      return _SnackBarPalette(
        backgroundColor: const Color(0xFFFFF4D8),
        borderColor: const Color(0xFFE0B44A),
        foregroundColor: const Color(0xFF8B6400),
        icon: Icons.report_gmailerrorred_outlined,
      );
    case AppTopSnackBarType.failure:
      return _SnackBarPalette(
        backgroundColor: const Color(0xFFFFE6E3),
        borderColor: const Color(0xFFE06A5F),
        foregroundColor: const Color(0xFFB23A2C),
        icon: Icons.cancel_outlined,
      );
    case AppTopSnackBarType.info:
      return _SnackBarPalette(
        backgroundColor: const Color(0xFFF4EFE7),
        borderColor: ColorsManger.primaryColor.withValues(alpha: 0.28),
        foregroundColor: ColorsManger.primaryColor,
        icon: Icons.info_outline_rounded,
      );
  }
}

class _SnackBarPalette {
  const _SnackBarPalette({
    required this.backgroundColor,
    required this.borderColor,
    required this.foregroundColor,
    required this.icon,
  });

  final Color backgroundColor;
  final Color borderColor;
  final Color foregroundColor;
  final IconData icon;
}

class AppTopSnackBar {
  const AppTopSnackBar._();

  static OverlayEntry? _currentEntry;

  static void show(
    BuildContext context, {
    required String message,
    required AppTopSnackBarType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null || message.trim().isEmpty) return;

    _removeCurrent();

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _SnackBarOverlay(
        message: message,
        type: type,
        duration: duration,
        onDismissed: () {
          if (identical(_currentEntry, entry)) {
            _currentEntry = null;
          }
          entry.remove();
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }

  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      type: AppTopSnackBarType.success,
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      type: AppTopSnackBarType.warning,
      duration: duration,
    );
  }

  static void showFailure(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      type: AppTopSnackBarType.failure,
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      type: AppTopSnackBarType.info,
      duration: duration,
    );
  }

  static void hideCurrent() {
    _removeCurrent();
  }

  static void _removeCurrent() {
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class _SnackBarCard extends StatelessWidget {
  const _SnackBarCard({
    required this.message,
    required this.type,
  });

  final String message;
  final AppTopSnackBarType type;

  @override
  Widget build(BuildContext context) {
    final palette = _snackBarPaletteForType(type);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(palette.icon, color: palette.foregroundColor),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                message,
                style: AppStylesManger.font14Medium.copyWith(
                  color: palette.foregroundColor,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showTopSnackBar(
  OverlayState? overlay,
  CustomSnackBar customSnackBar, {
  Duration animationDuration = const Duration(milliseconds: 260),
  Duration displayDuration = const Duration(seconds: 3),
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  ),
}) {
  if (overlay == null) return;

  AppTopSnackBar._removeCurrent();

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _SnackBarOverlay(
      message: customSnackBar.message,
      type: customSnackBar.type,
      duration: displayDuration,
      padding: padding,
      animationDuration: animationDuration,
      onDismissed: () {
        if (identical(AppTopSnackBar._currentEntry, entry)) {
          AppTopSnackBar._currentEntry = null;
        }
        entry.remove();
      },
    ),
  );

  AppTopSnackBar._currentEntry = entry;
  overlay.insert(entry);
}

class _SnackBarOverlay extends StatefulWidget {
  const _SnackBarOverlay({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismissed,
    this.padding = const EdgeInsets.fromLTRB(12, 8, 12, 0),
    this.animationDuration = const Duration(milliseconds: 260),
  });

  final String message;
  final AppTopSnackBarType type;
  final Duration duration;
  final EdgeInsetsGeometry padding;
  final Duration animationDuration;
  final VoidCallback onDismissed;

  @override
  State<_SnackBarOverlay> createState() => _SnackBarOverlayState();
}

class _SnackBarOverlayState extends State<_SnackBarOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _dismissTimer;
  bool _isDismissing = false;

  _SnackBarPalette get _palette {
    return _snackBarPaletteForType(widget.type);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      reverseDuration: const Duration(milliseconds: 220),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _controller.forward();
    _dismissTimer = Timer(widget.duration, dismiss);
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> dismiss() async {
    if (_isDismissing) return;
    _isDismissing = true;
    _dismissTimer?.cancel();
    await _controller.reverse();
    if (mounted) {
      widget.onDismissed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = _palette;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: widget.padding,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _offsetAnimation,
              child: Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: dismiss,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: palette.backgroundColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: palette.borderColor),
                      boxShadow: [
                        BoxShadow(
                          color:
                              palette.foregroundColor.withValues(alpha: 0.14),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 58),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              palette.icon,
                              color: palette.foregroundColor,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.message,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppStylesManger.font14Medium.copyWith(
                                  color: palette.foregroundColor,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: dismiss,
                              splashRadius: 18,
                              visualDensity: VisualDensity.compact,
                              icon: Icon(
                                Icons.close_rounded,
                                color: palette.foregroundColor,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
