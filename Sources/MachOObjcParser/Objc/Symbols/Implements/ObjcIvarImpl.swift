//
// Created by Mengyu Li on 2020/12/28.
//

import Foundation
import MachOParser

struct ObjcIvarImpl<Arch: ObjcArchitecture>: FromMach {
    typealias Raw = ObjC.ivar_t<Arch.PointerType>

    let mach: Mach
    let offset: Int

    init(mach: Mach, offset: Int) {
        self.mach = mach
        self.offset = offset
    }
}

extension ObjcIvarImpl: ObjcIvar {
    var name: PlainStringInData { mach.getCString(fromVmOffset: raw.name) }

    var type: PlainStringInData { mach.getCString(fromVmOffset: raw.type) }
}

extension ObjcIvarImpl: CustomStringConvertible {
    var description: String { "\(name): \(type)" }
}
