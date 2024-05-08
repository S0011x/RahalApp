//
//  UserAccount.swift
//  RahalApp
//
//  Created by Juman Dhaher on 27/10/1445 AH.
//

import SwiftUI

struct UserAccountView: View {
    var body: some View {
        ZStack{
            Color(.background).ignoresSafeArea()
            VStack{
                HeaderView
                NavigationLink(destination: UserInformationView()) {
                    widgetBox(text: "معلومات الحساب")
                }
                NavigationLink(destination: SavedTripsView()) {
                    widgetBox(text: "الرحلات المحفوظة")
                }
                NavigationLink(destination: FutureTripsView()) {
                    widgetBox(text: "الرحلات القادمة")
                }
                NavigationLink(destination: ContactUsView()) {
                    widgetBox(text: "تواصل معنا")
                }
                Spacer()
            }.padding(.top,30)
        }.navigationTitle("الحساب الشخصي")
    }
    
    func widgetBox(text: String) -> some View{
        return ZStack{
            Color(.whiteA700)
            HStack(spacing: 0) {
                Image(systemName: "chevron.backward").foregroundColor(.black900)
                Spacer()
                Text(text).foregroundColor(.black900)
                
            }.padding()
            .frame(width: 340,height: 40,alignment:.trailing)
        }.frame(width: 340,height: 50,alignment:.trailing).cornerRadius(12)
    }
    
}

#Preview {
    UserAccountView()
}


extension UserAccountView {
    private var HeaderView: some View{
        HStack{
            Text("جمان يوسف")
            Image("img_person_circle_1")
        }.frame(width: 340, alignment: .trailing)
    }
}

