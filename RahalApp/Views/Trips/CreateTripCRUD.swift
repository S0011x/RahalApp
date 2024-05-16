//
//  CloudKitCRUD.swift
//  TripManagement
//
//  Created by suha alrajhi on 15/10/1445 AH.
//
import SwiftUI
import CloudKit

struct CreateTrip1: Hashable {
    let TripName: String
    let code: String
    let record: CKRecord
    let id: String
    let user_id: String
    let tripDetails: String
    let phoneNumber: Int
    let level: String
    let startDate: Date
    let endDate: Date
    var MembersIDs: [CKRecord.Reference]  // Array to store member IDs
}


class TripCRUDViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var tripDetailsText: String = ""
    @Published var phoneNumberText: Int = 0
    @Published var level: String = "متوسط"  // Default level
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var trips: [CreateTrip1] = []
    @Published var selectedTrip: CreateTrip1?
    @Published var userID: String = ""
    
    @Published var newTripCode = ""

    init() {
        // Initialize if needed
    }
  //  Int(phoneNumberText)
    func addButtonPressed() -> String {
//       guard text.isEmpty, tripDetailsText.isEmpty,  phoneNumberText == 10  else {
////           if !text.isEmpty {}
//          // , endDate >= startDate
//            return "Please fill all fields and ensure end date is after start date"
//        }
        
        let uniqueCode = generateUniqueCode()
        let newTrip = addItem(TripName: text, code: uniqueCode, tripDetails: tripDetailsText, phoneNumber: phoneNumberText, level: level, startDate: startDate, endDate: endDate)
        
        newTripCode = uniqueCode
        
        return "Trip created!!"
    }

    private func generateUniqueCode() -> String {
        String(format: "%06d", Int.random(in: 100000...999999))
    }

    private func addItem(TripName: String, code: String, tripDetails: String, phoneNumber: Int, level: String, startDate: Date, endDate: Date) -> CKRecord {
        let newTrip = CKRecord(recordType: "Trips")
        newTrip["TripName"] = TripName
        newTrip["code"] = code
        newTrip["id"] = UUID().uuidString
        newTrip["tripDetails"] = tripDetails
        newTrip["phoneNumber"] = phoneNumber
        newTrip["level"] = level
        newTrip["startDate"] = startDate
        newTrip["endDate"] = endDate
        newTrip["MembersIDs"] = [] as [String]  // Initialize as empty array

        saveItem(record: newTrip)
        
        return newTrip
    }

    private func saveItem(record: CKRecord) {
        CKContainer.init(identifier: "iCloud.com.macrochallange.test.TripManagement")
            .publicCloudDatabase.save(record) { [weak self] returnedRecord, returnedError in
            print("Records:\(String(describing: returnedRecord))")
            print("Errors:\(String(describing: returnedError))")
        }
    }

    public func fetchTrip(withCode code: String, completion: @escaping (CreateTrip1?) -> Void) {
        let predicate = NSPredicate(format: "code == %@", code)
        let query = CKQuery(recordType: "Trips", predicate: predicate)

        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
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

struct CreateTripCRUD: View {
    @StateObject private var vm = TripCRUDViewModel()
    @State private var navigateToTrip = false
    let levels = ["سهل", "متوسط", "صعب"]

    var body: some View {
        ScrollView{
            VStack(alignment:.trailing ){
                TripNameView
                Spacer(minLength: 15)
                tripDetailsView
                Spacer(minLength: 15)
                tripLevelView
                Spacer(minLength: 15)
                startTrip
                Spacer(minLength: 15)
                endTrip
                Spacer(minLength: 15)
                phoneNumberView
                Spacer(minLength: 15)
                addButton
                
            }
        }
        .frame(width: 1000)
        .background(Color("background"))
        .navigationTitle("معلومات الرحلة")
        
    }
    private var TripNameView: some View {
        VStack(alignment: .trailing){
            Text("اسم الرحلة")
            TextField("", text: $vm.text)
            
                .frame(width: 300, height: 35)
                .background(Color("WhiteA700"))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(
                             Color("WhiteA700"))
                        .frame(width: 300, height: 35))
        }
            
    }
    
    
    
    

    private var tripDetailsView: some View {
        VStack(alignment: .trailing){
            Text("شرح تفاصيل الرحلة")
            ZStack {
                TextEditor(text: $vm.tripDetailsText)
                    .textEditorStyle(.plain)
                    .padding()
            }.overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("WhiteA700"))
            ).frame(width: 300, height: 150)
                .background(Color("WhiteA700"))
        }
            
    }
    
    
    
    
    

    private var phoneNumberView: some View {
        VStack(alignment: .trailing){
            Text("رقم الهاتف للتواصل")
            TextField("", value: $vm.phoneNumberText, format: .number)
                .keyboardType(.numberPad)
                .frame(width: 300, height: 35)
            
                .background(Color("WhiteA700"))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(
                            Color("WhiteA700"))
                        .frame(width: 300, height: 35)
            )
        }
            
    }
    
    

    private var tripLevelView: some View {
        VStack(alignment: .trailing){
            Text("مستوى صعوبة الرحلة")
            Picker("", selection: $vm.level) {
                ForEach(levels, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 300, height: 35)
            .padding()
        }}

    private var startTrip: some View {
        VStack(alignment: .trailing){
            Text("بداية الرحلة")
            HStack{
                DatePicker("", selection: $vm.startDate, displayedComponents: [.date, .hourAndMinute])
                    .labelsHidden().frame(
                        width: 300,
                        alignment:.center)
                    .datePickerStyle(CompactDatePickerStyle())
                    .padding()
            }
        }
    }
    
            
    private var endTrip: some View {
        VStack(alignment: .trailing){
            Text("نهاية الرحلة")
            HStack{
                DatePicker("", selection: $vm.endDate, displayedComponents: [.date, .hourAndMinute])
                    .labelsHidden().frame(
                        width: 300,
                        alignment:.center)
                    .datePickerStyle(CompactDatePickerStyle())
                    .padding()
            }
        }
    }
        
   

    private var addButton: some View {
        Button(action: {
            let result = vm.addButtonPressed()
            print(result)
            
            DispatchQueue.main.async {
                if vm.newTripCode != "" {
                    vm.fetchTrip(withCode: vm.newTripCode) { tripModel in
                        if let tripModel = tripModel {
                            vm.trips.append(tripModel)
                        } else {
                            print("Not Found")
                        }
                    }
                }
            }
        }, label: {
            NavigationLink(destination: SelectDestinationView()) {
                ButtonWidget(text: "التالي")
            }
        })
    }
}

// Preview Provider
struct CreateTripCRUD_Previews: PreviewProvider {
    static var previews: some View {
        CreateTripCRUD()
    }
}


