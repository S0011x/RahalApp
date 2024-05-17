//
//  LoginView.swift
//  RahalApp
//
//  Created by Juman Dhaher on 20/10/1445 AH.
//
import AuthenticationServices
import SwiftUI


struct LoginView: View {
    @ObservedObject var loginViewModel = LoginViewModel()
    //    @State var appleButton: AppleButtonLogic
    //        init() {
    //            self._appleButton = State(initialValue: AppleButtonLogic())
    //        }

    
    var body: some View {
        
          @State  var showingAccountView = loginViewModel.showingAccountView
          @State  var isSigninigIn = loginViewModel.isSigninigIn
          
          @State  var email = loginViewModel.email
          @State  var password = loginViewModel.password
          @State  var firstName = loginViewModel.firstName
          @State  var lastName = loginViewModel.lastName

//        Text("\(isSigninigIn)")
//        Text("\(showingAccountView)")

            NavigationStack {

            ZStack{
                Image("img_untitled_artwork").resizable().brightness(-0.4).ignoresSafeArea()
                
                ScrollView{
                    VStack(alignment:.center){
                        EmailView(email: email)
                        PasswordView(password: password)
                        NavigationLink(destination: ForgetPassword()) {
                            HStack{
                                Text("نسيت كلمة المرور؟").foregroundColor( Color("WhiteA7001")).fontWeight(.bold)}
                            .frame(width:300 ,alignment: .trailing)
                        }
                        
                        Spacer(minLength: 30)
                        ButtonWidget(text: "تسجيل الدخول")
                        Spacer(minLength: 20)
                        NavigationLink(destination: RegisterView(), label: {
                            HStack{
                                Text("سجل معنا").underline(color : Color("tivany"))
                                    .foregroundColor(Color("tivany"))
                                Text("ليس لديك حساب؟").foregroundColor( Color("WhiteA7001")).fontWeight(.heavy)
                            }
                        })
                        HStack{
                            line
                            Text("أو").foregroundColor(.whiteA7001)
                            line
                        }.frame(width: 300)
                        
                        SignInWithAppleButton(
                            
                            .signIn,
                            onRequest: loginViewModel.configureAppleSignInRequest,
                            onCompletion: loginViewModel.handleAppleSignInResult
                        )
                        .signInWithAppleButtonStyle(.white) // Set the button style to white
                        .frame(width: 300, height: 40)
                        .padding()
                        .environment(\.locale, .init(identifier: "ar"))
                        
                    }
                }.safeAreaPadding(.top,180)
            }
            .ignoresSafeArea()
            .navigationDestination(isPresented: $showingAccountView) {
                UserInformationView()
            }
        }
    }
    
    var line: some View {
        VStack { Divider().background(.whiteA7001) }.padding(10)
    }
    
    

    
    
    
    
    
    
//    extension LoginView {
        
//    func widgetBox(text: String) -> some View{
        
         func EmailView (email: String) -> some View{

            @State var email = email
            

            return VStack(alignment: .trailing){
                Text("البريد الالكتروني").foregroundColor( Color("WhiteA7001")).fontWeight(.heavy)
                
                TextField("", text: $email)
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
        
   
        
    func PasswordView (password: String) -> some View{
         
      
        @State var password = password
            
         return   VStack(alignment: .trailing){
                Text("كلمة المرور").foregroundColor( Color("WhiteA7001")).fontWeight(.heavy)
                
                
                TextField("", text: $password)
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
}

final class LoginViewModel: NSObject, ObservableObject {
    
    @Published var showingAccountView = false
    @Published var isSigninigIn = false
    
    @Published var email = ""
    @Published var password = ""
    @Published var firstName = ""
    @Published var lastName = ""
    
    //Apple Sign up
     func configureAppleSignInRequest(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
 
    }
    
     func handleAppleSignInResult(result: Result<ASAuthorization, Error>)  {
        switch result {
        case .success(let authResults):
            if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential  {
                
                 firstName = appleIDCredential.fullName?.givenName ?? ""
                 lastName = appleIDCredential.fullName?.familyName ?? ""
                 email = appleIDCredential.email ?? ""
                
                showingAccountView = true  // Set this to true to navigate to account
                isSigninigIn = true
               
                print("First❤️ Name: \(firstName)")
                print("Last Name: \(lastName)")
                print("Email: \(email)")
                print("isSigninigIn: \(isSigninigIn)")
                print("showingAccountView: \(showingAccountView)")
             
            }
            
//            showingAccountView = true  // Set this to true to navigate to account
//            isSigninigIn = true
            
        case .failure(let error):
            print("Authentication error: \(error.localizedDescription)")
            
           
        }
    }
    
}
