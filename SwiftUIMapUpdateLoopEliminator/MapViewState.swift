//
// Created by Eric Lightfoot on 2021-06-09.
//

import SwiftUI

class MapViewState: ObservableObject, Equatable {
    static func == (lhs: MapViewState, rhs: MapViewState) -> Bool {
        lhs.focused == rhs.focused
    }


    @Published var focused: AnnotationViewModel?
}
