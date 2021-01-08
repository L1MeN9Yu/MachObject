//
// Created by Mengyu Li on 2021/1/8.
//

import Foundation

struct ObfuscateConfig: Codable {
    let machoList: [MachOConfig]
}

extension ObfuscateConfig {
    struct MachOConfig: Codable {
        let classMapList: [ClassMap]
    }
}

extension ObfuscateConfig {
    struct ClassMap: Codable {
        let original: String
        let obfuscated: String
    }
}
