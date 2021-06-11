//
// Created by Eric Lightfoot on 2021-06-08.
//

import SwiftUI
import MapKit
import CoreLocation

struct AnnotationViewModel: Identifiable, Equatable {
    var id = UUID().uuidString
    var coordinate: CLLocationCoordinate2D
    var screenCoordinates: CGPoint?
}

struct MyMapView: View {
    @StateObject var mapState: MapViewState = .init()
    var annotations: [MapAnno]
    @State var visibleSprites: [AnnotationViewModel] = []

    var body: some View {
        ZStack {
            MapViewRepresentable(state: mapState) { coordinator in
                /// This block is called within MKMapViewDelegate
                /// mapViewDidChangeVisibleRegion (_ mapView: MKMapView)
                DispatchQueue.global(qos: .userInteractive).async {
                    let updated = coordinator.annotations.map { annotation -> AnnotationViewModel in
                        var result = AnnotationViewModel(coordinate: annotation.coordinate)
                        result.screenCoordinates = coordinator.mapView?.convert(annotation.coordinate, toPointTo: nil)
                        return result
                    }

                    DispatchQueue.main.async {
                        visibleSprites = updated
                    }
                }
            }
                    .annotations(annotations)

            /// This layer shows the annotations
            ForEach(visibleSprites) { annotation in
                AnimatedAnnotation(viewModel: annotation)
            }
        }
                .environmentObject(mapState)
    }
}

struct AnimatedAnnotation: View {
    @EnvironmentObject var mapState: MapViewState
    var viewModel: AnnotationViewModel
    @State private var opacity: Double = 1.0
    @State private var scale: CGFloat = 1.0

    var body: some View {
        Circle()
                .fill(Color.green)
                .frame(width: 20.0, height: 20.0).scaleEffect(scale)
                .opacity(opacity)
//                .onAppear {
//                    withAnimation(animation) {
//                        self.opacity = 0.2
//                        self.scale = 2.0
//                    }
//                }
                .onTapGesture {
                    mapState.focused = viewModel
                    print("Tapped \(viewModel.id)")
                }
                .position(viewModel.screenCoordinates ?? CGPoint(x: 0, y: 0))
    }

    var animation: Animation {
        Animation
                .easeInOut(duration: Double.random(in: 0.2...0.6))
                .repeatForever()
    }
}
