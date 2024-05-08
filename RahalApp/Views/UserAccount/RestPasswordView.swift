//
//  RestPasswordView.swift
//  RahalApp
//
//  Created by Juman Dhaher on 27/10/1445 AH.
//

import SwiftUI

struct RestPasswordView: View {
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        ZStack{
            Color(.background).ignoresSafeArea()
            VStack{
                PasswordView
                ConfirmPasswordView
                Spacer()
                ButtonWidget(text: "حفظ")
                
            }.padding(.top,30)
        }.navigationTitle("تغيير كلمة المرور")
    }
}

#Preview {
    RestPasswordView()
}


extension RestPasswordView {
    
    private var PasswordView: some View{
        VStack(alignment: .trailing){
            Text("كلمة المرور").foregroundColor( Color(.black900))
            
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
            Text("تأكيد كلمة المرور").foregroundColor( Color(.black900))
            
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
