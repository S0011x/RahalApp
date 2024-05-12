//
//  MyMapView.swift
//  RahalApp
//
//  Created by Juman Dhaher on 27/10/1445 AH.
//

import Foundation
import SwiftUI
import MapKit
struct MyMapView: UIViewRepresentable {
    @Binding var requestLocation: CLLocationCoordinate2D
    @Binding var destinationLocation: CLLocationCoordinate2D
    
    private let mapView = WrappableMapView()
    
    func makeUIView(context: UIViewRepresentableContext<MyMapView>) -> WrappableMapView{
        mapView.delegate = mapView
        return mapView
    }
    
    func updateUIView(_ uiView: WrappableMapView, context: UIViewRepresentableContext<MyMapView>) {
        
        //drow Pickup Pin
        let requestAnnotation = MKPointAnnotation()
        requestAnnotation.coordinate = requestLocation
        requestAnnotation.title = "pickup"
        uiView.addAnnotation(requestAnnotation)
        
        //drow DropOff Pin
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = destinationLocation
        destinationAnnotation.title = "dropoff"
        uiView.addAnnotation(destinationAnnotation)
        
        //Draw Path
        let requestPlacemark = MKPlacemark(coordinate: requestLocation)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: requestPlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .any
        
      let directions = MKDirections (request: directionRequest)
        
        directions.calculate { response, error in
            
            guard let response = response else {
                return
            }
            
            let route = response.routes[0]
            uiView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            uiView.setRegion(MKCoordinateRegion(rect), animated: true)
            
            
            uiView.setVisibleMapRect(rect, edgePadding: .init(top: 10, left: 50, bottom: 300, right: 50), animated: true)
        }
        
   }
    
    func setMapRegion(_ region: CLLocationCoordinate2D) {
        mapView.region =  MKCoordinateRegion(center: region, latitudinalMeters: 6000, longitudinalMeters: 6000)
        
    }
    
}

class WrappableMapView : MKMapView, MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = UIColor(Color.black)
        render.lineWidth = 4.0
        return render
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            if annotation is MKUserLocation {
                return nil
            }
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            } else{
                annotationView?.annotation = annotation
            }
            
            switch annotation.title {
            case "pickup":
                annotationView?.image = UIImage (named: "pickup")
                
            case "dropoff":
                annotationView?.image = UIImage (named: "dropoff")
            default:
                break                
            }
        
            return annotationView
        }
}
