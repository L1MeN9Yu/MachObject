//
// Created by Mengyu Li on 2020/7/23.
//

import Foundation
import MachO

// MARK: - Define

public struct Image {
    public let url: URL
    public let content: Content

    public init(url: URL) throws {
        self.url = url
        let data = try Data(contentsOf: url, options: .mappedIfSafe)
        let magic = data.magic
        switch magic {
        case FAT_CIGAM, FAT_MAGIC:
            content = try .fat(Fat(data: data))
        case MH_MAGIC, MH_MAGIC_64:
            content = try .mach(Mach(data: data))
        default:
            throw Error.unsupported(url: url, magic: magic)
        }
    }
}

// MARK: - Initialize

public extension Image {
    static func load(url: URL) throws -> Image {
        try Image(url: url)
    }
}

public extension Image {
    func eachMach(block: (Mach) -> ()) {
        switch content {
        case let .fat(fat):
            fat.architectures.forEach { block($0.mach) }
        case let .mach(mach):
            block(mach)
        }
    }
}
