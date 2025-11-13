import 'package:flutter/material.dart';

/// Call this function from any page to show a top snackbar
void showTopSnackBar(
  BuildContext context, {
  required String message,
  Color backgroundColor = const Color.fromARGB(186, 255, 82, 82),
  Duration duration = const Duration(seconds: 2),
}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 60,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: _AnimatedSnackBar(
            message: message,
            backgroundColor: backgroundColor,
          ),
        ),
      ),
    ),
  );

  overlay?.insert(overlayEntry);

  Future.delayed(duration, () {
    overlayEntry.remove();
  });
}

class _AnimatedSnackBar extends StatefulWidget {
  final String message;
  final Color backgroundColor;

  const _AnimatedSnackBar({
    Key? key,
    required this.message,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  State<_AnimatedSnackBar> createState() => _AnimatedSnackBarState();
}

class _AnimatedSnackBarState extends State<_AnimatedSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            widget.message,
            style: TextStyle(
              color: widget.backgroundColor,
              fontWeight: FontWeight.normal,
              fontFamily: 'sfproRoundSemiB',
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
