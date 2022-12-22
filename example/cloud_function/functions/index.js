const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

/* sample return value

{
	"amount": 1,
	"retryFlag": null,
	"referenceNo": "221104171949866",
	"gbpReferenceNo": "gbp12124182005142",
	"currencyCode": "764",
	"resultCode": "00",
	"resultMessage": null,
	"token": null,
	"totalAmount": 1,
	"fee": 0.01,
	"vat": 0.0007,
	"thbAmount": 1,
	"customerName": "นาย อนุชิต ชโลธร",
	"date": "05112022",
	"time": "005308",
	"paymentType": "Q",
	"mobileNo": null,
	"bankCode": null,
	"registerAccount": null,
	"tokenAccount": null,
	"registerDate": null,
	"registerTime": null,
	"severity": "INFO",
	"message": "message"
}

*/

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
