//
// Created by Eric Lightfoot on 2021-06-08.
//

import Foundation
import SwiftUI
import CoreGraphics
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    /// This prop must be observed to react to
    /// MapViewState.focused annotation being set
    ///
    /// This is how the loop is kicked off.
    /// What different strategy can be used here?
    @ObservedObject var state: MapViewState
    var annotations = [MapAnno]()

    func annotations (_ annotations: [MapAnno]) -> Self {
        var updated = self
        updated.annotations = annotations
        return updated
    }

    var onCameraChange: (Coordinator) -> () = { _ in }

    func makeUIView (context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setCenter(CLLocationCoordinate2D(latitude: 33.0, longitude: 0.0), animated: true)
        mapView.setCameraZoomRange(.init(maxCenterCoordinateDistance: 1000000), animated: false)
        mapView.delegate = context.coordinator
        context.coordinator.parent = self
        context.coordinator.mapView = mapView
        return mapView
    }

    func updateUIView (_ uiView: MKMapView, context: Context) {
        print("Updating viewRep")
        context.coordinator.annotations = annotations
        /// Clicking on an annotaion updates published property on MapViewState
        if let focused = state.focused {
            /// This will cause the MKMapViewDelegate method
            /// mapViewDidChangeVisibleRegion (_ mapView: MKMapView) to be called
            uiView.setCenter(focused.coordinate, animated: true)
        }
    }

    func makeCoordinator () -> MapViewRepresentable.Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable?
        var mapView: MKMapView?
        var annotations: [MapAnno] = [] {
            didSet {
                syncAnnotations()
            }
        }

        func syncAnnotations () {
            guard let mapView = mapView else { return }

            let annotationsById = Dictionary(uniqueKeysWithValues: annotations.map { ($0.id, $0)})

            let oldAnnotationIds = Set((mapView.annotations as! [MapAnno]).map { $0.id })
            let newAnnotationIds = Set(annotationsById.values.map { $0.id })

            let idsForAnnotationsToRemove = oldAnnotationIds.subtracting(newAnnotationIds)
            let annotationsToRemove = idsForAnnotationsToRemove.compactMap { idToRemove in
                (mapView.annotations as! [MapAnno]).first(where: { $0.id == idToRemove })
            }
            if !annotationsToRemove.isEmpty {
                mapView.removeAnnotations(annotationsToRemove)
            }

            let idsForAnnotationsToAdd = newAnnotationIds.subtracting(oldAnnotationIds)
            let annotationsToAdd = idsForAnnotationsToAdd.compactMap { idToAdd in
                (mapView.annotations as! [MapAnno]).first(where: { $0.id == idToAdd })
            }
            if !annotationsToRemove.isEmpty {
                mapView.addAnnotations(annotationsToAdd)
            }
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