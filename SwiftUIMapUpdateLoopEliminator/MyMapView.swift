//
// Created by Eric Lightfoot on 2021-06-08.
//

import SwiftUI
import MapKit
import CoreLocation

class AnnotationViewModel: NSObject, Identifiable, MKAnnotation {
    var id = UUID().uuidString
    var coordinate: CLLocationCoordinate2D
    var screenCoordinates: CGPoint?

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

struct MyMapView: View {
    @State var annotations: [AnnotationViewModel]

    var body: some View {
        ZStack {
            MapViewRepresentable { coordinator in
                annotations = coordinator.annotations
                        .map { (annotation: AnnotationViewModel) in
                            annotation.screenCoordinates = coordinator.mapView?.convert(annotation.coordinate, toPointTo: nil)
                            return annotation
                        }
            }
                    .annotations(annotations)

            /// This layer shows the annotations
            ForEach(annotations) { annotation in
                AnimatedAnnotation(viewModel: annotation)
            }
        }
    }
}

struct AnimatedAnnotation: View {
    var viewModel: AnnotationViewModel
    var duration: Double = Double.random(in: 0.2...0.6)
    @State var opacity: Double = 1.0
    @State var scale: CGFloat = 1.0

    var body: some View {
        Circle()
                .frame(width: 20.0, height: 20.0)
                .foregroundColor(.green)
                .opacity(opacity)
                .scaleEffect(scale)
                .position(viewModel.screenCoordinates ?? CGPoint(x: 0, y: 0))
                .onAppear {
                    withAnimation(animation) {
                        self.opacity = 0.0
                        self.scale = 2.0
                    }
                }
    }

    var animation: Animation {
        Animation
                .easeInOut(duration: duration)
                .repeatForever()
    }
}
