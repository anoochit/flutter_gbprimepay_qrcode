library flutter_gbprimepay_qrcode;

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class GBPrimePayQRCode extends StatelessWidget {
  const GBPrimePayQRCode({
    super.key,
    required this.referenceNo,
    required this.backgroundUrl,
    required this.amount,
    required this.token,
    required this.detail,
    required this.completeMessage1,
    required this.completeMessage2,
    required this.completeButtonTitle,
    required this.completeButtonOnTap,
    required this.failMessage1,
    required this.failMessage2,
    required this.failButtonTitle,
    required this.failButtonOnTap,
    required this.collectionRef,
  });

  final String referenceNo;
  final double amount;
  final String token;
  final String backgroundUrl;
  final String detail;

  final String completeMessage1;
  final String completeMessage2;
  final String completeButtonTitle;
  final VoidCallback completeButtonOnTap;

  final String failMessage1;
  final String failMessage2;
  final String failButtonTitle;
  final VoidCallback failButtonOnTap;

  final CollectionReference<Map<String, dynamic>> collectionRef;

  final apiEndpoint = "https://api.gbprimepay.com/v3/qrcode";

  // request QRCode payment
  Future<Uint8List?> getGBPrimePayQRCode() async {
    var map = <String, dynamic>{};
    map['token'] = token;
    map['backgroundUrl'] = backgroundUrl;
    map['referenceNo'] = referenceNo;
    map['amount'] = '$amount';
    map['detail'] = detail;

    try {
      http.Response response = await http.post(Uri.parse(apiEndpoint), body: map);
      log('status code = ${response.statusCode}');
      log('referenceNo = ${referenceNo}');
      if (response.statusCode == 200) {
        //log('bodyBytes = ${response.bodyBytes}');
        return response.bodyBytes;
      } else {
        return null;
      }
    } catch (e) {
      log('$e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        // get QRCode
        child: FutureBuilder(
          future: getGBPrimePayQRCode(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // has error
            if (snapshot.hasError) {
              return const Center(
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text("Cannot load QRCode"),
                  ),
                ),
              );
            }

            // loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

            // return null
            if (snapshot.data == null) {
              return const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text("Cannot load QRCode"),
                  ),
                ),
              );
            }

            // use stream to check recieve payment
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder(
                stream: collectionRef.doc(referenceNo).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> paymentSnapshot) {
                  if (paymentSnapshot.hasError) {
                    return Center(
                      child: Card(
                        child: Text('${snapshot.error}'),
                      ),
                    );
                  }

                  if (paymentSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }

                  final payment = paymentSnapshot.data;
                  if (payment!.exists != false) {
                    // has payment data show message
                    log("has payment data");
                    final doc = paymentSnapshot.data;
                    log('response doc = ${doc}');
                    log('result code = ${doc?["resultCode"]}');
                    if ('${doc?["resultCode"]}' == "00") {
                      // show complete message
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 32.0,
                            right: 32,
                            top: 32.0,
                            bottom: 16.0,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('$completeMessage1'),
                              Text('$completeMessage2'),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: OutlinedButton(
                                  onPressed: () => completeButtonOnTap(),
                                  child: Text('$completeButtonTitle'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      // show fail message
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 32.0,
                            right: 32,
                            top: 32.0,
                            bottom: 16.0,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('$failMessage1'),
                              Text('$failMessage2'),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: OutlinedButton(
                                  onPressed: () => failButtonOnTap(),
                                  child: Text('$failButtonTitle'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  } else {
                    // no payment data show QR Code
                    log("no payment data show QRCode");
                    return Image.memory(snapshot.data);
                  }
                },
              ),
              //child:
            );
          },
        ),
      ),
    );
  }
}
