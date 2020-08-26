//
// Created by Mengyu Li on 2020/8/4.
//

import Foundation

struct SwiftParser { private init() {} }

private extension SwiftParser {
    static var mangledNameMap: [String: String] = [
        "0x02f36d": "Int32",
        "0x02cd6d": "Int16",
        "0x027b6e": "UInt16",
        "0x022b6c": "UInt32",
        "0x02b98502": "Int64",
        "0x02418a02": "UInt64",
        "0x02958802": "CGFloat",
    ]
    static var cacheNominalOffsetMap: [Int: String] = [:] // used for name demangle
}

extension SwiftParser {
    static func parseProtos(mach: Mach) -> [SwiftMeta.ProtocolType] {
        var protocols = [SwiftMeta.ProtocolType]()
        guard let protosSection = mach.section(of: Section.SegmentName.__TEXT, name: Section.Name.__swift5_protos) else {
            return protocols
        }

        for index in 0..<protosSection.count {
            let indexOffset = index * protosSection.align + protosSection.range.lowerBound
            let localOffset: Int32 = mach.data.get(atOffset: Int(indexOffset))
            let protocolDescriptorOffset = Int(indexOffset) + Int(localOffset)
            let protocolDescriptor: SwiftMeta.ProtocolDescriptor = mach.data.get(atOffset: protocolDescriptorOffset)
            let nameOffset = protocolDescriptor.nameOffset(start: protocolDescriptorOffset)
            let name = mach.data.get(atOffset: nameOffset)

            func parseAssociatedTypeNames() -> String {
                if protocolDescriptor.associatedTypeNames != 0 {
                    let associatedTypeNamesOffset = protocolDescriptor.associatedTypeNamesOffset(start: protocolDescriptorOffset)
                    let associatedTypeNames = mach.data.get(atOffset: associatedTypeNamesOffset)
                    return associatedTypeNames
                } else {
                    return ""
                }
            }

            let associatedTypeNames = parseAssociatedTypeNames()
            let `protocol` = SwiftMeta.ProtocolType(
                raw: protocolDescriptor, offset: protocolDescriptorOffset,
                name: name, associatedTypeNames: associatedTypeNames
            )
            protocols.append(`protocol`)
        }
        return protocols
    }

    static func parseTypes(mach: Mach) {
        guard let typesSection = mach.section(of: Section.SegmentName.__TEXT, name: Section.Name.__swift5_types) else {
            return
        }
        for index in 0..<typesSection.count {
            let indexOffset = index * typesSection.align + typesSection.range.lowerBound
            let localOffset: Int32 = mach.data.get(atOffset: Int(indexOffset))
            let nominalDescriptorOffset = Int(indexOffset) + Int(localOffset)
            let flags: UInt32 = mach.data.get(atOffset: nominalDescriptorOffset)
            let contextDescriptorFlags = SwiftMeta.ContextDescriptorFlags(value: flags)
            guard let kind = contextDescriptorFlags.kind else { break }
            switch kind {
            case .class:
                let classDescriptor: SwiftMeta.ClassDescriptor = mach.data.get(atOffset: nominalDescriptorOffset)
                let nameOffset = classDescriptor.nameOffset(start: nominalDescriptorOffset)
                let name = mach.data.get(atOffset: nameOffset)
                var superClassName: String?
                if let superclassTypeOffset = classDescriptor.superclassTypeOffset(start: nominalDescriptorOffset) {
                    let superclassType = mach.data.get(atOffset: superclassTypeOffset)
                    if !superclassType.isEmpty {
                        if superclassType.hasPrefix("0x") {
                            superClassName = mangledNameMap[superclassType] ?? superclassType
                        } else {
                            superClassName = superclassType
                        }
                    }
                }
                cacheNominalOffsetMap[nominalDescriptorOffset] = name
                let fieldDescriptorOffset = classDescriptor.fieldDescriptorOffset(start: nominalDescriptorOffset)
                let fieldDescriptor: SwiftMeta.FieldDescriptor = mach.data.get(atOffset: fieldDescriptorOffset)
                let mangledTypeNameOffset = fieldDescriptor.mangledTypeNameOffset(start: fieldDescriptorOffset)
                let mangledTypeName = mach.data.get(atOffset: mangledTypeNameOffset, fallbackConvert: true)
                let fieldRecordOffsetStart = fieldDescriptor.fieldRecordsOffset(start: fieldDescriptorOffset)
                var fields = [SwiftMeta.Field]()
                for fieldRecordIndex in 0..<Int(fieldDescriptor.numFields) {
                    let fieldRecordOffset = fieldRecordOffsetStart + fieldRecordIndex * MemoryLayout<SwiftMeta.FieldRecord>.size
                    let fieldRecord: SwiftMeta.FieldRecord = mach.data.get(atOffset: fieldRecordOffset)
                    let mangledTypeNameOffset = fieldRecord.mangledTypeNameOffset(start: fieldRecordOffset)
                    let fieldNameOffset = fieldRecord.fieldNameOffset(start: fieldRecordOffset)
                    let mangledTypeName = mach.data.get(atOffset: mangledTypeNameOffset)
                    let fieldName = mach.data.get(atOffset: fieldNameOffset)
                    let typeName = SwiftDemangler.type(of: mangledTypeName)
                    let field = SwiftMeta.Field(name: fieldName, type: typeName, mangledTypeNameOffset: mangledTypeNameOffset)
                    fields.append(field)
                }
                if !mangledTypeName.isEmpty && !mangledNameMap.keys.contains(mangledTypeName) {
                    mangledNameMap[mangledTypeName] = name
                }
            case .struct:
                let structDescriptor: SwiftMeta.StructDescriptor = mach.data.get(atOffset: nominalDescriptorOffset)
                let nameOffset = structDescriptor.nameOffset(start: nominalDescriptorOffset)
                let name = mach.data.get(atOffset: nameOffset)
                cacheNominalOffsetMap[nominalDescriptorOffset] = name
            case .enum:
                let enumDescriptor: SwiftMeta.EnumDescriptor = mach.data.get(atOffset: nominalDescriptorOffset)
                let nameOffset = enumDescriptor.nameOffset(start: nominalDescriptorOffset)
                let name = mach.data.get(atOffset: nameOffset)
                cacheNominalOffsetMap[nominalDescriptorOffset] = name
            default:
                let nominalDescriptor: SwiftMeta.NominalDescriptor = mach.data.get(atOffset: nominalDescriptorOffset)
                let nameOffset = nominalDescriptor.nameOffset(start: nominalDescriptorOffset)
                let name = mach.data.get(atOffset: nameOffset)
                cacheNominalOffsetMap[nominalDescriptorOffset] = name
            }
        }
    }
}
