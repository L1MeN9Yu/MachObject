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
        guard let section = mach.section(of: Section.SegmentName.__TEXT, name: Section.Name.__cstring) else {
            throw Error.sectionNotFound(name: Section.SegmentName.__TEXT)
        }
        data.replaceString(range: section.range.intRange, filter: { (string: String) -> Bool in
            string.utf8.count >= replacement.utf8.count &&
                prefixes.contains(where: { prefix in string.starts(with: prefix) })
        }, mapping: { _ in replacement })
    }
}

extension MutableMach {
    mutating func replace(keyword: String, replacement: String, replaceStyle: ReplaceStyle) throws {
        guard !keyword.isEmpty else { return }
        guard keyword.utf8.count >= replacement.utf8.count else { throw Error.replaceStringLength }
        let mach = try Mach(data: data)
        guard let section = mach.section(of: Section.SegmentName.__TEXT, name: Section.Name.__cstring) else {
            throw Error.sectionNotFound(name: Section.SegmentName.__TEXT)
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
