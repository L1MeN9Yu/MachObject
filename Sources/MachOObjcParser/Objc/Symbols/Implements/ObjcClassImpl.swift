//
// Created by Mengyu Li on 2020/12/28.
//

import Foundation
import MachOParser

struct ObjcClassImpl<Arch: ObjcArchitecture>: FromMach {
    typealias Raw = Arch.ClassData
    let mach: Mach
    let offset: Int

    init(mach: Mach, offset: Int) {
        self.mach = mach
        self.offset = offset
    }
}

extension ObjcClassImpl: ObjcClass {
    var ivarLayout: PlainStringInData? {
        guard class_ro.ivarLayout != 0 else {
            return nil
        }
        return mach.getCString(fromVmOffset: class_ro.ivarLayout)
    }

    var name: MangledObjcClassNameInData {
        mach.getCString(fromVmOffset: class_ro.name)
    }

    var methods: [ObjcMethod] {
        // methods_list is entsize_list_tt with flags=0x3
        let list: [ObjcMethodImpl<Arch>] = mach.get_entsize_list_tt(fromVmOffset: class_ro.baseMethodList, flags: 0x03)
        return list
    }

    var ivars: [ObjcIvar] {
        // ivar_list is entsize_list_tt with flags=0
        let list: [ObjcIvarImpl<Arch>] = mach.get_entsize_list_tt(fromVmOffset: class_ro.ivars)
        return list
    }

    var properties: [ObjcProperty] {
        // property_list is entsize_list_tt with flags=0
        let list: [ObjcPropertyImpl<Arch>] = mach.get_entsize_list_tt(fromVmOffset: class_ro.baseProperties)
        return list
    }
}

private extension ObjcClassImpl {
    private var class_ro: Arch.ClassData.RODataType { mach.get(fromVmOffset: raw.data) }
}

extension ObjcClassImpl: CustomStringConvertible {
    var description: String { "Class \(name)\n  methods: \(methods)\n  properties: \(properties)\n  ivars: \(ivars)" }
}
