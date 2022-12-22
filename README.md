<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

A GBPrimePay QRCode package let's you request a QRCode image from QRCash service from GBPrimePay.

## Features

- Show QRCode from QRCash Service
- Listen payment result and store payment result using a query snapshot via Cloud FireStore

## Getting started

A GBPrimePay QRCode package let's you request a QRCode image from QRCash service from GBPrimePay. This package store and listen payment result via Cloud FireStore.

## Usage

Add dialog to popup a QRCode using Dialog.builder() or Get.builder to show a GNPrimePayQRCode widget. see more detail in [example](https://github.com/anoochit/flutter_gbprimepay_qrcode/tree/master/example) folder.

- `collectionRef` to keep track payment result
- `backgroundUrl` a call back URL which GBPrimePay will send a payment result to
- `token`a GBPrimePay token

```dart
// create timestamp as referenceId
final referenceNo = "202212220001";
final amount = 1.0;

// show dialog with QRCode
Get.dialog(
    GBPrimePayQRCode(
    collectionRef: FirebaseFirestore.instance.collection("payment"),
    referenceNo: referenceNo,
    detail: "Sample T-Shirt",
    amount: amount,
    backgroundUrl: BACKGROUND_URL,
    token: GB_TOKEN,
    completeMessage1: "Payment recieved!",
    completeMessage2: "Thank You",
    completeButtonTitle: "Close",
    completeButtonOnTap: () => Get.back(),
    failMessage1: "Payment not complete!",
    failMessage2: "Try other payment method",
    failButtonTitle: "Close",
    failButtonOnTap: () => Get.back(),
    ),
    useSafeArea: true,
);
```
