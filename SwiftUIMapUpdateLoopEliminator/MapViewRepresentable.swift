//
// Created by Eric Lightfoot on 2021-06-08.
//

import Foundation
import SwiftUI
import CoreGraphics
import MapKit

struct MapViewRepresentable: UIViewRepresentable {

    var annotations = [AnnotationViewModel]()

    func annotations (_ annotations: [AnnotationViewModel]) -> Self {
        var updated = self
        updated.annotations = annotations
        return updated
    }

    var onCameraChange: (Coordinator) -> () = { _ in }

    func makeUIView (context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setCenter(CLLocationCoordinate2D(latitude: 33.0, longitude: 0.0), animated: true)
        mapView.delegate = context.coordinator
        context.coordinator.parent = self
        context.coordinator.mapView = mapView
        return mapView
    }

    func updateUIView (_ uiView: MKMapView, context: Context) {
        context.coordinator.annotations = annotations
    }

    func makeCoordinator () -> MapViewRepresentable.Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable?
        var mapView: MKMapView?
        var annotations: [AnnotationViewModel] = [] {
            didSet {
                syncAnnotations(old: oldValue)
            }
        }

        func syncAnnotations (old: [AnnotationViewModel]) {
            mapView?.removeAnnotations(old)
            mapView?.addAnnotations(annotations)
        }

        func mapViewDidChangeVisibleRegion (_ mapView: MKMapView) {
            parent?.onCameraChange(self)
        }
    }
}

extension CLLocationCoordinate2D {
    static var random: CLLocationCoordinate2D {
        .init(
            latitude: CLLocationDegrees.random(in: 32...34),
            longitude: CLLocationDegrees.random(in: -1...1)
        )
    }
}