import 'dart:async';
import 'dart:io';
import 'package:e_learning_mobile/common/utils/toast_util.dart';
import 'package:e_learning_mobile/data/dtos/payment/payment_response_dto.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class QrPaymentDialog extends StatefulWidget {
  final PaymentResponseDto payment;
  final VoidCallback? onExpired;
  final VoidCallback? onCancel;

  const QrPaymentDialog({
    super.key,
    required this.payment,
    this.onExpired,
    this.onCancel,
  });

  @override
  State<QrPaymentDialog> createState() => _QrPaymentDialogState();
}

class _QrPaymentDialogState extends State<QrPaymentDialog> {
  ScreenshotController screenshotController = ScreenshotController();
  late Duration _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.payment.expiresAt!.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  void _onTick() {
    final left = widget.payment.expiresAt!.difference(DateTime.now());
    if (!mounted) return;
    final wasExpired = _remaining == Duration.zero;
    setState(() {
      _remaining = left.isNegative ? Duration.zero : left;
    });
    if (left.isNegative && !wasExpired) {
      _timer?.cancel();
      // Call onExpired callback if provided
      widget.onExpired?.call();
    }
  }

  Future<bool> checkAndRequestPermissions({required bool skipIfExists}) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return false; // Only Android and iOS platforms are supported
    }

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;

      if (skipIfExists) {
        // Read permission is required to check if the file already exists
        return sdkInt >= 33
            ? await Permission.photos.request().isGranted
            : await Permission.storage.request().isGranted;
      } else {
        // No read permission required for Android SDK 29 and above
        return sdkInt >= 29
            ? true
            : await Permission.storage.request().isGranted;
      }
    }

    return false; // Unsupported platforms
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hh = d.inHours;
    return hh > 0 ? '$hh:$mm:$ss' : '$mm:$ss';
  }

  Future<SaveResult?> saveImage(Uint8List image) async {
    if (await checkAndRequestPermissions(skipIfExists: false)) {
      final result = SaverGallery.saveImage(image,
          fileName: "qr_payment_${DateTime.now().millisecondsSinceEpoch}.png",
          skipIfExists: false);

      return result;
    } else {
      // show toast
      if (mounted) {
        ToastUtil.showError(context,
            text: 'Permission denied. Cannot save image.',
            position: ToastPosition.BOTTOM);
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isExpired = _remaining == Duration.zero;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Screenshot(
            controller: screenshotController,
            child: Column(
              children: [
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: QrImageView(
                      data: widget.payment.qrCode!,
                      size: 200,
                      embeddedImageEmitsError: true),
                ),
                const SizedBox(height: 12),
                // show bank account info
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoText(
                          title: 'Account Name',
                          content: widget.payment.accountName!),
                      InfoText(
                          title: 'Account Number',
                          content: widget.payment.accountNumber!),
                      InfoText(
                          title: 'Bank Name',
                          content: widget.payment.bankName ?? 'BIDV'),
                      InfoText(
                        title: 'Amount',
                        content:
                            '${widget.payment.amount.toStringAsFixed(0)} VND',
                      ),
                      InfoText(
                          title: 'Description',
                          content: widget.payment.description!),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // 2 buttons: copy qr code, save qr code
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: widget.payment.qrCode!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('QR code copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy QR Code'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      screenshotController.capture().then((Uint8List? image) {
                        // Save or share the image
                        if (context.mounted) {
                          ToastUtil.showSuccess(context,
                              text: 'QR code image saved',
                              position: ToastPosition.BOTTOM);
                          saveImage(image!);
                        }
                      }).catchError((onError) {
                        debugPrint(onError);
                      });
                    },
                    icon: const Icon(Icons.save_alt),
                    label: const Text('Save QR Image'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer_outlined),
              const SizedBox(width: 6),
              Text(
                isExpired ? 'Expired' : _fmt(_remaining),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isExpired ? Colors.red : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'This code will expire. Complete the payment before time runs out.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          // SizedBox(
          //   width: double.infinity,
          //   child: OutlinedButton(
          //     onPressed: () {
          //       widget.onCancel?.call();
          //       Navigator.of(context).pop();
          //     },
          //     child: const Text('Cancel'),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class InfoText extends StatelessWidget {
  final String title;
  final String content;

  const InfoText({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              content,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
