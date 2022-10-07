//
// Created by Mengyu Li on 2020/8/3.
//

import ArgumentParser
import Foundation
import MachOObjcParser
import MachOParser

struct Info: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Show Macho File Information")

    @Argument(help: "mach file path")
    var macho: String

    mutating func run() throws {
        let fileURL = URL(fileURLWithPath: macho)
        let image = try Image.load(url: fileURL)
        let content = image.content
        switch content {
        case let .fat(fat):
            fat.architectures.forEach {
                show(mach: $0.mach)
            }
        case let .mach(mach):
            show(mach: mach)
        }
    }
}

private extension Info {
    func show(mach: Mach) {
        header(mach: mach)
        loadCommands(mach: mach)
        codeSignature(mach: mach)
    }
}

private extension Info {
    func header(mach: Mach) {
        print("header ====>>")
        print("cpu type : \(mach.header.cpuType)")
        print("file type : \(mach.header.fileType)")
        print("command count : \(mach.header.commandCount)")
        print("command size : \(mach.header.commandSize)")
        print("flags : \(mach.header.flags)")
    }

    func loadCommands(mach: Mach) {
        print("load commands ====>>")
        mach.allLoadCommands.forEach {
            print("\($0)")
        }
    }

    func codeSignature(mach: Mach) {
        guard let codeSignature = mach.codeSignature else { return }
        print("code signature ====>>")
        print("\(codeSignature)")
    }
}

private extension Info {
    func showObjCClassList(mach: Mach) {
        let objcClassList = mach.objcClasses
        objcClassList.forEach { (objcClass: ObjcClass) in
            print("\(objcClass)")
        }
    }

    func showImportStack(mach: Mach) {
        mach.importStack.forEach {
            print("\($0.symbolString)")
        }
    }
}
