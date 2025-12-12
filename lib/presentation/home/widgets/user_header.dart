import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/presentation/payment/views/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class UserHeader extends StatelessWidget {
  final String name;
  final String avatarUrl;

  const UserHeader({
    super.key,
    required this.name,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.palette.primaryColor.withOpacity(0.2),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.palette.primaryColor.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage(avatarUrl),
                backgroundColor: Colors.grey[200],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello,',
                  style: context.textStyles.body1.copyWith(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: context.textStyles.heading4.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.palette.normalText,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            // Shopping cart icon
            _buildIconButton(
              context,
              icon: IconlyBold.buy,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartPage(),
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            // Notification icon
            Stack(
              children: [
                _buildIconButton(
                  context,
                  icon: IconlyBold.notification,
                  isPrimary: true,
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: context.palette.errorButtonLabel,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton(
    BuildContext context, {
    required IconData icon,
    VoidCallback? onTap,
    bool isPrimary = false,
  }) {
    final bgColor = isPrimary
        ? context.palette.primaryColor
        : context.palette.scaffoldBackground;
    final iconColor = isPrimary ? Colors.white : context.palette.normalText;
    final shadowColor = isPrimary
        ? context.palette.primaryColor.withOpacity(0.3)
        : Colors.black.withOpacity(0.05);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: isPrimary
              ? null
              : Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
      ),
    );
  }
}
