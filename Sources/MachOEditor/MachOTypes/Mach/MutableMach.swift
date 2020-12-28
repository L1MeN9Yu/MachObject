//
// Created by Mengyu Li on 2020/7/29.
//

import Foundation
@_implementationOnly import MachCore
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

    mutating func eraseSwiftInfo() throws {
        let mach = try Mach(data: data)
        let sectionNames = [
            "__swift5_typeref",
            "__swift5_reflstr",
        ]
        sectionNames.compactMap {
            mach.section(of: "__TEXT", name: $0)
        }.forEach {
            data.nullify(range: $0.range.intRange)
        }
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
