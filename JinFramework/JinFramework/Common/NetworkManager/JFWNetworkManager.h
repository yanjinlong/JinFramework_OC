//
//  JFWNetworkManager.h
//  JinFramework
//
//  Created by Jin on 2017/5/15.
//  Copyright © 2017年 Tribetech. All rights reserved.
//

#import "NetworkManager.h"
#import "JFWConfig.h"
#import "JFWEnumFile.h"

#define BusmanHelperCenter      @"http://api.t.myoba.net/doc/help.html" // 帮助中心
#define BusmanPayAgreement      @"http://api.t.myoba.net/doc/payment.html" //支付代扣协议
#define BusmanOfficialWebsite   @"http://www.myoba.net" // 部族科技官网链接

/**
 部族欧巴的网络管理者
 */
@interface JFWNetworkManager : NetworkManager

/**
 解析数据是正确还是错误
 
 @param     responseData 接口返回的数据
 @param     identifier 方法
 @return    是否正确
 */
+ (BOOL)parseDataYESOrNO:(id)responseData identifier:(NSString *)identifier;

@end
