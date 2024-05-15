import SwiftUI
import MapKit
import CoreLocation

struct MapViewMeetSpot: UIViewRepresentable {
    // Array to hold the selected locations
    @Binding var selectedLocations: [CLLocationCoordinate2D]

    // Reference to Core Location manager
    let locationManager = CLLocationManager()

    // Maximum number of meet spots
    let maxMeetSpots = 3

    // Create and configure the map view
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        // Request location authorization
        locationManager.requestWhenInUseAuthorization()

        // Enable tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(gesture:)))
        mapView.addGestureRecognizer(tapGesture)

        return mapView
    }

    // Update the map view when necessary
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Clear existing annotations
        mapView.removeAnnotations(mapView.annotations)

        // Add annotations for selected locations
        for location in selectedLocations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            mapView.addAnnotation(annotation)
        }

        // Center map on user's current location
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 5000, longitudinalMeters: 5000) // Adjust meters as needed
            mapView.setRegion(region, animated: true)
        }
    }

    // Coordinator to handle delegate methods
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewMeetSpot

        init(_ parent: MapViewMeetSpot) {
            self.parent = parent
        }

        // Handle tap gesture to add new location
        @objc func handleTap(gesture: UITapGestureRecognizer) {
            guard parent.selectedLocations.count < parent.maxMeetSpots else {
                // Notify the user somehow that they cannot select more than 3 meet spots
                return
            }

            let mapView = gesture.view as! MKMapView
            let location = gesture.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)

            parent.selectedLocations.append(coordinate)
        }

        // Customize the appearance of annotations
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                // Return nil to use default view for user location
                return nil
            }

            let reuseIdentifier = "customAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                annotationView?.canShowCallout = true

                // Add a callout accessory button
                let calloutButton = UIButton(type: .detailDisclosure)
                annotationView?.rightCalloutAccessoryView = calloutButton
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        }

        // Handle callout accessory view tap
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let annotation = view.annotation else {
                return
            }

            // Find the index of the selected annotation
            guard let index = mapView.annotations.firstIndex(where: { $0.coordinate.latitude == annotation.coordinate.latitude && $0.coordinate.longitude == annotation.coordinate.longitude }) else {
                return
            }

            // Show options to the user
            let alertController = UIAlertController(title: "Meet Spot Options", message: "What would you like to do?", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Remove Meet Spot", style: .destructive) { _ in
                self.parent.selectedLocations.remove(at: index)
            })
            alertController.addAction(UIAlertAction(title: "Show Place Name", style: .default) { _ in
                // You can add code here to show the place name
                // For example, you can use reverse geocoding to get the name of the location
            })
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            // Present the alert controller
            if let viewController = UIApplication.shared.windows.first?.rootViewController {
                viewController.present(alertController, animated: true)
            }
        }
    }
}

// Example usage:
struct MapViewMeetSpotView: View {
    @State private var selectedLocations: [CLLocationCoordinate2D] = []

    var body: some View {
        VStack {
            MapViewMeetSpot(selectedLocations: $selectedLocations)
                .edgesIgnoringSafeArea(.all)

            }
    }
}
                   
                        
#Preview {
    MapViewMeetSpotView()
}
