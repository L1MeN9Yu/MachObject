//
// Created by Mengyu Li on 2020/7/29.
//

import Foundation
@_implementationOnly import MachCore
@_implementationOnly import MachLog
import MachOObjcParser
import MachOParser

struct MutableMach {
    private(set) var data: Data

    init(mach: Mach) { data = mach.data }
}

// MARK: - Erase

extension MutableMach {
    mutating func erase(filePaths prefixes: [String], replacement: String) throws {
        guard !prefixes.isEmpty else { return }
        let mach = try Mach(data: data)
        guard let section = mach.section(of: SegmentName.__TEXT, name: SectionName.__cstring) else {
            throw Error.sectionNotFound(name: SegmentName.__TEXT)
        }
        data.replaceString(range: section.range.intRange, filter: { (string: String) -> Bool in
            string.utf8.count >= replacement.utf8.count &&
                prefixes.contains(where: { prefix in string.starts(with: prefix) })
        }, mapping: { _ in replacement })
    }

    mutating func eraseSymbolTable() throws {
        let mach = try Mach(data: data)
        guard let symtab: SymbolTableLC = mach.loadCommand() else { return }
        let range = Range<UInt64>(offset: UInt64(symtab.stringTableOffset), count: UInt64(symtab.stringTableSize))
        data.nullify(range: range.intRange)
    }
}

extension MutableMach {
    mutating func replace(keyword: String, replacement: String, replaceStyle: ReplaceStyle) throws {
        guard !keyword.isEmpty else { return }
        guard keyword.utf8.count >= replacement.utf8.count else { throw Error.replaceStringLength }
        let mach = try Mach(data: data)
        guard let section = mach.section(of: SegmentName.__TEXT, name: SectionName.__cstring) else {
            throw Error.sectionNotFound(name: SegmentName.__TEXT)
        }
        let filter: (String) -> Bool = { string in
            string.contains(keyword)
        }
        let mapping: (String) -> String = { originalString in
            switch replaceStyle {
            case .onlyKeyword:
                return originalString.replacingOccurrences(of: keyword, with: replacement)
            case .wholeString:
                return replacement
            }
        }
        data.replaceString(
            range: section.range.intRange,
            filter: filter,
            mapping: mapping
        )
    }
}

extension MutableMach {
    static let AAA = "YDDictWord"

    mutating func obfuscateObjC() throws {
        let mach = try Mach(data: data)

        if let methTypeSection = mach.section(of: .__TEXT, name: .__objc_methtype) {
            data.replaceString(range: methTypeSection.range.intRange) { original in
                if original.contains(Self.AAA) {
                    let target = original.replacingOccurrences(of: "YD", with: "DY")
                    logger.debug("\(original) => \(target)")
                    return target
                }
                return original
            }
        }

        mach.objcClasses
            .flatMap(\.properties)
            .forEach { (property: ObjcProperty) in
                var attrs = property.attributeValues
                let typename = property.typeAttribute
                if typename.contains(Self.AAA) {
                    logger.debug("attrs:\(attrs) => \(typename)")
                    let newTypename = typename.replacingOccurrences(of: "YD", with: "DY")
                    attrs[0] = newTypename
                    let newAttrsString = attrs.joined(separator: ",")
                    data.replaceWithPadding(range: property.attributes.range, string: newAttrsString)
                }
            }

        let classNamesInData = mach.classNamesInData
        classNamesInData.forEach { (mangledObjcClassNameInData: MangledObjcClassNameInData) in
            let original = mangledObjcClassNameInData.value
            if original.hasPrefix(Self.AAA) {
                let target = "DY\(original[original.index(original.startIndex, offsetBy: 2)..<original.endIndex])"
                logger.info("\(original) => \(target)")
                data.replaceWithPadding(range: mangledObjcClassNameInData.range, string: target)
            }
        }
    }
}
