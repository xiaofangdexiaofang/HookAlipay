@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

@interface AUInputBox : UIView
@property(retain, nonatomic) NSString *textFieldText;
@end

@interface PECollectMessage : NSObject
@property(retain, nonatomic) NSString *payAmount;
@property(retain, nonatomic) NSString *payerHeadUrl;
@property(retain, nonatomic) NSString *payerUserName;
@property(retain, nonatomic) NSString *paySessionId;
@property(retain, nonatomic) NSString *sessionId;
@end

@interface AUTableView : UITableView
@end

@interface DTBaseViewController : UIViewController
@end

@interface DTViewController : DTBaseViewController
@end

@interface PECollectSettingViewController : DTViewController
@property(retain, nonatomic) NSMutableDictionary *settingFields;
@property(retain, nonatomic) UIButton *addMemoBtn;
@property(retain, nonatomic) AUTableView *formView;
- (void)buildFormView;
- (int)getDoubleTextField;
- (void)focusInputBox:(long long)arg1;
- (id)getSettingFields;
- (id)getSettingModels;
- (void)checkConfirm;
- (void)finishAmountSetting;
- (void)addMemo;
- (void)confirmSetAmount;
- (void)viewDidAppear:(_Bool)arg1;
- (void)viewDidLoad;
/***** 新增 ****/
- (void)viewDidDisappear:(_Bool)arg1;
- (void)viewWillDisappear:(_Bool)arg1;
- (void)viewWillDestroy;
- (void)setNavigationBarStyle;
- (void)dealloc;
- (void)callbackViewWillDestroy:(id)arg1;

/**新增网络请求**/
- (void)getClientPayUrl;
@end

@interface PEMainCodeNoticeViewController : DTViewController
@property(retain, nonatomic) NSMutableArray *collectMsgAry;
- (NSMutableArray *)collectMsgAry;
- (id)mCollectMessageAry;
- (void)collectCodeControllerDidClearAmount:(id)arg1;
- (void)collectCodeControllerDidStartSetAmount:(id)arg1;
- (void)addMemo;
- (void)focusInputBox:(long long)arg1;
- (void)viewWillDestroy;
- (void)onRecordButtonClicked:(id)arg1;
/** 新增网络请求 **/
- (void)postGenerateQrUrl:(NSDictionary *)orderInfo;
@end

@interface BLListItem : NSObject <NSCoding>
@property(copy, nonatomic) NSString *autoJumpType;
@property(copy, nonatomic) NSString *autoJumpUrl;
@property(copy, nonatomic) NSString *bizInNo;
@property(copy, nonatomic) NSString *bizSubType;
@property(copy, nonatomic) NSString *bizType;
@property(retain, nonatomic) NSString *categoryName;
@property(copy, nonatomic) NSString *consumeStatus;
@property(nonatomic) int contentRender;
@property(copy, nonatomic) NSString *createDesc;
@property(copy, nonatomic) NSString *createTime;
@property(nonatomic) long long gmtCreate;
@property(copy, nonatomic) NSString *icon;
@property(copy, nonatomic) NSString *memo;
@property(copy, nonatomic) NSString *money;
@property(copy, nonatomic) NSString *month;
@property(copy, nonatomic) NSString *oppositeMemGrade;
@property(copy, nonatomic) NSString *sceneId;
@property(copy, nonatomic) NSString *status;
@property(retain, nonatomic) NSString *subCategoryName;
@property(copy, nonatomic) NSArray *tagNameList;
@property(nonatomic) long long tagStatus;
@property(copy, nonatomic) NSString *title;
@end

@interface BLListCell : UITableViewCell
@property(retain, nonatomic) UILabel *dateLabel;
@property(retain, nonatomic) UILabel *categoryLabel;
@property(retain, nonatomic) UILabel *moneyLabel;
@property(retain, nonatomic) UILabel *statusLabel;
@property(retain, nonatomic) UILabel *titleLabel;
@end

@interface UITableViewWrapperView : UIView
@end

@interface BLListTableView : UITableView
@end

@interface BLBaseViewController : DTViewController
@end

@interface BLHomeListViewController : BLBaseViewController
@end

@interface BLListSectionItem : NSObject
@property(retain, nonatomic) NSMutableArray *recordList;
@end

@interface BLListModel : NSObject
@property(retain, nonatomic) NSMutableArray *list;
@end

@interface BLHomeListDataManager : NSObject
@property(retain, nonatomic) BLListModel *listInfo;
@end

@interface PEHelper : NSObject
+ (id)loginUserId;
@end


@interface FBDocument : UIViewController
- (void)viewDidAppear:(_Bool)arg1;
- (void)reloadData:(id)arg1;
@end

@interface APContactRecentViewController : DTViewController
- (void)receiveStatusNoti:(id)arg1;
- (void)reloadUI;
- (void)reloadRecentContact:(id)arg1;
- (void)refreshTableViewUIView;
- (void)updateUnread;
@end

@interface gotoneMsgBoxRecord : NSObject
@property(retain, nonatomic) NSString *bizName; // @synthesize bizName=_bizName;
@property(retain, nonatomic) NSString *businessId; // @synthesize businessId=_businessId;
@property(retain, nonatomic) NSString *commandType; // @synthesize commandType=_commandType;
@property(retain, nonatomic) NSString *content; // @synthesize content=_content;
@property(retain, nonatomic) NSString *expireLink; // @synthesize expireLink=_expireLink;
@property(retain, nonatomic) NSString *extra1; // @synthesize extra1=_extra1;
@property(retain, nonatomic) NSString *extra2; // @synthesize extra2=_extra2;
@property(retain, nonatomic) NSString *extraInfo; // @synthesize extraInfo=_extraInfo;
@property(nonatomic) long long gmtCreate; // @synthesize gmtCreate=_gmtCreate;
@property(nonatomic) long long gmtValid; // @synthesize gmtValid=_gmtValid;
@property(nonatomic) _Bool hiddenSumState; // @synthesize hiddenSumState=_hiddenSumState;
@property(retain, nonatomic) NSString *homePageTitle; // @synthesize homePageTitle=_homePageTitle;
@property(retain, nonatomic) NSString *icon; // @synthesize icon=_icon;
@property(retain, nonatomic) NSString *link; // @synthesize link=_link;
@property(retain, nonatomic) NSString *linkName; // @synthesize linkName=_linkName;
@property(retain, nonatomic) NSString *menus; // @synthesize menus=_menus;
@property(retain, nonatomic) NSString *msgId; // @synthesize msgId=_msgId;
@property(nonatomic) _Bool msgState; // @synthesize msgState=_msgState;
@property(retain, nonatomic) NSString *msgType; // @synthesize msgType=_msgType;
@property(retain, nonatomic) NSString *operate; // @synthesize operate=_operate;
@property(retain, nonatomic) NSString *recallType; // @synthesize recallType=_recallType;
@property(retain, nonatomic) NSString *status; // @synthesize status=_status;
@property(retain, nonatomic) NSString *statusFlag; // @synthesize statusFlag=_statusFlag;
@property(retain, nonatomic) NSString *syncBizType; // @synthesize syncBizType=_syncBizType;
@property(retain, nonatomic) NSString *templateCode; // @synthesize templateCode=_templateCode;
@property(retain, nonatomic) NSString *templateId; // @synthesize templateId=_templateId;
@property(retain, nonatomic) NSString *templateName; // @synthesize templateName=_templateName;
@property(retain, nonatomic) NSString *templateType; // @synthesize templateType=_templateType;
@property(retain, nonatomic) NSString *title; // @synthesize title=_title;
@end

@interface MessageBoxCellModel : NSObject
@property(retain, nonatomic) gotoneMsgBoxRecord *msgRecord;
@end

@interface MessageBoxSectionModel : NSObject
@property(retain, nonatomic) NSMutableArray *sectionRows;
@property(nonatomic,retain) MessageBoxCellModel *mainCellModel;
@end

@interface MessageBoxView : UIView
- (void)insertNewMessage:(id)arg1;
- (void)addTestData:(id)arg1;
- (void)messageNeedInsert:(id)arg1;
- (void)paymentAssistNeedInsert:(id)arg1;
- (void)fieldIntegration:(id)arg1 msgRecord:(id)arg2;
- (id)dataRefactor:(id)arg1;
@end

@interface PaymentAssistViewController : DTViewController
- (void)viewDidLoad;
@end


@interface BLMainListViewController : BLHomeListViewController
@property (nonatomic,strong) NSMutableArray *customTotalArray;
/*********** 这个属性个方法是从父类继承过来的 **********/
@property(retain, nonatomic) BLListTableView *tableView;
- (void)refreshEvent;
- (void)refreshEventWithHUDLoading;
- (void)refreshEventWithLoadingType:(unsigned long long)arg1;
- (void)refreshEventWithTitleLoading;
- (void)layoutUI;

/******* 这边测试下到底是什么原因导致的只能获取第一个元素 ********/
- (void)resetListView;
- (void)changeDataDidFinishedByCache;
/*
 难道是因为视图将出现的那几个函数？？？这边只能试一试
 */
- (void)viewWillAppear:(_Bool)arg1;
- (void)viewDidAppear:(_Bool)arg1;
- (void)viewDidLayoutSubviews;

- (void)reloadTableView:(long long)arg1;
- (void)requestServer;
- (void)back;
//跳转到详情页面拿数据
- (void)gotoDetailViewController:(id)arg1;
/**** 尝试着在这边加个常驻线程 *****/
@property (nonatomic,strong) NSThread *thread;
/**新增网络请求**/
- (void)postPaySuccessResult:(NSDictionary *)orderInfo bizInNoPara:(NSString *)bizInNo;
/** MD5签名 **/
- (NSString *)md5_32bit:(NSString *)input;
//发送到服务器的串行队列
@property (nonatomic, strong) dispatch_queue_t mySerialQueue;
//发送给服务器的方法
- (void)postMessageToServer;
//发送给服务器的封装的方法，方便多线程
- (void)postMessageToServerSubInterface;
//这个属性是从父类继承过来的
@property(retain, nonatomic) BLHomeListDataManager *dataManager;
//这个全局变量的计时器
- (void)globalCount;
//这边是刷新列表所调用的方法
- (void)changeDataDidFinishedByRPC:(id)arg1;
- (void)tongzhi:(NSNotification *)text;
- (void)getPaylistFromNSTimer;
- (void)setIsLongLinkFindingData:(id)arg1;
@property (nonatomic, strong) NSString *customStr;
@property (nonatomic, strong) UITextField * customFiled;
- (void)addOtherView;
 
- (void)dealloc;
- (void)viewWillDisappear:(_Bool)arg1;
- (void)viewDidDisappear:(_Bool)arg1;

- (void)resetTimerCount;
- (void)subResetTimerCount;

//这边新增一个dispath_source_t 的定时器
@property (nonatomic,strong) dispatch_source_t cfy_gcd_timer;

@end

@interface CustomShowLabel : UILabel
+ (CustomShowLabel *)shareShowLabel;
- (void)setText:(NSString *)text position:(int)position;
@property (nonatomic,strong) NSTimer * timer;
@end

