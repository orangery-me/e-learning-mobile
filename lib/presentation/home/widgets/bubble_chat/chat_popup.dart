import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/common/utils/dialog_util.dart';
import 'package:e_learning_mobile/presentation/home/bloc/chat/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ChatPopup extends StatefulWidget {
  final VoidCallback onClose;

  const ChatPopup({super.key, required this.onClose});

  @override
  State<ChatPopup> createState() => _ChatPopupState();
}

class _ChatPopupState extends State<ChatPopup> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    context.read<ChatBloc>().add(SendMessage(message));
    _messageController.clear();
  }

  void _showEndChatDialog() {
    DialogUtil.showCustomDialog(
      context,
      title: 'End chat session',
      child: Text(
        'Are you sure you want to end the chat session?',
        style: context.textStyles.body2,
      ),
      isConfirmDialog: true,
      cancelButtonText: 'Cancel',
      confirmButtonText: 'Yes',
      confirmAction: _endChat,
    );
  }

  void _endChat() {
    context.read<ChatBloc>().add(const EndChat());
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        // Auto scroll when new message arrives
        if (state.messages.isNotEmpty) {
          _scrollToBottom();
        }
      },
      child: Positioned(
        top: 80,
        left: 16,
        right: 16,
        bottom: 100,
        child: Material(
          elevation: 0,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: context.palette.primaryColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          IconlyBold.chat,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "AI Assistant",
                              style: context.textStyles.heading4.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Always here to help",
                              style: context.textStyles.metadata1.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // End Chat Button
                      // IconButton(
                      //   icon: const Icon(
                      //     IconlyBold.closeSquare,
                      //     color: Colors.white,
                      //     size: 24,
                      //   ),
                      //   onPressed: _endChat,
                      //   tooltip: 'End Chat',
                      // ),
                    ],
                  ),
                ),

                // Chat Area
                Expanded(
                  child: Container(
                    color: const Color(0xFFF9FAFB),
                    child: BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        // Show welcome message if no messages
                        if (state.messages.isEmpty) {
                          return ListView(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(20),
                            children: [
                              _buildBotMessage(
                                context,
                                "Hello! How can I help you today?",
                              ),
                            ],
                          );
                        }

                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 20,
                            bottom: 100, // Space for end chat button
                          ),
                          itemCount: state.messages.length +
                              (state.isLoading ? 1 : 0) +
                              1, // +1 for end chat button
                          itemBuilder: (context, index) {
                            // End chat button at the end
                            if (index ==
                                state.messages.length +
                                    (state.isLoading ? 1 : 0)) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: _buildEndChatButton(context),
                              );
                            }

                            if (index < state.messages.length) {
                              final message = state.messages[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: message.isUser
                                    ? _buildUserMessage(context, message.text)
                                    : _buildBotMessage(context, message.text),
                              );
                            } else {
                              // Loading indicator
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildBotMessage(
                                  context,
                                  "Typing...",
                                  isLoading: true,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),

                // Input Area
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(24)),
                    border: Border(
                      top: BorderSide(color: Colors.grey.withOpacity(0.1)),
                    ),
                  ),
                  child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              height: 50,
                              decoration: BoxDecoration(
                                color: context.palette.textFieldBackground,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.1)),
                              ),
                              child: TextField(
                                controller: _messageController,
                                enabled: !state.isLoading,
                                decoration: InputDecoration(
                                  hintText: "Type a message...",
                                  hintStyle: context.textStyles.body2.copyWith(
                                    color: context.palette.hintTextField,
                                  ),
                                  border: InputBorder.none,
                                ),
                                onSubmitted: (_) => _sendMessage(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: state.isLoading
                                  ? Colors.grey
                                  : context.palette.primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (state.isLoading
                                          ? Colors.grey
                                          : context.palette.primaryColor)
                                      .withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(IconlyBold.send,
                                  color: Colors.white, size: 22),
                              onPressed: state.isLoading ? null : _sendMessage,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBotMessage(
    BuildContext context,
    String message, {
    bool isLoading = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: context.palette.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            IconlyBold.user3,
            color: context.palette.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isLoading
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            context.palette.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        message,
                        style: context.textStyles.body2.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  )
                : Text(
                    message,
                    style: context.textStyles.body2,
                  ),
          ),
        ),
        const SizedBox(width: 40),
      ],
    );
  }

  Widget _buildUserMessage(BuildContext context, String message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 40),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(4),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: context.palette.primaryColor.withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message,
              style: context.textStyles.body2.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEndChatButton(BuildContext context) {
    return Center(
      child: OutlinedButton.icon(
        onPressed: _showEndChatDialog,
        icon: const Icon(
          IconlyBold.closeSquare,
          size: 16,
        ),
        label: Text(
          'End Chat',
          style: context.textStyles.metadata1.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          side: BorderSide(
            color: Colors.grey[300]!,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          foregroundColor: Colors.grey[700],
        ),
      ),
    );
  }
}
