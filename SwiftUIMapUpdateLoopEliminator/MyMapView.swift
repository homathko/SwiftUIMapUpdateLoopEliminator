//
// Created by Eric Lightfoot on 2021-06-08.
//

import SwiftUI
import MapKit
import CoreLocation

struct AnnotationViewModel: Identifiable {
    var id = UUID().uuidString
    var coordinate: CLLocationCoordinate2D
    var screenCoordinates: CGPoint?
}

struct MyMapView: View {
    var annotations: [MapAnno]
    @State var visibleSprites: [AnnotationViewModel] = []

    var body: some View {
        ZStack {
            MapViewRepresentable { coordinator in
                DispatchQueue.global(qos: .userInteractive).async {
                    let updated = coordinator.annotations.map { annotation -> AnnotationViewModel in
                        var result = AnnotationViewModel(coordinate: annotation.coordinate)
                        result.screenCoordinates = coordinator.mapView?.convert(annotation.coordinate, toPointTo: nil)
                        return result
                    }

                    DispatchQueue.main.async {
                        self.visibleSprites = updated
                    }
                }
            }
                    .annotations(annotations)

            /// This layer shows the annotations
            ForEach(visibleSprites, id: \.id) { annotation in
                AnimatedAnnotation(viewModel: annotation)
            }
        }
    }
}

struct AnimatedAnnotation: View {
    var viewModel: AnnotationViewModel
    @State private var opacity: Double = 1.0
    @State private var scale: CGFloat = 1.0

    var body: some View {
            Circle()
                    .fill(Color.green)
                    .frame(width: 20.0, height: 20.0).scaleEffect(scale)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(animation) {
                            self.opacity = 0.0
                            self.scale = 2.0
                        }
                    }
                    .position(viewModel.screenCoordinates ?? CGPoint(x: 0, y: 0))
    }

    var animation: Animation {
        Animation
                .easeInOut(duration: Double.random(in: 0.2...0.6))
                .repeatForever()
    }
}
