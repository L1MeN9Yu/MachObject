//
//  ViewController.swift
//  App
//
//  Created by Mengyu Li on 2021/8/16.
//

import MachO
import MachOParser
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
}

private extension ViewController {
    func setup() {
        guard let executablePath = Bundle.main.executablePath else {
            fatalError()
        }
        var i: UInt32 = 0
        for index in 0..<_dyld_image_count() {
            guard let cString = _dyld_get_image_name(index) else { continue }
            let string = String(cString: cString)
            if string == executablePath {
                i = index
                break
            }
        }
        guard let machHeaderPointer = _dyld_get_image_header(i) else {
            fatalError()
        }
        let processMach = try! ProcessMach(headerPointer: machHeaderPointer)
        if let stringTable = processMach.stringTable {
            print("\(stringTable)")
        }
    }
}
