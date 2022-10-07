//
// Created by Mengyu Li on 2020/7/23.
//

import CodeSignParser
import Foundation
import MachO

// MARK: - Define

public struct Mach {
    public let data: Data
    public let swapped: Bool
    public let header: Header
    public let allLoadCommands: [LoadCommand]
    public private(set) lazy var segments: [Segment] = {
        var segments = [Segment]()
        if let segmentLCList: [SegmentLC] = loadCommands() {
            segments.append(contentsOf: segmentLCList.map { Segment(machData: data, segmentLC: $0) })
        }
        if let segment64LCList: [Segment64LC] = loadCommands() {
            segments.append(contentsOf: segment64LCList.map { Segment(machData: data, segment64LC: $0) })
        }

        return segments
    }()

    public private(set) lazy var sections: [Section] = {
        segments.reduce([Section]()) { (result: [Section], segment: Segment) in
            result + segment.sections
        }
    }()

    public init(data: Data) throws {
        let magic = data.magic
        switch magic {
        case MH_MAGIC, MH_CIGAM:
            try self.init(data32: data, swapped: magic == MH_CIGAM)
        case MH_MAGIC_64, MH_CIGAM_64:
            try self.init(data64: data, swapped: magic == MH_CIGAM_64)
        default:
            throw Error.magic(magic)
        }
    }
}

private extension Mach {
    init(data32: Data, swapped: Bool) throws {
        data = data32
        self.swapped = swapped
        let header: mach_header = data32.get(atOffset: 0)
        self.header = try ._32(Header._32_(header: header))
        allLoadCommands = Self.parseLoadCommand(
            data: data32, count: header.ncmds, headerSize: MemoryLayout<mach_header>.size
        )
    }

    init(data64: Data, swapped: Bool) throws {
        data = data64
        self.swapped = swapped
        let header: mach_header_64 = data64.get(atOffset: 0)
        self.header = try ._64(Header._64_(header: header))
        allLoadCommands = Self.parseLoadCommand(
            data: data64, count: header.ncmds, headerSize: MemoryLayout<mach_header_64>.size
        )
    }
}

public extension Mach {
    func section(of segmentName: SegmentName, name: SectionName) -> Section? {
        var mutableSelf = self
        return mutableSelf.sections.first { (section: Section) -> Bool in
            section.segmentName == segmentName && section.name == name
        }
    }

    func section(of segmentName: String, name: String) -> Section? {
        var mutableSelf = self
        return mutableSelf.sections.first { (section: Section) -> Bool in
            section.segmentName == segmentName && section.name == name
        }
    }

    func sectionContent<T: SectionContent>() -> T? {
        var mutableSelf = self
        guard let section = (mutableSelf.sections.first {
            $0.segmentName == T.segmentName && $0.name == T.sectionName
        })
        else { return nil }
        return T(machoData: data, range: section.range)
    }
}

// MARK: - Readable Property

public extension Mach {
    var fileType: Header.FileType { header.fileType }

    var cpuType: CPUType { header.cpuType }

    var flags: Set<Header.Flag> { header.flags }
}

public extension Mach {
    func loadCommands<T: LoadCommand>() -> [T]? { allLoadCommands.compactMap { $0 as? T } }

    func loadCommand<T: LoadCommand>() -> T? { loadCommands()?.first }
}

public extension Mach {
    var codeSignature: CodeSignature? {
        guard let codeSignatureLC: CodeSignatureLC = loadCommand() else { return nil }

        return CodeSignature(machData: data, offset: Int(codeSignatureLC.dataOffset))
    }

    var stringTable: StringTable? {
        StringTable(mach: self)
    }

    var exports: [String] {
        guard let dyldInfoOnlyLC: DyldInfoOnlyLC = loadCommand() else { return [] }
        let offset = Int(dyldInfoOnlyLC.exportOffset)
        let trie = Trie(data: data, rootNodeOffset: offset)
        return trie.exportedLabelStrings
    }

    var dyldInfo: DyldInfo? {
        if let dyldInfoOnlyLC: DyldInfoOnlyLC = loadCommand() {
            return DyldInfo(dyldInfoOnlyLC: dyldInfoOnlyLC)
        }

        if let dyldInfoLC: DyldInfoLC = loadCommand() {
            return DyldInfo(dyldInfoLC: dyldInfoLC)
        }
        return nil
    }

    var importStack: ImportStack {
        guard let dyldInfo = dyldInfo else { return [] }

        var importStack = ImportStack()

        if !dyldInfo.bind.isEmpty {
            importStack.add(opcodesData: data, range: dyldInfo.bind.intRange, weakly: false)
        }
        if !dyldInfo.weakBind.isEmpty {
            importStack.add(opcodesData: data, range: dyldInfo.weakBind.intRange, weakly: true)
        }
        if !dyldInfo.lazyBind.isEmpty {
            importStack.add(opcodesData: data, range: dyldInfo.lazyBind.intRange, weakly: false)
        }
        importStack.resolveMissingDylibOrdinals()
        return importStack
    }
}
