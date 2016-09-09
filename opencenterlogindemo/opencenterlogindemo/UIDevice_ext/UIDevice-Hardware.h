//
//  UIDeviceHardware.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
    UIDeviceUnknown,
    
    UIDeviceiPhoneSimulator,
    UIDeviceiPhoneSimulatoriPad,
    
    UIDeviceiPhone1,
    UIDeviceiPhone3G,
    UIDeviceiPhone3GS,
    UIDeviceiPhone4,
    UIDeviceiPhone4s,
    UIDeviceiPhone5,
    UIDeviceiPhone5c,
    UIDeviceiPhone5s,
    UIDeviceiPhone6,
    UIDeviceiPhone6plus,
    
    UIDeviceiPhone6s,
    UIDeviceiPhone6splus,
    
    UIDeviceiPod1,
    UIDeviceiPod2,
    UIDeviceiPod3,
    UIDeviceiPod4,
    UIDeviceiPod5,
    UIDeviceiPod6,
    
    UIDeviceiPad1,
    UIDeviceiPad2,
    UIDeviceiPad3,
    UIDeviceiPad4,
    UIDeviceiPadAir,
    UIDeviceiPadAir2,
    UIDeviceiPadMini,
    UIDeviceiPadMini2,
    UIDeviceiPadMini3,
    UIDeviceiPadMini4,
    
    UIDeviceAppleTV2,
    UIDeviceUnknownAppleTV,
    
    UIDeviceUnknowniPhone,
    UIDeviceUnknowniPod,
    UIDeviceUnknowniPad,
    UIDeviceIFPGA,
} UIDevicePlatform;

typedef enum
{
    iPhone35inch = 1,
    iPhone4inch = 2,
    iPhone47inch = 3,
    iPhone55inch = 4,
    iPadinch
} UIDeviceSize;

@interface UIDevice (Hardware)
- (NSString *) platform;
- (NSString *) hwmodel;
- (UIDevicePlatform) platformType;
- (NSString *) platformString;

- (NSUInteger) cpuFrequency;
- (NSUInteger) busFrequency;
- (NSUInteger) totalMemory;
- (NSUInteger) userMemory;

- (NSNumber *) totalDiskSpace;
- (NSNumber *) freeDiskSpace;

- (NSString *) macaddress;
- (NSUInteger) numberOfCPU;
- (NSString *)uniqueDeviceIdentifier;

-(UIDeviceSize)deviceSize;


@end


