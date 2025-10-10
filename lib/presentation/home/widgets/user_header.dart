// import 'package:e_learning_mobile/common/theme/text_styles.dart';
// import 'package:flutter/material.dart';

// class UserHeader extends StatelessWidget {
//   final String name;
//   final String imagePath;

//   const UserHeader({
//     super.key,
//     required this.name,
//     required this.imagePath,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         CircleAvatar(
//           radius: 30,
//           backgroundImage: AssetImage(imagePath),
//         ),
//         const SizedBox(width: 20),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Welcome",
//                 style: Fonts.s16w6.copyWith(color: Colors.grey[600])),
//             Text(
//               name,
//               style: Fonts.s24w7,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'package:e_learning_mobile/common/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserHeader extends StatelessWidget {
  final String name;
  final String avatarUrl;

  const UserHeader({
    Key? key,
    required this.name,
    required this.avatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(avatarUrl),
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Palette.light().buttonBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.notifications,
                color: Colors.white,
                size: 24,
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
