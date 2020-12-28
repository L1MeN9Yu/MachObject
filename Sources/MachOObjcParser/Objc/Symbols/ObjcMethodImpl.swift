//
// Created by Mengyu Li on 2020/12/25.
//

import Foundation
import MachOParser

struct ObjcMethodImpl<Arch: ObjcArchitecture>: FromMach {
    typealias Raw = ObjC.method_t<Arch.PointerType>

    let mach: Mach
    let offset: Int

    init(mach: Mach, offset: Int) {
        self.mach = mach
        self.offset = offset
    }
}

extension ObjcMethodImpl: ObjcMethod {
    var name: PlainStringInData { mach.getCString(fromVmOffset: raw.name) }
    var methType: PlainStringInData { mach.getCString(fromVmOffset: raw.types) }
}

extension ObjcMethodImpl: CustomStringConvertible {
    var description: String { "\(name): \(methType)" }
}
