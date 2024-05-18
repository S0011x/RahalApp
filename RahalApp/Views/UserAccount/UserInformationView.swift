//
//  UserInformationView.swift
//  RahalApp
//
//  Created by Juman Dhaher on 27/10/1445 AH.
//

import SwiftUI
import CloudKit

struct UserInformationView: View {
    
    @State var loginViewModel = LoginViewModel()
    
//    @State  var firstName = ""
//    @State  var lastName = ""
//    @State  var email = ""
   
    
    var body: some View {
        
        
        @State  var email = loginViewModel.email
        @State  var firstName = loginViewModel.firstName
        @State  var lastName = loginViewModel.lastName
        let emailAddress = "saharbintyousef@gmail.com"
        

        
        ZStack{
            Color(.background).ignoresSafeArea()
            VStack{
                HeaderView
                FirstNameView(firstName: firstName)
                LastNameView(lastName: lastName)
                EmailView(email: email)
                
                Button(action: {
                    if let emailURL = URL(string: "mailto:\(emailAddress)") {
                        UIApplication.shared.open(emailURL)
                    }
                }) {
                    Text("تواصل معنا")
                        .foregroundColor(.blue).frame(width: 300, alignment: .trailing).padding(.top)
                }
                
                

                
                
//                Button(action: deleteAccountFromCloudKit(TripName: String, completion: <#T##((any Error)?) -> Void#>) ) {
//                    Text("تواصل معنا")
//                        .foregroundColor(.blue).frame(width: 300, alignment: .trailing).padding(.top)
//                }
                
                

                

               
                Spacer()
//                ButtonWidget(text: "حفظ")
                
            }.padding(.top,30)
        }.navigationTitle("معلومات الحساب")
    }
}

#Preview {
    UserInformationView()
}



//Delete
//func deleteAccountFromCloudKit(TripName: String, completion: @escaping (Error?) -> Void) {
//    let container =  CKContainer.init(identifier: "iCloud.com.macrochallange.test.TripManagement")
//    let publicCloudDatabase = container.publicCloudDatabase
//    
//    let recordID = CKRecord.ID(recordName: TripName)
//    publicCloudDatabase.delete(withRecordID: recordID) { (recordID, error) in
//        if let error = error {
//            completion(error)
//            
//        } else {
//            completion(nil)
//            print ("MAMMAMMAMMAMAMAM")
//        }
//    }
//}


func deleteDataFromRecord(recordID: CKRecord.ID, fieldName: String, completion: @escaping (Error?) -> Void) {
    let container =  CKContainer.init(identifier: "iCloud.com.macrochallange.test.TripManagement")
    let publicCloudDatabase = container.publicCloudDatabase
    
    publicCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
        guard let record = record else {
            completion(error)
            return
        }
        
        record.setObject(nil, forKey: fieldName)
        
        let modifyOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        modifyOperation.savePolicy = .changedKeys
        
        modifyOperation.modifyRecordsCompletionBlock = { (savedRecords, _, error) in
            completion(error)
        }
        
        publicCloudDatabase.add(modifyOperation)
    }
}






extension UserInformationView {
    private var HeaderView: some View{
        HStack{
            Text("جمان يوسف").fontWeight(.bold)
                .font(FontScheme.kSFArabicBold(size: 24.0))
                
                
            Image(systemName: "person.crop.circle")
                .resizable()
                .foregroundColor(ColorConstants.IconColor)
                .frame(width: 55.0, height: 55.0)
            
            
        }.frame(width: 340,height:100, alignment: .trailing)
            .padding(.trailing , 35)
    }
    
    func FirstNameView (firstName: String) -> some View {
        
        @State var firstName = firstName
        
        return VStack(alignment: .trailing){
            Text("الأسم الأول").foregroundColor( Color(.black900))
            TextField("", text: $firstName)
                .disabled(true)
                .multilineTextAlignment(.trailing)
                    .padding()
                .frame(width: 300, height: 35)
            
            .background(Color("WhiteA700"))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(
                            Color("WhiteA700"))
                        .frame(width: 300, height: 35))
        }
    }
    
    func LastNameView (lastName:String) -> some View {
       
        @State var lastName = lastName

        return VStack(alignment: .trailing){
            Text("الأسم الأخير").foregroundColor( Color(.black900))
            
            TextField("", text: $lastName)
                .disabled(true)
                .multilineTextAlignment(.trailing)
                    .padding()
            
                .frame(width: 300, height: 35)
            
                .background(Color("WhiteA700"))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(
                            Color("WhiteA700"))
                        .frame(width: 300, height: 35))
        }
    }
    
    
    func EmailView (email: String) -> some View{

       @State var email = email
    
        return VStack(alignment: .trailing){
            Text("البريد الالكتروني").foregroundColor( Color(.black900))
            
            TextField("", text: $email)
                .disabled(true)
                .multilineTextAlignment(.trailing)
                .padding()
                .frame(width: 300, height: 35,alignment: .trailing)
            
                .background(Color("WhiteA700"))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(
                            Color("WhiteA700"))
                        .frame(width: 300, height: 35))
        }
    }
    
}








/*import SwiftUI
import CloudKit

struct TheTripView: View {
    var trip: TripsModel?

    var body: some View {
        VStack {
            if let trip = trip {
                Text("Trip Name: \(trip.name)")
                    .font(.largeTitle)
                Text("Trip Code: \(trip.code)")
                    .font(.title)
            } else {
                Text("No trip selected")
                    .font(.largeTitle)
            }
        }
    }
}

#Preview {
    TheTrip()
        
}*/
