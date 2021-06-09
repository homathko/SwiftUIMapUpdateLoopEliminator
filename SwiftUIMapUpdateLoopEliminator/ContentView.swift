//
//  ContentView.swift
//  SwiftUIMapUpdateLoopEliminator
//
//  Created by Eric Lightfoot on 2021-06-08.
//
//

import SwiftUI

var _annotations = (0...50).map { _ in
    AnnotationViewModel(coordinate: .random)
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
