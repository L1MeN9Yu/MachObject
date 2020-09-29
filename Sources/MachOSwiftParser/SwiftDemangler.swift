//
// Created by Mengyu Li on 2020/8/4.
//

import Foundation

struct SwiftDemangler { private init() {} }

extension SwiftDemangler {
    static func canDemangleFromRuntime(_ name: String) -> Bool {
        name.hasPrefix("So") || name.hasPrefix("$So") || name.hasPrefix("_$So") || name.hasPrefix("_T")
    }

    static func demangledFromRuntime(name: String) -> String {
        let fixedName: String = name.hasPrefix("So") ? "$s" + name : name
        guard canDemangleFromRuntime(fixedName) || canDemangleFromRuntime(name) else { return name }

        let bufLen: Int = 128 // may be 128 is big enough
        var buf = [Int8](repeating: 0, count: bufLen)
        let retLen = _getDemangledName(fixedName, &buf, bufLen)

        if retLen > 0 && retLen < bufLen {
            let resultBuf: [UInt8] = buf[0..<retLen].map { UInt8($0) }
            let retStr = String(bytes: resultBuf, encoding: .utf8)
            return retStr?.replacingOccurrences(of: "__C.", with: "") ?? name
        }
        return name
    }

    static func type(of name: String) -> String {
        if canDemangleFromRuntime(name) { return demangledFromRuntime(name: name) }
        guard name.isASCII else { return name }
        guard let type = _getTypeByMangledNameInContext(name, name.count, nil, nil) else {
            return name
        }
        let typeName = String(describing: type)
        return typeName
    }

    static func removeModulePrefix(typeName: String) -> String {
        if let idx = typeName.firstIndex(of: ".") {
            let useIdx = typeName.index(after: idx)
            return String(typeName.suffix(from: useIdx))
        }

        return typeName
    }
}

@_silgen_name("swift_getTypeByMangledNameInContext")
func _getTypeByMangledNameInContext(_ name: UnsafePointer<UInt8>,
                                    _ nameLength: Int,
                                    _ genericContext: UnsafeRawPointer?,
                                    _ genericArguments: UnsafeRawPointer?) -> Any.Type?

@_silgen_name("swift_demangle_getDemangledName")
func _getDemangledName(_ name: UnsafePointer<Int8>?, _ output: UnsafeMutablePointer<Int8>?, _ len: Int) -> Int
