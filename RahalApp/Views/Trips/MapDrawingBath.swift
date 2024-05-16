//
//  MapDrawingBath.swift
//  RahalApp
//
//  Created by Juman Dhaher on 05/11/1445 AH.
//

import MapKit
import SwiftUI
import UIKit
struct MapView: UIViewRepresentable {

  typealias UIViewType = MKMapView

    @Binding var pickupLocation: CLLocationCoordinate2D
    @Binding var dropOffLocation: CLLocationCoordinate2D

   // @State var drop : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

  func makeCoordinator() -> MapViewCoordinator {
    return MapViewCoordinator()
  }
    
  func makeUIView(context: Context) -> MKMapView {
      
    let mapView = MKMapView()
    mapView.delegate = context.coordinator

    // NYC
      let p1 = MKPlacemark(coordinate: pickupLocation)
      
    // Boston
    let p2 = MKPlacemark(coordinate: dropOffLocation)

    let request = MKDirections.Request()
    request.source = MKMapItem(placemark: p1)
    request.destination = MKMapItem(placemark: p2)
    request.transportType = .automobile

    let directions = MKDirections(request: request)
    directions.calculate { response, error in
      guard let route = response?.routes.first else { return }
      mapView.addAnnotations([p1, p2])
      mapView.addOverlay(route.polyline)
      mapView.setVisibleMapRect(
        route.polyline.boundingMapRect,
        edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
        animated: true)
    }
    
    return mapView
  }

  func updateUIView(_ uiView: MKMapView, context: Context) {
      //drow Pickup Pin
      let requestAnnotation = MKPointAnnotation()
      requestAnnotation.coordinate = pickupLocation
      requestAnnotation.title = "pickup"
      uiView.addAnnotation(requestAnnotation)
      
      //drow DropOff Pin
      let destinationAnnotation = MKPointAnnotation()
      destinationAnnotation.coordinate = dropOffLocation
      destinationAnnotation.title = "dropoff"
      uiView.addAnnotation(destinationAnnotation)
      
      
      //Draw Path
      let requestPlacemark = MKPlacemark(coordinate: pickupLocation)
      let destinationPlacemark = MKPlacemark(coordinate: dropOffLocation)
      
      let directionRequest = MKDirections.Request()
      directionRequest.source = MKMapItem(placemark: requestPlacemark)
      directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
      directionRequest.transportType = .automobile
      
    let directions = MKDirections (request: directionRequest)
      
      directions.calculate { response, error in
          
          guard let response = response else {
              return
          }
          
         // let route = response.routes[0]
         // uiView.addOverlay(route.polyline, level: .aboveRoads)
          
         // let rect = route.polyline.boundingMapRect
         // uiView.setRegion(MKCoordinateRegion(rect), animated: true)
          
          
          let route = response.routes[0]
              uiView.addOverlay(route.polyline, level: .aboveRoads)
              
              let rect = route.polyline.boundingMapRect
              let region = MKCoordinateRegion(rect)
              
              // Ensure zoom levels are within limits
              let limitedRegion = MKCoordinateRegion(
                  center: region.center,
                  span: MKCoordinateSpan(latitudeDelta:500 , longitudeDelta: 500)
              )
              
              uiView.setRegion(limitedRegion, animated: true)
          
          uiView.setVisibleMapRect(rect, edgePadding: .init(top: 10, left: 50, bottom: 300, right: 50), animated: true)
      }
      
      
  }

  class MapViewCoordinator: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      let renderer = MKPolylineRenderer(overlay: overlay)
      renderer.strokeColor = .systemBlue
      renderer.lineWidth = 5
      return renderer
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
              case "pin":
                  annotationView?.image = UIImage (named: "img_group_22")
              default:
                  break
              }
          
              return annotationView
          }
  }
}
