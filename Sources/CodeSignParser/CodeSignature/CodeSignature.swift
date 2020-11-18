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
        self.init(machData: codeSignatureData, dataOffset: 0)
    }

    public init(machData: Data, dataOffset: Int) {
        let superBlob: SuperBlob = machData.get(atOffset: dataOffset)

        var entitlementsString: String?
        var codeDirectoryList = [CodeDirectory]()
        var cmsSignatureString: String?

        for index in 0..<superBlob.count.byteSwapped {
            let offset = dataOffset + MemoryLayout<SuperBlob>.size + MemoryLayout<BlobIndex>.size * Int(index)
            let blobIndex: BlobIndex = machData.get(atOffset: offset)
            let slot = Slot(rawValue: blobIndex.type.byteSwapped)
            switch slot {
            case .codeDirectory:
                let cd = Self.codeDirectory(machData: machData, dataOffset: dataOffset, blobIndex: blobIndex)
                codeDirectoryList.append(cd)
            case .entitlements:
                entitlementsString = Self.entitlements(machData: machData, dataOffset: dataOffset, blobIndex: blobIndex)
            case .alternate:
                let cd = Self.codeDirectory(machData: machData, dataOffset: dataOffset, blobIndex: blobIndex)
                codeDirectoryList.append(cd)
            case .signature:
                cmsSignatureString = Self.cmsSignature(machData: machData, dataOffset: dataOffset, blobIndex: blobIndex)
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
    static func codeDirectory(machData: Data, dataOffset: Int, blobIndex: BlobIndex) -> CodeDirectory {
        let begin = blobIndex.offset.byteSwapped
        let blobOffset = Int(begin) + dataOffset
        let codeDirectory: CodeDirectoryBlob = machData.get(atOffset: blobOffset)
        let version = codeDirectory.version.byteSwapped
//        let hashOffset = codeDirectory.hashOffset.byteSwapped
//        let hashSize = codeDirectory.hashSize.byteSwapped
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

    static func entitlements(machData: Data, dataOffset: Int, blobIndex: BlobIndex) -> String? {
        let begin = blobIndex.offset.byteSwapped
        let blobOffset = Int(begin) + dataOffset
        let blob: Blob = machData.get(atOffset: blobOffset)
        let sub = machData.subdata(in: Range<Int>(offset: blobOffset + MemoryLayout<Blob>.size, count: Int(blob.length.byteSwapped) - MemoryLayout<Blob>.size))
        return String(data: sub, encoding: .utf8)
    }

    static func cmsSignature(machData: Data, dataOffset: Int, blobIndex: BlobIndex) -> String? {
        let begin = blobIndex.offset.byteSwapped
        let blobOffset = Int(begin) + dataOffset
        let blob: Blob = machData.get(atOffset: blobOffset)
        let sub = machData.subdata(in: Range<Int>(offset: blobOffset + MemoryLayout<Blob>.size, count: Int(blob.length.byteSwapped) - MemoryLayout<Blob>.size))
        guard let x509 = try? X509Certificate(data: sub) else { return nil }
        return x509.description
    }
}
