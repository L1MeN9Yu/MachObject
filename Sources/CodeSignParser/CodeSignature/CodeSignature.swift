//
// Created by Mengyu Li on 2020/8/25.
//

import Foundation
import MachCore

public struct CodeSignature {
    public let entitlements: String?
    public let codeDirectoryList: [CodeDirectory]
    public let cmsSignature: String?

    public init(codeSignatureData: Data) {
        self.init(machData: codeSignatureData, offset: 0)
    }

    public init(machData: Data, offset: Int) {
        let superBlob: SuperBlob = machData.get(atOffset: offset)

        var entitlementsString: String?
        var codeDirectoryList = [CodeDirectory]()
        var cmsSignatureString: String?

        for index in 0..<superBlob.count.byteSwapped {
            let blobIndexOffset = offset + MemoryLayout<SuperBlob>.size + MemoryLayout<BlobIndex>.size * Int(index)
            let blobIndex: BlobIndex = machData.get(atOffset: blobIndexOffset)
            let slot = Slot(rawValue: blobIndex.type.byteSwapped)
            switch slot {
            case .codeDirectory:
                let cd = Self.codeDirectory(machData: machData, offset: offset, blobIndex: blobIndex)
                codeDirectoryList.append(cd)
            case .entitlements:
                entitlementsString = Self.entitlements(machData: machData, offset: offset, blobIndex: blobIndex)
            case .alternate:
                let cd = Self.codeDirectory(machData: machData, offset: offset, blobIndex: blobIndex)
                codeDirectoryList.append(cd)
            case .signature:
                cmsSignatureString = Self.cmsSignature(machData: machData, offset: offset, blobIndex: blobIndex)
            default:
                break
            }
        }

        cmsSignature = cmsSignatureString
        self.codeDirectoryList = codeDirectoryList
        entitlements = entitlementsString
    }

    public init(machPointer: UnsafeRawPointer, offset: Int) {
        let superBlob: SuperBlob = machPointer.advanced(by: offset).get()

        var entitlementsString: String?
        var codeDirectoryList = [CodeDirectory]()
        var cmsSignatureString: String?

        for index in 0..<superBlob.count.byteSwapped {
            let blobIndexOffset = offset + MemoryLayout<SuperBlob>.size + MemoryLayout<BlobIndex>.size * Int(index)
            let blobIndex: BlobIndex = machPointer.advanced(by: blobIndexOffset).get()
            let slot = Slot(rawValue: blobIndex.type.byteSwapped)
            switch slot {
            case .codeDirectory:
                let cd = Self.codeDirectory(machPointer: machPointer, offset: offset, blobIndex: blobIndex)
                codeDirectoryList.append(cd)
            case .entitlements:
                entitlementsString = Self.entitlements(machPointer: machPointer, offset: offset, blobIndex: blobIndex)
            case .alternate:
                let cd = Self.codeDirectory(machPointer: machPointer, offset: offset, blobIndex: blobIndex)
                codeDirectoryList.append(cd)
            case .signature:
                cmsSignatureString = Self.cmsSignature(machPointer: machPointer, offset: offset, blobIndex: blobIndex)
            default:
                break
            }
        }

        cmsSignature = cmsSignatureString
        self.codeDirectoryList = codeDirectoryList
        entitlements = entitlementsString
    }
}

private extension CodeSignature {
    static func codeDirectory(machData: Data, offset: Int, blobIndex: BlobIndex) -> CodeDirectory {
        let begin = blobIndex.offset.byteSwapped
        let blobOffset = Int(begin) + offset
        let codeDirectory: CodeDirectoryBlob = machData.get(atOffset: blobOffset)
        let version = codeDirectory.version.byteSwapped
        let hashType = codeDirectory.hashType.byteSwapped

        let identOffset = Int(codeDirectory.identOffset.byteSwapped) + blobOffset
        let ident = machData.get(atOffset: identOffset)

        guard version >= 0x20200 else {
            return CodeDirectory(version: version, ident: ident, team: nil, hashType: hashType)
        }

        let teamOffset = Int(codeDirectory.teamOffset.byteSwapped) + blobOffset
        let team = machData.get(atOffset: teamOffset)

        return CodeDirectory(version: version, ident: ident, team: team, hashType: hashType)
    }

    static func codeDirectory(machPointer: UnsafeRawPointer, offset: Int, blobIndex: BlobIndex) -> CodeDirectory {
        let begin = blobIndex.offset.byteSwapped
        let blobOffset = Int(begin) + offset
        let codeDirectory: CodeDirectoryBlob = machPointer.advanced(by: blobOffset).get()
        let version = codeDirectory.version.byteSwapped
        let hashType = codeDirectory.hashType.byteSwapped

        let identOffset = Int(codeDirectory.identOffset.byteSwapped) + blobOffset
        let ident: String = machPointer.advanced(by: identOffset).getString()

        guard version >= 0x20200 else {
            return CodeDirectory(version: version, ident: ident, team: nil, hashType: hashType)
        }

        let teamOffset = Int(codeDirectory.teamOffset.byteSwapped) + blobOffset
        let team: String = machPointer.advanced(by: teamOffset).getString()

        return CodeDirectory(version: version, ident: ident, team: team, hashType: hashType)
    }

    static func entitlements(machData: Data, offset: Int, blobIndex: BlobIndex) -> String? {
        let begin = blobIndex.offset.byteSwapped
        let blobOffset = Int(begin) + offset
        let blob: Blob = machData.get(atOffset: blobOffset)
        let length = blob.length
        let count = Int(length.byteSwapped)
        let sub = machData.subdata(in: Range<Int>(offset: blobOffset + MemoryLayout<Blob>.stride, count: count - MemoryLayout<Blob>.stride))
        return String(data: sub, encoding: .utf8)
    }

    static func entitlements(machPointer: UnsafeRawPointer, offset: Int, blobIndex: BlobIndex) -> String? {
        let begin = blobIndex.offset.byteSwapped
        let blobOffset = Int(begin) + offset
        let blob: Blob = machPointer.advanced(by: blobOffset).get()
        let count = Int(blob.length.byteSwapped)
        let sub = Data(bytes: machPointer.advanced(by: blobOffset + MemoryLayout<Blob>.stride), count: count - MemoryLayout<Blob>.stride)
        return String(data: sub, encoding: .utf8)
    }

    static func cmsSignature(machData: Data, offset: Int, blobIndex: BlobIndex) -> String? {
        let begin = blobIndex.offset.byteSwapped
        let blobOffset = Int(begin) + offset
        let blob: Blob = machData.get(atOffset: blobOffset)
        let sub = machData.subdata(in: Range<Int>(offset: blobOffset + MemoryLayout<Blob>.stride, count: Int(blob.length.byteSwapped) - MemoryLayout<Blob>.stride))
        guard let x509 = try? X509Certificate(data: sub) else { return nil }
        return x509.description
    }

    static func cmsSignature(machPointer: UnsafeRawPointer, offset: Int, blobIndex: BlobIndex) -> String? {
        let begin = blobIndex.offset.byteSwapped
        let blobOffset = Int(begin) + offset
        let blob: Blob = machPointer.advanced(by: blobOffset).get()
        let sub = Data(bytes: machPointer.advanced(by: blobOffset + MemoryLayout<Blob>.stride), count: Int(blob.length.byteSwapped) - MemoryLayout<Blob>.stride)
        guard let x509 = try? X509Certificate(data: sub) else { return nil }
        return x509.description
    }
}
