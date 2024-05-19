//
//  UserInfo.swift
//  RahalApp
//
//  Created by suha alrajhi on 11/11/1445 AH.
//
import SwiftUI
import CloudKit

struct UserInformationView: View {
    @StateObject var vm = UserInformationModel1()
    @State private var navigateToTrip = false
    @State private var navigateToSelectDestinationView = false
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea() // Adjust the background color as needed
            VStack {
                HeaderView
                FirstNameView
                LastNameView
                EmailView
                
                Button(action: {
                    if let emailURL = URL(string: "mailto:\(vm.emailAddress)") {
                        UIApplication.shared.open(emailURL)
                    }
                }) {
                    Text("تواصل معنا")
                        .foregroundColor(.blue)
                        .frame(width: 300, alignment: .trailing)
                        .padding(.top)
                }
                
                Button(action: {
                    // Add the delete account action here
                    vm.deleteAccount()
                }) {
                    Text("حذف الحساب")
                        .foregroundColor(.red)
                        .frame(width: 300, alignment: .trailing)
                        .padding(.top)
                }
                
                Spacer()
            }.padding(.top, 30)
        }
        .navigationTitle("معلومات الحساب")
        .onAppear {
            vm.fetchUserInfo()
        }
    }
    
    var HeaderView: some View {
        HStack {
            Text("\(vm.firstName) \(vm.lastName)")
                .fontWeight(.bold)
                .font(FontScheme.kSFArabicBold(size: 24.0))
            
            Image(systemName: "person.crop.circle")
                .resizable()
                .foregroundColor(ColorConstants.IconColor)
                .frame(width: 55.0, height: 55.0)
        }
        .frame(width: 340, height: 100, alignment: .trailing)
        .padding(.trailing, 35)
    }
    
    var FirstNameView: some View {
        VStack(alignment: .trailing) {
            Text("الأسم الأول").foregroundColor(Color(.black900))
            TextField("", text: $vm.firstName)
                .disabled(true)
                .multilineTextAlignment(.trailing)
                .padding()
                .frame(width: 300, height: 35)
                .background(Color("WhiteA700"))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color("WhiteA700"))
                        .frame(width: 300, height: 35)
                )
        }
    }
    
    var LastNameView: some View {
        VStack(alignment: .trailing) {
            Text("الأسم الأخير").foregroundColor(Color(.black900))
            TextField("", text: $vm.lastName)
                .disabled(true)
                .multilineTextAlignment(.trailing)
                .padding()
                .frame(width: 300, height: 35)
                .background(Color("WhiteA700"))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color("WhiteA700"))
                        .frame(width: 300, height: 35)
                )
        }
    }
    
    var EmailView: some View {
        VStack(alignment: .trailing) {
            Text("البريد الالكتروني").foregroundColor(Color(.black900))
            TextField("", text: $vm.email)
                .disabled(true)
                .multilineTextAlignment(.trailing)
                .padding()
                .frame(width: 300, height: 35, alignment: .trailing)
                .background(Color("WhiteA700"))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color("WhiteA700"))
                        .frame(width: 300, height: 35)
                )
        }
    }
}

class UserInformationModel1: ObservableObject {
    @Published var userInfo: UserInfo?
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    
    let emailAddress = "saharbintyousef@gmail.com"

    func fetchUserInfo() {
        let container = CKContainer(identifier: "iCloud.com.macrochallange.test.TripManagement")
        let publicCloudDatabase = container.publicCloudDatabase
        
        let predicate = NSPredicate(value: true) // Adjust this predicate as needed
        let query = CKQuery(recordType: "UserRecords", predicate: predicate)
        
        publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching user info: \(error.localizedDescription)")
                return
            }
            
            guard let records = records, let record = records.first else {
                print("No user info record found")
                return
            }
            
            DispatchQueue.main.async {
                self.userInfo = UserInfo(
                    idUser: record["idUser"] as? String ?? "",
                    firstName: record["firstName"] as? String ?? "",
                    lastName: record["lastName"] as? String ?? "",
                    Email: record["email"] as? String ?? "",
                    confirmEmail: record["confirmEmail"] as? String ?? "",
                    encryptedPass: record["encryptedPass"] as? String ?? "",
                    confirmPassword: record["confirmPassword"] as? String ?? "",
                    comingTrips: record["comingTrips"] as? String ?? "",
                    onTrip: record["onTrip"] as? Bool ?? false,
                    record: record
                )
                
                self.firstName = record["firstName"] as? String ?? ""
                self.lastName = record["lastName"] as? String ?? ""
                self.email = record["email"] as? String ?? ""
                
                print("Fetched user info:")
                print("First Name: \(self.firstName)")
                print("Last Name: \(self.lastName)")
                print("Email: \(self.email)")
            }
        }
    }
    
    func deleteAccount() {
        guard let userInfo = userInfo else { return }
        
        deleteAccountFromCloudKit(user: userInfo.idUser) { error in
            if let error = error {
                print("Error deleting account: \(error.localizedDescription)")
            } else {
                print("Account deleted successfully")
            }
        }
    }
    
    func deleteAccountFromCloudKit(user: String, completion: @escaping (Error?) -> Void) {
        let container = CKContainer(identifier: "iCloud.com.macrochallange.test.TripManagement")
        let publicCloudDatabase = container.publicCloudDatabase
        
        let recordID = CKRecord.ID(recordName: user)
        publicCloudDatabase.delete(withRecordID: recordID) { (recordID, error) in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
                print("Account deleted")
            }
        }
    }
}

#Preview {
    UserInformationView()
}
