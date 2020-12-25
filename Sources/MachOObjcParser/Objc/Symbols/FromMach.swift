//
// Created by Mengyu Li on 2020/12/25.
//

import Foundation
import MachOParser

protocol FromMach {
    init(mach: Mach, offset: Int)
    /// Structure describing raw metadata structure in image
    associatedtype Raw

    var mach: Mach { get }
    var offset: Int { get }
}

extension FromMach {
    var raw: Raw {
        mach.data.get(atOffset: offset)
    }
}
