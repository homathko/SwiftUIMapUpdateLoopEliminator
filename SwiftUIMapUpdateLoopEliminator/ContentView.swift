//
//  ContentView.swift
//  SwiftUIMapUpdateLoopEliminator
//
//  Created by Eric Lightfoot on 2021-06-08.
//
//

import SwiftUI
import MapKit
import CoreLocation

class MapAnno: NSObject, MKAnnotation {
    var id = UUID().uuidString
    var coordinate: CLLocationCoordinate2D

    init (_ coord: CLLocationCoordinate2D) {
        coordinate = coord
    }
}

var _annotations = (0..<50).map { _ in
    MapAnno(.random)
}

struct ContentView: View {
    var body: some View {
        MyMapView(annotations: _annotations)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
