//
//  NotificationClass.swift
//  RahalApp
//
//  Created by Sahora on 17/05/2024.
//

import SwiftUI
import CloudKit

class NotificationViewModel: ObservableObject {
    //MSG
    @State var msg = ""
    
        
    

    //Create Msgs
    private func saveItem (record:CKRecord){
        CKContainer.init(identifier: "iCloud.com.macrochallange.test.TripManagement").publicCloudDatabase.save(record){ [weak self] returnedRecord,returnedError in
            print ("Record: \(String(describing: returnedRecord)) Meaw")
            print ("Error: \(returnedError) Hohoo")
            
            DispatchQueue.main.async {
                self?.msg = ""
            }
            
        }
    }

    
    
    //Send Notification
    func addItem ( name: String ) {
        let newMsg = CKRecord(recordType: "MSGS")
        newMsg["name"] = ""
        newMsg["Creator"] =  ""
        saveItem(record: newMsg)
        print ("NOTIFIACATION   IS  CREATED")
      
        
        
    //        let msg = VM.Themsg
    //        var themsge = CRUD.themsge
        //var Date = Date.distantPast
    //         fitchnoti()
        
        let predicate = NSPredicate(value: true)
        let subscrpition = CKQuerySubscription(recordType:"MSGS", predicate: predicate, subscriptionID: "Msg_Added", options: .firesOnRecordCreation)
        let noti = CKSubscription.NotificationInfo()
        print ("NOTIFIACATION  IS  UPLOADED")
        noti.title = ""
        noti.alertBody = ""
        noti.soundName = "default"

        subscrpition.notificationInfo = noti
        CKContainer.default().publicCloudDatabase.save(subscrpition) {returnedsubscrpition, returnedError in
            
            if let error = returnedError {
                print(error)
            } else {
                print ("Subscribed")
            }
            
        }
    }
    
    
}
