//
// Created by Mengyu Li on 2020/12/25.
//

import ArgumentParser
import Foundation
import MachOEditor
import MachOObjcParser
import MachOParser

struct ObfuscateObjc: ParsableCommand {
    @Argument(help: ArgumentHelp(stringLiteral: "macho file path"))
    var macho: String

    @Argument(help: ArgumentHelp(stringLiteral: "output file path"))
    var outputFile: String

    func run() throws {
        let image = try Image.load(url: URL(fileURLWithPath: macho))
        autoreleasepool {
            image.eachMach { (mach: Mach) in
                let objcClassList = mach.objcClasses
                objcClassList.forEach { (objcClass: ObjcClass) in
                    print("\(objcClass)")
                }
            }
        }
    }
}
