//
// Created by Mengyu Li on 2020/7/23.
//

import Foundation
import MachO

// MARK: - Define

public struct Mach {
	public let data: Data
	public let swapped: Bool
	public let header: Header
	public let loadCommands: [LoadCommand]
	public let sections: [Section]

	public init(data: Data) throws {
		let magic = data.magic
		switch magic {
		case MH_MAGIC:
			self.init(data32: data, swapped: magic == MH_CIGAM)
		case MH_MAGIC_64:
			self.init(data64: data, swapped: magic == MH_CIGAM_64)
		default:
			throw Error.magic(magic)
		}
	}
}

private extension Mach {
	init(data32: Data, swapped: Bool) {
		data = data32
		self.swapped = swapped
		let header: mach_header = data32.get(atOffset: 0)
		self.header = ._32(MachHeader32(header: header))
		loadCommands = Self.parseLoadCommand(
			data: data32, count: header.ncmds, headerSize: MemoryLayout<mach_header>.size
		)
		sections = Self.parseSections(loadCommands: loadCommands, machoData: data32)
	}

	init(data64: Data, swapped: Bool) {
		data = data64
		self.swapped = swapped
		let header: mach_header_64 = data64.get(atOffset: 0)
		self.header = ._64(MachHeader64(header: header))
		loadCommands = Self.parseLoadCommand(
			data: data64, count: header.ncmds, headerSize: MemoryLayout<mach_header_64>.size
		)
		sections = Self.parseSections(loadCommands: loadCommands, machoData: data64)
	}
}

public extension Mach {
	func section(of segmentName: String, name: String) -> Section? {
		sections.first { (section: Section) -> Bool in
			section.segmentName == segmentName && section.name == name
		}
	}
}

// MARK: - Readable Property

public extension Mach {
	var fileType: FileType { header.fileType }
	var cpuType: CPUType { header.cpuType }
	var flags: Set<MachHeaderFlag> { header.readableFlag }
	var codeSignature: CodeSignature? { CodeSignature(tuple: CodeSignParser.parse(mach: self)) }
}