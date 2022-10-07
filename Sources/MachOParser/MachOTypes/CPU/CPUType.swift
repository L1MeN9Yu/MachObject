//
// Created by Mengyu Li on 2022/10/5.
//

import MachO

public enum CPUType {
    case any
    case vax
    case mc680X0
    case x86
    case i386
    case x86_64
    case mc98000
    case hppa
    case arm
    case arm64
    case arm64_32
    case mc88000
    case sparc
    case i860
    case powerpc
    case powerpc64

    init(cpuType: cpu_type_t) {
        switch cpuType {
        case CPU_TYPE_ANY:
            self = .any
        case CPU_TYPE_VAX:
            self = .vax
        case CPU_TYPE_MC680x0:
            self = .mc680X0
        case CPU_TYPE_X86:
            self = .x86
        case CPU_TYPE_I386:
            self = .i386
        case CPU_TYPE_X86_64:
            self = .x86_64
        case CPU_TYPE_MC98000:
            self = .mc98000
        case CPU_TYPE_HPPA:
            self = .hppa
        case CPU_TYPE_ARM:
            self = .arm
        case CPU_TYPE_ARM64:
            self = .arm64
        case CPU_TYPE_ARM64_32:
            self = .arm64_32
        case CPU_TYPE_MC88000:
            self = .mc88000
        case CPU_TYPE_SPARC:
            self = .sparc
        case CPU_TYPE_I860:
            self = .i860
        case CPU_TYPE_POWERPC:
            self = .powerpc
        case CPU_TYPE_POWERPC64:
            self = .powerpc64
        default:
            self = .any
        }
    }
}

extension CPUType: RawRepresentable {
    public typealias RawValue = cpu_type_t

    public init?(rawValue: RawValue) {
        self.init(cpuType: rawValue)
    }

    public var rawValue: RawValue {
        switch self {
        case .any:
            return CPU_TYPE_ANY
        case .vax:
            return CPU_TYPE_VAX
        case .mc680X0:
            return CPU_TYPE_MC680x0
        case .x86:
            return CPU_TYPE_X86
        case .i386:
            return CPU_TYPE_I386
        case .x86_64:
            return CPU_TYPE_X86_64
        case .mc98000:
            return CPU_TYPE_MC98000
        case .hppa:
            return CPU_TYPE_HPPA
        case .arm:
            return CPU_TYPE_ARM
        case .arm64:
            return CPU_TYPE_ARM64
        case .arm64_32:
            return CPU_TYPE_ARM64_32
        case .mc88000:
            return CPU_TYPE_MC88000
        case .sparc:
            return CPU_TYPE_SPARC
        case .i860:
            return CPU_TYPE_I860
        case .powerpc:
            return CPU_TYPE_POWERPC
        case .powerpc64:
            return CPU_TYPE_POWERPC64
        }
    }
}
