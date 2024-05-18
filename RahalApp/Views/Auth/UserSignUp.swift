//
//  UserSignUp.swift
//  RahalApp
//
//  Created by suha alrajhi on 09/11/1445 AH.
//


import SwiftUI
import AuthenticationServices
import CloudKit



struct UserInfo: Hashable{
    
    let idUser: String
    let firstName: String
    let lastName: String
    let Email: String
    let confirmEmail: String
    let encryptedPass: String
    let confirmPassword: String
    let comingTrips: String
    let onTrip: Bool
    let record: CKRecord
    
}


class UserSignUpModel: ObservableObject{
    
    @Published var userID: String = ""
    @Published var userFirstName: String = ""
    @Published var userLastName: String = ""
    @Published var userEmail: String = ""
    @Published var confirmUserEmail: String = ""
    @Published var userPassword: String = ""
    @Published var confirmUserPassword: String = ""
    @Published var userComingTrips: String = ""
    @Published var userOnTrip: Bool = false

    init() {
        // Initialize if needed
    }
    
    
    func encryptPassword(_ encryptedPass: String) -> String {
        // Example: Base64 encoding (not secure for actual password encryption)
        let data = encryptedPass.data(using: .utf8)!
        return data.base64EncodedString()
    }
    
    private func addUser(firstName: String, lastName: String, Email: String, encryptedPass: String, comingTrips: String, onTrip: Bool, completion: @escaping (Bool, Error?) -> Void) {
        let newUser = CKRecord(recordType: "UserRecords")
        newUser["idUser"] = UUID().uuidString
        newUser["firstName"] = firstName
        newUser["lastName"] = lastName
        newUser["Email"] = Email
        newUser["encryptedPass"] = encryptPassword(encryptedPass)
        newUser["comingTrips"] = comingTrips
        newUser["onTrip"] = onTrip ? 1 : 0

        saveUser(record: newUser, completion: completion)
    }

    
    private func saveUser(record: CKRecord, completion: @escaping (Bool, Error?) -> Void) {
        CKContainer.init(identifier: "iCloud.com.macrochallange.test.TripManagement")
            .publicCloudDatabase.save(record) { returnedRecord, returnedError in
                DispatchQueue.main.async {
                    if let error = returnedError {
                        print("Error saving user: \(error)")
                        completion(false, error)
                        return
                    }
                    print("User saved successfully: \(String(describing: returnedRecord))")
                    completion(true, nil)
                }
            }
    }

    public func fetchUser( completion: @escaping (UserInfo?) -> Void) {
        let predicate = NSPredicate(format: "idUser == %@", userID)
        let query = CKQuery(recordType: "Users", predicate: predicate)

        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Failed to fetch user: \(error)")
                    completion(nil)
                    return
                }

                guard let record = records?.first else {
                    print("No user found with the provided code.")
                    completion(nil)
                    return
                }
                
                let firstName = record["firstName"] as? String ?? ""
                let lastName = record["lastName"] as? String ?? ""
                let ID = record["idUser"] as? String ?? ""
                let Email = record["Email"] as? String ?? ""
                let confirmEmail = record["confirmEmail"] as? String ?? ""
                let encryptedPass = record["encryptedPass"] as? String ?? ""
                let confirmPassword = record["confirmPassword"] as? String ?? ""
                let comingTrips = record["comingTrips"] as? String ?? ""
                let onTrip = (record["onTrip"] as? Int) == 1 ? true : false

                

                let userModel = UserInfo(idUser: ID, firstName: firstName, lastName: lastName, Email: Email, confirmEmail: confirmEmail, encryptedPass: encryptedPass, confirmPassword: confirmPassword, comingTrips: comingTrips, onTrip: onTrip, record: record)

                completion(userModel)
            }
        }
    }
    
    
    func addButtonPressed() {
        let newTrip = addUser(firstName: userFirstName, lastName: userLastName, Email: userEmail, encryptedPass: userPassword, comingTrips: userComingTrips, onTrip: userOnTrip) { success, error in
            if success {
                print("User created successfully!")
            } else if let error = error {
                print("Failed to create user: \(error.localizedDescription)")
            }
        }
    }
        
        
        
        
        
        
   
    
    
}




struct UserSignUp: View {
    //    @State var appleButton: AppleButtonLogic
    //        init() {
    //            self._appleButton = State(initialValue: AppleButtonLogic())
    //        }
    @StateObject private var vm = UserSignUpModel()
    @State private var showingAccountView = false
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var confirmEmail = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var navigateToSelectDestinationView = false

    
    var body: some View {
            NavigationStack {
            ZStack{
                Image("img_untitled_artwork").resizable().brightness(-0.4).ignoresSafeArea()
                
                ScrollView{
                    VStack(){
                        FirstNameView
                        LastNameView
                        EmailView
                        ConfirmEmailView
                        PasswordView
                        ConfirmPasswordView
                        Spacer(minLength: 30)
                        addButton
                        Spacer(minLength: 20)
                        NavigationLink(destination: LoginView()) {
                            HStack{
                                Text("سجل الدخول").underline(color : Color("tivany"))
                                    .foregroundColor(Color("tivany"))
                                Text("لديك حساب مسجل مسبقا؟ ").foregroundColor( Color("WhiteA7001")).fontWeight(.heavy)
                            }
                        }
                        
                        HStack{
                            line
                            Text("أو").foregroundColor(.whiteA7001)
                            line
                        }.frame(width: 300)
                        
                        
                        
                        
                        
                        SignInWithAppleButton(
                            
                            .signUp,
                            onRequest: configureAppleSignInRequest,
                            onCompletion: handleAppleSignInResult
                        )
                        .signInWithAppleButtonStyle(.white) // Set the button style to white
                        .frame(width: 300, height: 40)
                        .padding()
                        .environment(\.locale, .init(identifier: "ar"))
                        
                    }/*.navigationDestination(isPresented: $navigateToSelectDestinationView) {
                        UserInformationView()
                    }*/
                }.safeAreaPadding(.top,80)
            }
            .ignoresSafeArea()
            .navigationDestination(isPresented: $navigateToSelectDestinationView) {
                UserInformationView()
            }
        }
    }
    
    var line: some View {
        VStack { Divider().background(.whiteA7001) }.padding(10)
    }
    
    
    
    //Apple Sign up
    private func configureAppleSignInRequest(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    private func handleAppleSignInResult(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            guard let _ = authResults.credential as? ASAuthorizationAppleIDCredential else {
               
                return
                
            }
            
            showingAccountView = true  // Set this to true to navigate to HomeView
            
        case .failure(let error):
            print("Authentication error: \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    extension RegisterView {
        
        private var FirstNameView: some View{
            VStack(alignment: .trailing){
                Text("الأسم الأول").foregroundColor( Color("WhiteA7001")).fontWeight(.heavy)
                TextField("", text: $vm.userFirstName)
                    .multilineTextAlignment(.trailing)
                    .padding()
                    .frame(width: 300, height: 35)
                
                    .background(Color("WhiteA7001"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(
                                Color("WhiteA7001"))
                            .frame(width: 300, height: 35))
            }
        }
        
        private var LastNameView: some View{
            VStack(alignment: .trailing){
                Text("الأسم الأخير").foregroundColor( Color("WhiteA7001")).fontWeight(.heavy)
                
                TextField("", text: $vm.userLastName)
                    .multilineTextAlignment(.trailing)
                    .padding()
                    .frame(width: 300, height: 35)
                
                    .background(Color("WhiteA7001"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(
                                Color("WhiteA7001"))
                            .frame(width: 300, height: 35))
            }
        }
        
        private var EmailView: some View{
            VStack(alignment: .trailing){
                Text("البريد الالكتروني").foregroundColor( Color("WhiteA7001")).fontWeight(.heavy)
                
                TextField("", text: $vm.userEmail)
                    .multilineTextAlignment(.trailing)
                    .padding()
                    .frame(width: 300, height: 35)
                
                    .background(Color("WhiteA7001"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(
                                Color("WhiteA7001"))
                            .frame(width: 300, height: 35))
            }
        }
        
        private var ConfirmEmailView: some View{
            VStack(alignment: .trailing){
                Text("تأكيد البريد الالكتروني").foregroundColor( Color("WhiteA7001")).fontWeight(.heavy)
                
                TextField("", text: $vm.confirmUserEmail)
                    .multilineTextAlignment(.trailing)
                    .padding()
                    .frame(width: 300, height: 35)
                
                    .background(Color("WhiteA7001"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(
                                Color("WhiteA7001"))
                            .frame(width: 300, height: 35))
            }
        }
        
        private var PasswordView: some View{
            VStack(alignment: .trailing){
                Text("كلمة المرور").foregroundColor( Color("WhiteA7001")).fontWeight(.heavy)
                
                TextField("", text: $vm.userPassword)
                    .multilineTextAlignment(.trailing)
                    .padding()
                    .frame(width: 300, height: 35)
                
                    .background(Color("WhiteA7001"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(
                                Color("WhiteA7001"))
                            .frame(width: 300, height: 35))
            }
        }
        
        private var ConfirmPasswordView: some View{
            VStack(alignment: .trailing){
                Text("تأكيد كلمة المرور").foregroundColor( Color("WhiteA7001")).fontWeight(.heavy)
                
                TextField("", text: $vm.confirmUserPassword)
                    .multilineTextAlignment(.trailing)
                    .padding()
                    .frame(width: 300, height: 35)
                
                    .background(Color("WhiteA7001"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(
                                Color("WhiteA7001"))
                            .frame(width: 300, height: 35))
            }
        }
        
//    }
    
    
    private var addButton: some View {
        Button(action: {
            // Add the user
            let result = vm.addButtonPressed()
            print(result)
            navigateToSelectDestinationView.toggle()
            // Attempt to fetch the user
            vm.fetchUser { userModel in
                if let userModel = userModel {
                    print("User found: \(userModel.firstName)")
                    // Update the navigation trigger here if the user is found
                    navigateToSelectDestinationView = true
                } else {
                    print("User not found or an error occurred.")
                }
            }
        }, label: {
            ButtonWidget(text: "انشاء الحساب")
        })

      }
    
    
}
    

#Preview {
    UserSignUp()
}
