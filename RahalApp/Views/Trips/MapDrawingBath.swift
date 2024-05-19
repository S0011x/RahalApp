//
//  MapDrawingBath.swift
//  RahalApp
//
//  Created by Juman Dhaher on 05/11/1445 AH.

import MapKit
import SwiftUI
import UIKit

struct MapView: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    
    @Binding var pickupLocation: CLLocationCoordinate2D
    @Binding var dropOffLocation: CLLocationCoordinate2D
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Clear existing annotations and overlays
        uiView.removeAnnotations(uiView.annotations)
        uiView.removeOverlays(uiView.overlays)
        
        // Add pickup and dropoff annotations
        let pickupAnnotation = MKPointAnnotation()
        pickupAnnotation.coordinate = pickupLocation
        pickupAnnotation.title = "pickup"
        
        let dropOffAnnotation = MKPointAnnotation()
        dropOffAnnotation.coordinate = dropOffLocation
        dropOffAnnotation.title = "dropoff"
        
        uiView.addAnnotations([pickupAnnotation, dropOffAnnotation])
        
        // Set the region to focus on the pickup location with a closer zoom level
        let region = MKCoordinateRegion(
            center: pickupLocation,
            latitudinalMeters: 22000, // Adjust as needed for zoom level
            longitudinalMeters: 22000  // Adjust as needed for zoom level
        )
        uiView.setRegion(region, animated: true)
        
        // Create and calculate directions
        let requestPlacemark = MKPlacemark(coordinate: pickupLocation)
        let destinationPlacemark = MKPlacemark(coordinate: dropOffLocation)
        
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
            
            // Calculate a region that fits both annotations and the route
            var zoomRect = MKMapRect.null
            for annotation in uiView.annotations {
                let annotationPoint = MKMapPoint(annotation.coordinate)
                let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)
                zoomRect = zoomRect.union(pointRect)
            }
            zoomRect = zoomRect.union(route.polyline.boundingMapRect)
            
            // Set the visible map rect with padding
            uiView.setVisibleMapRect(zoomRect, edgePadding: .init(top: 20, left: 50, bottom: 50, right: 50), animated: true)
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
            } else {
                annotationView?.annotation = annotation
            }
            
            switch annotation.title ?? "" {
            case "pickup":
                annotationView?.image = UIImage(named: "pickup")
            case "dropoff":
                annotationView?.image = UIImage(named: "dropoff")
            default:
                break
            }
            
            return annotationView
        }
    }
}
