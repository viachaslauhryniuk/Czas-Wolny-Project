const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.deleteExpiredItems = functions.pubsub.schedule('every 15 minutes').onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    const snapshot = await admin.firestore().collection('userscodes').get();

    if (!snapshot.empty) {
        const expiredSnapshot = snapshot.docs.filter(doc => doc.data().expiry.toMillis() <= now.toMillis());

        if (!expiredSnapshot.length) return null;

        // Delete documents in a batch
        var batch = admin.firestore().batch();
        expiredSnapshot.forEach((doc) => {
            batch.delete(doc.ref);
        });

        await batch.commit();
    }
});

exports.deleteOldRecord = functions.firestore.document('userscodes/{docId}').onCreate(async (snap, context) => {
    const newValue = snap.data();
    const email = newValue.email;

    const snapshot = await admin.firestore().collection('userscodes').where('email', '==', email).get();
    if (!snapshot.empty) {
        const oldRecords = snapshot.docs.filter(doc => doc.id !== snap.id);

        // Delete old records in a batch
        var batch = admin.firestore().batch();
        oldRecords.forEach((doc) => {
            batch.delete(doc.ref);
        });

        await batch.commit();
    }
});
