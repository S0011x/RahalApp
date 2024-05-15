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
    @Binding var meetSpots: [CLLocationCoordinate2D] // Add meet spots

    private let mapView = WrappableMapView()
    
    func makeUIView(context: UIViewRepresentableContext<MyMapView>) -> WrappableMapView{
        mapView.delegate = mapView
          mapView.isUserInteractionEnabled = true // Enable user interaction
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:))))
         return mapView
    }
    
    func updateUIView(_ uiView: WrappableMapView, context: UIViewRepresentableContext<MyMapView>) {
        // Update existing annotations (pickup, dropoff, and meet spots)
        updateAnnotations(uiView)


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
          mapView.region = MKCoordinateRegion(center: region, latitudinalMeters: 1000, longitudinalMeters: 1000)
      }
    
    
    func updateAnnotations(_ uiView: MKMapView) {
        uiView.removeAnnotations(uiView.annotations)
               
               addAnnotation(coordinate: requestLocation, title: "pickup", mapView: uiView)
               addAnnotation(coordinate: destinationLocation, title: "dropoff", mapView: uiView)
               
        var uniqueMeetSpots = [CLLocationCoordinate2D]()
           for meetSpot in meetSpots {
               if !uniqueMeetSpots.contains(where: { $0.latitude == meetSpot.latitude && $0.longitude == meetSpot.longitude }) {
                   uniqueMeetSpots.append(meetSpot)
               }
           }
               
               uniqueMeetSpots.prefix(3).enumerated().forEach { index, meetSpot in
                   addAnnotation(coordinate: meetSpot, title: "meetSpot", mapView: uiView)
               }
               
               // Focus on pickup and dropoff locations
               let region = MKCoordinateRegion(center: requestLocation, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
               uiView.setRegion(region, animated: true)
    }

    func addAnnotation(coordinate: CLLocationCoordinate2D, title: String, mapView: MKMapView) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = title
            
            var annotationImage: UIImage?
            switch title {
            case "pickup":
                annotationImage = UIImage(named: "pickup")
            case "dropoff":
                annotationImage = UIImage(named: "dropoff")
            case let meetSpotTitle where meetSpotTitle.hasPrefix("meetSpot"):
                annotationImage = UIImage(named: "meetSpot") // Use your custom image for meet spots
            default:
                break
            }
            
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: title)
            annotationView.image = annotationImage
            mapView.addAnnotation(annotation)
        }



    func makeCoordinator() -> Coordinator {
           return Coordinator(self)
       }

       class Coordinator: NSObject {
           var parent: MyMapView

           init(_ parent: MyMapView) {
               self.parent = parent
           }

           @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
                     guard parent.meetSpots.count < 3 else { return }
                     let mapView = parent.mapView
                     let location = gestureRecognizer.location(in: mapView)
                     let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
                     parent.meetSpots.append(coordinate)
                 }
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
