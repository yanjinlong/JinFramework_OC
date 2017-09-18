//
//  StatusHelper.m
//  JinFramework
//
//  Created by Jin on 2017/6/1.
//  Copyright © 2017年  Tribetech. All rights reserved.
//

#import "StatusHelper.h"
#import "UIColor+YYAdd.h"
#import "TableItem.h"

@implementation StatusHelper

/**
 At正则 例如 @王思聪
 */
+ (NSRegularExpression *)regexAt {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 微博的 At 只允许 英文数字下划线连字符，和 unicode 4E00~9FA5 范围内的中文字符，这里保持和微博一致。。
        // 目前中文字符范围比这个大
        regex = [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:kNilOptions error:NULL];
    });
    return regex;
}

/**
 话题正则 例如 #暖暖环游世界#
 */
+ (NSRegularExpression *)regexTopic {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"#[^@#]+?#" options:kNilOptions error:NULL];
    });
    return regex;
}

/**
 表情正则 例如 [偷笑]
 */
+ (NSRegularExpression *)regexEmoticon {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

/**
 获得表情的字典
 
 @return 表情字典
 */
+ (NSMutableDictionary *)getEmoticonDict {
    NSMutableDictionary *mapper = [NSMutableDictionary new];
    mapper[@"[呵呵]"] = [UIImage imageNamed:@"d_hehe"];
    mapper[@"[嘻嘻]"] = [UIImage imageNamed:@"d_xixi"];
    mapper[@"[哈哈]"] = [UIImage imageNamed:@"d_haha"];
    mapper[@"[爱你]"] = [UIImage imageNamed:@"d_aini"];
    mapper[@"[挖鼻屎]"] = [UIImage imageNamed:@"d_wabishi"];
    mapper[@"[吃惊]"] = [UIImage imageNamed:@"d_chijing"];
    mapper[@"[晕]"] = [UIImage imageNamed:@"d_yun"];
    mapper[@"[泪]"] = [UIImage imageNamed:@"d_lei"];
    mapper[@"[馋嘴]"] = [UIImage imageNamed:@"d_chanzui"];
    mapper[@"[抓狂]"] = [UIImage imageNamed:@"d_zhuakuang"];
    mapper[@"[哼]"] = [UIImage imageNamed:@"d_heng"];
    mapper[@"[可爱]"] = [UIImage imageNamed:@"d_keai"];
    mapper[@"[怒]"] = [UIImage imageNamed:@"d_nu"];
    mapper[@"[汗]"] = [UIImage imageNamed:@"d_han"];
    mapper[@"[害羞]"] = [UIImage imageNamed:@"d_haixiu"];
    mapper[@"[睡觉]"] = [UIImage imageNamed:@"d_shuijiao"];
    mapper[@"[钱]"] = [UIImage imageNamed:@"d_qian"];
    mapper[@"[偷笑]"] = [UIImage imageNamed:@"d_touxiao"];
    mapper[@"[笑cry]"] = [UIImage imageNamed:@"d_xiaoku"];
    mapper[@"[doge]"] = [UIImage imageNamed:@"d_doge"];
    mapper[@"[喵喵]"] = [UIImage imageNamed:@"d_miao"];
    mapper[@"[酷]"] = [UIImage imageNamed:@"d_ku"];
    mapper[@"[衰]"] = [UIImage imageNamed:@"d_shuai"];
    mapper[@"[闭嘴]"] = [UIImage imageNamed:@"d_bizui"];
    mapper[@"[鄙视]"] = [UIImage imageNamed:@"d_bishi"];
    mapper[@"[花心]"] = [UIImage imageNamed:@"d_huaxin"];
    mapper[@"[鼓掌]"] = [UIImage imageNamed:@"d_guzhang"];
    mapper[@"[悲伤]"] = [UIImage imageNamed:@"d_beishang"];
    mapper[@"[思考]"] = [UIImage imageNamed:@"d_sikao"];
    mapper[@"[生病]"] = [UIImage imageNamed:@"d_shengbing"];
    mapper[@"[亲亲]"] = [UIImage imageNamed:@"d_qinqin"];
    mapper[@"[怒骂]"] = [UIImage imageNamed:@"d_numa"];
    mapper[@"[太开心]"] = [UIImage imageNamed:@"d_taikaixin"];
    mapper[@"[懒得理你]"] = [UIImage imageNamed:@"d_landelini"];
    mapper[@"[右哼哼]"] = [UIImage imageNamed:@"d_youhengheng"];
    mapper[@"[左哼哼]"] = [UIImage imageNamed:@"d_zuohengheng"];
    mapper[@"[嘘]"] = [UIImage imageNamed:@"d_xu"];
    mapper[@"[委屈]"] = [UIImage imageNamed:@"d_weiqu"];
    mapper[@"[吐]"] = [UIImage imageNamed:@"d_tu"];
    mapper[@"[可怜]"] = [UIImage imageNamed:@"d_kelian"];
    mapper[@"[打哈气]"] = [UIImage imageNamed:@"d_dahaqi"];
    mapper[@"[挤眼]"] = [UIImage imageNamed:@"d_jiyan"];
    mapper[@"[失望]"] = [UIImage imageNamed:@"d_shiwang"];
    mapper[@"[顶]"] = [UIImage imageNamed:@"d_ding"];
    mapper[@"[疑问]"] = [UIImage imageNamed:@"d_yiwen"];
    mapper[@"[困]"] = [UIImage imageNamed:@"d_kun"];
    mapper[@"[感冒]"] = [UIImage imageNamed:@"d_ganmao"];
    mapper[@"[拜拜]"] = [UIImage imageNamed:@"d_baibai"];
    mapper[@"[黑线]"] = [UIImage imageNamed:@"d_heixian"];
    mapper[@"[阴险]"] = [UIImage imageNamed:@"d_yinxian"];
    mapper[@"[打脸]"] = [UIImage imageNamed:@"d_dalian"];
    mapper[@"[傻眼]"] = [UIImage imageNamed:@"d_shayan"];
    mapper[@"[猪头]"] = [UIImage imageNamed:@"d_zhutou"];
    mapper[@"[熊猫]"] = [UIImage imageNamed:@"d_xiongmao"];
    mapper[@"[兔子]"] = [UIImage imageNamed:@"d_tuzi"];
    
    return mapper;
}

/**
 获得表情的key数组
 
 @return 表情key数组
 */
+ (NSMutableArray *)getEmoticonKeyArray {
    NSMutableArray *array = [NSMutableArray new];
    
    [array addObject:@"[呵呵]"];
    [array addObject:@"[嘻嘻]"];
    [array addObject:@"[哈哈]"];
    [array addObject:@"[爱你]"];
    [array addObject:@"[挖鼻屎]"];
    [array addObject:@"[吃惊]"];
    [array addObject:@"[晕]"];
    [array addObject:@"[泪]"];
    [array addObject:@"[馋嘴]"];
    [array addObject:@"[抓狂]"];
    [array addObject:@"[哼]"];
    [array addObject:@"[可爱]"];
    [array addObject:@"[怒]"];
    [array addObject:@"[汗]"];
    [array addObject:@"[害羞]"];
    [array addObject:@"[睡觉]"];
    [array addObject:@"[钱]"];
    [array addObject:@"[偷笑]"];
    [array addObject:@"[笑cry]"];
    [array addObject:@"[doge]"];
    [array addObject:@"[喵喵]"];
    [array addObject:@"[酷]"];
    [array addObject:@"[衰]"];
    [array addObject:@"[闭嘴]"];
    [array addObject:@"[鄙视]"];
    [array addObject:@"[花心]"];
    [array addObject:@"[鼓掌]"];
    [array addObject:@"[悲伤]"];
    [array addObject:@"[思考]"];
    [array addObject:@"[生病]"];
    [array addObject:@"[亲亲]"];
    [array addObject:@"[怒骂]"];
    [array addObject:@"[太开心]"];
    [array addObject:@"[懒得理你]"];
    [array addObject:@"[右哼哼]"];
    [array addObject:@"[左哼哼]"];
    [array addObject:@"[嘘]"];
    [array addObject:@"[委屈]"];
    [array addObject:@"[吐]"];
    [array addObject:@"[可怜]"];
    [array addObject:@"[打哈气]"];
    [array addObject:@"[挤眼]"];
    [array addObject:@"[失望]"];
    [array addObject:@"[顶]"];
    [array addObject:@"[疑问]"];
    [array addObject:@"[困]"];
    [array addObject:@"[感冒]"];
    [array addObject:@"[拜拜]"];
    [array addObject:@"[黑线]"];
    [array addObject:@"[阴险]"];
    [array addObject:@"[打脸]"];
    [array addObject:@"[傻眼]"];
    [array addObject:@"[猪头]"];
    [array addObject:@"[熊猫]"];
    [array addObject:@"[兔子]"];
    
    return array;
}

/**
 根据性别获得性别的图片
 
 @param gender 性别值 0女，1男，2保密
 @return 对应的性别图片
 */
+ (UIImage *)getGenderImageByGenderValue:(NSInteger)gender {
    NSString *imageName = @"";
    
    if (gender == 0) {
        imageName = @"msg_detail_female";
    }
    else if (gender == 1) {
        imageName = @"msg_detail_male";
    }
    else if (gender == 2) {
        imageName = @"msg_detail_sex";
    }
    
    return [UIImage imageNamed:imageName];
}

/**
 标签颜色数组
 
 @return 颜色数组
 */
+ (NSArray *)labelColorArray {
    NSMutableArray *colorArray = [NSMutableArray new];
    [colorArray addObject:[UIColor colorWithHexString:@"f9df94"]];
    [colorArray addObject:[UIColor colorWithHexString:@"9be9f8"]];
    [colorArray addObject:[UIColor colorWithHexString:@"86e3b0"]];
    
    return colorArray;
}

/**
 *  重置手机号码文本显示成   139****2342
 *
 *  @param phone 手机文本
 *
 *  @return 重置后的手机号码
 */
+ (NSString *)reSetPhoneText:(NSString *)phone {
    if (phone.length < 11) {
        return phone;
    }
    
    NSString *p = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4)
                                                 withString:@"****"];
    
    return p;
}

/**
 验证手机号是否合法有效
 
 @param mobileNum 手机号
 @return YES有效 NO无效
 */
+ (BOOL)isValidPhoneNumber:(NSString *)mobileNum {
    if (mobileNum.length != 11) {
        return NO;
    }
    
    NSString *mobile = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    return [regextestmobile evaluateWithObject:mobileNum];
}

/**
 校验密码是否合法
 
 @param password 校验的密码
 @param resultStr 不合法时返回对应错误字符串
 @return YES 合法 NO不合法
 */
+ (BOOL)validPassWordCharacter:(NSString *)password result:(NSString **)resultStr {
    BOOL result = NO;
    
    
    if (password.length < 8 || password.length > 20) {
        *resultStr = @"请输入8-20位字母和数字组成的密码，至少一位大写字母";
        return result;
    }
    else if ([password containsString:@"="]  || [password containsString:@"/"] ||
             [password containsString:@"\\"] || [password containsString:@" "] ||
             [password containsString:@"="]  || [password containsString:@"／"] ||
             [password containsString:@"／"] || [password containsString:@" "]) {
        *resultStr = @"密码含有非法字符";
        return result;
    }
    
    NSString * regex = @"^(?![0-9]+$)((?=.*[A-Z]))[^=\\ /]{8,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:password];
    
    if (!result) {
        *resultStr = @"请输入8-20位字母和数字组成的密码，至少一位大写字母";
    }
    
    return result;
}

/**
 检测输入框是否是金额的文本

 @param textField 文本框
 @param range 输入的位置
 @param string 输入的文本
 @param maxLength 长度控制
 @param isFirstZero 是否第一个是0
 @param isHaveDian 是否带点
 @return yes可以输入，no不可输入
 */
+ (BOOL)checkDecimalText:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string maxLength:(NSInteger)maxLength isFirstZero:(BOOL *)isFirstZero isHaveDian:(BOOL *)isHaveDian {
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        
        if ((single >= '0' && single <= '9') || single == '.') {
            //数据格式正确
            if ([textField.text length] == 0) {
                if (single == '.') {
                    //首字母不能为小数点
                    return NO;
                }
                
                if (single == '0') {
                    *isFirstZero = YES;
                    return YES;
                }
            }
            
            if (single == '.') {
                if (!*isHaveDian) {//text中还没有小数点
                    *isHaveDian = YES;
                    return YES;
                }
                else {
                    return NO;
                }
            }
            else if (single == '0') {
                if ((*isFirstZero && *isHaveDian) || (!*isFirstZero && *isHaveDian)) {
                    //首位有0有.（0.01）或首位没0有.（10200.00）可输入两位数的0
                    if ([textField.text isEqualToString:@"0.0"]) {
                        return NO;
                    }
                    
                    NSRange ran = [textField.text rangeOfString:@"."];
                    int tt = (int)(range.location - ran.location);
                    
                    if (tt <= 2) {
                        return YES;
                    }
                    else {
                        return NO;
                    }
                }
                else if (*isFirstZero && !*isHaveDian) {
                    //首位有0没.不能再输入0
                    return NO;
                }
                else {
                    return YES;
                }
            }
            else {
                if (*isHaveDian) {
                    //存在小数点，保留两位小数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    int tt= (int)(range.location - ran.location);
                    
                    if (tt <= 2) {
                        return YES;
                    }
                    else {
                        return NO;
                    }
                }
                else if (*isFirstZero && !*isHaveDian) {
                    //首位有0没点
                    return NO;
                }
                else {
                    // 整数不能超过8位
                    if (textField.text.length > maxLength) {
                        return NO;
                    }
                    
                    return YES;
                }
            }
        }
        else {
            //输入的数据格式不正确
            return NO;
        }
    }
    else {
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if ([toBeString rangeOfString:@"."].location == NSNotFound) {
            *isHaveDian = NO;
        }
        else {
            *isHaveDian = YES;
        }
        
        if ([toBeString rangeOfString:@"0"].location == 0) {
            *isFirstZero = YES;
        }
        else {
            *isFirstZero = NO;
        }
        
        return YES;
    }
}

/**
 得到中英文混合字符串长度
 
 @param text 字符串
 @return 字符长度
 */
+ (NSInteger)getStringCharLength:(NSString *)text {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *da = [text dataUsingEncoding:enc];
    
    return [da length];
}

/**
 通过银行卡类型获得图标
 
 @param type 类型
 @return 图标
 */
+ (UIImage *)getBankImageByType:(NSInteger)type {
    UIImage *image;
    
    if (type == 1) {
        image = [UIImage imageNamed:@"mywallet_zhifubao"];
    }
    else if (type == 2) {
        image = [UIImage imageNamed:@"mywallet_weixin"];
    }
    else {
        image = [UIImage imageNamed:@"mywallet_zhifubao"];
    }
    
    return image;
}

/**
 获取默认支付方式
 
 @return 支付方式数组
 */
+ (NSMutableArray *)getDefaultPayTypeArray {
    NSMutableArray *itemArray = [NSMutableArray new];
    
    TableRowItem *itemAlipay = [TableRowItem itemWithIcon:[UIImage imageNamed:@"mywallet_zhifubao"] text:@"支付宝" code:@"alipay"];
    TableRowItem *itemWX = [TableRowItem itemWithIcon:[UIImage imageNamed:@"mywallet_weixin"] text:@"微信" code:@"wx"];
    
    [itemArray addObject:itemAlipay];
    [itemArray addObject:itemWX];
    
    return itemArray;
}

/**
 获取资讯的来源描述
 
 @param source 来源类型 0新浪 1自编
 @return 来源字符串
 */
+ (NSString *)getNewsSourceByType:(NSInteger)source {
    NSString *sourceStr = @"新浪新闻";
    
    if (source == 0) {
        sourceStr = @"新浪新闻";
    }
    else if (source == 1) {
        sourceStr = @"部族欧巴";
    }
    
    return sourceStr;
}

/**
 获取资讯的来源图标
 
 @param source 来源类型 0新浪 1自编
 @return 来源图标
 */
+ (UIImage *)getNewsSourceImageByType:(NSInteger)source {
    NSString *imageName = @"information_conyent_sina-icon";
    
    if (source == 0) {
        imageName = @"information_conyent_sina-icon";
    }
    else if (source == 1) {
        imageName = @"information_content_oba";
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}

@end
