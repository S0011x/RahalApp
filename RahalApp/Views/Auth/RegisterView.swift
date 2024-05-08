//
//  RegisterView.swift
//  RahalApp
//
//  Created by Juman Dhaher on 20/10/1445 AH.
//

import SwiftUI

struct RegisterView: View {
    @State var appleButton: AppleButtonLogic
        init() {
            self._appleButton = State(initialValue: AppleButtonLogic())
        }
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var confirmEmail = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    var body: some View {
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
                        ButtonWidget(text: "انشاء الحساب")
                        Spacer(minLength: 20)
                        NavigationLink(destination: LoginView()) {
                            HStack{
                                Text("سجل الدخول").underline(color : Color("tivany"))
                                    .foregroundColor(Color("tivany"))
                                Text("لديك حساب مسجل مسبقا؟ ").foregroundColor( Color("WhiteA700")).fontWeight(.heavy)
                            }
                        }
                       
                        HStack{
                            line
                            Text("أو").foregroundColor(.whiteA700)
                            line
                        }.frame(width: 300)
                        Button {
                                           
                           } label: {
                             AppleButtonView()
                                   .frame(width: 300, height: 40)
                      }
                        
                    }
                }.safeAreaPadding(.top,80)
            }
            .ignoresSafeArea()
    }
    
    var line: some View {
        VStack { Divider().background(.whiteA700) }.padding(10)
    }
    
}

#Preview {
    RegisterView()
}


extension RegisterView {
    
    private var FirstNameView: some View{
        VStack(alignment: .trailing){
            Text("الأسم الأول").foregroundColor( Color("WhiteA700")).fontWeight(.heavy)
            TextField("", text: $firstName)
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
    
    private var LastNameView: some View{
        VStack(alignment: .trailing){
            Text("الأسم الأخير").foregroundColor( Color("WhiteA700")).fontWeight(.heavy)
            
            TextField("", text: $lastName)
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
    
    private var EmailView: some View{
        VStack(alignment: .trailing){
            Text("البريد الالكتروني").foregroundColor( Color("WhiteA700")).fontWeight(.heavy)
            
            TextField("", text: $email)
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
    
    private var ConfirmEmailView: some View{
        VStack(alignment: .trailing){
            Text("تأكيد البريد الالكتروني").foregroundColor( Color("WhiteA700")).fontWeight(.heavy)
            
            TextField("", text: $confirmEmail)
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
    
    private var PasswordView: some View{
        VStack(alignment: .trailing){
            Text("كلمة المرور").foregroundColor( Color("WhiteA700")).fontWeight(.heavy)
            
            TextField("", text: $password)
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
    
    private var ConfirmPasswordView: some View{
        VStack(alignment: .trailing){
            Text("تأكيد كلمة المرور").foregroundColor( Color("WhiteA700")).fontWeight(.heavy)
            
            TextField("", text: $confirmPassword)
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
    
}
