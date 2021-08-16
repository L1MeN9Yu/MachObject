//
// Created by Mengyu Li on 2020/7/27.
//

import Foundation
import MachO

public extension ProcessMach {
    enum CPUType {
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
}
