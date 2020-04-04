//
//  FMPSystemInfo.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 05.03.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPSystemInfo.h"
#import <sys/sysctl.h>

#ifndef CPUFAMILY_INTEL_CORE
#define CPUFAMILY_INTEL_CORE 0x73d67300
#endif

#ifndef CPUFAMILY_INTEL_CORE2
#define CPUFAMILY_INTEL_CORE2 0x426f69ef
#endif

static NSString *const kCPUInfoType = @"cpu_type";
static NSString *const kCPUInfoFrequency = @"cpu_frequency_MHz";
static NSString *const kCPUInfoCoreCount = @"core_count";

@implementation FMPSystemInfo

+ (NSString *)systemInfoString
{
    NSMutableString *string = [NSMutableString string];
    for (NSDictionary *dict in [self gatherInfo])
    {
        [string appendFormat:@"%@ = %@\n", [dict objectForKey:@"key"], [dict objectForKey:@"value"]];
    }
    return string;
}

+ (NSArray<NSDictionary *> *)gatherInfo
{
    NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    NSArray *infoKeys = [NSArray arrayWithObjects:@"key", @"value", nil];
    
    NSString *machinemodel = [NSString stringWithFormat:@"%@", [self machineModel]];
    [infoArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Machine Model", machinemodel, nil]
                                                     forKeys:infoKeys]];
    
    NSString *osversion = [NSString stringWithFormat:@"%@", [self OSVersion]];
    [infoArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"OS Version", osversion, nil]
                                                     forKeys:infoKeys]];
    
    NSString *language = [NSString stringWithFormat:@"%@", [self language]];
    [infoArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Preferred Language", language, nil]
                                                     forKeys:infoKeys]];
    
    NSString *freeSpace = [NSString stringWithFormat:@"%@", [self freeDiskSpace]];
    [infoArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Free Disk Space", freeSpace, nil]
                                                     forKeys:infoKeys]];

    NSString *ramsize = [NSString stringWithFormat:@"%@", [self RAMSize]];
    [infoArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"RAM Size", ramsize, nil]
                                                     forKeys:infoKeys]];

    NSString *GPUModels = [NSString stringWithFormat:@"%@", [self GPUModels]];
    [infoArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"GPU Models", GPUModels, nil]
                                                     forKeys:infoKeys]];

    NSString *cputype = [NSString stringWithFormat:@"%@", [self CPUType]];
    [infoArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"CPU Type", cputype, nil]
                                                     forKeys:infoKeys]];

    NSString *cpuspeed = [NSString stringWithFormat:@"%@", [self CPUSpeed]];
    [infoArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"CPU Speed (MHz)", cpuspeed, nil]
                                                     forKeys:infoKeys]];

    NSString *cpucount = [NSString stringWithFormat:@"%@", [self CPUCount]];
    [infoArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Number of CPUs", cpucount, nil]
                                                     forKeys:infoKeys]];

    NSString *is64bit = [NSString stringWithFormat:@"%@", [self is64bit]];
    [infoArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"CPU is 64-Bit", is64bit, nil]
                                                     forKeys:infoKeys]];

    return infoArray;
}

+ (NSDictionary *)CPUInfo
{
    static NSDictionary *sCPUInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sCPUInfo = [self getCPUInfo];
    });
    
    return sCPUInfo;
}

+ (NSString *)CPUType
{
    return [self.CPUInfo valueForKey:kCPUInfoType];
}

+ (NSString *)CPUSpeed
{
    return [self.CPUInfo valueForKey:kCPUInfoFrequency];
}

+ (NSString *)CPUCount
{
    return [self.CPUInfo valueForKey:kCPUInfoCoreCount];
}

+ (NSDictionary<NSString *, NSString *> *)getCPUInfo
{
    // CPU type
    NSString *cpuTypeStr = [self sysctlValueForName:@"hw.cputype" ctlType:CTLTYPE_INT];
    cpu_type_t cpuType = CPU_TYPE_ANY;
    if (cpuTypeStr)
    {
        cpuType = cpuTypeStr.intValue;
    }
    
    NSString *cpuTypeName = nil;
    if (CPU_TYPE_X86 == cpuType)
    {
        cpuTypeName = [self sysctlValueForName:@"machdep.cpu.brand_string" ctlType:CTLTYPE_STRING];
    }
    if (!cpuTypeName)
    {
        NSString *cpuFamilyStr = [self sysctlValueForName:@"hw.cpufamily" ctlType:CTLTYPE_INT];
        cpu_subtype_t cpuFamily = CPUFAMILY_UNKNOWN;
        if (cpuFamilyStr)
        {
            cpuFamily = cpuFamilyStr.intValue;
        }
        
        switch (cpuFamily)
        {
            case CPUFAMILY_POWERPC_G3:
                cpuTypeName = @"PowerPC G3";
                break;
            case CPUFAMILY_POWERPC_G4:
                cpuTypeName = @"PowerPC G4";
                break;
            case CPUFAMILY_POWERPC_G5:
                cpuTypeName = @"PowerPC G5";
                break;
            case CPUFAMILY_INTEL_CORE:
                cpuTypeName = @"Intel Core Duo";
                break;
            case CPUFAMILY_INTEL_CORE2:
                cpuTypeName = @"Intel Core 2 Duo";
                break;
            case CPUFAMILY_INTEL_PENRYN:
                cpuTypeName = @"Intel Core 2 Duo (Penryn)";
                break;
            case CPUFAMILY_INTEL_NEHALEM:
                cpuTypeName = @"Intel Xeon (Nehalem)";
                break;
        }
    }
    if (!cpuTypeName && CPU_TYPE_X86 == cpuType)
    {
        cpuTypeName = @"Intel";
    }
    
    cpu_subtype_t cpuSubtype = CPU_TYPE_ANY;
    if (!cpuTypeName) // not Intel
    {
        NSString *cpuSubtypeStr = [self sysctlValueForName:@"hw.cpusubtype" ctlType:CTLTYPE_INT];
        if (cpuSubtypeStr)
        {
            cpuSubtype = cpuSubtypeStr.intValue;
        }
        
        switch (cpuSubtype)
        {
            case CPU_SUBTYPE_POWERPC_750:
                cpuTypeName = @"PowerPC G3";
                break;
            case CPU_SUBTYPE_POWERPC_7400:
            case CPU_SUBTYPE_POWERPC_7450:
                cpuTypeName = @"PowerPC G4";
                break;
            case CPU_SUBTYPE_POWERPC_970:
                cpuTypeName = @"PowerPC G5";
                break;
        }
    }
    if (!cpuTypeName)
    {
        cpuTypeName = [NSString stringWithFormat:@"Unknown (type = %d, subtype = %d)", cpuType, cpuSubtype];
    }
    
    // CPU frequency
    NSString *cpuFrequencyMHz = @"";
    NSString *cpuFrequencyStr = [self sysctlValueForName:@"hw.cpufrequency" ctlType:CTLTYPE_QUAD];
    if (cpuFrequencyStr)
    {
        cpuFrequencyMHz = [NSString stringWithFormat:@"%lld", cpuFrequencyStr.longLongValue / 1000000];
    }
    
    // CPU count
    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount = HOST_BASIC_INFO_COUNT;
    host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount);
    NSString *cpuCoreCount = [NSString stringWithFormat:@"%d", hostInfo.physical_cpu];
    
    // Return dict
    NSArray<NSString *> *infoKeys = @[kCPUInfoType, kCPUInfoFrequency, kCPUInfoCoreCount];
    NSArray<NSString *> *infoValues = @[cpuTypeName, cpuFrequencyMHz, cpuCoreCount];
    return [NSDictionary dictionaryWithObjects:infoValues forKeys:infoKeys];
}

+ (NSString *)GPUModels
{
    NSMutableArray<NSString *> *gpuModels = [NSMutableArray new];
    CFMutableDictionaryRef matchDict = IOServiceMatching("IOPCIDevice");
    io_iterator_t iterator;

    if (IOServiceGetMatchingServices(kIOMasterPortDefault, matchDict, &iterator) == kIOReturnSuccess)
    {
        io_registry_entry_t regEntry;

        while ((regEntry = IOIteratorNext(iterator))) {
            CFMutableDictionaryRef serviceDictionary;
            if (IORegistryEntryCreateCFProperties(regEntry,
                                                  &serviceDictionary,
                                                  kCFAllocatorDefault,
                                                  kNilOptions) != kIOReturnSuccess)
            {
                IOObjectRelease(regEntry);
                continue;
            }
            const void *GPUModel = CFDictionaryGetValue(serviceDictionary, @"model");

            if (GPUModel != nil) {
                if (CFGetTypeID(GPUModel) == CFDataGetTypeID()) {
                    NSString *modelName = [[NSString alloc] initWithData:
                                           (__bridge NSData *)GPUModel encoding:NSASCIIStringEncoding];
                    [gpuModels addObject:modelName];
                }
            }
            CFRelease(serviceDictionary);
            IOObjectRelease(regEntry);
        }
        IOObjectRelease(iterator);
    }
    
    return [gpuModels componentsJoinedByString:@", "];
}

+ (NSString *)freeDiskSpace
{
    NSDictionary* fileAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:@"/" error:nil];
    unsigned long long freeSpace = [[fileAttributes objectForKey:NSFileSystemFreeSize] longLongValue];
    NSByteCountFormatter *formatter = [NSByteCountFormatter new];
    formatter.countStyle = NSByteCountFormatterCountStyleFile;
    return [formatter stringFromByteCount:freeSpace];
}

+ (NSString *)OSVersion
{
    return NSProcessInfo.processInfo.operatingSystemVersionString;
}

+ (NSString *)machineModel
{
    return [self sysctlValueForName:@"hw.model" ctlType:CTLTYPE_STRING];
}

+ (NSString *)RAMSize
{
    NSString *stringBytes = [self sysctlValueForName:@"hw.memsize" ctlType:CTLTYPE_QUAD];
    NSUInteger bytes = stringBytes.integerValue;
    NSByteCountFormatter *formatter = [NSByteCountFormatter new];
    formatter.countStyle = NSByteCountFormatterCountStyleMemory;
    return [formatter stringFromByteCount:bytes];
}

+ (NSString *)is64bit
{
    NSArray *names = @[@"hw.cpu64bit_capable", @"hw.optional.x86_64", @"hw.optional.64bitops"];
    for (NSString *name in names)
    {
        if ([self sysctlValueForName:name ctlType:CTLTYPE_STRING])
        {
            return @"Yes";
        }
    }
    return @"No";
}

+ (NSString *)language
{
    return [[NSLocale currentLocale] localeIdentifier];
}

+ (NSString *)sysctlValueForName:(NSString *)sysctlName ctlType:(UInt8)ctlType
{
    if (!sysctlName)
    {
        return nil;
    }
    
    size_t size;
    char *cName = strdup([sysctlName UTF8String]);
    if (noErr != sysctlbyname(cName, NULL, &size, NULL, 0))
    {
        return nil;
    }
    
    NSString *value = nil;
    char *cValue = malloc(size);
    if (noErr == sysctlbyname(cName, cValue, &size, NULL, 0))
    {
        switch (ctlType)
        {
            case CTLTYPE_INT:
            {
                SInt32 intValue = *(SInt32 *)cValue;
                value = [NSString stringWithFormat:@"%d", intValue];
                break;
            }
            case CTLTYPE_QUAD:
            {
                SInt64 quadValue = *(SInt64 *)cValue;
                value = [NSString stringWithFormat:@"%lld", quadValue];
                break;
            }
            case CTLTYPE_STRING:
            default:
            {
                value = [NSString stringWithFormat:@"%s", cValue];
                break;
            }
        }
    }
    free(cName);
    free(cValue);
    
    return value;
}

@end
