//
// Created by Mengyu Li on 2020/12/29.
//

import Foundation
import MachCore

final class RealWordsMangler: SymbolMangling {
    private let exportTrieMangler: RealWordsExportTrieMangling

    init(exportTrieMangler: RealWordsExportTrieMangling) {
        self.exportTrieMangler = exportTrieMangler
    }

    func mangleSymbols(_ symbols: ObfuscationSymbols) -> SymbolManglingMap {
        mangleSymbols(symbols, sentenceGenerator: EnglishSentenceGenerator())
    }

    func mangleSymbols(_ symbols: ObfuscationSymbols, sentenceGenerator: SentenceGenerator) -> SymbolManglingMap {
        let nonSettersManglingMap: [(String, String)] =
            symbols.nonSettersManglingMap(sentenceGenerator: sentenceGenerator)

        let settersManglingMap: [(String, String)] =
            symbols.settersManglingMap(matchingToNonSetterManglingMap: nonSettersManglingMap)

        let selectorsManglingMap: [(String, String)] =
            nonSettersManglingMap + settersManglingMap

        let classManglingMap: [(String, String)] =
            symbols.classManglingMap(sentenceGenerator: sentenceGenerator)

        let exportTriesManglingMap =
            symbols.exportTriesManglingMap(exportTrieMangler: exportTrieMangler)

        return SymbolManglingMap(
            selectors: Dictionary(uniqueKeysWithValues: selectorsManglingMap),
            classNames: Dictionary(uniqueKeysWithValues: classManglingMap),
            exportTrieObfuscationMap: exportTriesManglingMap
        )
    }
}

private extension ObfuscationSymbols {
    func nonSettersManglingMap(sentenceGenerator: SentenceGenerator) -> [(String, String)] {
        let mangledSelectorsBlacklist = (Array(blackList.selectors) + Array(whiteList.selectors)).unique
        let nonSetterManglingEntryProvider: (String) -> (String, String)? = { selector in
            while let randomSelector = sentenceGenerator.getUniqueSentence(length: selector.utf8.count) {
                if !mangledSelectorsBlacklist.contains(randomSelector) {
                    return (selector, randomSelector)
                }
            }
            return nil
        }
        return whiteList
            .selectors
            .filter { !$0.isSetter }
            .compactMap(nonSetterManglingEntryProvider)
    }

    func settersManglingMap(matchingToNonSetterManglingMap nonSetterManglingMap: [(String, String)]) -> [(String, String)] {
        let setterManglingEntryProvider: (String) -> (String, String)? = { setter in
            guard let getter = setter.getterFromSetter,
                  let mangledGetter = nonSetterManglingMap.first(where: { $0.0 == getter })?.1,
                  let mangledSetter = mangledGetter.setterFromGetter
            else {
                return nil
            }
            return (setter, mangledSetter)
        }
        return whiteList
            .selectors
            .filter(\.isSetter)
            .compactMap(setterManglingEntryProvider)
    }

    func classManglingMap(sentenceGenerator: SentenceGenerator) -> [(String, String)] {
        let mangledClassesBlacklist = (Array(blackList.classes) + Array(whiteList.classes)).unique
        let classManglingEntryProvider: (String) -> (String, String)? = { className in
            while let randomClassName = sentenceGenerator.getUniqueSentence(length: className.utf8.count)?.capitalizedOnFirstLetter {
                if !mangledClassesBlacklist.contains(randomClassName) {
                    return (className, randomClassName)
                }
            }
            return nil
        }
        return whiteList.classes.compactMap(classManglingEntryProvider)
    }

    func exportTriesManglingMap(exportTrieMangler: RealWordsExportTrieMangling) -> [URL: SymbolManglingMap.TriePerCpu] {
        exportTriesPerCpuIdPerURL.mapValues { exportTriesPerCpuId in
            exportTriesPerCpuId.mapValues { ($0, exportTrieMangler.mangle(trie: $0)) }
        }
    }
}

private extension String {
    var isSetter: Bool {
        let prefix = "set"
        guard count >= 5,
              hasPrefix(prefix),
              hasSuffix(":")
        else {
            return false
        }
        let firstGetterLetter = self[index(startIndex, offsetBy: 3)]
        return ("A"..."Z").contains(firstGetterLetter)
    }

    var getterFromSetter: String? {
        guard isSetter else { return nil }

        let getterPart = dropFirst(3).dropLast()
        return getterPart.prefix(1).lowercased() + getterPart.dropFirst()
    }

    var setterFromGetter: String? { "set" + prefix(1).uppercased() + dropFirst(1) + ":" }
}
