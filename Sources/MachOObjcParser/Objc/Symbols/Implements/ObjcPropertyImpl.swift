//
// Created by Mengyu Li on 2020/12/28.
//

import Foundation
import MachOParser

struct ObjcPropertyImpl<Arch: ObjcArchitecture>: FromMach {
    typealias Raw = ObjC.property_t<Arch.PointerType>

    let mach: Mach
    let offset: Int

    init(mach: Mach, offset: Int) {
        self.mach = mach
        self.offset = offset
    }
}

extension ObjcPropertyImpl: ObjcProperty {
    var name: PlainStringInData { mach.getCString(fromVmOffset: raw.name) }
}

extension ObjcPropertyImpl: CustomStringConvertible {
    var attributes: PlainStringInData { mach.getCString(fromVmOffset: raw.attributes) }

    var description: String { "\(name): \(attributes)" }
}
