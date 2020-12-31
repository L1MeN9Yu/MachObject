//
// Created by Mengyu Li on 2020/12/28.
//

import Foundation
import MachOParser

private extension Mach {
    private var as32: Mach32 { Mach32(mach: self) }

    private var as64: Mach64 { Mach64(mach: self) }

    private var asArchitecture: ObjcImage {
        switch data.magic {
        case MH_MAGIC_64:
            return as64
        case MH_MAGIC:
            return as32
        default:
            fatalError("Unsupported mach binary magic \(String(data.magic ?? 0, radix: 0x10, uppercase: true))")
        }
    }

    private var objcClasslistSection: Section? {
        section(of: SegmentName.__DATA, name: SectionName.__objc_classlist)
    }

    private var objcCatlistSection: Section? {
        section(of: SegmentName.__DATA, name: SectionName.__objc_catlist)
    }

    private var objcProtocollistSection: Section? {
        section(of: SegmentName.__DATA, name: SectionName.__objc_protolist)
    }
}

public extension Mach {
    var objcClasses: [ObjcClass] {
        asArchitecture.getObjectsFromList(section: objcClasslistSection, creator: asArchitecture.create(offset:))
    }

    var objcCategories: [ObjcCategory] {
        asArchitecture.getObjectsFromList(section: objcCatlistSection, creator: asArchitecture.create(offset:))
    }

    var objcProtocols: [ObjcProtocol] {
        asArchitecture.getObjectsFromList(section: objcProtocollistSection, creator: asArchitecture.create(offset:))
    }
}

public extension Mach {
    var classNamesInData: [MangledObjcClassNameInData] {
        (objcClasses.map(\.name) + objcProtocols.map(\.name)).filter { !$0.isSwift } + pureObjcCategoryNames
    }

    var classNames: [String] {
        classNamesInData.map(\.value)
    }

    private var pureObjcCategoryNames: [MangledObjcClassNameInData] {
        objcCategories.map(\.name).filter(isPureObjCCategory(_:))
    }

    func isPureObjCCategory(_ name: MangledObjcClassNameInData) -> Bool {
        section(of: .__TEXT, name: .__objc_classname)?.contains(data: name) ?? false
    }
}

private class Mach32: MachArchitecture<Mach32.PointerType, Mach32>, ObjcArchitecture32 {}

private class Mach64: MachArchitecture<Mach64.PointerType, Mach64>, ObjcArchitecture64 {}

private class MachArchitecture<PointerType: UnsignedInteger, Me: ObjcArchitecture>: ObjcImage {
    private let mach: Mach

    init(mach: Mach) {
        self.mach = mach
    }

    private func getObjectsOffsetsFromList(section list: Section?) -> [Int] {
        guard let objcList = list else { return [] }

        let objectVMAddresses: [PointerType] = mach.data.get(fromRange: objcList.range.intRange)
        let objectFileAddresses: [Int] = objectVMAddresses.map(mach.fileOffset(fromVmOffset:))
        return objectFileAddresses
    }

    func getObjectsFromList<Element>(section list: Section?, creator: (Int) -> Element) -> [Element] {
        getObjectsOffsetsFromList(section: list).map { creator($0) }
    }

    func create(offset: Int) -> ObjcClass {
        ObjcClassImpl<Me>(mach: mach, offset: offset)
    }

    func create(offset: Int) -> ObjcCategory {
        ObjcCategoryImpl<Me>(mach: mach, offset: offset)
    }

    func create(offset: Int) -> ObjcProtocol {
        ObjcProtocolImpl<Me>(mach: mach, offset: offset)
    }
}
