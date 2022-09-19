//
//  FireReport.swift
//  Meetings
//
//  Created by Yu on 2022/07/28.
//

import Firebase

class FireReport {
    
    static func createReport(targetId: String, targetFamily: String, probremCategory: String, detail: String, completion: ((String?) -> Void)?) {
        // ドキュメント追加
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("reports")
            .addDocument(data: [
                "createdAt": FieldValue.serverTimestamp(),
                "userId": FireAuth.uid() as Any,
                "targetId": targetId,
                "targetFamily": targetFamily,
                "probremCategory": probremCategory,
                "detail": detail
            ]) { error in
                // 失敗
                if let error = error {
                    print("HELLO! Fail! Error adding new Report. \(error)")
                    completion?(nil)
                    return
                }
                
                // 成功
                print("HELLO! Success! Added 1 Report.")
                completion?(ref!.documentID)
            }
    }
    
}
