//
// Created by Mengyu Li on 2020/8/24.
//

import Foundation

struct CodeSignParser { private init() {} }

extension CodeSignParser {
    static func parse(mach: Mach) -> (Data?, Data?) {
        // todo codeDirectoryData
        let codeDirectoryData: Data? = nil
        var entitlementsData: Data?
        guard let codeSignatureLC = (mach.loadCommands.first { $0 is CodeSignatureLC }) as? CodeSignatureLC else {
            return (codeDirectoryData, entitlementsData)
        }
        let superBlob: SuperBlob = mach.data.get(atOffset: Int(codeSignatureLC.dataOffset))

        for index in 0..<superBlob.count.byteSwapped {
            let offset = codeSignatureLC.dataOffset + UInt32(MemoryLayout<SuperBlob>.size) + UInt32(MemoryLayout<BlobIndex>.size) * index
            let blobIndex: BlobIndex = mach.data.get(atOffset: Int(offset))
            let slot = Slot(rawValue: blobIndex.type.byteSwapped)
            switch slot {
            case .codeDirectory:
                break
            case .entitlements:
                let begin = blobIndex.offset.byteSwapped
                let blobOffset = Int(begin + codeSignatureLC.dataOffset)
                let blob: Blob = mach.data.get(atOffset: blobOffset)
                let sub = mach.data.subdata(in: Range<Int>(offset: blobOffset + MemoryLayout<Blob>.size, count: Int(blob.length.byteSwapped) - MemoryLayout<Blob>.size))
                entitlementsData = sub
            default:
                break
            }
        }
        return (codeDirectoryData, entitlementsData)
    }
}

private struct BlobIndex {
    let type: UInt32
    let offset: UInt32
}

private struct Blob {
    let magic: UInt32
    let length: UInt32
}

private struct SuperBlob {
    let blob: Blob
    let count: UInt32
}

private struct CodeDirectory {
    let magic: UInt32 /* magic number (CSMAGIC_CODEDIRECTORY) */
    let length: UInt32 /* total length of CodeDirectory blob */
    let version: UInt32 /* compatibility version */
    let flags: UInt32 /* setup and mode flags */
    let hashOffset: UInt32 /* offset of hash slot element at index zero */
    let identOffset: UInt32 /* offset of identifier string */
    let nSpecialSlots: UInt32 /* number of special hash slots */
    let nCodeSlots: UInt32 /* number of ordinary (code) hash slots */
    let codeLimit: UInt32 /* limit to main image signature range */
    let hashSize: UInt8 /* size of each hash in bytes */
    let hashType: UInt8 /* type of hash (cdHashType* constants) */
    let spare1: UInt8 /* unused (must be zero) */
    let pageSize: UInt8 /* log2(page size in bytes); 0 => infinite */
    let spare2: UInt32 /* unused (must be zero) */
    // char end_earliest[0];

    /* Version 0x20100 */
    let scatterOffset: UInt32 /* offset of optional scatter vector */
    // char end_withScatter[0];

    /* Version 0x20200 */
    let teamOffset: UInt32 /* offset of optional team identifier */
    // char end_withTeam[0];

    /* Version 0x20300 */
    let spare3: UInt32 /* unused (must be zero) */
    let codeLimit64: UInt64 /* limit to main image signature range, 64 bits */
    // char end_withCodeLimit64[0];

    /* Version 0x20400 */
    let execSegBase: UInt64 /* offset of executable segment */
    let execSegLimit: UInt64 /* limit of executable segment */
    let execSegFlags: UInt64 /* executable segment flags */
    // char end_withExecSeg[0];

    /* followed by dynamic content as located by offset fields above */
}

private enum Slot: UInt32 {
    case codeDirectory = 0x00000
    case info = 0x00001
    case requirements = 0x00002
    case resourcesDirectory = 0x00003
    case application = 0x00004
    case entitlements = 0x00005
    case alternate = 0x01000
    case signature = 0x10000 // CMS Signature
}
