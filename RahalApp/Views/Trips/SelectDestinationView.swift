//
//  SelectDestinationView.swift
//  RahalApp
//
//  Created by Juman Dhaher on 26/10/1445 AH.
//

import SwiftUI
import MapKit

struct SelectDestinationView: View {
    @Environment(\.presentationMode) var presentationMode

    @State var pickupLocation = /*CLLocationCoordinate2D(latitude: 24.8613, longitude: 46.7255)*/ CLLocationCoordinate2D(latitude: 42.6619, longitude: 21.1501)
    
  @State var dropOffLocation  = /*CLLocationCoordinate2D(latitude: 24.8414, longitude: 46.7333)*/
                                                      CLLocationCoordinate2D(latitude: 42.6619, longitude: 21.1701)
    
    var body: some View {
        ZStack{
            MyMapView(requestLocation: $pickupLocation, destinationLocation: $dropOffLocation).edgesIgnoringSafeArea(.all)
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
                        Text("موقع الانطلاق").frame(width: 300 ,alignment: .trailing)
                        Divider()
                        Text("موقع الوصول").frame(width: 300 ,alignment: .trailing)
                    }
                }.frame(width: 340,height:80 ,alignment: .trailing)
                    .cornerRadius(8)
                   
                Spacer()
                NavigationLink(destination: SelectMeetSpotView()) {
                    ButtonWidget(text: "التالي")
                }
            }
        }.hideNavigationBar()
    }
}

#Preview {
    SelectDestinationView()
}
