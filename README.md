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

The GBPrimePay QRCode package allows you to request a QRCode image from the QRCash service provided by GBPrimePay.

## Features

Show QRCode from QRCash Service
Listen for payment results and store them using a Cloud FireStore query snapshot
Getting Started
To use this package, you can add a dialog with the GBPrimePayQRCode widget using Dialog.builder() or Get.builder(). See the example folder for more details.

## Getting started

To use this package, you can add a dialog with the GBPrimePayQRCode widget using Dialog.builder() or Get.dialog(). See the example folder for more details.

```dart
// create timestamp as referenceId
final referenceNo = "202212220001";
final amount = 1.0;

// show dialog with QRCode
Get.dialog(
    GBPrimePayQRCode(
    // A reference to the Cloud FireStore collection where payment results will be stored
    collectionRef: FirebaseFirestore.instance.collection("payments"),
    // A unique reference number for the payment
    referenceNo: referenceNo,
    // A description of the item being purchased
    detail: "Sample T-Shirt",
    // The amount of the purchase
    amount: amount,
    // The callback URL that GBPrimePay will send the payment result to
    backgroundUrl: BACKGROUND_URL,
    // The GBPrimePay token provided by the service
    token: GB_TOKEN,
    // The message to display on successful payment
    completeMessage1: "Payment received!",
    completeMessage2: "Thank you",
    // The title of the button to close the dialog on successful payment
    completeButtonTitle: "Close",
    // The callback function to execute when the button is pressed on successful payment
    completeButtonOnTap: () => Get.back(),
    // The message to display on failed payment
    failMessage1: "Payment not complete!",
    failMessage2: "Try another payment method",
    // The title of the button to close the dialog on failed payment
    failButtonTitle: "Close",
    // The callback function to execute when the button is pressed on failed payment
    failButtonOnTap: () => Get.back(),
  ),
  // Use the safe area of the screen to avoid overlaps with the system UI
  useSafeArea: true,
);
```

Cloud function for call back URL from GBPrimePay

```javascript
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.webhookGBPay = functions.https.onRequest(async (req, res) => {
  functions.logger.log("message", req.body);

  // add data payment data to cloud firestore
  await admin
    .firestore()
    .collection("payments")
    .doc(req.body.referenceNo)
    .set(req.body);

  res.status(200).send();
});
```

In this example, the GBPrimePayQRCode widget is being shown in a dialog and listens for payment results using the provided collectionRef. The backgroundUrl is a callback URL that GBPrimePay will send the payment result to. The token is the GBPrimePay token provided by the service. The widget also includes messages and button titles for both successful and failed payments.
