//
//  UserInformationView.swift
//  RahalApp
//
//  Created by Juman Dhaher on 27/10/1445 AH.
//

import SwiftUI

struct UserInformationView: View {
    
    @State var loginViewModel = LoginViewModel()
    
//    @State  var firstName = ""
//    @State  var lastName = ""
//    @State  var email = ""
   
    
    var body: some View {
        
        
        @State  var email = loginViewModel.email
        @State  var firstName = loginViewModel.firstName
        @State  var lastName = loginViewModel.lastName
        
        ZStack{
            Color(.background).ignoresSafeArea()
            VStack{
                HeaderView
                FirstNameView(firstName: firstName)
                LastNameView(lastName: lastName)
                EmailView(email: email)
                
                NavigationLink(destination: RestPasswordView(), label: {
                    Text("تواصل معنا")
                        .foregroundColor(.blue).frame(width: 300, alignment: .trailing).padding(.top)
                })
                NavigationLink(destination: RestPasswordView(), label: {
                    Text("حذف الحساب")
                        .foregroundColor(.blue).frame(width: 300, alignment: .trailing).padding(.top)
                })
                
                
//                NavigationLink(destination: RestPasswordView(), label: {
//                    Text("اعادة تعيين كلمة المرور؟").foregroundColor(.blue).frame(width: 300, alignment: .trailing).padding(.top)
//                })
//
               
                Spacer()
//                ButtonWidget(text: "حفظ")
                
            }.padding(.top,30)
        }.navigationTitle("معلومات الحساب")
    }
}

#Preview {
    UserInformationView()
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


