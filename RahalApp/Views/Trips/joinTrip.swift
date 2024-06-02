//
//  joinTrip.swift
//  Masier
//
//  Created by suha alrajhi on 15/11/1445 AH.
//



import SwiftUI
import CloudKit


struct JoinTripView: View {
    @State private var trip: CreateTrip1? = nil
    @State private var code = ""
    @State private var statusMessage = ""
    @State private var showAlert = false
    @State private var navigateToTripView = false
    @State private var navigateToSelectDestinationView = false
    @State private var showMembersMapView: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter Join Code", text: $code)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Join Trip") {
                    guard !code.isEmpty else {
                        statusMessage = "Please enter a join code."
                        showAlert = true
                        return
                    }
                    let currentUserRecordID = CKRecord.ID(recordName: "currentUserRecord")
                    joinTrip(withCode: code, currentUserRecordID: currentUserRecordID)
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Join Trip"), message: Text(statusMessage), dismissButton:
                            .default(Text("OK")))
                }

                .navigationDestination(isPresented: $navigateToSelectDestinationView) {
                    MembersMapView(pickupLocation:  CLLocationCoordinate2D(latitude: 42.6619, longitude: 21.1501), dropOffLocation: CLLocationCoordinate2D(latitude: 42.6619, longitude: 21.1701), meetSpots: [ CLLocationCoordinate2D(latitude: 42.6619, longitude: 21.1701)])

                }            }
            .padding()
        }
    }

    func joinTrip(withCode code: String, currentUserRecordID: CKRecord.ID) {
        let predicate = NSPredicate(format: "code == %@", code)
        let query = CKQuery(recordType: "Trips", predicate: predicate)

        CKContainer(identifier: "iCloud.com.macrochallange.test.TripManagement").publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.statusMessage = "Error: \(error.localizedDescription)"
                    self.showAlert = true
                //         tripRecord["MembersIDs"]append self.user.userID

                }
                return
            }

            guard let tripRecord = records?.first else {
                DispatchQueue.main.async {
                    self.statusMessage = "No trip found with the provided code."
                    self.showAlert = true
                }
                return
            }

            updateTripMembers(tripRecord: tripRecord, currentUserRecordID: currentUserRecordID)
        }
    }




    func updateTripMembers(tripRecord: CKRecord, currentUserRecordID: CKRecord.ID, retryCount: Int = 0) {
        var membersIDs = tripRecord["MembersIDs"] as? [CKRecord.Reference] ?? []
        
        let userReference = CKRecord.Reference(recordID: currentUserRecordID, action: .none)
        membersIDs.append(userReference)  // Add the current user's reference
        
        tripRecord["MembersIDs"] = membersIDs
        
        CKContainer(identifier: "iCloud.com.macrochallange.test.TripManagement").publicCloudDatabase.save(tripRecord) { record, error in
            DispatchQueue.main.async {
                if let error = error {
                    if retryCount < 3 && (error as? CKError)?.code == .serverRecordChanged {
                        // Retry the operation if it's a conflict error
                        CKContainer(identifier: "iCloud.com.macrochallange.test.TripManagement").publicCloudDatabase.fetch(withRecordID: tripRecord.recordID) { newRecord, fetchError in
                            if let newRecord = newRecord, fetchError == nil {
                                self.updateTripMembers(tripRecord: newRecord, currentUserRecordID: currentUserRecordID, retryCount: retryCount + 1)
                            } else {
                                self.statusMessage = "Error fetching updated trip record: \(fetchError?.localizedDescription ?? "Unknown error")"
                                self.showAlert = true
                            }
                        }
                    } else {
                        self.statusMessage = "Error updating trip members: \(error.localizedDescription)"
                        self.showAlert = true
                    }
                } else {
                    // Fetch updated trip details to navigate
                    self.fetchTrip(withCode: self.code) { tripModel in
                        if let tripModel = tripModel {
                            self.trip = tripModel
                            self.navigateToTripView = true // Trigger navigation
                        } else {
                            self.statusMessage = "Updated trip not found."
                            self.showAlert = true
                        }
                    }
                }
            }
        }
    }


    public func fetchTrip(withCode code: String, completion: @escaping (CreateTrip1?) -> Void) {
        let predicate = NSPredicate(format: "code == %@", code)
        let query = CKQuery(recordType: "Trips", predicate: predicate)

        CKContainer(identifier: "iCloud.com.macrochallange.test.TripManagement").publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Failed to fetch trip: \(error)")
                    completion(nil)
                    return
                }

                guard let record = records?.first else {
                    print("No trip found with the provided code.")
                    completion(nil)
                    return
                }

                let tripName = record["TripName"] as? String ?? ""
                let tripCode = record["code"] as? String ?? ""
                let ID = record["id"] as? String ?? ""
                let userID = record["user_id"] as? String ?? ""
                let tripDetails = record["tripDetails"] as? String ?? ""
                let phoneNumber = record["phoneNumber"] as? Int ?? 0
                let level = record["level"] as? String ?? "Easy"
                let startDate = record["startDate"] as? Date ?? Date()
                let endDate = record["endDate"] as? Date ?? Date()
                let membersIDs = record["MembersIDs"] as? [CKRecord.Reference] ?? []

                let tripModel = CreateTrip1(TripName: tripName, code: tripCode, record: record, id: ID, user_id: userID, tripDetails: tripDetails, phoneNumber: phoneNumber, level: level, startDate: startDate, endDate: endDate, MembersIDs: membersIDs)
                completion(tripModel)
            }
        }
    }




}
