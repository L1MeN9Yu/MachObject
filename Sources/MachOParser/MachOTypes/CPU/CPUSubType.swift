//
// Created by Mengyu Li on 2022/10/7.
//

import MachO

public enum CPUSubType {
    case any
    case multiple
    case littleEndian
    case bigEndian
    case vaxAll
    case vax780
    case vax785
    case vax750
    case vax730
    case uvaxi
    case uvaxii
    case vax8200
    case vax8500
    case vax8600
    case vax8650
    case vax8800
    case uvaxiii
    case mc680X0All
    case mc68030
    case mc68040
    case mc68030Only
    case x86All
    case x86_64All
    case x86Arch1
    case x86_64H
    case mipsAll
    case mipsR2300
    case mipsR2600
    case mipsR2800
    case mipsR2000A
    case mipsR2000
    case mipsR3000A
    case mipsR3000
    case mc98000All
    case mc98601
    case hppaAll
    case hppa7100
    case hppa7100Lc
    case mc88000All
    case mc88100
    case mc88110
    case sparcAll
    case i860All
    case i860_860
    case powerpcAll
    case powerpc601
    case powerpc602
    case powerpc603
    case powerpc603E
    case powerpc603Ev
    case powerpc604
    case powerpc604E
    case powerpc620
    case powerpc750
    case powerpc7400
    case powerpc7450
    case powerpc970
    case armAll
    case armV4T
    case armV6
    case armV5Tej
    case armXscale
    case armV7
    case armV7F
    case armV7S
    case armV7K
    case armV8
    case armV6M
    case armV7M
    case armV7Em
    case armV8M
    case arm64All
    case arm64V8
    case arm64E
    case arm64_32All
    case arm64_32V8

    init(cpu_subtype: cpu_subtype_t) {
        switch cpu_subtype {
        case CPU_SUBTYPE_ANY:
            self = .any
        case CPU_SUBTYPE_MULTIPLE:
            self = .multiple
        case CPU_SUBTYPE_LITTLE_ENDIAN:
            self = .littleEndian
        case CPU_SUBTYPE_BIG_ENDIAN:
            self = .bigEndian
        case CPU_SUBTYPE_VAX_ALL:
            self = .vaxAll
        case CPU_SUBTYPE_VAX780:
            self = .vax780
        case CPU_SUBTYPE_VAX785:
            self = .vax785
        case CPU_SUBTYPE_VAX750:
            self = .vax750
        case CPU_SUBTYPE_VAX730:
            self = .vax730
        case CPU_SUBTYPE_UVAXI:
            self = .uvaxi
        case CPU_SUBTYPE_UVAXII:
            self = .uvaxii
        case CPU_SUBTYPE_VAX8200:
            self = .vax8200
        case CPU_SUBTYPE_VAX8500:
            self = .vax8500
        case CPU_SUBTYPE_VAX8600:
            self = .vax8600
        case CPU_SUBTYPE_VAX8650:
            self = .vax8650
        case CPU_SUBTYPE_VAX8800:
            self = .vax8800
        case CPU_SUBTYPE_UVAXIII:
            self = .uvaxiii
        case CPU_SUBTYPE_MC680x0_ALL:
            self = .mc680X0All
        case CPU_SUBTYPE_MC68030:
            self = .mc68030
        case CPU_SUBTYPE_MC68040:
            self = .mc68040
        case CPU_SUBTYPE_MC68030_ONLY:
            self = .mc68030Only
        case CPU_SUBTYPE_X86_ALL:
            self = .x86All
        case CPU_SUBTYPE_X86_64_ALL:
            self = .x86_64All
        case CPU_SUBTYPE_X86_ARCH1:
            self = .x86Arch1
        case CPU_SUBTYPE_X86_64_H:
            self = .x86_64H
        case CPU_SUBTYPE_MIPS_ALL:
            self = .mipsAll
        case CPU_SUBTYPE_MIPS_R2300:
            self = .mipsR2300
        case CPU_SUBTYPE_MIPS_R2600:
            self = .mipsR2600
        case CPU_SUBTYPE_MIPS_R2800:
            self = .mipsR2800
        case CPU_SUBTYPE_MIPS_R2000a:
            self = .mipsR2000A
        case CPU_SUBTYPE_MIPS_R2000:
            self = .mipsR2000
        case CPU_SUBTYPE_MIPS_R3000a:
            self = .mipsR3000A
        case CPU_SUBTYPE_MIPS_R3000:
            self = .mipsR3000
        case CPU_SUBTYPE_MC98000_ALL:
            self = .mc98000All
        case CPU_SUBTYPE_MC98601:
            self = .mc98601
        case CPU_SUBTYPE_HPPA_ALL:
            self = .hppaAll
        case CPU_SUBTYPE_HPPA_7100:
            self = .hppa7100
        case CPU_SUBTYPE_HPPA_7100LC:
            self = .hppa7100Lc
        case CPU_SUBTYPE_MC88000_ALL:
            self = .mc88000All
        case CPU_SUBTYPE_MC88100:
            self = .mc88100
        case CPU_SUBTYPE_MC88110:
            self = .mc88110
        case CPU_SUBTYPE_SPARC_ALL:
            self = .sparcAll
        case CPU_SUBTYPE_I860_ALL:
            self = .i860All
        case CPU_SUBTYPE_I860_860:
            self = .i860_860
        case CPU_SUBTYPE_POWERPC_ALL:
            self = .powerpcAll
        case CPU_SUBTYPE_POWERPC_601:
            self = .powerpc601
        case CPU_SUBTYPE_POWERPC_602:
            self = .powerpc602
        case CPU_SUBTYPE_POWERPC_603:
            self = .powerpc603
        case CPU_SUBTYPE_POWERPC_603e:
            self = .powerpc603E
        case CPU_SUBTYPE_POWERPC_603ev:
            self = .powerpc603Ev
        case CPU_SUBTYPE_POWERPC_604:
            self = .powerpc604
        case CPU_SUBTYPE_POWERPC_604e:
            self = .powerpc604E
        case CPU_SUBTYPE_POWERPC_620:
            self = .powerpc620
        case CPU_SUBTYPE_POWERPC_750:
            self = .powerpc750
        case CPU_SUBTYPE_POWERPC_7400:
            self = .powerpc7400
        case CPU_SUBTYPE_POWERPC_7450:
            self = .powerpc7450
        case CPU_SUBTYPE_POWERPC_970:
            self = .powerpc970
        case CPU_SUBTYPE_ARM_ALL:
            self = .armAll
        case CPU_SUBTYPE_ARM_V4T:
            self = .armV4T
        case CPU_SUBTYPE_ARM_V6:
            self = .armV6
        case CPU_SUBTYPE_ARM_V5TEJ:
            self = .armV5Tej
        case CPU_SUBTYPE_ARM_XSCALE:
            self = .armXscale
        case CPU_SUBTYPE_ARM_V7:
            self = .armV7
        case CPU_SUBTYPE_ARM_V7F:
            self = .armV7F
        case CPU_SUBTYPE_ARM_V7S:
            self = .armV7S
        case CPU_SUBTYPE_ARM_V7K:
            self = .armV7K
        case CPU_SUBTYPE_ARM_V8:
            self = .armV8
        case CPU_SUBTYPE_ARM_V6M:
            self = .armV6M
        case CPU_SUBTYPE_ARM_V7M:
            self = .armV7M
        case CPU_SUBTYPE_ARM_V7EM:
            self = .armV7Em
        case CPU_SUBTYPE_ARM_V8M:
            self = .armV8M
        case CPU_SUBTYPE_ARM64_ALL:
            self = .arm64All
        case CPU_SUBTYPE_ARM64_V8:
            self = .arm64V8
        case CPU_SUBTYPE_ARM64E:
            self = .arm64E
        case CPU_SUBTYPE_ARM64_32_ALL:
            self = .arm64_32All
        case CPU_SUBTYPE_ARM64_32_V8:
            self = .arm64_32V8
        default:
            self = .any
        }
    }
}

extension CPUSubType: RawRepresentable {
    public typealias RawValue = cpu_subtype_t

    public init(rawValue: RawValue) {
        self.init(cpu_subtype: rawValue)
    }

    public var rawValue: RawValue {
        switch self {
        case .any:
            return CPU_SUBTYPE_ANY
        case .multiple:
            return CPU_SUBTYPE_MULTIPLE
        case .littleEndian:
            return CPU_SUBTYPE_LITTLE_ENDIAN
        case .bigEndian:
            return CPU_SUBTYPE_BIG_ENDIAN
        case .vaxAll:
            return CPU_SUBTYPE_VAX_ALL
        case .vax780:
            return CPU_SUBTYPE_VAX780
        case .vax785:
            return CPU_SUBTYPE_VAX785
        case .vax750:
            return CPU_SUBTYPE_VAX750
        case .vax730:
            return CPU_SUBTYPE_VAX730
        case .uvaxi:
            return CPU_SUBTYPE_UVAXI
        case .uvaxii:
            return CPU_SUBTYPE_UVAXII
        case .vax8200:
            return CPU_SUBTYPE_VAX8200
        case .vax8500:
            return CPU_SUBTYPE_VAX8500
        case .vax8600:
            return CPU_SUBTYPE_VAX8600
        case .vax8650:
            return CPU_SUBTYPE_VAX8650
        case .vax8800:
            return CPU_SUBTYPE_VAX8800
        case .uvaxiii:
            return CPU_SUBTYPE_UVAXIII
        case .mc680X0All:
            return CPU_SUBTYPE_MC680x0_ALL
        case .mc68030:
            return CPU_SUBTYPE_MC68030
        case .mc68040:
            return CPU_SUBTYPE_MC68040
        case .mc68030Only:
            return CPU_SUBTYPE_MC68030_ONLY
        case .x86All:
            return CPU_SUBTYPE_X86_ALL
        case .x86_64All:
            return CPU_SUBTYPE_X86_64_ALL
        case .x86Arch1:
            return CPU_SUBTYPE_X86_ARCH1
        case .x86_64H:
            return CPU_SUBTYPE_X86_64_H
        case .mipsAll:
            return CPU_SUBTYPE_MIPS_ALL
        case .mipsR2300:
            return CPU_SUBTYPE_MIPS_R2300
        case .mipsR2600:
            return CPU_SUBTYPE_MIPS_R2600
        case .mipsR2800:
            return CPU_SUBTYPE_MIPS_R2800
        case .mipsR2000A:
            return CPU_SUBTYPE_MIPS_R2000a
        case .mipsR2000:
            return CPU_SUBTYPE_MIPS_R2000
        case .mipsR3000A:
            return CPU_SUBTYPE_MIPS_R3000a
        case .mipsR3000:
            return CPU_SUBTYPE_MIPS_R3000
        case .mc98000All:
            return CPU_SUBTYPE_MC98000_ALL
        case .mc98601:
            return CPU_SUBTYPE_MC98601
        case .hppaAll:
            return CPU_SUBTYPE_HPPA_ALL
        case .hppa7100:
            return CPU_SUBTYPE_HPPA_7100
        case .hppa7100Lc:
            return CPU_SUBTYPE_HPPA_7100LC
        case .mc88000All:
            return CPU_SUBTYPE_MC88000_ALL
        case .mc88100:
            return CPU_SUBTYPE_MC88100
        case .mc88110:
            return CPU_SUBTYPE_MC88110
        case .sparcAll:
            return CPU_SUBTYPE_SPARC_ALL
        case .i860All:
            return CPU_SUBTYPE_I860_ALL
        case .i860_860:
            return CPU_SUBTYPE_I860_860
        case .powerpcAll:
            return CPU_SUBTYPE_POWERPC_ALL
        case .powerpc601:
            return CPU_SUBTYPE_POWERPC_601
        case .powerpc602:
            return CPU_SUBTYPE_POWERPC_602
        case .powerpc603:
            return CPU_SUBTYPE_POWERPC_603
        case .powerpc603E:
            return CPU_SUBTYPE_POWERPC_603e
        case .powerpc603Ev:
            return CPU_SUBTYPE_POWERPC_603ev
        case .powerpc604:
            return CPU_SUBTYPE_POWERPC_604
        case .powerpc604E:
            return CPU_SUBTYPE_POWERPC_604e
        case .powerpc620:
            return CPU_SUBTYPE_POWERPC_620
        case .powerpc750:
            return CPU_SUBTYPE_POWERPC_750
        case .powerpc7400:
            return CPU_SUBTYPE_POWERPC_7400
        case .powerpc7450:
            return CPU_SUBTYPE_POWERPC_7450
        case .powerpc970:
            return CPU_SUBTYPE_POWERPC_970
        case .armAll:
            return CPU_SUBTYPE_ARM_ALL
        case .armV4T:
            return CPU_SUBTYPE_ARM_V4T
        case .armV6:
            return CPU_SUBTYPE_ARM_V6
        case .armV5Tej:
            return CPU_SUBTYPE_ARM_V5TEJ
        case .armXscale:
            return CPU_SUBTYPE_ARM_XSCALE
        case .armV7:
            return CPU_SUBTYPE_ARM_V7
        case .armV7F:
            return CPU_SUBTYPE_ARM_V7F
        case .armV7S:
            return CPU_SUBTYPE_ARM_V7S
        case .armV7K:
            return CPU_SUBTYPE_ARM_V7K
        case .armV8:
            return CPU_SUBTYPE_ARM_V8
        case .armV6M:
            return CPU_SUBTYPE_ARM_V6M
        case .armV7M:
            return CPU_SUBTYPE_ARM_V7M
        case .armV7Em:
            return CPU_SUBTYPE_ARM_V7EM
        case .armV8M:
            return CPU_SUBTYPE_ARM_V8M
        case .arm64All:
            return CPU_SUBTYPE_ARM64_ALL
        case .arm64V8:
            return CPU_SUBTYPE_ARM64_V8
        case .arm64E:
            return CPU_SUBTYPE_ARM64E
        case .arm64_32All:
            return CPU_SUBTYPE_ARM64_32_ALL
        case .arm64_32V8:
            return CPU_SUBTYPE_ARM64_32_V8
        }
    }
}
