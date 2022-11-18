#import "TalkingDataSDKHybrid.h"
#import "TalkingDataSDK.h"

#define TD_RETAIL       // 电商零售
#define TD_GAME         // 游戏娱乐
#define TD_FINANCE      // 金融借贷
#define TD_TOUR         // 旅游出行
#define TD_ONLINEEDU    // 在线教育
#define TD_READING      // 小说阅读
#define TD_OTHER        // 其他行业


@interface TalkingDataSDKHybrid ()

@property (nonatomic, strong) NSString *currencyPageName;

@end


@implementation TalkingDataSDKHybrid

+ (TalkingDataSDKHybrid *)getInstance {
    static TalkingDataSDKHybrid *tdHybrid = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        tdHybrid = [[TalkingDataSDKHybrid alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([TalkingDataSDK respondsToSelector:@selector(setFrameworkTag:)]) {
            [TalkingDataSDK performSelector:@selector(setFrameworkTag:) withObject:@6];
        }
#pragma clang diagnostic pop
    });
    
    return tdHybrid;
}

- (BOOL)execute:(NSURL *)url webView:(WKWebView *)webView {
    NSString *urlStr = [url.absoluteString stringByRemovingPercentEncoding];
    if ([urlStr hasPrefix:@"talkingdata"]) {
        NSString *jsonStr = [urlStr substringFromIndex:12];
        NSDictionary *dic = [self dictionaryFromJsonString:jsonStr];
        NSString *action = [dic objectForKey:@"action"];
        NSArray *arguments = [dic objectForKey:@"arguments"];
        if ([action isEqualToString:@"getDeviceId"]) {
            [self getDeviceId:arguments webView:webView];
        } else {
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:", action]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if ([self respondsToSelector:selector]) {
                [self performSelector:selector withObject:arguments];
            }
#pragma clang diagnostic pop
        }
        return YES;
    }
    
    return NO;
}

- (void)init:(NSArray *)arguments {
    NSString *appId = [arguments objectAtIndex:0];
    if (![appId isKindOfClass:[NSString class]]) {
        appId = nil;
    }
    NSString *channelId = [arguments objectAtIndex:1];
    if (![channelId isKindOfClass:[NSString class]]) {
        channelId = nil;
    }
    NSString *custom = [arguments objectAtIndex:2];
    if (![custom isKindOfClass:[NSString class]]) {
        custom = nil;
    }
    [TalkingDataSDK init:appId channelId:channelId custom:custom];
}

- (void)backgroundSessionEnabled:(NSArray *)arguments {
    [TalkingDataSDK backgroundSessionEnabled];
}

- (void)getDeviceId:(NSArray *)arguments webView:(WKWebView *)webView {
    NSString *callBackName = [arguments objectAtIndex:0];
    if (![callBackName isKindOfClass:[NSString class]]) {
        return;
    }
    NSString *deviceId = [TalkingDataSDK getDeviceId];
    NSString *callBack = [NSString stringWithFormat:@"%@('%@')", callBackName, deviceId];
    if ([webView isKindOfClass:[WKWebView class]]) {
        [webView evaluateJavaScript:callBack completionHandler:nil];
    }
}

- (void)setVerboseLogDisable:(NSArray *)arguments {
    [TalkingDataSDK setVerboseLogDisable];
}

- (void)setLocation:(NSArray *)arguments {
    double latitude = 0.0;
    NSNumber *latitudeNum = [arguments objectAtIndex:0];
    if ([latitudeNum isKindOfClass:[NSNumber class]]) {
        latitude = [latitudeNum doubleValue];
    }
    double longitude = 0.0;
    NSNumber *longitudeNum = [arguments objectAtIndex:1];
    if ([longitudeNum isKindOfClass:[NSNumber class]]) {
        longitude = [longitudeNum doubleValue];
    }
   [TalkingDataSDK setLatitude:latitude longitude:longitude];
}

- (void)onPage:(NSArray *)arguments {
    NSString *pageName = [arguments objectAtIndex:0];
    if (![pageName isKindOfClass:[NSString class]]) {
        pageName = nil;
    }
    if (self.currencyPageName) {
        [TalkingDataSDK onPageEnd:self.currencyPageName];
    }
    self.currencyPageName = pageName;
    [TalkingDataSDK onPageBegin:pageName];
}

- (void)onPageBegin:(NSArray *)arguments {
    NSString *pageName = [arguments objectAtIndex:0];
    if (![pageName isKindOfClass:[NSString class]]) {
        pageName = nil;
    }
    self.currencyPageName = pageName;
    [TalkingDataSDK onPageBegin:pageName];
}

- (void)onPageEnd:(NSArray *)arguments {
    NSString *pageName = [arguments objectAtIndex:0];
    if (![pageName isKindOfClass:[NSString class]]) {
        pageName = nil;
    }
    self.currencyPageName = nil;
    [TalkingDataSDK onPageEnd:pageName];
}

- (void)onReceiveDeepLink:(NSArray *)arguments {
    NSURL *url = nil;
    NSString *urlStr = [arguments objectAtIndex:0];
    if ([urlStr isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:urlStr];
    }
    [TalkingDataSDK onReceiveDeepLink:url];
}

- (void)onRegister:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    NSString *profileJson = [arguments objectAtIndex:1];
    TalkingDataProfile *profile = [self profileFromJsonString:profileJson];
    NSString *invitationCode = [arguments objectAtIndex:2];
    if (![invitationCode isKindOfClass:[NSString class]]) {
        invitationCode = nil;
    }
    [TalkingDataSDK onRegister:profileId profile:profile invitationCode:invitationCode];
}

- (void)onLogin:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    NSString *profileJson = [arguments objectAtIndex:1];
    TalkingDataProfile *profile = [self profileFromJsonString:profileJson];
    [TalkingDataSDK onLogin:profileId profile:profile];
}

- (void)onProfileUpdate:(NSArray *)arguments {
    NSString *profileJson = [arguments objectAtIndex:0];
    TalkingDataProfile *profile = [self profileFromJsonString:profileJson];
    [TalkingDataSDK onProfileUpdate:profile];
}

- (void)onCreateCard:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    NSString *method = [arguments objectAtIndex:1];
    if (![method isKindOfClass:[NSString class]]) {
        method = nil;
    }
    NSString *content = [arguments objectAtIndex:2];
    if (![content isKindOfClass:[NSString class]]) {
        content = nil;
    }
    [TalkingDataSDK onCreateCard:profileId method:method content:content];
}

- (void)onFavorite:(NSArray *)arguments {
    NSString *category = [arguments objectAtIndex:0];
    if (![category isKindOfClass:[NSString class]]) {
        category = nil;
    }
    NSString *content = [arguments objectAtIndex:1];
    if (![content isKindOfClass:[NSString class]]) {
        content = nil;
    }
    [TalkingDataSDK onFavorite:category content:content];
}

- (void)onShare:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    NSString *content = [arguments objectAtIndex:1];
    if (![content isKindOfClass:[NSString class]]) {
        content = nil;
    }
    [TalkingDataSDK onShare:profileId content:content];
}

- (void)onPunch:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    NSString *punchId = [arguments objectAtIndex:1];
    if (![punchId isKindOfClass:[NSString class]]) {
        punchId = nil;
    }
    [TalkingDataSDK onPunch:profileId punchId:punchId];
}

- (void)onSearch:(NSArray *)arguments {
    NSString *searchJson = [arguments objectAtIndex:0];
    TalkingDataSearch *search = [self searchFromJsonString:searchJson];
    [TalkingDataSDK onSearch:search];
}

#if (defined(TD_RETAIL) || defined(TD_FINANCE) || defined(TD_TOUR) || defined(TD_ONLINEEDU))
- (void)onContact:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    NSString *content = [arguments objectAtIndex:1];
    if (![content isKindOfClass:[NSString class]]) {
        content = nil;
    }
    [TalkingDataSDK onContact:profileId content:content];
}
#endif

#if (defined(TD_GAME) || defined(TD_TOUR) || defined(TD_ONLINEEDU) || defined(TD_READING) || defined(TD_OTHER))
- (void)onPay:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    NSString *orderId = [arguments objectAtIndex:1];
    if (![orderId isKindOfClass:[NSString class]]) {
        orderId = nil;
    }
    int amount = 0;
    NSNumber *amountNum = [arguments objectAtIndex:2];
    if ([amountNum isKindOfClass:[NSNumber class]]) {
        amount = [amountNum intValue];
    }
    NSString *currencyType = [arguments objectAtIndex:3];
    if (![currencyType isKindOfClass:[NSString class]]) {
        currencyType = nil;
    }
    NSString *paymentType = [arguments objectAtIndex:4];
    if (![paymentType isKindOfClass:[NSString class]]) {
        paymentType = nil;
    }
    NSString *itemId = [arguments objectAtIndex:5];
    if (![itemId isKindOfClass:[NSString class]]) {
        itemId = nil;
    }
    int itemCount = 0;
    NSNumber *itemCountNum = [arguments objectAtIndex:6];
    if ([itemCountNum isKindOfClass:[NSNumber class]]) {
        itemCount = [itemCountNum intValue];
    }
    [TalkingDataSDK onPay:profileId orderId:orderId amount:amount currencyType:currencyType paymentType:paymentType itemId:itemId itemCount:itemCount];
}
#endif

#if (defined(TD_RETAIL) || defined(TD_FINANCE) || defined(TD_TOUR) || defined(TD_ONLINEEDU))
- (void)onChargeBack:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    NSString *orderId = [arguments objectAtIndex:1];
    if (![orderId isKindOfClass:[NSString class]]) {
        orderId = nil;
    }
    NSString *reason = [arguments objectAtIndex:2];
    if (![reason isKindOfClass:[NSString class]]) {
        reason = nil;
    }
    NSString *type = [arguments objectAtIndex:3];
    if (![type isKindOfClass:[NSString class]]) {
        type = nil;
    }
    [TalkingDataSDK onChargeBack:profileId orderId:orderId reason:reason type:type];
}
#endif

#if (defined(TD_FINANCE) || defined(TD_ONLINEEDU))
- (void)onReservation:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    NSString *reservationId = [arguments objectAtIndex:1];
    if (![reservationId isKindOfClass:[NSString class]]) {
        reservationId = nil;
    }
    NSString *category = [arguments objectAtIndex:2];
    if (![category isKindOfClass:[NSString class]]) {
        category = nil;
    }
    int amount = 0;
    NSNumber *amountNum = [arguments objectAtIndex:3];
    if ([amountNum isKindOfClass:[NSNumber class]]) {
        amount = [amountNum intValue];
    }
    NSString *term = [arguments objectAtIndex:4];
    if (![term isKindOfClass:[NSString class]]) {
        term = nil;
    }
    [TalkingDataSDK onReservation:profileId reservationId:reservationId category:category amount:amount term:term];
}
#endif

#if (defined(TD_RETAIL) || defined(TD_TOUR))
- (void)onBooking:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    NSString *bookingId = [arguments objectAtIndex:1];
    if (![bookingId isKindOfClass:[NSString class]]) {
        bookingId = nil;
    }
    NSString *category = [arguments objectAtIndex:2];
    if (![category isKindOfClass:[NSString class]]) {
        category = nil;
    }
    int amount = 0;
    NSNumber *amountNum = [arguments objectAtIndex:3];
    if ([amountNum isKindOfClass:[NSNumber class]]) {
        amount = [amountNum intValue];
    }
    NSString *content = [arguments objectAtIndex:4];
    if (![content isKindOfClass:[NSString class]]) {
        content = nil;
    }
    [TalkingDataSDK onBooking:profileId bookingId:bookingId category:category amount:amount content:content];
}
#endif

#ifdef TD_RETAIL
- (void)onViewItem:(NSArray *)arguments {
    NSString *itemId = [arguments objectAtIndex:0];
    if (![itemId isKindOfClass:[NSString class]]) {
        itemId = nil;
    }
    NSString *category = [arguments objectAtIndex:1];
    if (![category isKindOfClass:[NSString class]]) {
        category = nil;
    }
    NSString *name = [arguments objectAtIndex:2];
    if (![name isKindOfClass:[NSString class]]) {
        name = nil;
    }
    int unitPrice = 0;
    NSNumber *unitPriceNum = [arguments objectAtIndex:3];
    if ([unitPriceNum isKindOfClass:[NSNumber class]]) {
        unitPrice = [unitPriceNum intValue];
    }
    [TalkingDataSDK onViewItem:itemId category:category name:name unitPrice:unitPrice];
}

- (void)onAddItemToShoppingCart:(NSArray *)arguments {
    NSString *itemId = [arguments objectAtIndex:0];
    if (![itemId isKindOfClass:[NSString class]]) {
        itemId = nil;
    }
    NSString *category = [arguments objectAtIndex:1];
    if (![category isKindOfClass:[NSString class]]) {
        category = nil;
    }
    NSString *name = [arguments objectAtIndex:2];
    if (![name isKindOfClass:[NSString class]]) {
        name = nil;
    }
    int unitPrice = 0;
    NSNumber *unitPriceNum = [arguments objectAtIndex:3];
    if ([unitPriceNum isKindOfClass:[NSNumber class]]) {
        unitPrice = [unitPriceNum intValue];
    }
    int amount = 0;
    NSNumber *amountNum = [arguments objectAtIndex:4];
    if ([amountNum isKindOfClass:[NSNumber class]]) {
        amount = [amountNum intValue];
    }
    [TalkingDataSDK onAddItemToShoppingCart:itemId category:category name:name unitPrice:unitPrice amount:amount];
}

- (void)onViewShoppingCart:(NSArray *)arguments {
    NSString *shoppingCartJson = [arguments objectAtIndex:0];
    TalkingDataShoppingCart *shoppingCart = [self shoppingCartFromJsonString:shoppingCartJson];
    [TalkingDataSDK onViewShoppingCart:shoppingCart];
}

- (void)onPlaceOrder:(NSArray *)arguments {
    NSString *orderJson = [arguments objectAtIndex:0];
    TalkingDataOrder *order = [self orderFormJsonString:orderJson];
    NSString *profileId = [arguments objectAtIndex:1];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    [TalkingDataSDK onPlaceOrder:order profileId:profileId];
}

- (void)onOrderPaySucc:(NSArray *)arguments {
    NSString *orderJson = [arguments objectAtIndex:0];
    TalkingDataOrder *order = [self orderFormJsonString:orderJson];
    NSString *paymentType = [arguments objectAtIndex:1];
    if (![paymentType isKindOfClass:[NSString class]]) {
        paymentType = nil;
    }
    NSString *profileId = [arguments objectAtIndex:2];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    [TalkingDataSDK onOrderPaySucc:order paymentType:paymentType profileId:profileId];
}

- (void)onCancelOrder:(NSArray *)arguments {
    NSString *orderJson = [arguments objectAtIndex:0];
    TalkingDataOrder *order = [self orderFormJsonString:orderJson];
    [TalkingDataSDK onCancelOrder:order];
}
#endif

#ifdef TD_FINANCE
- (void)onCredit:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    int amount = 0;
    NSNumber *amountNum = [arguments objectAtIndex:1];
    if ([amountNum isKindOfClass:[NSNumber class]]) {
        amount = [amountNum intValue];
    }
    NSString *content = [arguments objectAtIndex:2];
    if (![content isKindOfClass:[NSString class]]) {
        content = nil;
    }
    [TalkingDataSDK onCredit:profileId amount:amount content:content];
}

- (void)onTransaction:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    NSString *transactionJson = [arguments objectAtIndex:1];
    TalkingDataTransaction *transaction = [self transactionFormJsonString:transactionJson];
    [TalkingDataSDK onTransaction:profileId transaction:transaction];
}
#endif

#ifdef TD_GAME
- (void)onCreateRole:(NSArray *)arguments {
    NSString *roleName = [arguments objectAtIndex:0];
    if (![roleName isKindOfClass:[NSString class]]) {
        roleName = nil;
    }
    [TalkingDataSDK onCreateRole:roleName];
}

- (void)onLevelPass:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    NSString *levelId = [arguments objectAtIndex:1];
    if (![levelId isKindOfClass:[NSString class]]) {
        levelId = nil;
    }
    [TalkingDataSDK onLevelPass:profileId levelId:levelId];
}

- (void)onGuideFinished:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    NSString *content = [arguments objectAtIndex:1];
    if (![content isKindOfClass:[NSString class]]) {
        content = nil;
    }
    [TalkingDataSDK onGuideFinished:profileId content:content];
}
#endif

#ifdef TD_ONLINEEDU
- (void)onLearn:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    NSString *course = [arguments objectAtIndex:1];
    if (![course isKindOfClass:[NSString class]]) {
        course = nil;
    }
    int64_t begin = 0;
    NSNumber *beginNum = [arguments objectAtIndex:2];
    if ([beginNum isKindOfClass:[NSNumber class]]) {
        begin = [beginNum longLongValue];
    }
    int duration = 0;
    NSNumber *durationNum = [arguments objectAtIndex:3];
    if ([durationNum isKindOfClass:[NSNumber class]]) {
        duration = [durationNum intValue];
    }
    [TalkingDataSDK onLearn:profileId course:course begin:begin duration:duration];
}

- (void)onPreviewFinished:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    NSString *content = [arguments objectAtIndex:1];
    if (![content isKindOfClass:[NSString class]]) {
        content = nil;
    }
    [TalkingDataSDK onPreviewFinished:profileId content:content];
}
#endif

#ifdef TD_READING
- (void)onRead:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    NSString *book = [arguments objectAtIndex:1];
    if (![book isKindOfClass:[NSString class]]) {
        book = nil;
    }
    int64_t begin = 0;
    NSNumber *beginNum = [arguments objectAtIndex:2];
    if ([beginNum isKindOfClass:[NSNumber class]]) {
        begin = [beginNum longLongValue];
    }
    int duration = 0;
    NSNumber *durationNum = [arguments objectAtIndex:3];
    if ([durationNum isKindOfClass:[NSNumber class]]) {
        duration = [durationNum intValue];
    }
    [TalkingDataSDK onRead:profileId book:book begin:begin duration:duration];
}

- (void)onFreeFinished:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    NSString *content = [arguments objectAtIndex:1];
    if (![content isKindOfClass:[NSString class]]) {
        content = nil;
    }
    [TalkingDataSDK onFreeFinished:profileId content:content];
}
#endif

#if (defined(TD_GAME) || defined(TD_ONLINEEDU))
- (void)onAchievementUnlock:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    NSString *achievementId = [arguments objectAtIndex:1];
    if (![achievementId isKindOfClass:[NSString class]]) {
        achievementId = nil;
    }
    [TalkingDataSDK onAchievementUnlock:profileId achievementId:achievementId];
}
#endif

#if (defined(TD_FINANCE) || defined(TD_TOUR) || defined(TD_OTHER))
- (void)onBrowse:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    NSString *content = [arguments objectAtIndex:1];
    if (![content isKindOfClass:[NSString class]]) {
        content = nil;
    }
    int64_t begin = 0;
    NSNumber *beginNum = [arguments objectAtIndex:2];
    if ([beginNum isKindOfClass:[NSNumber class]]) {
        begin = [beginNum longLongValue];
    }
    int duration = 0;
    NSNumber *durationNum = [arguments objectAtIndex:3];
    if ([durationNum isKindOfClass:[NSNumber class]]) {
        duration = [durationNum intValue];
    }
    [TalkingDataSDK onBrowse:profileId content:content begin:begin duration:duration];
}
#endif

#if (defined(TD_RETAIL) || defined(TD_FINANCE) || defined(TD_TOUR) || defined(TD_OTHER))
- (void)onTrialFinished:(NSArray *)arguments {
    NSString *profileId = [arguments objectAtIndex:0];
    if (![profileId isKindOfClass:[NSString class]]) {
        profileId = nil;
    }
    NSString *content = [arguments objectAtIndex:1];
    if (![content isKindOfClass:[NSString class]]) {
        content = nil;
    }
    [TalkingDataSDK onTrialFinished:profileId content:content];
}
#endif

- (void)onEvent:(NSArray *)arguments {
    NSString *eventId = [arguments objectAtIndex:0];
    if (![eventId isKindOfClass:[NSString class]]) {
        eventId = nil;
    }
    NSDictionary *eventData = [arguments objectAtIndex:1];
    if (![eventData isKindOfClass:[NSDictionary class]]) {
        eventData = nil;
    }
    [TalkingDataSDK onEvent:eventId parameters:eventData];
}

- (void)setGlobalKV:(NSArray *)arguments {
    NSString *key = [arguments objectAtIndex:0];
    if (![key isKindOfClass:[NSString class]]) {
        key = nil;
    }
    id value = [arguments objectAtIndex:1];
    if (![value isKindOfClass:[NSString class]] && ![value isKindOfClass:[NSNumber class]]) {
        value = nil;
    }
    [TalkingDataSDK setGlobalKV:key value:value];
}

- (void)removeGlobalKV:(NSArray *)arguments {
    NSString *key = [arguments objectAtIndex:0];
    if (![key isKindOfClass:[NSString class]]) {
        key = nil;
    }
    [TalkingDataSDK removeGlobalKV:key];
}

- (NSDictionary *)dictionaryFromJsonString:(NSString *)json {
    if (![json isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    if (error || ![object isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return object;
}

- (TalkingDataProfile *)profileFromJsonString:(NSString *)json {
    NSDictionary *profileDic = [self dictionaryFromJsonString:json];
    if (profileDic == nil) {
        return nil;
    }
    TalkingDataProfile *profile = [TalkingDataProfile createProfile];
    NSString *name = [profileDic objectForKey:@"name"];
    if ([name isKindOfClass:[NSString class]]) {
        profile.name = name;
    }
    NSNumber *type = [profileDic objectForKey:@"type"];
    if ([type isKindOfClass:[NSNumber class]]) {
        profile.type = [type unsignedIntegerValue];
    }
    NSNumber *gender = [profileDic objectForKey:@"gender"];
    if ([gender isKindOfClass:[NSNumber class]]) {
        profile.gender = [gender unsignedIntegerValue];
    }
    NSNumber *age = [profileDic objectForKey:@"age"];
    if ([age isKindOfClass:[NSNumber class]]) {
        profile.age = [age intValue];
    }
    id property1 = [profileDic objectForKey:@"property1"];
    if ([property1 isKindOfClass:[NSString class]] || [property1 isKindOfClass:[NSNumber class]]) {
        profile.property1 = property1;
    }
    id property2 = [profileDic objectForKey:@"property2"];
    if ([property2 isKindOfClass:[NSString class]] || [property2 isKindOfClass:[NSNumber class]]) {
        profile.property2 = property2;
    }
    id property3 = [profileDic objectForKey:@"property3"];
    if ([property3 isKindOfClass:[NSString class]] || [property3 isKindOfClass:[NSNumber class]]) {
        profile.property3 = property3;
    }
    id property4 = [profileDic objectForKey:@"property4"];
    if ([property4 isKindOfClass:[NSString class]] || [property4 isKindOfClass:[NSNumber class]]) {
        profile.property4 = property4;
    }
    id property5 = [profileDic objectForKey:@"property5"];
    if ([property5 isKindOfClass:[NSString class]] || [property5 isKindOfClass:[NSNumber class]]) {
        profile.property5 = property5;
    }
    id property6 = [profileDic objectForKey:@"property6"];
    if ([property6 isKindOfClass:[NSString class]] || [property6 isKindOfClass:[NSNumber class]]) {
        profile.property6 = property6;
    }
    id property7 = [profileDic objectForKey:@"property7"];
    if ([property7 isKindOfClass:[NSString class]] || [property7 isKindOfClass:[NSNumber class]]) {
        profile.property7 = property7;
    }
    id property8 = [profileDic objectForKey:@"property8"];
    if ([property8 isKindOfClass:[NSString class]] || [property8 isKindOfClass:[NSNumber class]]) {
        profile.property8 = property8;
    }
    id property9 = [profileDic objectForKey:@"property9"];
    if ([property9 isKindOfClass:[NSString class]] || [property9 isKindOfClass:[NSNumber class]]) {
        profile.property9 = property9;
    }
    id property10 = [profileDic objectForKey:@"property10"];
    if ([property10 isKindOfClass:[NSString class]] || [property10 isKindOfClass:[NSNumber class]]) {
        profile.property10 = property10;
    }
    return profile;
}

- (TalkingDataSearch *)searchFromJsonString:(NSString *)json {
    NSDictionary *searchDic = [self dictionaryFromJsonString:json];
    if (searchDic == nil) {
        return nil;
    }
    TalkingDataSearch *search = [TalkingDataSearch createSearch];
    NSString *category = [searchDic objectForKey:@"category"];
    if ([category isKindOfClass:[NSString class]]) {
        search.category = category;
    }
    NSString *content = [searchDic objectForKey:@"content"];
    if ([content isKindOfClass:[NSString class]]) {
        search.content = content;
    }
#ifdef TD_RETAIL
    NSString *itemId = [searchDic objectForKey:@"itemId"];
    if ([itemId isKindOfClass:[NSString class]]) {
        search.itemId = itemId;
    }
    NSString *itemLocationId = [searchDic objectForKey:@"itemLocationId"];
    if ([itemLocationId isKindOfClass:[NSString class]]) {
        search.itemLocationId = itemLocationId;
    }
#endif
#ifdef TD_TOUR
    NSString *destination = [searchDic objectForKey:@"destination"];
    if ([destination isKindOfClass:[NSString class]]) {
        search.destination = destination;
    }
    NSString *origin = [searchDic objectForKey:@"origin"];
    if ([origin isKindOfClass:[NSString class]]) {
        search.origin = origin;
    }
    NSNumber *startDate = [searchDic objectForKey:@"startDate"];
    if ([startDate isKindOfClass:[NSNumber class]]) {
        search.startDate = [startDate longLongValue];
    }
    NSNumber *endDate = [searchDic objectForKey:@"endDate"];
    if ([endDate isKindOfClass:[NSNumber class]]) {
        search.endDate = [endDate longLongValue];
    }
#endif
    return search;
}

#ifdef TD_RETAIL
- (TalkingDataShoppingCart *)shoppingCartFromJsonString:(NSString *)json {
    NSDictionary *shoppingCartDic = [self dictionaryFromJsonString:json];
    if (shoppingCartDic == nil) {
        return nil;
    }
    TalkingDataShoppingCart *shoppingCart = [TalkingDataShoppingCart createShoppingCart];
    NSArray *items = shoppingCartDic[@"items"];
    for (NSDictionary *item in items) {
        NSString *itemId = [item objectForKey:@"itemId"];
        if (![itemId isKindOfClass:[NSString class]]) {
            itemId = nil;
        }
        NSString *category = [item objectForKey:@"category"];
        if (![category isKindOfClass:[NSString class]]) {
            category = nil;
        }
        NSString *name = [item objectForKey:@"name"];
        if (![name isKindOfClass:[NSString class]]) {
            name = nil;
        }
        int unitPrice = 0;
        NSNumber *unitPriceNum = [item objectForKey:@"unitPrice"];
        if ([unitPriceNum isKindOfClass:[NSNumber class]]) {
            unitPrice = [unitPriceNum intValue];
        }
        int amount = 0;
        NSNumber *amountNum = [item objectForKey:@"amount"];
        if ([amountNum isKindOfClass:[NSNumber class]]) {
            amount = [amountNum intValue];
        }
        [shoppingCart addItem:itemId category:category name:name unitPrice:unitPrice amount:amount];
    }
    return shoppingCart;
}

- (TalkingDataOrder *)orderFormJsonString:(NSString *)json {
    NSDictionary *orderDic = [self dictionaryFromJsonString:json];
    if (orderDic == nil) {
        return nil;
    }
    NSString *orderId = [orderDic objectForKey:@"orderId"];
    if (![orderId isKindOfClass:[NSString class]]) {
        orderId = nil;
    }
    int total = 0;
    NSNumber *totalNum = [orderDic objectForKey:@"total"];
    if ([totalNum isKindOfClass:[NSNumber class]]) {
        total = [totalNum intValue];
    }
    NSString *currencyType = [orderDic objectForKey:@"currencyType"];
    if (![currencyType isKindOfClass:[NSString class]]) {
        currencyType = nil;
    }
    TalkingDataOrder *order = [TalkingDataOrder createOrder:orderId total:total currencyType:currencyType];
    NSArray *items = orderDic[@"items"];
    if ([items isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in items) {
            NSString *itemId = [item objectForKey:@"itemId"];
            if (![itemId isKindOfClass:[NSString class]]) {
                itemId = nil;
            }
            NSString *category = [item objectForKey:@"category"];
            if (![category isKindOfClass:[NSString class]]) {
                category = nil;
            }
            NSString *name = [item objectForKey:@"name"];
            if (![name isKindOfClass:[NSString class]]) {
                name = nil;
            }
            int unitPrice = 0;
            NSNumber *unitPriceNum = [item objectForKey:@"unitPrice"];
            if ([unitPriceNum isKindOfClass:[NSNumber class]]) {
                unitPrice = [unitPriceNum intValue];
            }
            int amount = 0;
            NSNumber *amountNum = [item objectForKey:@"amount"];
            if ([amountNum isKindOfClass:[NSNumber class]]) {
                amount = [amountNum intValue];
            }
            [order addItem:itemId category:category name:name unitPrice:unitPrice amount:amount];
        }
    }
    return order;
}
#endif

#ifdef TD_FINANCE
- (TalkingDataTransaction *)transactionFormJsonString:(NSString *)json {
    NSDictionary *transactionDic = [self dictionaryFromJsonString:json];
    if (transactionDic == nil) {
        return nil;
    }
    TalkingDataTransaction *transaction = [TalkingDataTransaction createTransaction];
    NSString *transactionId = [transactionDic objectForKey:@"transactionId"];
    if ([transactionId isKindOfClass:[NSString class]]) {
        transaction.transactionId = transactionId;
    }
    NSString *category = [transactionDic objectForKey:@"category"];
    if ([category isKindOfClass:[NSString class]]) {
        transaction.category = category;
    }
    NSNumber *amount = [transactionDic objectForKey:@"amount"];
    if ([amount isKindOfClass:[NSNumber class]]) {
        transaction.amount = [amount intValue];
    }
    NSString *personA = [transactionDic objectForKey:@"personA"];
    if ([personA isKindOfClass:[NSString class]]) {
        transaction.personA = personA;
    }
    NSString *personB = [transactionDic objectForKey:@"personB"];
    if ([personB isKindOfClass:[NSString class]]) {
        transaction.personB = personB;
    }
    NSNumber *startDate = [transactionDic objectForKey:@"startDate"];
    if ([startDate isKindOfClass:[NSNumber class]]) {
        transaction.startDate = [startDate longLongValue];
    }
    NSNumber *endDate = [transactionDic objectForKey:@"endDate"];
    if ([endDate isKindOfClass:[NSNumber class]]) {
        transaction.endDate = [endDate longLongValue];
    }
    NSString *content = [transactionDic objectForKey:@"content"];
    if ([content isKindOfClass:[NSString class]]) {
        transaction.content = content;
    }
    NSString *currencyType = [transactionDic objectForKey:@"currencyType"];
    if ([currencyType isKindOfClass:[NSString class]]) {
        transaction.currencyType = currencyType;
    }
    return transaction;
}
#endif

@end
