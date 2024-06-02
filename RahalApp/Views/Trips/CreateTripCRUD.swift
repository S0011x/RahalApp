//
//  CloudKitCRUD.swift
//  TripManagement
//
//  Created by suha alrajhi on 15/10/1445 AH.
//
import SwiftUI
import CloudKit
import iPhoneNumberField

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
    @Published var phoneNumberText: String = ""
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
    
    //       guard text.isEmpty, tripDetailsText.isEmpty,  phoneNumberText == 10  else {
    ////           if !text.isEmpty {}
    //          // , endDate >= startDate
    //            return "Please fill all fields and ensure end date is after start date"
    //        }
  //  Int(phoneNumberText)
    func addButtonPressed() -> String {
        print("Hi function")
        let uniqueCode = generateUniqueCode()
        let newTrip = addItem(TripName: text, code: uniqueCode, tripDetails: tripDetailsText, phoneNumber: Int(phoneNumberText) ?? 0, level: level, startDate: startDate, endDate: endDate)
        print(newTrip["TripName"],"🚗")
        
        newTripCode = uniqueCode
        
        return "Trip created!!"
    }
    
    
    func validateFields() -> [String: String] {
        var errors = [String: String]()

        if text.isEmpty {
            errors["tripName"] = "الرجاء ادخال اسم الرحلة!"
        }
        if tripDetailsText.isEmpty {
            errors["tripDetails"] = "الرجاء ادخال تفاصيل الرحلة!"
        }
        if String(phoneNumberText).count == 9 || String(phoneNumberText).first == "0" {
            errors["phoneNumber"] = "الرجاء ادخال رقم هاتف صحيح (يجب أن يكون 10 أرقام ولا يبدأ بصفر)!"
        }
        if startDate > endDate {
            errors["date"] = "تاريخ نهاية الرحلة يجب ان يكون بعد تاريخ بداية الرحلة"
        }

        return errors
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
            print("Records:\(String(describing: returnedRecord)) ⛺️")
            print("Errors:\(String(describing: returnedError)) ⛺️")
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
    @State private var navigateToSelectDestinationView = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""

    let levels = ["سهل", "متوسط", "صعب"]

    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment:.trailing ){
                    TripNameView
                    Spacer(minLength: 20)
                    tripDetailsView
                    Spacer(minLength: 20)
                    phoneNumberView
                    Spacer(minLength: 20)
                    tripLevelView
                    Spacer(minLength: 20)
                    startTrip
                    Spacer(minLength: 20)
                    endTrip
                    Spacer(minLength: 20)
                    addButton
                    
                }.padding(.horizontal,20)
                .navigationDestination(isPresented: $navigateToSelectDestinationView) {
                    SelectDestinationView()
                }
            }
            .frame(width: 1000)
            .background(Color("background"))
        }.alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Validation Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }  
        .navigationTitle("معلومات الرحلة")

    }
    
    
    
    private var TripNameView: some View {
        VStack(alignment: .trailing){
            Text("اسم الرحلة")
            TextField("", text: $vm.text).multilineTextAlignment(.trailing)
                .frame(width: 300, height: 35)
                .background(Color("WhiteA700"))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 50)
//                        .stroke(
//                             Color("WhiteA700"))
//                        .frame(width: 300, height: 35))
        }.padding(.horizontal)
            
    }
    
    
    
    

    private var tripDetailsView: some View {
        VStack(alignment: .trailing){
            Text("شرح تفاصيل الرحلة")
            ZStack {
                TextEditor(text: $vm.tripDetailsText).multilineTextAlignment(.trailing)
                    .textEditorStyle(.plain)
                    .padding()
            }.overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("WhiteA700"))
            ).frame(width: 300, height: 150)
                .background(Color("WhiteA700"))
        }.padding(.horizontal)
            
    }
    
    
    
    
    

    private var phoneNumberView: some View {
        VStack(alignment: .trailing){
            Text("رقم الهاتف للتواصل")
            iPhoneNumberField("50-000-0000",text: $vm.phoneNumberText)
                       .flagHidden(false)
                       .flagSelectable(true)
                       .maximumDigits(9)
                .frame(width: 300, height: 35)
                .background(Color("WhiteA700"))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(
                            Color("WhiteA700"))
            )
        }.padding(.horizontal)
            
    }
    
    

    private var tripLevelView: some View {
        VStack(alignment: .trailing){
            Text("مستوى صعوبة الرحلة")
                .frame(width: 300, height: 35 , alignment: .trailing)
                .padding(.trailing)
            Picker("", selection: $vm.level) {
                ForEach(levels, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 300, height: 35)
            .padding(.horizontal)
            
            
        }
    }

    private var startTrip: some View {
        VStack(alignment: .trailing){
            Text("بداية الرحلة")
                .frame(width: 300, height: 35 , alignment: .trailing)
                .padding(.trailing)
            HStack{
                DatePicker("", selection: $vm.startDate, displayedComponents: [.date, .hourAndMinute])
                    .labelsHidden()
                    .frame(width: 300, height: 35)
                    .datePickerStyle(CompactDatePickerStyle())
                    .padding(.horizontal)
            }
        }
    }
    
            
    private var endTrip: some View {
        VStack(alignment: .trailing){
            Text("نهاية الرحلة")
                .frame(width: 300, height: 35 , alignment: .trailing)
                .padding(.trailing)
            HStack{
                DatePicker("", selection: $vm.endDate, displayedComponents: [.date, .hourAndMinute])
                    .labelsHidden()
                    .frame( width: 300, height: 35)
                    .datePickerStyle(CompactDatePickerStyle())
                    .padding(.horizontal)
            }
        }
    }
        
   

    private var addButton: some View {
        Button(action: {
            let errors = vm.validateFields()
            if errors.isEmpty {
                let result = vm.addButtonPressed()
                print(result)
                navigateToSelectDestinationView.toggle()
            } else {
                // Construct a message from all errors
                errorMessage = errors.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
                showErrorAlert = true
            }
        }, label: {
            ButtonWidget(text: "التالي")
        }).padding(.trailing)
    }

}

// Preview Provider
struct CreateTripCRUD_Previews: PreviewProvider {
    static var previews: some View {
        CreateTripCRUD()
    }
}


