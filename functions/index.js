/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();

exports.addOrder = functions.https.onCall(async (data, context) => {
  const orderDetails = data.orderDetails;
  const ordersRef = db.collection("Orders");
  const counterRef = db.collection("counters").doc("orderCounter");

  return db.runTransaction(async (transaction) => {
    const counterDoc = await transaction.get(counterRef);
    let orderNumber = 1;

    if (counterDoc.exists) {
      orderNumber = counterDoc.data().orderNumber + 1;
    }

    transaction.set(counterRef, {orderNumber}, {merge: true});
    transaction.set(ordersRef.doc(orderNumber.toString()), orderDetails);

    return {orderNumber};
  }).then(() => {
    return {message: "Order ${orderNumber} added successfully."};
  }).catch((error) => {
    console.error("Error adding order: ", error);
    throw new functions.https.HttpsError("internal", "Unable to add order");
  });
});

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
