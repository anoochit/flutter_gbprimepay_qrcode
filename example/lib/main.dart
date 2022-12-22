import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gbprimepay_qrcode/flutter_gbprimepay_qrcode.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // use firestore emulator
  FirebaseFirestore.instance.useFirestoreEmulator('10.0.2.2', 8088);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'GBPrimePay QRCode Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // pay with gbprimapay qrcode

            // create timestamp as referenceId
            final referenceNo =
                DateTime.now().millisecondsSinceEpoch.toString();
            const amount = 1.0;

            // show dialog
            Get.dialog(
              GBPrimePayQRCode(
                collectionRef: FirebaseFirestore.instance.collection("payment"),
                referenceNo: referenceNo,
                detail: "Sample T-Shirt",
                amount: amount,
                backgroundUrl: dotenv.env['BACKGROUND_URL'] ?? "",
                token: dotenv.env['GB_TOKEN'] ?? "",
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
          },
          child: const Text("Pay via QRCode"),
        ),
      ),
    );
  }
}
