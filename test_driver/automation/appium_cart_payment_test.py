"""
Automation tests for cart and payment flows using Appium + appium-flutter-driver.

Prerequisites:
  * Start Appium server (default http://127.0.0.1:4723)
  * Supply desired capabilities (deviceName, platformVersion, app, etc.)
  * Ensure app builds include the targeted widgets/text content referenced here.

These tests cover:
  1. Creating an order directly from the course detail page (Buy now path)
  2. Creating an order from the cart (Checkout path)
  3. Creating a payment (Confirm Payment -> QR dialog)
"""

from __future__ import annotations

import os   
import unittest
from dotenv import load_dotenv
from typing import Optional

from appium import webdriver
from appium.webdriver.common.appiumby import AppiumBy
from appium_flutter_finder.flutter_finder import FlutterFinder
from selenium.common.exceptions import WebDriverException
from appium.options.common import AppiumOptions

# Load environment variables
load_dotenv()

# Fixed: Remove /wd/hub from default URL since we're running Appium without base-path
APPIUM_SERVER_URL = os.environ.get("APPIUM_SERVER_URL", "http://127.0.0.1:4723")


def build_default_capabilities() -> dict:
    """
    Returns a baseline set of desired capabilities.
    Update the placeholders to match the target device/emulator and build.
    """
    return {
        "platformName": os.environ.get("PLATFORM_NAME", "Android"),
        "automationName": os.environ.get("AUTOMATION_NAME", "Flutter"),  # appium-flutter-driver
        "deviceName": os.environ.get("DEVICE_NAME", "Android Emulator"),
        "platformVersion": os.environ.get("PLATFORM_VERSION"),  # Optional
        "app": os.environ.get("APP_PATH"),  # Optional when testing installed builds
        "appPackage": os.environ.get("APP_PACKAGE"),  # e.g., com.example.app
        "appActivity": os.environ.get("APP_ACTIVITY"),  # e.g., .MainActivity
        "noReset": True,
        "newCommandTimeout": 120,
    }


class CartPaymentFlowsTest(unittest.TestCase):
    """
    Appium UI automation for cart & payment flows.
    """

    driver: webdriver.Remote
    finder: FlutterFinder

    @classmethod
    def setUpClass(cls) -> None:
        desired_caps = build_default_capabilities()
        if not desired_caps.get("app") and not desired_caps.get("appPackage"):
            print(
                "[WARN] No app/appPackage specified. "
                "Make sure the app is already installed on the target device."
            )

        options = AppiumOptions()
        options.load_capabilities(desired_caps)

        print(f"[INFO] Connecting to Appium server at: {APPIUM_SERVER_URL}")
        cls.driver = webdriver.Remote(
            command_executor=APPIUM_SERVER_URL,
            options=options
        )
        cls.finder = FlutterFinder()

    @classmethod
    def tearDownClass(cls) -> None:
        if cls.driver:
            cls.driver.quit()

    # --------------------------------------------------------------------- #
    # Helper methods
    # --------------------------------------------------------------------- #
    def _wait_for(self, finder_expression, timeout_ms: int = 20_000) -> None:
        """
        Waits until the finder expression resolves (Flutter waitFor).
        """
        self.driver.execute_script(
            "flutter:waitFor",
            finder_expression,
            {"durationMilliseconds": timeout_ms}
        )

    def _is_present(self, finder_expression, timeout_ms: int = 2_000) -> bool:
        """
        Returns True if the finder expression resolves within the timeout.
        """
        try:
            self._wait_for(finder_expression, timeout_ms=timeout_ms)
            return True
        except WebDriverException:
            return False

    def _tap(self, finder_expression, timeout_ms: int = 20_000) -> None:
        """
        Waits for the finder and taps it.
        """
        self._wait_for(finder_expression, timeout_ms=timeout_ms)
        self.driver.execute_script("flutter:tap", finder_expression, {})

    def _scroll_until_visible(
        self,
        scrollable_finder,
        item_finder,
        dx: float = 0.0,
        dy: float = -300.0,
        timeout_ms: int = 15_000,
    ) -> None:
        """
        Scrolls the given scrollable until the item finder becomes visible.
        dx, dy: scroll delta per command (dy negative scrolls down).
        """
        self.driver.execute_script(
            "flutter:scrollUntilVisible",
            scrollable_finder,
            {
                "item": item_finder,
                "dxScroll": dx,
                "dyScroll": dy,
                "durationMilliseconds": timeout_ms
            }
        )

    def _ensure_on_home_tab(self) -> None:
        """
        Ensures we are on the Home tab by tapping the bottom nav item if needed.
        """
        home_nav = self.finder.by_text("Home")
        if self._is_present(home_nav):
            self._tap(home_nav)

        # Wait for a stable home widget to confirm navigation
        hero_text = self.finder.by_text("What do you want to learn today?")
        self._wait_for(hero_text)

    def _open_first_course_detail(self) -> None:
        """
        Opens the first course detail from the home page by tapping the play
        button overlay of the first CourseCard.
        """
        self._ensure_on_home_tab()

        course_card = self.finder.by_type("CourseCard")
        play_button = self.finder.descendant(
            of_=course_card, matching=self.finder.by_type("IconButton")
        )
        self._tap(play_button)

        order_detail_header = self.finder.by_text("Course Info")
        self._wait_for(order_detail_header)

    def _go_back(self) -> None:
        """
        Taps default back button (assumes AppBar back arrow).
        """
        back_button = self.finder.by_type("BackButton")
        if not self._is_present(back_button):
            back_button = self.finder.by_type("IconButton")
        self._tap(back_button)

    # --------------------------------------------------------------------- #
    # Test cases
    # --------------------------------------------------------------------- #
    def test_create_order_buy_now_flow(self) -> None:
        """
        Select a course on home -> open detail -> tap Buy now -> land on order detail page.
        """
        self._open_first_course_detail()

        buy_now_button = self.finder.by_text("Buy now")
        self._tap(buy_now_button)

        order_detail_title = self.finder.by_text("Order Detail")
        self._wait_for(order_detail_title)

        items_header = self.finder.by_text("Items")
        self.assertTrue(
            self._is_present(items_header),
            "Order detail should list items after Buy now flow.",
        )

        # Navigate back so the next test starts from course detail.
        self._go_back()

    def test_create_order_from_cart_flow(self) -> None:
        """
        Add a course to cart -> open cart -> checkout -> land on order detail page.
        """
        self._open_first_course_detail()

        add_to_cart_button = self.finder.by_text("Add to cart")
        if self._is_present(add_to_cart_button, timeout_ms=1_000):
            self._tap(add_to_cart_button)

        view_cart_button = self.finder.by_text("Xem giỏ hàng")
        if not self._is_present(view_cart_button, timeout_ms=2_000):
            view_cart_button = self.finder.by_text("View cart")
        self._tap(view_cart_button)

        cart_title = self.finder.by_text("Shopping Cart")
        self._wait_for(cart_title)

        checkout_button = self.finder.by_text("Checkout")
        self._tap(checkout_button)

        order_detail_title = self.finder.by_text("Order Detail")
        self._wait_for(order_detail_title)

        total_label = self.finder.by_text("Total")
        self.assertTrue(
            self._is_present(total_label),
            "Order detail total should be visible after checkout.",
        )

        # Leave order detail open for the payment test.

    def test_create_payment_flow(self) -> None:
        """
        From an order detail page: tap Confirm Payment -> wait for QR dialog.
        """
        order_detail_title = self.finder.by_text("Order Detail")
        self._wait_for(order_detail_title)

        confirm_button = self.finder.by_text("Confirm Payment")
        self._tap(confirm_button)

        qr_dialog_title = self.finder.by_text("Scan to Pay")
        self._wait_for(qr_dialog_title, timeout_ms=30_000)

        countdown_label = self.finder.by_text("This code will expire. Complete the payment before time runs out.")
        self.assertTrue(
            self._is_present(countdown_label),
            "QR dialog should show countdown text."
        )

        cancel_button = self.finder.by_text("Cancel")
        self._tap(cancel_button)

        # Ensure we are back on the order detail page
        self._wait_for(order_detail_title)


if __name__ == "__main__":
    unittest.main()