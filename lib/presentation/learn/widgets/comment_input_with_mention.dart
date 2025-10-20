import 'package:e_learning_mobile/common/utils/format_util.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CommentInputWithMention extends StatefulWidget {
  final VideoPlayerController? videoController;
  final YoutubePlayerController? youtubeController;
  final Function(String content, int? timestamp) onSubmit;

  const CommentInputWithMention({
    super.key,
    this.videoController,
    this.youtubeController,
    required this.onSubmit,
  });

  @override
  State<CommentInputWithMention> createState() =>
      _CommentInputWithMentionState();
}

class _CommentInputWithMentionState extends State<CommentInputWithMention> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink =
      LayerLink(); // Dùng để liên kết vị trí của TextField và Overlay
  OverlayEntry? _overlayEntry;

  int? _getCurrentVideoTimestamp() {
    if (widget.videoController != null) {
      return widget.videoController!.value.position.inSeconds;
    } else if (widget.youtubeController != null) {
      return widget.youtubeController!.value.position.inSeconds;
    }
    return null;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _overlayEntry?.dispose();
    super.dispose();
  }

  void _showSuggestion() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String content = FormatUtil.convertTimestampToDuration(
          _getCurrentVideoTimestamp() ?? 0);
      _overlayEntry = _createOverlayEntry(content);
      Overlay.of(context).insert(_overlayEntry!);
    });
  }

  void _hideSuggestion() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  void _insertMention(String content) {
    final currentText = _controller.text;
    final cursorPos =
        _controller.selection.baseOffset; // Vị trí con trỏ hiện tại
    final newText = currentText.replaceRange(cursorPos - 1, cursorPos,
        ' $content'); // Thay thế "@" bằng nội dung đề xuất

    setState(() {
      _controller.text = newText;
      _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: cursorPos + content.length));
    });
  }

  OverlayEntry _createOverlayEntry(String content) {
    RenderBox renderBox = context.findRenderObject()
        as RenderBox; // đảm bảo context lấy của textfield
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
            left: offset.dx,
            top: offset.dy + size.height + 5.0,
            width: 100,
            // CompositeTransformFollower để theo dõi vị trí của TextField
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false, // Ẩn khi TextField không còn liên kết
              offset: Offset(0, -50), // Đặt overlay bên dưới TextField
              child: Material(
                  elevation: 4,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        title: Text(content),
                        onTap: () {
                          // Xử lý khi chọn user
                          _insertMention(content);
                          _hideSuggestion();
                        },
                      ),
                    ],
                  )),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Builder(builder: (buildContext) {
        return TextField(
          maxLines: 2,
          controller: _controller,
          focusNode:
              _focusNode, // Sử dụng FocusNode để theo dõi trạng thái focus
          decoration: InputDecoration(
            hintText: 'Write your note here...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                final value = _controller.text.trim();
                if (value.isEmpty) return;
                final timestamp = _getCurrentVideoTimestamp();
                widget.onSubmit(value, timestamp);
                _controller.clear();
                _hideSuggestion();
              },
              tooltip: 'Send',
            ),
          ),
          onChanged: (value) {
            if (value.endsWith('@')) {
              _showSuggestion();
            } else {
              _hideSuggestion();
            }
          },
        );
      }),
    );
  }
}
