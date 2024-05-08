//
//  SelectMeetSpotView.swift
//  RahalApp
//
//  Created by Juman Dhaher on 26/10/1445 AH.
//

import SwiftUI
import MapKit

struct SelectMeetSpotView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            Map(interactionModes: [.rotate, .zoom])
                .mapStyle(.standard)
            
            VStack{
                
                VStack{
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        Image(systemName: "chevron.backward").padding()
                            .frame(width: 350,height: 40 ,alignment: .leading)
                    }
                    
                    
                    ZStack{
                        Color(.whiteA700)
                        VStack{
                            Text("نقاط الالتقاء").frame(width: 300 ,alignment: .trailing)
                        }
                    }.frame(width: 340,height:40 ,alignment: .trailing)
                        .cornerRadius(8)
                    
                    Spacer()
                    NavigationLink(destination: PrepardLocationView()) {
                        ButtonWidget(text: "التالي")
                    }
                }
            }
        }.hideNavigationBar()
    }
}
#Preview {
    SelectMeetSpotView()
}
