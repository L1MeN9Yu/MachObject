//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation
import MachO

public extension Mach.Header {
    enum FileType {
        case object
        case execute
        case fvmlib
        case core
        case preload
        case dylib
        case dylinker
        case bundle
        case dylibStub
        case dsym
        case kextBundle
        case fileset

        init(fileType: UInt32) throws {
            switch Int32(fileType) {
            case MH_OBJECT: self = .object
            case MH_EXECUTE: self = .execute
            case MH_FVMLIB: self = .fvmlib
            case MH_CORE: self = .core
            case MH_PRELOAD: self = .preload
            case MH_DYLIB: self = .dylib
            case MH_DYLINKER: self = .dylinker
            case MH_BUNDLE: self = .bundle
            case MH_DYLIB_STUB: self = .dylibStub
            case MH_DSYM: self = .dsym
            case MH_KEXT_BUNDLE: self = .kextBundle
            case MH_FILESET: self = .fileset
            default: throw Mach.Error.fileType(fileType)
            }
        }
    }
}

extension Mach.Header.FileType: RawRepresentable {
    public typealias RawValue = UInt32

    public init?(rawValue: RawValue) {
        do {
            try self.init(fileType: rawValue)
        } catch {
            return nil
        }
    }

    public var rawValue: RawValue { fatalError("rawValue has not been implemented") }
}
