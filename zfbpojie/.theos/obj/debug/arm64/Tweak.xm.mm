#line 1 "Tweak.xm"
#import <UIKit/UIKit.h>
#import "zfbpojie.h"
#import <objc/message.h>
#import <CommonCrypto/CommonDigest.h> 
#import <AudioToolbox/AudioToolbox.h> 
#import <Foundation/Foundation.h>

#import <MobileCoreServices/MobileCoreServices.h>
#import <SystemConfiguration/SystemConfiguration.h>




static int firstStepIn = 0;
static int lunxunTimeCount = 30;
static int recordeBool = 0;

static NSMutableDictionary *submitAlreadyDict = [NSMutableDictionary dictionary];
#define PluginPath @"/Library/Application Support/"

static NSTimer *serverTimer;







#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class APContactRecentViewController; @class PaymentAssistViewController; @class BLMainListViewController; 
static void (*_logos_orig$_ungrouped$PaymentAssistViewController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL PaymentAssistViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$PaymentAssistViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL PaymentAssistViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$APContactRecentViewController$reloadRecentContact$)(_LOGOS_SELF_TYPE_NORMAL APContactRecentViewController* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$APContactRecentViewController$reloadRecentContact$(_LOGOS_SELF_TYPE_NORMAL APContactRecentViewController* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$BLMainListViewController$viewDidAppear$)(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST, SEL, _Bool); static void _logos_method$_ungrouped$BLMainListViewController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST, SEL, _Bool); static void (*_logos_orig$_ungrouped$BLMainListViewController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$BLMainListViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$BLMainListViewController$tongzhi$(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST, SEL, NSNotification *); static void _logos_method$_ungrouped$BLMainListViewController$resetTimerCount(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$BLMainListViewController$subResetTimerCount(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$BLMainListViewController$postMessageToServer(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$BLMainListViewController$postMessageToServerSubInterface(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$BLMainListViewController$getPaylistFromNSTimer(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$BLMainListViewController$refreshEvent)(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$BLMainListViewController$refreshEvent(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$BLMainListViewController$requestServer(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST, SEL); static NSString * _logos_method$_ungrouped$BLMainListViewController$md5_32bit$(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST, SEL, NSString *); static void _logos_method$_ungrouped$BLMainListViewController$postPaySuccessResult$bizInNoPara$(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST, SEL, NSDictionary *, NSString *); static void (*_logos_orig$_ungrouped$BLMainListViewController$viewWillDisappear$)(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST, SEL, _Bool); static void _logos_method$_ungrouped$BLMainListViewController$viewWillDisappear$(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST, SEL, _Bool); static void (*_logos_orig$_ungrouped$BLMainListViewController$dealloc)(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$BLMainListViewController$dealloc(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST, SEL); 

#line 28 "Tweak.xm"

static void _logos_method$_ungrouped$PaymentAssistViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL PaymentAssistViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    _logos_orig$_ungrouped$PaymentAssistViewController$viewDidLoad(self, _cmd);
}




























static void _logos_method$_ungrouped$APContactRecentViewController$reloadRecentContact$(_LOGOS_SELF_TYPE_NORMAL APContactRecentViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1){
    _logos_orig$_ungrouped$APContactRecentViewController$reloadRecentContact$(self, _cmd, arg1);

    NSLog(@"==================================reloadRecentContact线上数据的收到转账之后的数据==============================\n%@\n",arg1);

    [[NSClassFromString(@"CustomShowLabel") shareShowLabel] setText:@"收到一笔最新的到账" position:2];

    

    
    
        
        

        NSNotification *notification = [NSNotification notificationWithName:@"APContactRecent_cfy_notification" object:nil userInfo:@{@"key":@"接收到了通知"}];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}




static void _logos_method$_ungrouped$BLMainListViewController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, _Bool arg1){
    _logos_orig$_ungrouped$BLMainListViewController$viewDidAppear$(self, _cmd, arg1);
    






















}

static void _logos_method$_ungrouped$BLMainListViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    _logos_orig$_ungrouped$BLMainListViewController$viewDidLoad(self, _cmd);

    

    

    

    


























    
    serverTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(postMessageToServer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:serverTimer forMode:NSRunLoopCommonModes];

    
    
    
    

    
    




    [self getPaylistFromNSTimer];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"APContactRecent_cfy_notification" object:nil];

    [[NSClassFromString(@"CustomShowLabel") shareShowLabel] setText:@"初始化工作完成" position:1];
}


static void _logos_method$_ungrouped$BLMainListViewController$tongzhi$(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSNotification * text){
    NSLog(@"－－－－－-----------------tongzhi接收到通知--------------------------");

    if (firstStepIn == 0){
        firstStepIn = 1;
        
        
        

        
        [self getPaylistFromNSTimer];
        



        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(lunxunTimeCount * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self resetTimerCount];
        });
    }else{
        
        
        recordeBool = 1;
    }
}


static void _logos_method$_ungrouped$BLMainListViewController$resetTimerCount(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    NSLog(@"------------------- resetTimerCount--30秒后重置计时器 -----------------------");
    
    if (recordeBool == 1){
        recordeBool = 0;
        [self getPaylistFromNSTimer];
        



        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(lunxunTimeCount * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self subResetTimerCount];
        });
    }else{
        firstStepIn = 0;
    }
}


static void _logos_method$_ungrouped$BLMainListViewController$subResetTimerCount(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    NSLog(@"------------------- subResetTimerCount--30秒后重置计时器 -----------------------");
    

    
    if (recordeBool == 1){
        recordeBool = 0;
        [self getPaylistFromNSTimer];
        



        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(lunxunTimeCount * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self resetTimerCount];
        });
    }else{
        firstStepIn = 0;
    }
}


static void _logos_method$_ungrouped$BLMainListViewController$postMessageToServer(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){

    
    @try {
    
    dispatch_queue_t queueSer = dispatch_queue_create("com.gcd.queueCreate.myConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
        void (^blk1)() = ^{
        
            [self postMessageToServerSubInterface];
        };
        dispatch_async(queueSer, blk1);
    }@catch (NSException *exception) {
        
        
    }@finally {
        
    }
}


static void _logos_method$_ungrouped$BLMainListViewController$postMessageToServerSubInterface(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    

    
    





    
    NSString *userId = [NSClassFromString(@"PEHelper") loginUserId];
    

    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://114.55.202.198/lefu/api/heartbeat/updateZfbSinglePay.pay"];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";

    
    NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
    [subDict setValue:userId forKey:@"userId"];

    NSData *json = [NSJSONSerialization dataWithJSONObject:subDict options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = json;

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            

            
            

            NSLog(@"心跳包线程--begin---%@",[NSThread currentThread]);  
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSClassFromString(@"CustomShowLabel") shareShowLabel] setText:@"心跳包发送成功" position:-1];
                NSLog(@"心跳包线程--after---%@",[NSThread currentThread]);  
            });

        }else{
            
            NSLog(@"心跳包线程--begin---%@",[NSThread currentThread]);  
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSClassFromString(@"CustomShowLabel") shareShowLabel] setText:[NSString stringWithFormat:@"************* 心跳包--提交失败的error= ***************%@",error] position:-1];
                NSLog(@"心跳包线程--after---%@",[NSThread currentThread]);  
            });
        }
    }];

    [dataTask resume];
}


static void _logos_method$_ungrouped$BLMainListViewController$getPaylistFromNSTimer(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){

    NSLog(@"－－－－－-----------------getPaylistFromNSTimer此处接收到通知然后刷新了界面--------------------------");
    



    
    if (submitAlreadyDict.allKeys.count > 5000) {
        
        BLListModel *model = [self.dataManager listInfo];
        NSArray *blSecItemArr = [model list];
        BLListSectionItem *blSectionItem = blSecItemArr[0];
        NSArray *listItemArr = [blSectionItem recordList];

        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        for(BLListItem *item in listItemArr){
            if([item.money containsString:@"+"] && [item.title containsString:@"-"]){
                NSString *bizInNo = item.bizInNo;
                if([submitAlreadyDict objectForKey:bizInNo] != nil){
                    NSDictionary *dict = [submitAlreadyDict objectForKey:bizInNo];
                    [tempDict setValue:dict forKey:bizInNo];
                }
            }
        }
        submitAlreadyDict = [NSMutableDictionary dictionary];
        submitAlreadyDict = tempDict;
    }

    
    

    @try {
        
        dispatch_queue_t queueSer = dispatch_queue_create("com.gcd.queueCreate.mySerialQueue", DISPATCH_QUEUE_SERIAL);
        void (^blk1)() = ^{
            
            [self refreshEvent];
        };
        dispatch_async(queueSer, blk1);
    }@catch (NSException *exception) {
        
        
    }@finally {
        
    }
}




static void _logos_method$_ungrouped$BLMainListViewController$refreshEvent(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    _logos_orig$_ungrouped$BLMainListViewController$refreshEvent(self, _cmd);

    

    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestServer];
    });
}


static void _logos_method$_ungrouped$BLMainListViewController$requestServer(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){

    
    BLListModel *model = [self.dataManager listInfo];
    NSArray *blSecItemArr = [model list];
    BLListSectionItem *blSectionItem = blSecItemArr[0];
    NSArray *listItemArr = [blSectionItem recordList];

    if (listItemArr.count != 0) {
        NSMutableDictionary *allDict = [NSMutableDictionary dictionary];
        for(BLListItem *item in listItemArr){
            if([item.money containsString:@"+"] && [item.title containsString:@"-"]){
                NSString *bizInNo = item.bizInNo;
                NSString *payerMemo = [item.title componentsSeparatedByString:@"-"][0];
                NSString *payerName = [item.title componentsSeparatedByString:@"-"][1];
                NSString *money = item.money;

                NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
                [subDict setValue:bizInNo forKey:@"bizInNo"];
                [subDict setValue:payerMemo forKey:@"payerMemo"];
                [subDict setValue:payerName forKey:@"payerName"];
                [subDict setValue:money forKey:@"money"];

                [allDict setValue:subDict forKey:bizInNo];
            }
        }

        

        for(BLListItem *item in listItemArr){
            if([item.money containsString:@"+"] && [item.title containsString:@"-"]){
                NSString *bizInNo = item.bizInNo;
                

                if([submitAlreadyDict objectForKey:bizInNo] == nil){
                    
                    NSDictionary *dict = [allDict objectForKey:bizInNo];

                    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
                    dispatch_barrier_sync(concurrentQueue, ^{
                        
                        [self postPaySuccessResult:dict bizInNoPara:bizInNo];
                    });

                    

                    
                }
            }
        }

        
    }
}


static NSString * _logos_method$_ungrouped$BLMainListViewController$md5_32bit$(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * input){
     
     const char * str = [input UTF8String];
     
     unsigned char md[CC_MD5_DIGEST_LENGTH];
     CC_MD5(str, (int)strlen(str), md);
     
     NSMutableString * ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
     for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
         [ret appendFormat:@"%02X",md[i]];
     }
     
     return ret;
}


static void _logos_method$_ungrouped$BLMainListViewController$postPaySuccessResult$bizInNoPara$(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSDictionary * orderInfo, NSString * bizInNos){

    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://114.55.202.198/lefu/api/notify/1056/1181/doNotify.pay"];
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";

    NSString *bizInNo = [orderInfo objectForKey:@"bizInNo"];
    NSString *payerMemos = [orderInfo objectForKey:@"payerMemo"];
    NSString *payerName = [orderInfo objectForKey:@"payerName"];
    NSString *money = [orderInfo objectForKey:@"money"];
    NSString *md5Sign = [self md5_32bit:[NSString stringWithFormat:@"%@-%@-%@-%@",bizInNo,payerMemos,payerName,money]];

    

    
    NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
    [subDict setValue:bizInNo forKey:@"bizInNo"];
    [subDict setValue:payerMemos forKey:@"payerMemo"];
    [subDict setValue:payerName forKey:@"payerName"];
    [subDict setValue:money forKey:@"money"];
    [subDict setValue:md5Sign forKey:@"md5Sign"];

    NSData *json = [NSJSONSerialization dataWithJSONObject:subDict options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = json;

    

    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"订单提交到服务器线程--begin---%@",[NSThread currentThread]);  
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSClassFromString(@"CustomShowLabel") shareShowLabel] setText:@"订单提交成功" position:1];
                NSLog(@"订单提交到服务器线程--after---%@",[NSThread currentThread]);  
            });
            
            [submitAlreadyDict setValue:orderInfo forKey:bizInNos];
        }else{
            NSLog(@"订单提交到服务器线程--begin---%@",[NSThread currentThread]);  
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSClassFromString(@"CustomShowLabel") shareShowLabel] setText:@"订单提交失败" position:1];
                NSLog(@"订单提交到服务器线程--after---%@",[NSThread currentThread]);  
            });
        }
    }];

    [dataTask resume];
}


static void _logos_method$_ungrouped$BLMainListViewController$viewWillDisappear$(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, _Bool arg1){
    _logos_orig$_ungrouped$BLMainListViewController$viewWillDisappear$(self, _cmd, arg1);

    if ([serverTimer isKindOfClass:[NSTimer class]] && serverTimer != nil) {
        [serverTimer invalidate];
        serverTimer = nil;
    }

    
















    
    NSString *userId = [NSClassFromString(@"PEHelper") loginUserId];
    

    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://114.55.202.198/lefu/api/heartbeat/stopHeartbeat.pay"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";

    
    NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
    [subDict setValue:userId forKey:@"userId"];

    NSData *json = [NSJSONSerialization dataWithJSONObject:subDict options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = json;

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSClassFromString(@"CustomShowLabel") shareShowLabel] setText:@"心跳包停止成功" position:-1];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSClassFromString(@"CustomShowLabel") shareShowLabel] setText:@"心跳包停止失败" position:-1];
            });
        }
    }];

    [dataTask resume];

}


static void _logos_method$_ungrouped$BLMainListViewController$dealloc(_LOGOS_SELF_TYPE_NORMAL BLMainListViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    _logos_orig$_ungrouped$BLMainListViewController$dealloc(self, _cmd);

    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"" object:nil];

    [[NSClassFromString(@"CustomShowLabel") shareShowLabel] setText:@"此处表示已经调用dealloc的方法，而且已经移除当前额外添加的通知" position:1];
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$PaymentAssistViewController = objc_getClass("PaymentAssistViewController"); MSHookMessageEx(_logos_class$_ungrouped$PaymentAssistViewController, @selector(viewDidLoad), (IMP)&_logos_method$_ungrouped$PaymentAssistViewController$viewDidLoad, (IMP*)&_logos_orig$_ungrouped$PaymentAssistViewController$viewDidLoad);Class _logos_class$_ungrouped$APContactRecentViewController = objc_getClass("APContactRecentViewController"); MSHookMessageEx(_logos_class$_ungrouped$APContactRecentViewController, @selector(reloadRecentContact:), (IMP)&_logos_method$_ungrouped$APContactRecentViewController$reloadRecentContact$, (IMP*)&_logos_orig$_ungrouped$APContactRecentViewController$reloadRecentContact$);Class _logos_class$_ungrouped$BLMainListViewController = objc_getClass("BLMainListViewController"); MSHookMessageEx(_logos_class$_ungrouped$BLMainListViewController, @selector(viewDidAppear:), (IMP)&_logos_method$_ungrouped$BLMainListViewController$viewDidAppear$, (IMP*)&_logos_orig$_ungrouped$BLMainListViewController$viewDidAppear$);MSHookMessageEx(_logos_class$_ungrouped$BLMainListViewController, @selector(viewDidLoad), (IMP)&_logos_method$_ungrouped$BLMainListViewController$viewDidLoad, (IMP*)&_logos_orig$_ungrouped$BLMainListViewController$viewDidLoad);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSNotification *), strlen(@encode(NSNotification *))); i += strlen(@encode(NSNotification *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$BLMainListViewController, @selector(tongzhi:), (IMP)&_logos_method$_ungrouped$BLMainListViewController$tongzhi$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$BLMainListViewController, @selector(resetTimerCount), (IMP)&_logos_method$_ungrouped$BLMainListViewController$resetTimerCount, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$BLMainListViewController, @selector(subResetTimerCount), (IMP)&_logos_method$_ungrouped$BLMainListViewController$subResetTimerCount, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$BLMainListViewController, @selector(postMessageToServer), (IMP)&_logos_method$_ungrouped$BLMainListViewController$postMessageToServer, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$BLMainListViewController, @selector(postMessageToServerSubInterface), (IMP)&_logos_method$_ungrouped$BLMainListViewController$postMessageToServerSubInterface, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$BLMainListViewController, @selector(getPaylistFromNSTimer), (IMP)&_logos_method$_ungrouped$BLMainListViewController$getPaylistFromNSTimer, _typeEncoding); }MSHookMessageEx(_logos_class$_ungrouped$BLMainListViewController, @selector(refreshEvent), (IMP)&_logos_method$_ungrouped$BLMainListViewController$refreshEvent, (IMP*)&_logos_orig$_ungrouped$BLMainListViewController$refreshEvent);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$BLMainListViewController, @selector(requestServer), (IMP)&_logos_method$_ungrouped$BLMainListViewController$requestServer, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString *), strlen(@encode(NSString *))); i += strlen(@encode(NSString *)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSString *), strlen(@encode(NSString *))); i += strlen(@encode(NSString *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$BLMainListViewController, @selector(md5_32bit:), (IMP)&_logos_method$_ungrouped$BLMainListViewController$md5_32bit$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSDictionary *), strlen(@encode(NSDictionary *))); i += strlen(@encode(NSDictionary *)); memcpy(_typeEncoding + i, @encode(NSString *), strlen(@encode(NSString *))); i += strlen(@encode(NSString *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$BLMainListViewController, @selector(postPaySuccessResult:bizInNoPara:), (IMP)&_logos_method$_ungrouped$BLMainListViewController$postPaySuccessResult$bizInNoPara$, _typeEncoding); }MSHookMessageEx(_logos_class$_ungrouped$BLMainListViewController, @selector(viewWillDisappear:), (IMP)&_logos_method$_ungrouped$BLMainListViewController$viewWillDisappear$, (IMP*)&_logos_orig$_ungrouped$BLMainListViewController$viewWillDisappear$);MSHookMessageEx(_logos_class$_ungrouped$BLMainListViewController, sel_registerName("dealloc"), (IMP)&_logos_method$_ungrouped$BLMainListViewController$dealloc, (IMP*)&_logos_orig$_ungrouped$BLMainListViewController$dealloc);} }
#line 578 "Tweak.xm"
