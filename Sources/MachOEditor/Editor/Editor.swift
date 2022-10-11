//
// Created by Mengyu Li on 2020/7/30.
//

import Foundation
import MachOParser

public struct Editor { private init() {} }

public extension Editor {
    static func erase(filePath prefixes: [String], replacement: String = "", macho url: URL) throws -> Data {
        let image = try Image.load(url: url)
        var mutableImage = MutableImage(image: image)
        try mutableImage.update { (mach: inout MutableMach) throws in
            try mach.erase(filePaths: prefixes, replacement: replacement)
        }
        return mutableImage.data
    }
}

public extension Editor {
    static func replace(keyword: String, replacement: String, replaceStyle: ReplaceStyle, macho url: URL) throws -> Data {
        let image = try Image.load(url: url)
        var mutableImage = MutableImage(image: image)
        try mutableImage.update { (mach: inout MutableMach) throws in
            try mach.replace(keyword: keyword, replacement: replacement, replaceStyle: replaceStyle)
        }
        return mutableImage.data
    }
}

public extension Editor {
    static func eraseSymbolTable(macho url: URL) throws -> Data {
        let image = try Image.load(url: url)
        var mutableImage = MutableImage(image: image)
        try mutableImage.update { (mach: inout MutableMach) in
            try mach.eraseSymbolTable()
        }
        return mutableImage.data
    }
}
