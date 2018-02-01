//
//  SKNetworkInfo.m
//  StatioKit
//
//  Created by Varun Santhanam on 1/14/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Darwin.POSIX.sys.socket;
@import Darwin.POSIX.arpa.inet;
@import Darwin.POSIX.net;
@import Darwin.POSIX.ifaddrs;
@import Darwin.POSIX.ioctl;
@import Darwin.sys.sysctl;

#import "SKNetworkInfo.h"

#import "route.h"

#define RTF_PRCLONING   0x10000        /* protocol requires cloning */
#define RTF_WASCLONED   0x20000        /* route generated through cloning */
#define RTF_PROTO3      0x40000        /* protocol specific routing flag */

#define RTAX_DST        0               /* destination sockaddr present */
#define RTAX_GATEWAY    1               /* gateway sockaddr present */
#define RTAX_NETMASK    2               /* netmask sockaddr present */
#define RTAX_GENMASK    3               /* cloning mask sockaddr present */
#define RTAX_IFP        4               /* interface name sockaddr present */
#define RTAX_IFA        5               /* interface addr sockaddr present */
#define RTAX_AUTHOR     6               /* sockaddr for author of redirect */
#define RTAX_BRD        7               /* for NEWADDR, broadcast or p-p dest addr */
#define RTAX_MAX        8               /* size of array to allocate */

#define RTA_DST         0x1             /* destination sockaddr present */
#define RTA_GATEWAY     0x2             /* gateway sockaddr present */
#define RTA_NETMASK     0x4             /* netmask sockaddr present */
#define RTA_GENMASK     0x8             /* cloning mask sockaddr present */
#define RTA_IFP         0x10            /* interface name sockaddr present */
#define RTA_IFA         0x20            /* interface addr sockaddr present */
#define RTA_AUTHOR      0x40            /* sockaddr for author of redirect */
#define RTA_BRD         0x80            /* for NEWADDR, broadcast or p-p dest addr */

@interface SKRouteInfo : NSObject {
    
    struct sockaddr     m_addrs[RTAX_MAX];
    struct rt_msghdr2   m_rtm;
    int                 m_len;
    
}

- (instancetype)initWithRtm:(struct rt_msghdr2 *)rtm;

+ (nullable NSMutableArray<SKRouteInfo *> *)getRoutes;
+ (nullable SKRouteInfo *)getRoute:(struct rt_msghdr2 *)rtm;

- (nullable NSString *)getDestination;
- (nullable NSString *)getNetmask;
- (nullable NSString *)getGateway;
- (nullable NSString *)getAddrStringByIndex:(int)rtax_index;

- (void)setAddr:(struct sockaddr *)sa index:(int)rtax_index;

@end;

@implementation SKRouteInfo

- (instancetype)initWithRtm:(struct rt_msghdr2 *)rtm {
    
    int i;
    struct sockaddr *sa = (struct sockaddr*)(rtm + 1);
    
    memcpy(&(m_rtm), rtm, sizeof(struct rt_msghdr2));
    
    for(i = 0; i < RTAX_MAX; i++) {
        
        [self setAddr:&(sa[i]) index:i];
        
    }
    
    return self;
    
}

+ (NSMutableArray<SKRouteInfo *> *)getRoutes {
    
    NSMutableArray<SKRouteInfo *> *routeArray = [[NSMutableArray<SKRouteInfo *> alloc] init];
    SKRouteInfo* route = nil;
    
    size_t len;
    int mib[6];
    char *buf;
    register struct rt_msghdr2 *rtm;
    
    mib[0] = CTL_NET;
    mib[1] = PF_ROUTE;
    mib[2] = 0;
    mib[3] = 0;
    mib[4] = NET_RT_DUMP2;
    mib[5] = 0;
    
    sysctl(mib, 6, NULL, &len, NULL, 0);
    buf = malloc(len);
    
    if (buf && sysctl(mib, 6, buf, &len, NULL, 0) == 0) {
        
        for (char * ptr = buf; ptr < buf + len; ptr += rtm->rtm_msglen) {
            
            rtm = (struct rt_msghdr2 *)ptr;
            route = [self getRoute:rtm];
            
            if (route != nil) {
                
                [routeArray addObject:route];
                break;
                
            }
            
        }
        
    }
    
    free(buf);
    
    return routeArray;
    
}

+ (SKRouteInfo *)getRoute:(struct rt_msghdr2 *)rtm {
    
    struct sockaddr* dst_sa = (struct sockaddr *)(rtm + 1);
    
    SKRouteInfo *route = nil;
    
    if (rtm->rtm_addrs & RTA_DST) {
        
        if (dst_sa->sa_family == AF_INET && !((rtm->rtm_flags & RTF_WASCLONED) && (rtm->rtm_parentflags & RTF_PRCLONING))) {
            
            route = [[SKRouteInfo alloc] initWithRtm:rtm];
            
        }
        
    }
    
    return route;
    
}

- (void)setAddr:(struct sockaddr *)sa index:(int)rtax_index {
    
    if (rtax_index >= 0 && rtax_index < RTAX_MAX) {
        
        memcpy(&(m_addrs[rtax_index]), sa, sizeof(struct sockaddr));
        
    }
    
}

- (nullable NSString*)getDestination {
    
    return [self getAddrStringByIndex:RTAX_DST];
    
}

- (nullable NSString*)getNetmask {
    
    return [self getAddrStringByIndex:RTAX_NETMASK];
    
}

- (nullable NSString*)getGateway {
    
    return [self getAddrStringByIndex:RTAX_GATEWAY];
    
}

- (nullable NSString*)getAddrStringByIndex:(int)rtax_index {
    
    NSString *routeString = nil;
    struct sockaddr *sa = &(m_addrs[rtax_index]);
    int flagVal = 1 << rtax_index;
    
    if(!(m_rtm.rtm_addrs & flagVal)) {
        
        return nil;
        
    }
    
    if(rtax_index >= 0 && rtax_index < RTAX_MAX) {
        
        switch(sa->sa_family) {
                
            case AF_INET: {
                struct sockaddr_in *si = (struct sockaddr_in *)sa;
                
                if(si->sin_addr.s_addr == INADDR_ANY)
                    routeString = @"default";
                else
                    routeString = [NSString stringWithCString:(char *)inet_ntoa(si->sin_addr) encoding:NSASCIIStringEncoding];
                
            }
                
                break;
                
            case AF_LINK: {
                
                struct sockaddr_dl *sdl = (struct sockaddr_dl*)sa;
                
                if(sdl->sdl_nlen + sdl->sdl_alen + sdl->sdl_slen == 0)
                    routeString = [NSString stringWithFormat: @"link #%d", sdl->sdl_index];
                else
                    routeString = [NSString stringWithCString:link_ntoa(sdl) encoding:NSASCIIStringEncoding];
                
            }
                
                break;
                
            default: {
                
                char a[3 * sa->sa_len];
                char *cp;
                char *sep = "";
                int i;
                
                if(sa->sa_len == 0) {
                    
                    routeString = nil;
                    
                } else {
                    
                    a[0] = '\0';
                    for(i = 0, cp = a; i < sa->sa_len; i++) {
                        
                        cp += sprintf(cp, "%s%02x", sep, (unsigned char)sa->sa_data[i]);
                        sep = ":";
                        
                    }
                    
                    routeString = [NSString stringWithCString:a encoding:NSASCIIStringEncoding];
                    
                }
                
            }
                
        }
        
    }
    
    return routeString;
    
}

@end

@implementation SKNetworkInfo

#pragma mark - Public Class Methods

+ (instancetype)sharedNetworkInfo {
    
    static SKNetworkInfo *sharedNetworkInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedNetworkInfo = [[self alloc] init];
        
    });
    
    return sharedNetworkInfo;
    
}

#pragma mark - Property Access Methods

- (BOOL)isConnected {
    
    return (self.connectedToWLAN || self.connectedToWWAN);
    
}

- (NSString *)currentIPAddress {
    
    if (self.connectedToWLAN) {
        
        return self.WLANIPAddress;
        
    } else if (self.connectedToWWAN) {
        
        return self.WWANIPAddress;
        
    }
    
    return nil;
    
}

- (NSString *)externalIPAddress {
    
    if (!self.connected) {
        
        return nil;
        
    }
    
    NSError *error;
    
    NSString *externalIP = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://icanhazip.com/"] encoding:NSUTF8StringEncoding error:&error];
    
    if (!error) {
        
        externalIP = [externalIP stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        if (externalIP == nil || externalIP.length <= 0) {
            
            return nil;
            
        }
        
        return externalIP;
        
    }
    
    return nil;
    
}

- (BOOL)isConnectedToWWAN {
    
    return (BOOL)self.WWANIPAddress;
    
}

- (NSString *)WWANIPAddress {
    
    NSString *IPAddress;

    struct ifaddrs *interfaces;
    struct ifaddrs *temp;
    struct sockaddr_in *s4;
    char buf[64];
    
    if (!getifaddrs(&interfaces)) {
        
        temp = interfaces;
        
        while (temp != NULL) {

            if (temp->ifa_addr->sa_family == AF_INET) {
                
                if ([[NSString stringWithUTF8String:temp->ifa_name] isEqualToString:@"pdp_ip0"]) {
                    
                    s4 = (struct sockaddr_in *)temp->ifa_addr;
                    
                    if (inet_ntop(temp->ifa_addr->sa_family, (void *)&(s4->sin_addr), buf, sizeof(buf)) == NULL) {

                        IPAddress = nil;
                        
                    } else {

                        IPAddress = [NSString stringWithUTF8String:buf];
                        
                    }
                    
                }
                
            }
            
            temp = temp->ifa_next;
            
        }
        
    }
    
    freeifaddrs(interfaces);
    
    if (IPAddress == nil || IPAddress.length <= 0) {

        return nil;
        
    }
    
    return IPAddress;
    
}

- (NSString *)WWANIPv6Address {

    NSString *IPv6Address;

    struct ifaddrs *interfaces;
    struct ifaddrs *temp;
    struct sockaddr_in6 *s6;
    char buf[INET6_ADDRSTRLEN];
    
    if (!getifaddrs(&interfaces)) {

        temp = interfaces;
        
        while(temp != NULL) {

            if (temp->ifa_addr->sa_family == AF_INET6) {

                if ([[NSString stringWithUTF8String:temp->ifa_name] isEqualToString:@"pdp_ip0"]) {
                    
                    s6 = (struct sockaddr_in6 *)temp->ifa_addr;
                    
                    if (inet_ntop(AF_INET6, (void *)&(s6->sin6_addr), buf, sizeof(buf)) == NULL) {
                        
                        IPv6Address = nil;
                        
                    } else {
                        
                        IPv6Address = [NSString stringWithUTF8String:buf];
                        
                    }
                    
                }
                
            }
            
            temp = temp->ifa_next;
            
        }
        
    }
    
    freeifaddrs(interfaces);
    
    if (IPv6Address == nil || IPv6Address.length <= 0) {

        return nil;
        
    }
    
    return IPv6Address;
    
}

- (NSString *)WWANNetmaskAddress {
    
    struct ifreq afr;

    strncpy(afr.ifr_name, [@"pdp_ip0" UTF8String], IFNAMSIZ-1);

    int afd = socket(AF_INET, SOCK_DGRAM, 0);
    
    if (afd == -1) {

        return nil;
        
    }
    
    if (ioctl(afd, SIOCGIFNETMASK, &afr) == -1) {

        close(afd);
        
        return nil;
        
    }
    
    close(afd);
    
    char *netstring = inet_ntoa(((struct sockaddr_in *)&afr.ifr_addr)->sin_addr);
    
    NSString *Netmask = [NSString stringWithUTF8String:netstring];
    
    if (Netmask == nil || Netmask.length <= 0) {

        return nil;
    }

    return Netmask;
    
}

- (NSString *)WWANBroadcastAddress {
    
    // Set up strings for the IP and Netmask
    NSString *IPAddress = self.WWANIPAddress;
    NSString *Netmask = self.WWANNetmaskAddress;
    
    if (!IPAddress || !Netmask) {
        
        return nil;
        
    }

    NSArray<NSString *> *IPCheck = [IPAddress componentsSeparatedByString:@"."];
    NSArray<NSString *> *NetmaskCheck = [Netmask componentsSeparatedByString:@"."];
    
    if (IPCheck.count != 4 || NetmaskCheck.count != 4) {
        
        return nil;
        
    }
    
    NSUInteger ip = 0;
    NSUInteger nm = 0;
    NSUInteger cs = 24;
    
    for (NSUInteger i = 0; i < 4; i++, cs -= 8) {
        
        ip |= [[IPCheck objectAtIndex:i] intValue] << cs;
        nm |= [[NetmaskCheck objectAtIndex:i] intValue] << cs;
        
    }
    
    NSUInteger ba = ~nm | ip;
    

    NSString *broadcastAddress = [NSString stringWithFormat:@"%ld.%ld.%ld.%ld", (long)(ba & 0xFF000000) >> 24,
                                                                                (long)(ba & 0x00FF0000) >> 16,
                                                                                (long)(ba & 0x0000FF00) >> 8,
                                                                                (long)(ba & 0x000000FF)];
    
    if (broadcastAddress == nil || broadcastAddress.length <= 0) {

        return nil;
        
    }

    return broadcastAddress;
    
}

- (BOOL)isConnectedToWLAN {
    
    return (BOOL)self.WLANIPAddress;
    
}

- (NSString *)WLANIPAddress {
    
    NSString *IPAddress;

    struct ifaddrs *interfaces;
    struct ifaddrs *temp;

    int Status = 0;
    
    Status = getifaddrs(&interfaces);
    
    if (Status == 0) {

        temp = interfaces;
        
        while (temp != NULL) {

            if (temp->ifa_addr->sa_family == AF_INET) {

                if ([[NSString stringWithUTF8String:temp->ifa_name] isEqualToString:@"en0"]) {

                    IPAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp->ifa_addr)->sin_addr)];
                    
                }
            }
            
            temp = temp->ifa_next;
            
        }
        
    }
    
    freeifaddrs(interfaces);
    
    if (IPAddress == nil || IPAddress.length <= 0) {

        return nil;
        
    }
    
    return IPAddress;
    
}

- (NSString *)WLANIPv6Address {
    
    NSString *IPv6Address;

    struct ifaddrs *interfaces;
    struct ifaddrs *temp;

    int status = 0;
    
    status = getifaddrs(&interfaces);
    
    if (status == 0) {

        temp = interfaces;
        
        while (temp != NULL) {

            if (temp->ifa_addr->sa_family == AF_INET6) {

                if ([[NSString stringWithUTF8String:temp->ifa_name] isEqualToString:@"en0"]) {

                    struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)temp->ifa_addr;
                    char buf[INET6_ADDRSTRLEN];
                    
                    if (inet_ntop(AF_INET6, (void *)&(addr6->sin6_addr), buf, sizeof(buf)) == NULL) {

                        IPv6Address = nil;
                        
                    } else {

                        IPv6Address = [NSString stringWithUTF8String:buf];
                        
                    }
                    
                }
                
            }
            
            temp = temp->ifa_next;
            
        }
        
    }
    
    freeifaddrs(interfaces);

    if (IPv6Address == nil || IPv6Address.length <= 0) {

        return nil;
        
    }
    
    return IPv6Address;
    
}

- (NSString *)WLANNetmaskAddress {
    
    struct ifreq afr;

    strncpy(afr.ifr_name, [@"en0" UTF8String], IFNAMSIZ-1);

    int afd = socket(AF_INET, SOCK_DGRAM, 0);
    
    if (afd == -1) {

        return nil;
        
    }
    
    if (ioctl(afd, SIOCGIFNETMASK, &afr) == -1) {

        close(afd);

        return nil;
        
    }
    
    close(afd);

    char *netstring = inet_ntoa(((struct sockaddr_in *)&afr.ifr_addr)->sin_addr);
    
    NSString *netmask = [NSString stringWithUTF8String:netstring];
    
    if (netmask == nil || netmask.length <= 0) {

        return nil;
        
    }

    return netmask;
    
}

- (NSString *)WLANBroadcastAddress {
    
    NSString *IPAddress = self.WLANIPAddress;
    NSString *Netmask = self.WLANNetmaskAddress;
    
    if (!IPAddress || !Netmask) {
        
        return nil;
        
    }
    
    NSArray<NSString *> *IPCheck = [IPAddress componentsSeparatedByString:@"."];
    NSArray<NSString *> *NetmaskCheck = [Netmask componentsSeparatedByString:@"."];
    
    if (IPCheck.count != 4 || NetmaskCheck.count != 4) {
  
        return nil;
        
    }
    
    NSUInteger ip = 0;
    NSUInteger nm = 0;
    NSUInteger cs = 24;
    
    for (NSUInteger i = 0; i < 4; i++, cs -= 8) {
        
        ip |= [[IPCheck objectAtIndex:i] intValue] << cs;
        nm |= [[NetmaskCheck objectAtIndex:i] intValue] << cs;
        
    }
    
    NSUInteger ba = ~nm | ip;
    
    NSString *broadcastAddress = [NSString stringWithFormat:@"%lu.%lu.%lu.%lu", (long)(ba & 0xFF000000) >> 24,
                                                                                (long)(ba & 0x00FF0000) >> 16,
                                                                                (long)(ba & 0x0000FF00) >> 8,
                                                                                (long)(ba & 0x000000FF)];
    
    if (broadcastAddress == nil || broadcastAddress.length <= 0) {

        return nil;
        
    }
    
    return broadcastAddress;
    
}

- (NSString *)WLANRouterAddress {
    
    NSString *RouterIP = nil;
    NSMutableArray<SKRouteInfo *> *routerArray = [SKRouteInfo getRoutes];

    for (int i = 0; i < (int)routerArray.count; i++) {

        SKRouteInfo *router = (SKRouteInfo *)routerArray[i];
        RouterIP = [router getGateway];
        
    }

    return RouterIP;
    
}

@end
