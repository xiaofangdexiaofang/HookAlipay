#import <UIKit/UIKit.h>
#import "zfbpojie.h"
#import <objc/message.h>
#import <CommonCrypto/CommonDigest.h> //MD5签名
#import <AudioToolbox/AudioToolbox.h> //铃声和震动的框架
#import <Foundation/Foundation.h>
//AFNetworking
#import <MobileCoreServices/MobileCoreServices.h>
#import <SystemConfiguration/SystemConfiguration.h>

/*static NSMutableArray *payerList;*/
/*static int notiMark = 0;*/
/*static int timeRecordeNumber = 0;*/
static int firstStepIn = 0;
static int lunxunTimeCount = 30;
static int recordeBool = 0;
/*static NSMutableString *paySuccessResult = [[NSMutableString alloc] init];*/
static NSMutableDictionary *submitAlreadyDict = [NSMutableDictionary dictionary];
#define PluginPath @"/Library/Application Support/"

static NSTimer *serverTimer;
/*static NSTimer *cfyFirstStepTimer;*/
//static NSTimer *firstTimer;
//static NSTimer *secondTimer;
//static NSTimer *thirdTimer;


%hook PaymentAssistViewController
- (void)viewDidLoad{
    %orig;
}
%end

/*
%hook MessageBoxView
- (void)addTestData:(id)arg1{
    %orig;

    //转账之后，这边会调用4此这个函数，不管是线上的测试或者是自己的这边的转账都是调用4次

    //这边先等待20秒也就是发送心跳包的时间
    NSLog(@"*************addTestData-arg1 = %@***********",arg1);


    while(0){
        ++timeRecordeNumber;
        if (timeRecordeNumber==1){
            timeRecordeNumber = 0;
        }else if (timeRecordeNumber==4){
            timeRecordeNumber = 0;
            break;
        }
    }
}
%end
*/

%hook APContactRecentViewController

- (void)reloadRecentContact:(id)arg1{
    %orig;

    NSLog(@"==================================reloadRecentContact线上数据的收到转账之后的数据==============================\n%@\n",arg1);

    [[NSClassFromString(@"CustomShowLabel") shareShowLabel] setText:@"收到一笔最新的到账" position:2];

    //不知道为什么，通过我自己转账的操作之后，这边就发送三次通知，但是通过线上的操作之后就发送一次通知？？？？修改了转账的链接地址

    /*++timeRecordeNumber;*/
    /*if (timeRecordeNumber>=3){*/
        /*timeRecordeNumber = 0;*/
        /*NSLog(@"==================================reloadRecentContact收到转账之后的数据==============================\n%@\n",arg1);*/

        NSNotification *notification = [NSNotification notificationWithName:@"APContactRecent_cfy_notification" object:nil userInfo:@{@"key":@"接收到了通知"}];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    /*}*/
}
%end

%hook BLMainListViewController

- (void)viewDidAppear:(_Bool)arg1{
    %orig;
    /*
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入轮询的时间值" preferredStyle:UIAlertControllerStyleAlert];

    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];

    //增加确定按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取第1个输入框；
        UITextField *userNameTextField = alertController.textFields.firstObject;
        NSLog(@"支付密码 = %@",userNameTextField.text);
        lunxunTimeCount = [userNameTextField.text intValue];

        NSLog(@"－－－－－-----------------修改轮询值的--------------------------%d",lunxunTimeCount);
    }]];

    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入轮询值";
    }];
    [self presentViewController:alertController animated:true completion:nil];
    */
}

- (void)viewDidLoad{
    %orig;

    //这里还有一个很重要的因素，导致大量到账订单没有提交，原因可能是线程开启的过多，导致影响主线程进而导致页面刷新失败，没有新的订单刷新，但是为什么手动刷新，反而可以提交，可能在于手动刷新的方法和自动刷新的方法不同

    //这里我在考虑要不要将全局的字典在这里初始化，相当于每次进来都会把最新的前20个提交到服务器

    //这里后面可以考虑将发送心跳包的NSTimer实现的定时器，用GCD去实现，这样的话就彻底将NSTimer这个会导致内存泄漏的因素给扼杀掉,这边后面测试下相关的代码

    /*
    //获取队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    //创建一个定时器（dispatch_source_t本质还是个OC对象）
    self.cfy_gcd_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0,0,queue);
    //设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    //GCD的时间参数，一般是纳秒
    //何时开始执行第一个任务
    //dispatch_time(DISPATCH_TIME_NOW,1.0*NSEC_PER_SEC) 比当前时间晚三秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW,(int64_t)(1.0*NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.cfy_gcd_timer,start,interval,0);

    //设置回调
    dispatch_source_set_event_handler(self.cfy_gcd_timer,^{
        NSLog(@"-------------%@-------",[NSThread currentThread]);

        //取消定时器,后面将定时器取消放在viewWillDisAppear中
        dispatch_cancel(self.cfy_gcd_timer);
        self.cfy_gcd_timer = nil;
    });

    //启动定时器
    dispatch_resume(self.cfy_gcd_timer);
    */


    //这边按照要求去向服务器轮询发送心跳包，这边后面要做一个限制，就是限制其并发线程的数目，
    serverTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(postMessageToServer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:serverTimer forMode:NSRunLoopCommonModes];

    //这里要做一个轮询，每隔2秒执行一个方法，然后去触动focusInputBox这个方法的执行
    //这边昨天尝试了40S轮询一次，没问题，出错的原因在于提交的服务器失败，然后直接执行了添加字典的方法，所以导致没发送到服务器，下次再对比的时候，还是没有提交的服务器
    //如果这边2S轮询一次，会不会因为速度过快，前面的几个网络请求还没有完成就又轮询一次
    //这边应该设置一个随机数

    //这个是一开始进入账单页面，把最新的20条记录，提交给服务器，防止因为操作的问题，导致订单提交不了
    /*
    cfyFirstStepTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getPaylistFromNSTimer) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:cfyFirstStepTimer forMode:NSRunLoopCommonModes];
    */

    [self getPaylistFromNSTimer];

    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"APContactRecent_cfy_notification" object:nil];

    [[NSClassFromString(@"CustomShowLabel") shareShowLabel] setText:@"初始化工作完成" position:1];
}

%new
- (void)tongzhi:(NSNotification *)text{
    NSLog(@"－－－－－-----------------tongzhi接收到通知--------------------------");

    if (firstStepIn == 0){
        firstStepIn = 1;
        //这边开始计时30秒后
        //收到通知以后刷新界面，这边先延迟30秒再去刷新列表提交服务器
        //这个timer应该使用同一个？

        //刷新列表
        [self getPaylistFromNSTimer];
        /*
        firstTimer = [NSTimer scheduledTimerWithTimeInterval:lunxunTimeCount target:self selector:@selector(resetTimerCount) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:firstTimer forMode:NSRunLoopCommonModes];
        */
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(lunxunTimeCount * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self resetTimerCount];
        });
    }else{
        //相当于在30秒内如果有请求，将其做一个标记，30秒时间结束，再刷新一遍列表
        //如果进入到此分支，说明30秒内有其他请求过来
        recordeBool = 1;
    }
}

%new
- (void)resetTimerCount{
    NSLog(@"------------------- resetTimerCount--30秒后重置计时器 -----------------------");
    //30秒之后再重新发送一次,把之前累积的通知一起发送过去，但是如果30秒之内没有任务过来的话，这边就不需要刷新
    if (recordeBool == 1){
        recordeBool = 0;
        [self getPaylistFromNSTimer];
        /*
        secondTimer = [NSTimer scheduledTimerWithTimeInterval:lunxunTimeCount target:self selector:@selector(subResetTimerCount) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:secondTimer forMode:NSRunLoopCommonModes];
        */
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(lunxunTimeCount * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self subResetTimerCount];
        });
    }else{
        firstStepIn = 0;
    }
}

%new
- (void)subResetTimerCount{
    NSLog(@"------------------- subResetTimerCount--30秒后重置计时器 -----------------------");
    //等30秒内的其他请求完成以后，再将入口置为可行，这边有个大问题，只有等到下一次提交上来之前才能之前的积压的三个提交的服务器，如果后面没有刷新，那么就会造成漏单

    //30秒之后再重新发送一次,把之前累积的通知一起发送过去，但是如果30秒之内没有任务过来的话，这边就不需要刷新
    if (recordeBool == 1){
        recordeBool = 0;
        [self getPaylistFromNSTimer];
        /*
        thirdTimer = [NSTimer scheduledTimerWithTimeInterval:lunxunTimeCount target:self selector:@selector(resetTimerCount) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:thirdTimer forMode:NSRunLoopCommonModes]
        */
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(lunxunTimeCount * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self resetTimerCount];
        });
    }else{
        firstStepIn = 0;
    }
}

%new
- (void)postMessageToServer{

    //这边应该使用并发队列，把任务放到队列中，不影响其他线程
    @try {
    // 可能会出现崩溃的代码
    dispatch_queue_t queueSer = dispatch_queue_create("com.gcd.queueCreate.myConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
        void (^blk1)() = ^{
        /*NSLog(@"------------------- test = -----------------------%@",@"OK");*/
            [self postMessageToServerSubInterface];
        };
        dispatch_async(queueSer, blk1);
    }@catch (NSException *exception) {
        // 捕获到的异常exception
        /*NSLog(@"------------------- exception = -----------------------%@",exception);*/
    }@finally {
        // 结果处理
    }
}

%new
- (void)postMessageToServerSubInterface{
    //这边是轮询服务器的接口

    //这边获取userID，因为这边只有这个类的声明，然后却没有他的实现，所以导致出现这个错误
    /*
        Undefined symbols for architecture armv7:
        "_OBJC_CLASS_$_PEHelper", referenced from:
        objc-class-ref in Tweak.xm.28737e99.o
        ld: symbol(s) not found for architecture armv7
    */
    //所以需要使用这种方式实现
    NSString *userId = [NSClassFromString(@"PEHelper") loginUserId];
    /*NSLog(@"------------------- userId = -----------------------%@",userId);*/

    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://114.55.202.198/lefu/api/heartbeat/updateZfbSinglePay.pay"];
    //http://jh.lecou.com.cn/lefu/api/heartbeat/updateZfbSinglePay.pay
    //https://u5.utopay.cn/utopay5/api/heartbeat/updateZfbSinglePay.pay
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";

    //如果这边连接失败，客户端这边要做什么？找一个数记录下，如果检测到这边失败直接将timer置为失败，或者不执行后面的代码
    NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
    [subDict setValue:userId forKey:@"userId"];

    NSData *json = [NSJSONSerialization dataWithJSONObject:subDict options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = json;

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            /*NSLog(@"************* 心跳包--提交成功response= ***************%@",response);*/

            /*NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];*/
            /*NSLog(@"************* 心跳包--返回的数据***************%@",dict);*/

            NSLog(@"心跳包线程--begin---%@",[NSThread currentThread]);  // 打印当前线程
            dispatch_async(dispatch_get_main_queue(), ^{
                //界面展示要在主线程做
                [[NSClassFromString(@"CustomShowLabel") shareShowLabel] setText:@"心跳包发送成功" position:-1];
                NSLog(@"心跳包线程--after---%@",[NSThread currentThread]);  // 打印当前线程
            });

        }else{
            /*NSLog(@"************* 心跳包--提交失败的error= ***************%@",error);*/
            NSLog(@"心跳包线程--begin---%@",[NSThread currentThread]);  // 打印当前线程
            dispatch_async(dispatch_get_main_queue(), ^{
                //界面展示要在主线程做,这边发送心跳包失败的时候，要把失败的原因打印出来
                [[NSClassFromString(@"CustomShowLabel") shareShowLabel] setText:[NSString stringWithFormat:@"************* 心跳包--提交失败的error= ***************%@",error] position:-1];
                NSLog(@"心跳包线程--after---%@",[NSThread currentThread]);  // 打印当前线程
            });
        }
    }];

    [dataTask resume];
}

%new
-(void)getPaylistFromNSTimer{

    NSLog(@"－－－－－-----------------getPaylistFromNSTimer此处接收到通知然后刷新了界面--------------------------");
    /*
    此处每次都应该让其刷新下，从网络获取数据，更新列表，当这边帅新列表的时候，才会触发BLListCell中的刷新方法，进而发送通知，VC接受通知做出处理
    */

    //我感觉这边也应该清空下submitAlreadyDict的字典，因为越来越大，会导致出现内存问题，然后在未刷新之前把当前界面的subviews的cell上数据找出来，保留不删除，相当于只留当前界面的几个数据，其他的全部删除，我感觉这个想法满不错的,下面是当字典大于1000的时候，清除一波
    if (submitAlreadyDict.allKeys.count > 5000) {
        //这边获取到的应该是最新的20个
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

    //因为每隔3秒，就来刷新下列表，3秒之内请求还未完成，又来一个任务，所以导致后面的订单提交重复
    //创建一个串行队列？ 然后同步发送此代码？这样能避免重复提交的情况？？？

    @try {
        // 可能会出现崩溃的代码
        dispatch_queue_t queueSer = dispatch_queue_create("com.gcd.queueCreate.mySerialQueue", DISPATCH_QUEUE_SERIAL);
        void (^blk1)() = ^{
            /*NSLog(@"------------------- test = -----------------------%@",@"OK");*/
            [self refreshEvent];
        };
        dispatch_async(queueSer, blk1);
    }@catch (NSException *exception) {
        // 捕获到的异常exception
        /*NSLog(@"------------------- exception = -----------------------%@",exception);*/
    }@finally {
        // 结果处理
    }
}

/*
重写刷新的方法
*/
- (void)refreshEvent{
    %orig;

    //这边通过这个方法去获取当前界面的图层问题，然后分析其中的文字，如果有这个文字，表示支付宝已经检测出来，应该立即停止心跳包

    //这边还有一个这样的问题，如果当前界面刷新时，支付宝检测到，然后就不刷新了，跳出弹框

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestServer];
    });
}

%new
- (void)requestServer{

    //这边获取到的应该是最新的20个,当新注册的支付宝账号列表是没有订单的，所以这边应该做个判断，有可能blSecItemArr这个数组为空
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

        /*NSLog(@"------------------- 查找之前submitAlreadyDict = -----------------------%@",submitAlreadyDict);*/

        for(BLListItem *item in listItemArr){
            if([item.money containsString:@"+"] && [item.title containsString:@"-"]){
                NSString *bizInNo = item.bizInNo;
                /*NSLog(@"------------------- 当前界面cell的bizInNo = -----------------------%@",bizInNo);*/

                if([submitAlreadyDict objectForKey:bizInNo] == nil){
                    //通过subviews获取到的cell上memo，去获取BLListItem上的订单号对应的字典
                    NSDictionary *dict = [allDict objectForKey:bizInNo];

                    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
                    dispatch_barrier_sync(concurrentQueue, ^{
                        //这边将获取到的字集合发送到服务器
                        [self postPaySuccessResult:dict bizInNoPara:bizInNo];
                    });

                    /*NSLog(@"*********************正在添加中submitAlreadyDict = *********************%@",submitAlreadyDict);*/

                    //我估计是因为发送请求没有成功，但是dict已经添加到字典中了，所以会导致没有字典添加进去？？？？？
                }
            }
        }

        /*NSLog(@"*********************查找之后submitAlreadyDict = *********************%@",submitAlreadyDict);*/
    }
}

%new
- (NSString *)md5_32bit:(NSString *)input{
     //传入参数,转化成char
     const char * str = [input UTF8String];
     //开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
     unsigned char md[CC_MD5_DIGEST_LENGTH];
     CC_MD5(str, (int)strlen(str), md);
     //创建一个可变字符串收集结果
     NSMutableString * ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
     for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
         [ret appendFormat:@"%02X",md[i]];
     }
     //返回一个长度为32的字符串
     return ret;
}

%new
- (void)postPaySuccessResult:(NSDictionary *)orderInfo bizInNoPara:(NSString *)bizInNos{

    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://114.55.202.198/lefu/api/notify/1077/1220/doNotify.pay"];
    //http://jh.lecou.com.cn/lefu/api/notify/1056/1181/doNotify.pay
    //http://192.168.1.136:8087/seckill/getClientSucessPayResult
    //https://u5.utopay.cn/utopay5/api/notify/1054/1180/doNotify.pay
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";

    NSString *bizInNo = [orderInfo objectForKey:@"bizInNo"];
    NSString *payerMemos = [orderInfo objectForKey:@"payerMemo"];
    NSString *payerName = [orderInfo objectForKey:@"payerName"];
    NSString *money = [orderInfo objectForKey:@"money"];
    NSString *md5Sign = [self md5_32bit:[NSString stringWithFormat:@"%@-%@-%@-%@",bizInNo,payerMemos,payerName,money]];

    /*NSLog(@"*********************签名的md5Sign = *********************%@",md5Sign);*/

    //这边将拿到的字典添加一个MD5的签名
    NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
    [subDict setValue:bizInNo forKey:@"bizInNo"];
    [subDict setValue:payerMemos forKey:@"payerMemo"];
    [subDict setValue:payerName forKey:@"payerName"];
    [subDict setValue:money forKey:@"money"];
    [subDict setValue:md5Sign forKey:@"md5Sign"];

    NSData *json = [NSJSONSerialization dataWithJSONObject:subDict options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = json;

    //这边每次都创建一个TCP连接很耗时，下次优化的时候，可以只连接一次，节省传输时间

    //这边如果速度过快，会导致重复提交，提交很多订单，我觉得是因为这个时候，字典里面还没有添加上，所以后面的程序可以依然请求，但是当你添加上以后，其他的请求已经提交了，所以会导致很多的重复订单请求，这个问题怎么解决
    //将去任务放在队列中，一个一个排队解决
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"订单提交到服务器线程--begin---%@",[NSThread currentThread]);  // 打印当前线程

            dispatch_async(dispatch_get_main_queue(), ^{

                //界面展示要在主线程做
                [[NSClassFromString(@"CustomShowLabel") shareShowLabel] setText:@"订单提交成功" position:1];
                NSLog(@"订单提交到服务器线程--after---%@",[NSThread currentThread]);  // 打印当前线程
            });
            //此处的字典是全局的，所以可能会导致多线程竞争，所以这里要加锁
            [submitAlreadyDict setValue:orderInfo forKey:bizInNos];
        }else{
            NSLog(@"订单提交到服务器线程--begin---%@",[NSThread currentThread]);  // 打印当前线程

            dispatch_async(dispatch_get_main_queue(), ^{

                NSLog(@"---cfy---postServer-error---%@---",error);
                //界面展示要在主线程做
                [[NSClassFromString(@"CustomShowLabel") shareShowLabel] setText:@"订单提交失败" position:1];
                NSLog(@"订单提交到服务器线程--after---%@",[NSThread currentThread]);  // 打印当前线程
            });
        }
    }];

    [dataTask resume];
}

//此处应该将NSTimer释放掉，但是现在逆向的写法中释放不掉，因为NStimer持有Controller，所以里面的代码一直执行
- (void)viewWillDisappear:(_Bool)arg1{
    %orig;

    if ([serverTimer isKindOfClass:[NSTimer class]] && serverTimer != nil) {
        [serverTimer invalidate];
        serverTimer = nil;
    }

    /*
    if ([firstTimer isKindOfClass:[NSTimer class]] && firstTimer != nil) {
        [firstTimer invalidate];
        firstTimer = nil;
    }

    if ([secondTimer isKindOfClass:[NSTimer class]] && secondTimer != nil) {
        [secondTimer invalidate];
        secondTimer = nil;
    }

    if ([thirdTimer isKindOfClass:[NSTimer class]] && thirdTimer != nil) {
        [thirdTimer invalidate];
        thirdTimer = nil;
    }
    */

    //这边要给服务器发送离开页面的请求，告诉服务器，这个页面将要消失，不要再派送订单给此页面,但是此处这个函数容易崩溃，看这边的崩溃信息，应该是没找到对应的方法，相当于对象用错了方法
    NSString *userId = [NSClassFromString(@"PEHelper") loginUserId];
    /*NSLog(@"------------------- userId = -----------------------%@",userId);*/

    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://114.55.202.198/lefu/api/heartbeat/stopHeartbeat.pay"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";

    //如果这边连接失败，客户端这边要做什么？找一个数记录下，如果检测到这边失败直接将timer置为失败，或者不执行后面的代码
    NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
    [subDict setValue:userId forKey:@"userId"];

    NSData *json = [NSJSONSerialization dataWithJSONObject:subDict options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = json;

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //界面展示要在主线程做
                [[NSClassFromString(@"CustomShowLabel") shareShowLabel] setText:@"心跳包停止成功" position:-1];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //界面展示要在主线程做
                [[NSClassFromString(@"CustomShowLabel") shareShowLabel] setText:@"心跳包停止失败" position:-1];
            });
        }
    }];

    [dataTask resume];

}

//这边理论上来说已经解决掉NSTimer的相互引用的问题，然后这边还需要移除通知
- (void)dealloc{
    %orig;

    //移除当前的名为APContactRecent_cfy_notification的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"" object:nil];

    [[NSClassFromString(@"CustomShowLabel") shareShowLabel] setText:@"此处表示已经调用dealloc的方法，而且已经移除当前额外添加的通知" position:1];
}

%end
