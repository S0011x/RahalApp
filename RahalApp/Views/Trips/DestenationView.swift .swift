//
//  DestenationView.swift
//  RahalApp
//
//  Created by Juman Dhaher on 05/11/1445 AH.
//

    import MapKit
    import SwiftUI
    import UIKit

    struct DestenationView: View {
        
        @State var pickupLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 42.6619, longitude: 21.1501)
        @State var dropOffLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 42.6619, longitude: 21.1701)
        
        @State var anotionOne: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 42.6619, longitude: 21.1701)
        @State var anotionTwo: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 42.6619, longitude: 21.1701)
        @State var anotionTHree: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 42.6619, longitude: 21.1701)
        var body: some View {
            VStack {
                MapView(pickupLocation: $pickupLocation , dropOffLocation: $dropOffLocation, annotationOne: $anotionOne , annotationTwo: $anotionTwo ,annotationThree: $anotionTHree )
                
            }.ignoresSafeArea()
      }
    }


    struct DestenationView_Previews: PreviewProvider {
      static var previews: some View {
          DestenationView()
      }
    }
