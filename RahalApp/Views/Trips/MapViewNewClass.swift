import SwiftUI
import MapKit

struct MapViewNewClass: UIViewRepresentable {
    @Binding var pickupCoordinate: CLLocationCoordinate2D
    @Binding var dropoffCoordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        let pickupAnnotation = MKPointAnnotation()
        pickupAnnotation.coordinate = pickupCoordinate
        pickupAnnotation.title = "Pickup Location"
        
        let dropoffAnnotation = MKPointAnnotation()
        dropoffAnnotation.coordinate = dropoffCoordinate
        dropoffAnnotation.title = "Drop-off Location"
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations([pickupAnnotation, dropoffAnnotation])
        
        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: dropoffCoordinate)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let route = response?.routes.first else {
                if let error = error {
                    print("Error calculating directions: \(error.localizedDescription)")
                }
                return
            }
            mapView.removeOverlays(mapView.overlays)
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewNewClass
        
        init(_ parent: MapViewNewClass) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
            return renderer
        }
    }
}

struct DataView: View {
    @State private var pickupCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    @State private var dropoffCoordinate = CLLocationCoordinate2D(latitude: 37.3352, longitude: -122.0096)
    
    var body: some View {
        VStack {
            MapViewNewClass(pickupCoordinate: $pickupCoordinate, dropoffCoordinate: $dropoffCoordinate)
                .edgesIgnoringSafeArea(.all)
                .frame(height: 300)
      }
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView()
    }
}
