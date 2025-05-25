/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// Cloud Firestore triggers ref: https://firebase.google.com/docs/functions/firestore-events
// Firestoreに新しいドキュメントが作成された際にトリガーされる

// v2 Firestore トリガー API を読み込む
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
// Admin SDK の Messaging モジュールを読み込む
const {getMessaging} = require("firebase-admin/messaging");
const admin = require("firebase-admin");

// 必ず初期化
admin.initializeApp();

// ドキュメント作成時に動く関数
exports.myFunctionV2 = onDocumentCreated(
    "chat/{messageId}",
    async (event) => {
    // event.data は DocumentSnapshot
      const snapshot = event.data;
      if (!snapshot) {
        console.error("No snapshot in event.data");
        return;
      }

      // snapshot.data() でドキュメントの中身を取得
      const data = snapshot.data();
      if (!data) {
        console.error("Document data is empty");
        return;
      }

      const {username, text} = data;

      try {
        await getMessaging().send({
          notification: {
            title: username || "新しいメッセージ",
            body: text || "",
          },
          data: {
            click_action: "FLUTTER_NOTIFICATION_CLICK",
          },
          topic: "chat",
        });
        console.log("Notification sent:", {username, text});
      } catch (err) {
        console.error("Error sending notification:", err);
      }
    },
);
