//
// Created by Mengyu Li on 2021/1/7.
//

import ArgumentParser
import Foundation
import LogMan
import Zip

struct Obfuscate: ParsableCommand {
    @Argument(help: "ipa file path")
    var ipaPath: String

    @Argument(help: "ipa output file path")
    var outputPath: String

    @Argument(help: "config file path")
    var configPath: String

    func run() throws {
        logger.debug("start unzip \(ipaPath)")

        guard ipaPath != outputPath else { throw ObfuscateError.inOutDuplicate }

        let data = try Data(contentsOf: URL(fileURLWithPath: configPath))

        let config = try decode(data: data)

        let ipaURL = try URL(fileURLWithPath: prepare(ipaPath: ipaPath))
        let ipaExtension = ipaURL.pathExtension
        let destinationURL = URL(fileURLWithPath: ipaURL.path.replacingOccurrences(of: ".\(ipaExtension)", with: ""))

        try clean(url: destinationURL)

        try Zip.unzipFile(ipaURL, destination: destinationURL, overwrite: true, password: nil)

        logger.debug("unzipped to \(destinationURL.path)")

        let payloadURL = destinationURL.appendingPathComponent("Payload")

        try Zip.zipFiles(paths: [payloadURL], zipFilePath: URL(fileURLWithPath: outputPath), password: nil, progress: nil)

        logger.debug("zip ipa to \(outputPath)")
    }
}

private extension Obfuscate {
    func prepare(ipaPath: String) throws -> String {
        var newIpaPath = ipaPath
        if ipaPath.hasSuffix(".ipa") {
            let fileManager = FileManager.default
            newIpaPath = ipaPath.replacingOccurrences(of: ".ipa", with: ".zip")
            if fileManager.fileExists(atPath: newIpaPath) {
                try fileManager.removeItem(atPath: newIpaPath)
            }
            try fileManager.copyItem(atPath: ipaPath, toPath: newIpaPath)
        }
        return newIpaPath
    }

    func clean(url: URL) throws {
        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
        }

        try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
    }

    func decode(data: Data) throws -> ObfuscateConfig {
        let decoder = JSONDecoder()
        let config = try decoder.decode(ObfuscateConfig.self, from: data)
        return config
    }
}
