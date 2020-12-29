//
// Created by Mengyu Li on 2020/12/29.
//

import Foundation
import MachOParser

struct SymbolManglingMap {
    typealias ObfuscationTriePair = (unobfuscated: Trie, obfuscated: Trie)

    typealias TriePerCpu = [CpuId: ObfuscationTriePair]

    let selectors: [String: String]

    let classNames: [String: String]

    let exportTrieObfuscationMap: [URL: TriePerCpu]
}
