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
    var stopSelectMeetSpots: Bool // Add meet spots

    private let mapView = WrappableMapView()
    
    func makeUIView(context: UIViewRepresentableContext<MyMapView>) -> WrappableMapView {
        mapView.delegate = context.coordinator
        mapView.isUserInteractionEnabled = true // Enable user interaction
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:))))
        return mapView
    }
    
    func updateUIView(_ uiView: WrappableMapView, context: UIViewRepresentableContext<MyMapView>) {
        // Update existing annotations (pickup, dropoff, and meet spots)
        updateAnnotations(uiView)
        
        // Create a region that fits both the pickup and dropoff locations
        var zoomRect = MKMapRect.null
        for location in [requestLocation, destinationLocation] {
            let point = MKMapPoint(location)
            let rect = MKMapRect(x: point.x, y: point.y, width: 0, height: 0)
            zoomRect = zoomRect.union(rect)
        }

        // Adjust the map's visible region to include both annotations with padding
        uiView.setVisibleMapRect(zoomRect, edgePadding: .init(top: 20, left: 50, bottom: 50, right: 50), animated: true)

        // Create and calculate directions
        let requestPlacemark = MKPlacemark(coordinate: requestLocation)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation)

        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: requestPlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .automobile

        let directions = MKDirections(request: directionRequest)

        directions.calculate { response, error in
            guard let response = response, let route = response.routes.first else {
                print("Error calculating directions: \(String(describing: error))")
                return
            }

            // Add route overlay to map
            uiView.addOverlay(route.polyline, level: .aboveRoads)

            // Union the route's bounding map rect with the zoomRect to include the route
            zoomRect = zoomRect.union(route.polyline.boundingMapRect)

            // Set the visible map rect with padding again to ensure the route is also included
            uiView.setVisibleMapRect(zoomRect, edgePadding: .init(top: 20, left: 50, bottom: 50, right: 50), animated: true)
        }
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

    }
    
    func addAnnotation(coordinate: CLLocationCoordinate2D, title: String, mapView: MKMapView) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MyMapView

        init(_ parent: MyMapView) {
            self.parent = parent
        }

        
        @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            guard parent.meetSpots.count < 3 else { return }
            if(parent.stopSelectMeetSpots){
                let mapView = parent.mapView
                let location = gestureRecognizer.location(in: mapView)
                let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
                parent.meetSpots.append(coordinate)
            }
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 4.0
            return renderer
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom") ?? MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView.annotation = annotation
            
            switch annotation.title ?? "" {
            case "pickup":
                annotationView.image = UIImage(named: "pickup")
            case "dropoff":
                annotationView.image = UIImage(named: "dropoff")
            case "meetSpot":
                annotationView.image = UIImage(named: "meetSpot")
            default:
                annotationView.image = nil
            }
            
            return annotationView
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
