//
//  LoginView.swift
//  RahalApp
//
//  Created by Juman Dhaher on 20/10/1445 AH.
//

import SwiftUI

struct LoginView: View {
    @State var appleButton: AppleButtonLogic
        init() {
            self._appleButton = State(initialValue: AppleButtonLogic())
        }

    @State private var email = ""
    @State private var password = ""

    var body: some View {
            ZStack{
                Image("img_untitled_artwork").resizable().brightness(-0.4).ignoresSafeArea()
                
                ScrollView{
                    VStack(alignment:.center){
                        EmailView
                        PasswordView
                        NavigationLink(destination: ForgetPassword()) {
                            HStack{
                                Text("نسيت كلمة المرور؟").foregroundColor( Color("WhiteA700")).fontWeight(.bold)}
                            .frame(width:300 ,alignment: .trailing)
                        }
                        
                        Spacer(minLength: 30)
                        ButtonWidget(text: "تسجيل الدخول")
                        Spacer(minLength: 20)
                        NavigationLink(destination: RegisterView(), label: {
                            HStack{
                                Text("سجل معنا").underline(color : Color("tivany"))
                                    .foregroundColor(Color("tivany"))
                                Text("ليس لديك حساب؟").foregroundColor( Color("WhiteA700")).fontWeight(.heavy)
                            }
                        })
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
                }.safeAreaPadding(.top,180)
            }
            .ignoresSafeArea()
    }
    
    var line: some View {
        VStack { Divider().background(.whiteA700) }.padding(10)
    }
}

#Preview {
    LoginView()
}


extension LoginView {

    
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
    
}
