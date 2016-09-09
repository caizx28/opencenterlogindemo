//
//  UIDeviceHardware.m
//
//  usage :
//      NSString *platform = [UIDeviceHardware platform];
//

#import "UIDevice-Hardware.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import <CommonCrypto/CommonDigest.h>

@implementation  UIDevice (Hardware)

#pragma mark sysctlbyname utils
- (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

- (NSString *) platform
{
    return [self getSysInfoByName:"hw.machine"];
}


// Thanks, Tom Harrington (Atomicbird)
- (NSString *) hwmodel
{
    return [self getSysInfoByName:"hw.model"];
}

#pragma mark sysctl utils

- (NSString *)uniqueDeviceIdentifier {
    
    // Create pointer to the string as UTF8
    const char *ptr = [[self macaddress] UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char hashedChars[CC_SHA256_DIGEST_LENGTH];
    
    // Hash pointer to hashedChars array
    CC_SHA256(ptr, CC_SHA256_DIGEST_LENGTH, hashedChars);
    
    // Convert SHA256 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString string];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        
        [output appendFormat:@"%02x",hashedChars[i]];
        
    }
    
    // add dashes
    [output insertString:@"-" atIndex:8];
    [output insertString:@"-" atIndex:13];
    [output insertString:@"-" atIndex:18];
    [output insertString:@"-" atIndex:23];
    [output insertString:@"-" atIndex:36];
    [output insertString:@"-" atIndex:49];
    [output insertString:@"-" atIndex:54];
    [output insertString:@"-" atIndex:59];
    [output insertString:@"-" atIndex:64];
    
    return [output uppercaseString];
    
}


- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (NSUInteger) cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}

- (NSUInteger) busFrequency
{
    return [self getSysInfo:HW_BUS_FREQ];
}

- (NSUInteger) totalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

- (NSUInteger) userMemory
{
    return [self getSysInfo:HW_USERMEM];
}

- (NSUInteger) maxSocketBufferSize
{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

- (NSUInteger) numberOfCPU
{
    return [self getSysInfo:HW_NCPU];
}

#pragma mark file system -- Thanks Joachim Bean!
- (NSNumber *) totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *) freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
- (NSString *) macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    // NSString *outstring = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X",
    //                       *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

#pragma mark platform type and name utils


- (UIDevicePlatform) platformType
{
    NSString *platform = [self platform];
    
    if ([platform isEqualToString:@"iFPGA"])        return UIDeviceIFPGA;
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return UIDeviceiPhone1;
    if ([platform isEqualToString:@"iPhone1,2"])    return UIDeviceiPhone3G;
    if ([platform hasPrefix:@"iPhone2"])            return UIDeviceiPhone3GS;
    if ([platform hasPrefix:@"iPhone3"])            return UIDeviceiPhone4;
    if ([platform hasPrefix:@"iPhone4"])            return UIDeviceiPhone4s;
    if ([platform isEqualToString:@"iPhone5,2"]||
        [platform isEqualToString:@"iPhone5,1"])            return UIDeviceiPhone5;
    if ([platform isEqualToString:@"iPhone5,3"]||
        [platform isEqualToString:@"iPhone5,4"])    return UIDeviceiPhone5c;
    if ([platform hasPrefix:@"iPhone6"])    return UIDeviceiPhone5s;
    if ([platform isEqualToString:@"iPhone7,1"])    return UIDeviceiPhone6plus;
    if ([platform isEqualToString:@"iPhone7,2"])    return UIDeviceiPhone6;
    
    if ([platform isEqualToString:@"iPhone8,1"])    return UIDeviceiPhone6splus;
    if ([platform isEqualToString:@"iPhone8,2"])    return UIDeviceiPhone6s;
    
    // iPod
    if ([platform hasPrefix:@"iPod1"])             return UIDeviceiPod1;
    if ([platform hasPrefix:@"iPod2"])              return UIDeviceiPod2;
    if ([platform hasPrefix:@"iPod3"])              return UIDeviceiPod3;
    if ([platform hasPrefix:@"iPod4"])              return UIDeviceiPod4;
    if ([platform isEqualToString:@"iPod5,1"])            return UIDeviceiPod5;
    if ([platform isEqualToString:@"iPod7,1"])            return UIDeviceiPod6;
    
    // iPad
    if ([platform hasPrefix:@"iPad1"])              return UIDeviceiPad1;
    if ([platform isEqualToString:@"iPad2,1"]||
        [platform isEqualToString:@"iPad2,2"]||
        [platform isEqualToString:@"iPad2,3"])      return UIDeviceiPad2;
    
    if ([platform isEqualToString:@"iPad2,5"]||
        [platform isEqualToString:@"iPad2,6"]||
        [platform isEqualToString:@"iPad2,7"])      return UIDeviceiPadMini;
    
    if ([platform isEqualToString:@"iPad3,1"]||
        [platform isEqualToString:@"iPad3,2"]||
        [platform isEqualToString:@"iPad3,3"])      return UIDeviceiPad3;
    
    if ([platform isEqualToString:@"iPad3,4"]||
        [platform isEqualToString:@"iPad3,5"]||
        [platform isEqualToString:@"iPad3,6"])      return UIDeviceiPad4;
    
    if ([platform isEqualToString:@"iPad4,1"]||
        [platform isEqualToString:@"iPad4,2"]||
        [platform isEqualToString:@"iPad4,3"])      return UIDeviceiPadAir;
    
    if ([platform isEqualToString:@"iPad4,4"]||
        [platform isEqualToString:@"iPad4,5"])      return UIDeviceiPadMini2;
    
    if ([platform isEqualToString:@"iPad4,7"]||
        [platform isEqualToString:@"iPad4,8"]||
        [platform isEqualToString:@"iPad4,9"])      return UIDeviceiPadMini3;
    
    if ([platform isEqualToString:@"iPad5,1"]||
        [platform isEqualToString:@"iPad5,2"])      return UIDeviceiPadMini4;
    
    if ([platform isEqualToString:@"iPad5,3"]||
        [platform isEqualToString:@"iPad5,4"])      return UIDeviceiPadAir2;
    
    // Apple TV
    if ([platform hasPrefix:@"AppleTV2"])           return UIDeviceAppleTV2;
    
    if ([platform hasPrefix:@"iPhone"])             return UIDeviceUnknowniPhone;
    if ([platform hasPrefix:@"iPod"])               return UIDeviceUnknowniPod;
    if ([platform hasPrefix:@"iPad"])               return UIDeviceUnknowniPad;
    
    // Simulator thanks Jordan Breeding
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"]|| [platform isEqualToString:@"i386"])
    {
        BOOL smallerScreen = [[UIScreen mainScreen] bounds].size.width < 768;
        return smallerScreen ? UIDeviceiPhoneSimulator : UIDeviceiPhoneSimulatoriPad;
    }
    
    return UIDeviceUnknown;
}

- (NSString *) platformString
{
    switch ([self platformType])
    {
        case UIDeviceiPhone1: return @"iPhone";
        case UIDeviceiPhone3G: return @"iPhone3";
        case UIDeviceiPhone3GS: return @"iPhone3GS";
        case UIDeviceiPhone4: return @"iPhone4";
        case UIDeviceiPhone4s: return @"iPhone4s";
        case UIDeviceiPhone5: return @"iPhone5";
        case UIDeviceiPhone5c: return @"iPhone5c";
        case UIDeviceiPhone5s: return @"iPhone5s";
        case UIDeviceiPhone6: return @"iPhone6";
        case UIDeviceiPhone6plus: return @"iPhone6plus";
        case UIDeviceiPhone6s: return @"iPhone6s";
        case UIDeviceiPhone6splus: return @"iPhone6splus";
            
        case UIDeviceiPod1:  return @"iPod1";
        case UIDeviceiPod2:  return @"iPod2";
        case UIDeviceiPod3:  return @"iPod3";
        case UIDeviceiPod4:  return @"iPod4";
        case UIDeviceiPod5:  return @"iPod5";
        case UIDeviceiPod6:  return @"iPod6";
            
        case UIDeviceiPad1:  return @"iPad1";
        case UIDeviceiPad2:  return @"iPad2";
        case UIDeviceiPad3:  return @"iPad3";
        case UIDeviceiPad4:  return @"iPad4";
        case UIDeviceiPadMini:  return @"iPadMini";
        case UIDeviceiPadMini2:  return @"iPadMini2";
        case UIDeviceiPadMini3:  return @"iPadMini3";
        case UIDeviceiPadMini4:  return @"iPadMini4";
        case UIDeviceiPadAir:  return @"iPadAir";
        case UIDeviceiPadAir2:  return @"iPadAir2";
            
        case UIDeviceUnknownAppleTV: return @"UnknownAppleTV";
        case UIDeviceAppleTV2: return @"AppleTV2";
        case UIDeviceIFPGA: return @"IFPGA";
            
        case UIDeviceUnknowniPad: return @"UnknowniPad";
        case UIDeviceUnknowniPod: return @"UnknowniPod";
        case UIDeviceUnknowniPhone: return @"UnknowniPhone";
            
        case UIDeviceiPhoneSimulator: return @"Simulator";
            
        case UIDeviceiPhoneSimulatoriPad: return @"Simulator";
        default: return @"UnknownDevice";
    }
}

-(UIDeviceSize)deviceSize
{
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight == 480.0)
        return iPhone35inch;
    else if(screenHeight == 568.0)
        return iPhone4inch;
    else if(screenHeight == 667.0)
        return  iPhone47inch;
    else if(screenHeight == 736.0)
        return iPhone55inch;
    else if(screenHeight == 1024.0)
        return iPadinch;
    return iPhone4inch;
}

@end
