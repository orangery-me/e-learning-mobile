import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class FloatingChatBubble extends StatefulWidget {
  final VoidCallback onTap;
  final bool isOpen;

  const FloatingChatBubble({
    super.key,
    required this.onTap,
    required this.isOpen,
  });

  @override
  State<FloatingChatBubble> createState() => _FloatingChatBubbleState();
}

class _FloatingChatBubbleState extends State<FloatingChatBubble> {
  double? x;
  double? y;
  bool _isInitialized = false;

  void _initializePosition(BuildContext context) {
    if (!_isInitialized) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      x = screenWidth - 65 - 40; // 65 là width của bubble
      y = screenHeight - 300 - 65; // 65 là height của bubble
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _initializePosition(context);

    // When open, force position to top right
    final double targetX =
        widget.isOpen ? MediaQuery.of(context).size.width - 60 : (x ?? 0);
    final double targetY = widget.isOpen ? 60 : (y ?? 0);

    final bubble = GestureDetector(
      onPanUpdate: widget.isOpen
          ? null // Disable dragging when open
          : (details) {
              setState(() {
                x = (x ?? 0) + details.delta.dx;
                y = (y ?? 0) + details.delta.dy;
              });
            },
      onTap: widget.onTap,
      child: Container(
        width: widget.isOpen ? 50 : 60,
        height: widget.isOpen ? 50 : 60,
        decoration: BoxDecoration(
          color: widget.isOpen ? Colors.white : context.palette.primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: context.palette.primaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
          border: widget.isOpen
              ? Border.all(color: Colors.grey.withOpacity(0.2), width: 1)
              : null,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: widget.isOpen
              ? Icon(
                  Icons.close_rounded,
                  key: const ValueKey('close'),
                  color: Colors.grey[600],
                  size: 32,
                )
              : const Icon(
                  IconlyBold.chat,
                  key: ValueKey('chat'),
                  color: Colors.white,
                  size: 32,
                ),
        ),
      ),
    );

    // Use AnimatedPositioned only when open; otherwise regular Positioned to keep drag smooth
    if (widget.isOpen) {
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutBack,
        left: targetX,
        top: targetY,
        child: bubble,
      );
    }

    return Positioned(
      left: targetX,
      top: targetY,
      child: bubble,
    );
  }
}
