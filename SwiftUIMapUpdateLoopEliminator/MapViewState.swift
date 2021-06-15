//
// Created by Eric Lightfoot on 2021-06-09.
//

import SwiftUI

class MapViewState: ObservableObject, NSCopying, Equatable {
    func copy (with zone: NSZone? = nil) -> Any {
        let copy = MapViewState()
        copy.focused = focused
        return copy
    }

    static func == (lhs: MapViewState, rhs: MapViewState) -> Bool {
        lhs.focused == rhs.focused
    }


    @Published var focused: AnnotationViewModel?
}
