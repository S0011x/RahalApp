//
//  ForgetPassword.swift
//  RahalApp
//
//  Created by Juman Dhaher on 26/10/1445 AH.
//

import SwiftUI

struct ForgetPassword: View {
    @State private var email = ""

    var body: some View {
            ZStack{
                Color(.background)
                ScrollView{

                VStack(alignment:.trailing){
                    Spacer(minLength: 100)
                    EmailView
                    Spacer(minLength: 500)
                    ButtonWidget(text: "ارسال كود التحقق")
                    
                }.frame(alignment:.top)
            }
        }.navigationTitle("استعادة كلمة المرور").ignoresSafeArea()
        
          
    }
}

#Preview {
    ForgetPassword()
}


extension ForgetPassword {
    
    private var EmailView: some View{
        VStack(alignment: .trailing){
            Text("البريد الالكتروني المسجل في التطبيق").fontWeight(.heavy)
            
            TextField("", text: $email)
            
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

