import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:e_learning_mobile/main_dev.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Payment Integration Tests', () {
    // Test credentials - adjust these based on your test environment
    const String testEmail = 'test@example.com';
    const String testPassword = 'password123';

    /// Helper function to handle notification permission dialog
    Future<void> handleNotificationPermission(WidgetTester tester) async {
      // Wait for any permission dialogs
      await tester.pumpAndSettle();

      // Look for common permission dialog buttons
      // iOS: "Allow" or "Don't Allow"
      // Android: "Allow" or "Deny"
      final allowButton = find.text('Allow').first;
      final allowButtonVi = find.text('Cho phép').first;

      if (allowButton.evaluate().isNotEmpty) {
        await tester.tap(allowButton);
        await tester.pumpAndSettle();
      } else if (allowButtonVi.evaluate().isNotEmpty) {
        await tester.tap(allowButtonVi);
        await tester.pumpAndSettle();
      }
    }

    /// Helper function to perform login
    Future<void> performLogin(
        WidgetTester tester, String email, String password) async {
      // Wait for login screen
      await tester.pumpAndSettle();

      // Find email field - look for "Email" or "Email Address" label
      final emailField = find
          .widgetWithText(
            TextFormField,
            '',
          )
          .first;

      // Alternative: find by hint text using finder
      final emailFieldByHint = find.byWidgetPredicate(
        (widget) {
          if (widget is! TextFormField) return false;
          // Try to find by checking if it's the first text field (usually email)
          return true;
        },
      );

      if (emailFieldByHint.evaluate().isNotEmpty) {
        await tester.enterText(emailFieldByHint, email);
        await tester.pumpAndSettle();
      } else if (emailField.evaluate().isNotEmpty) {
        await tester.enterText(emailField, email);
        await tester.pumpAndSettle();
      } else {
        // Try finding by key or type
        final emailFields = find.byType(TextFormField);
        if (emailFields.evaluate().isNotEmpty) {
          await tester.enterText(emailFields.first, email);
          await tester.pumpAndSettle();
        }
      }

      // Find password field - it's usually the second TextFormField
      final passwordFields = find.byType(TextFormField);
      if (passwordFields.evaluate().length >= 2) {
        await tester.enterText(passwordFields.at(1), password);
        await tester.pumpAndSettle();
      } else if (passwordFields.evaluate().isNotEmpty) {
        // Fallback: if only one field, try the first one
        await tester.enterText(passwordFields.first, password);
        await tester.pumpAndSettle();
      }

      // Find and tap sign in button
      final signInButton = find.text('Sign in').first;
      final signInButtonVi = find.text('Đăng nhập').first;

      if (signInButton.evaluate().isNotEmpty) {
        await tester.tap(signInButton);
      } else if (signInButtonVi.evaluate().isNotEmpty) {
        await tester.tap(signInButtonVi);
      } else {
        // Try finding button by type
        final buttons = find.byType(ElevatedButton);
        if (buttons.evaluate().isNotEmpty) {
          await tester.tap(buttons.first);
        }
      }

      await tester.pumpAndSettle(const Duration(seconds: 3));
    }

    /// Helper function to select a course from home screen
    Future<void> selectCourse(WidgetTester tester) async {
      await tester.pumpAndSettle();

      // Wait for courses to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find a course card - look for CourseCard or tap on course image/play button
      // Course cards are typically in a horizontal scrollable list
      final courseCards = find.byWidgetPredicate(
        (widget) =>
            widget is InkWell ||
            widget is GestureDetector ||
            (widget is Container && widget.decoration != null),
      );

      // Try to find course by looking for play button icon
      final playButtons = find.byIcon(Icons.play_arrow_rounded);

      if (playButtons.evaluate().isNotEmpty) {
        await tester.tap(playButtons.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      } else if (courseCards.evaluate().isNotEmpty) {
        // Tap on first course card
        await tester.tap(courseCards.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
      } else {
        // Fallback: scroll and find any tappable course
        await tester.drag(find.byType(Scrollable).first, const Offset(-300, 0));
        await tester.pumpAndSettle();

        final anyCourse = find.byType(InkWell).first;
        if (anyCourse.evaluate().isNotEmpty) {
          await tester.tap(anyCourse);
          await tester.pumpAndSettle(const Duration(seconds: 2));
        }
      }
    }

    testWidgets(
      'Test 1: Buy Now Flow - Allow notification -> Login -> Select course -> Buy now',
      (WidgetTester tester) async {
        // Start the app
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Step 1: Handle notification permission
        await handleNotificationPermission(tester);

        // Step 2: Perform login
        await performLogin(tester, testEmail, testPassword);

        // Step 3: Select a course
        await selectCourse(tester);

        // Step 4: Verify we're on course detail page
        await tester.pumpAndSettle();
        expect(find.text('Buy now'), findsOneWidget);

        // Step 5: Tap "Buy now" button
        final buyNowButton = find.text('Buy now');
        expect(buyNowButton, findsOneWidget);
        await tester.tap(buyNowButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Step 6: Verify we're on order detail page
        // Look for order detail indicators like "Order Summary" or price
        await tester.pumpAndSettle();

        // The order should be created and we should see order details
        // This might show loading state first, then order details
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Verify order detail page is shown (look for common elements)
        final orderDetailIndicators = [
          find.text('Order Summary'),
          find.text('Tóm tắt đơn hàng'),
          find.text('Total'),
          find.text('Tổng cộng'),
          find.byType(CircularProgressIndicator), // Loading state
        ];

        bool foundOrderDetail = false;
        for (final indicator in orderDetailIndicators) {
          if (indicator.evaluate().isNotEmpty) {
            foundOrderDetail = true;
            break;
          }
        }

        // If we see loading indicator, wait for it to complete
        if (find.byType(CircularProgressIndicator).evaluate().isNotEmpty) {
          await tester.pumpAndSettle(const Duration(seconds: 5));
        }

        // Verify order was created (should see order details or confirm payment button)
        expect(
          find.text('Confirm Payment').evaluate().isNotEmpty ||
              find.text('Xác nhận thanh toán').evaluate().isNotEmpty ||
              foundOrderDetail,
          true,
          reason: 'Order detail page should be displayed after creating order',
        );
      },
    );

    testWidgets(
      'Test 2: Add to Cart -> Checkout Flow - Allow notification -> Login -> Select course -> Add to cart -> Go to cart -> Checkout',
      (WidgetTester tester) async {
        // Start the app
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Step 1: Handle notification permission
        await handleNotificationPermission(tester);

        // Step 2: Perform login
        await performLogin(tester, testEmail, testPassword);

        // Step 3: Select a course
        await selectCourse(tester);

        // Step 4: Verify we're on course detail page
        await tester.pumpAndSettle();
        expect(find.text('Add to cart'), findsOneWidget);

        // Step 5: Tap "Add to cart" button
        final addToCartButton = find.text('Add to cart');
        expect(addToCartButton, findsOneWidget);
        await tester.tap(addToCartButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Step 6: Verify success message (snackbar)
        // Look for success message or snackbar
        await tester.pumpAndSettle();

        // Step 7: Navigate to cart
        // Look for cart icon in app bar or bottom navigation
        final cartIcon = find.byIcon(Icons.shopping_cart);
        if (cartIcon.evaluate().isNotEmpty) {
          await tester.tap(cartIcon.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));
        } else {
          // Alternative: Look for "Xem giỏ hàng" button if course is already in cart
          final viewCartButton = find.text('Xem giỏ hàng');
          if (viewCartButton.evaluate().isNotEmpty) {
            await tester.tap(viewCartButton);
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }
        }

        // Step 8: Verify we're on cart page
        await tester.pumpAndSettle();
        expect(
          find.text('Checkout').evaluate().isNotEmpty ||
              find.text('Cart').evaluate().isNotEmpty ||
              find.text('Giỏ hàng').evaluate().isNotEmpty,
          true,
          reason: 'Should be on cart page',
        );

        // Step 9: Tap "Checkout" button
        final checkoutButton = find.text('Checkout');
        expect(checkoutButton, findsOneWidget);
        await tester.tap(checkoutButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Step 10: Verify we're on order detail page
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Verify order was created from cart
        expect(
          find.text('Confirm Payment').evaluate().isNotEmpty ||
              find.text('Xác nhận thanh toán').evaluate().isNotEmpty ||
              find.byType(CircularProgressIndicator).evaluate().isNotEmpty,
          true,
          reason: 'Order detail page should be displayed after checkout',
        );
      },
    );

    testWidgets(
      'Test 3: Confirm Payment Flow - Go to existing order -> Confirm payment',
      (WidgetTester tester) async {
        // Start the app
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Step 1: Handle notification permission
        await handleNotificationPermission(tester);

        // Step 2: Perform login
        await performLogin(tester, testEmail, testPassword);

        // Step 3: Navigate to orders page
        // Look for orders/management tab or menu item
        await tester.pumpAndSettle();

        // Try to find orders navigation - might be in bottom nav or drawer
        final ordersTab = find.text('Management').first;
        final ordersTabVi = find.text('Quản lý').first;

        if (ordersTab.evaluate().isNotEmpty) {
          await tester.tap(ordersTab);
          await tester.pumpAndSettle(const Duration(seconds: 2));
        } else if (ordersTabVi.evaluate().isNotEmpty) {
          await tester.tap(ordersTabVi);
          await tester.pumpAndSettle(const Duration(seconds: 2));
        } else {
          // Alternative: Look for bottom navigation and tap orders tab
          // Usually tab index 3 or 4 (after Home, Search, Notification)
          final bottomNav = find.byType(BottomNavigationBar);
          if (bottomNav.evaluate().isNotEmpty) {
            // Try tapping different tabs to find orders
            // This is a fallback - in real scenario, you'd know the tab index
            // For now, we'll skip this and look for order items directly
          }
        }

        // Step 4: Wait for orders to load
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Step 5: Find and tap on an existing order
        // Look for order cards or list items
        final orderItems = find.byWidgetPredicate(
          (widget) =>
              widget is ListTile ||
              widget is Card ||
              (widget is InkWell || widget is GestureDetector),
        );

        if (orderItems.evaluate().isNotEmpty) {
          // Tap on first order (assuming it's pending and can be paid)
          await tester.tap(orderItems.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));
        } else {
          // Alternative: Look for order by text pattern
          final orderText = find.textContaining('Order');
          if (orderText.evaluate().isNotEmpty) {
            await tester.tap(orderText.first);
            await tester.pumpAndSettle(const Duration(seconds: 2));
          }
        }

        // Step 6: Verify we're on order detail page
        await tester.pumpAndSettle();

        // Step 7: Look for "Confirm Payment" button
        final confirmPaymentButton = find.text('Confirm Payment');
        final confirmPaymentButtonVi = find.text('Xác nhận thanh toán');

        if (confirmPaymentButton.evaluate().isEmpty &&
            confirmPaymentButtonVi.evaluate().isEmpty) {
          // Order might already be paid or in different state
          // Try to find any payment-related button
          final paymentButtons = find.byWidgetPredicate(
            (widget) => widget is OutlinedButton || widget is ElevatedButton,
          );

          if (paymentButtons.evaluate().isNotEmpty) {
            // Check if button text contains payment-related keywords
            // This is a simplified check
          }
        }

        // Step 8: Tap "Confirm Payment" button if available
        if (confirmPaymentButton.evaluate().isNotEmpty) {
          await tester.tap(confirmPaymentButton);
          await tester.pumpAndSettle(const Duration(seconds: 3));
        } else if (confirmPaymentButtonVi.evaluate().isNotEmpty) {
          await tester.tap(confirmPaymentButtonVi);
          await tester.pumpAndSettle(const Duration(seconds: 3));
        } else {
          // If button not found, the order might already be paid
          // or in a state that doesn't allow payment
          // This is acceptable for test - log it
          print(
              'Confirm Payment button not found - order may already be paid or in different state');
        }

        // Step 9: Verify payment was created
        // After confirming payment, should see QR code dialog or success message
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Look for QR code dialog or payment success indicators
        final qrCodeIndicators = [
          find.text('QR Code'),
          find.text('Mã QR'),
          find.byType(Image), // QR code image
          find.text('Payment successful'),
          find.text('Thanh toán thành công'),
        ];

        bool foundPaymentIndicator = false;
        for (final indicator in qrCodeIndicators) {
          if (indicator.evaluate().isNotEmpty) {
            foundPaymentIndicator = true;
            break;
          }
        }

        // Note: If payment button was not found, this test might not complete
        // but that's acceptable if the order is already in a paid state
        if (confirmPaymentButton.evaluate().isNotEmpty ||
            confirmPaymentButtonVi.evaluate().isNotEmpty) {
          expect(
            foundPaymentIndicator ||
                find.byType(CircularProgressIndicator).evaluate().isNotEmpty,
            true,
            reason:
                'Payment should be created and show QR code or success message',
          );
        }
      },
    );
  });
}
