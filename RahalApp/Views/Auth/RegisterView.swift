//
//  RegisterView.swift
//  RahalApp
//
//  Created by Juman Dhaher on 20/10/1445 AH.
//


import AuthenticationServices
import SwiftUI

struct RegisterView: View {
    @State private var showingHomeView = false

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var confirmEmail = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Image("img_untitled_artwork").resizable().brightness(-0.4).ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        FirstNameView
                        LastNameView
                        EmailView
                        ConfirmEmailView
                        PasswordView
                        ConfirmPasswordView
                        Spacer(minLength: 30)
                        Button("انشاء الحساب", action: registerUser)
                            .buttonStyle(.borderedProminent)
                            .frame(width: 300, height: 40)
                        Spacer(minLength: 20)
                        NavigationLink(destination: LoginView()) {
                            HStack {
                                Text("سجل الدخول").underline(color: Color("tivany"))
                                    .foregroundColor(Color("tivany"))
                                Text("لديك حساب مسجل مسبقا؟ ").foregroundColor(Color("WhiteA700")).fontWeight(.heavy)
                            }
                        }
                        
                        HStack {
                            line
                            Text("أو").foregroundColor(.white)
                            line
                        }.frame(width: 300)
                        
                        SignInWithAppleButton(
                            .signIn,
                            onRequest: configureAppleSignInRequest,
                            onCompletion: handleAppleSignInResult
                        )
                        .signInWithAppleButtonStyle(.white) // Set the button style to white
                        .frame(width: 300, height: 40)
                        .padding()
                    }
                }.safeAreaPadding(.top, 80)
            }
            .ignoresSafeArea()
            .navigationDestination(isPresented: $showingHomeView) {
                UserAccountView()
            }
        }
    }
    
    var line: some View {
        VStack { Divider().background(Color.white) }.padding(10)
    }
    
    private func registerUser() {
        // Implement registration logic here
    }
    
    private func configureAppleSignInRequest(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    private func handleAppleSignInResult(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            guard let _ = authResults.credential as? ASAuthorizationAppleIDCredential else {
                return
            }
            showingHomeView = true  // Set this to true to navigate to HomeView
            
        case .failure(let error):
            print("Authentication error: \(error.localizedDescription)")
        }
    }

    // Subviews
    private var FirstNameView: some View {
        VStack(alignment: .trailing) {
            Text("الأسم الأول").foregroundColor(Color("WhiteA700")).fontWeight(.heavy)
            TextField("", text: $firstName)
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
    
    private var LastNameView: some View {
        VStack(alignment: .trailing) {
            Text("الأسم الأخير").foregroundColor(Color("WhiteA700")).fontWeight(.heavy)
            TextField("", text: $lastName)
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
    
    private var EmailView: some View {
        VStack(alignment: .trailing) {
            Text("البريد الالكتروني").foregroundColor(Color("WhiteA700")).fontWeight(.heavy)
            TextField("", text: $email)
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
    
    private var ConfirmEmailView: some View {
        VStack(alignment: .trailing) {
            Text("تأكيد البريد الالكتروني").foregroundColor(Color("WhiteA700")).fontWeight(.heavy)
            TextField("", text: $confirmEmail)
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
    
    private var PasswordView: some View {
        VStack(alignment: .trailing) {
            Text("كلمة المرور").foregroundColor(Color("WhiteA700")).fontWeight(.heavy)
            SecureField("", text: $password)
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
    
    private var ConfirmPasswordView: some View {
        VStack(alignment: .trailing) {
            Text("تأكيد كلمة المرور").foregroundColor(Color("WhiteA700")).fontWeight(.heavy)
            SecureField("", text: $confirmPassword)
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
}

