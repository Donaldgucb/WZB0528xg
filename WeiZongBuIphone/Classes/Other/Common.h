//
//  Common.h
//  WeiZongBuIphone
//
//  Created by Donald on 14/12/10.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#ifndef WeiZongBuIphone_Common_h
#define WeiZongBuIphone_Common_h

//121.40.85.6
//192.168.10.110
//192.168.10.88:8081/
//192.168.10.86:8080
// 1.判断是否为iPhone5的宏
#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)


#define ScrennWidth ([UIScreen mainScreen].bounds.size.width)
#define ScrennHeight ([UIScreen mainScreen].bounds.size.height)

#ifdef DEBUG
// 调试状态
#define MyLog(...) NSLog(__VA_ARGS__)
#else
// 发布状态
#define MyLog(...)
#endif

#define kIP @"http://192.168.10.110/"

//展会信息
#define kExhibitionUrl @"wzbAppService/showActivity/getShowClassList.htm?"

//行业列表
#define kIndustryListUrl @"wzbAppService/company/companyClasses.htm"


//行业资讯列表
#define IndustryUrl @"wzbAppService/news/getNewsList.htm?page=0&offset=20&"

//主题活动列表
#define ActivityListUrl @"wzbAppService/showActivity/getActivityList.htm?page=0&offset=20&"

//合伙人活动列表
#define PartnerActivityListUrl @"wzbAppService/partner/getPartnerActivityInfoList.htm?page=0&offset=20&"

#define PartnerActivityDetailUrl @"wzbAppService/partner/getPartnerActivityDetail/"

//招标信息列表
#define ZhaoBiaoListUrl @"wzbAppService/demandAndTender/getTenderList.htm?username=admin&password=111111&token=&page=0&offset=20"

//需求专区列表
#define RequireListUrl @"wzbAppService/demandAndTender/getDemandList.htm?page=0&offset=20&"

//注册
#define RegistUrl @"wzbAppService/userRegist.htm"

//系统消息
#define SystermMessageUrl @"wzbAppService/information/getSystemNewsList.htm?page=0&offset=100&"

//创新基地列表
#define InnovationListUrl @"wzbAppService/innovation/getInnovationList.htm?page=0&offset=21&"


#define DetailTitleUrl @"pic"

//登陆
#define kLoginUrl @"wzbAppService/userLogin.htm?"

//xg登陆
#define kXGLoginUrl @"wzbAppService/userLogin2.htm"


#define checkPhoneNumber @"wzbAppService/checkUserNameEx.htm"

//请求获取重置密码的验证码
#define CheckPasswordUrl @"wzbCRM/system/sendCode.htm"

//请求重置密码Url
#define ResetPasswordUrl @"wzbCRM/system/checkTelAndCode.htm"

//找回密码
#define FindPasswordUrl @"wzbCMS/findPassword/findNewPasswordJson.htm?userName="

//修改密码
#define FixPasswordUrl @"wzbAppService/userResetPassword.htm?"

//合伙人列表
#define partnerListUrl @"wzbAppService/partner/getLastPartnerList.htm?page=0&offset=10&"

//加载更多
#define partnerListUrlMore @"wzbAppService/partner/getLastPartnerList.htm"

//合伙人搜索
#define PartnerSearchUrl @"wzbAppService/partner/searchForPartner.htm"


//公司搜索
#define CompanySearchUrl @"wzbAppService/company/getCompanyListByParam.htm?username=admin&password=111111&token=&page=0&offset=100&searchParam="

//产品搜索
#define ProductSearchUrl @"/wzbAppService/product/getProductListByParam.htm?username=admin&password=111111&token=&page=0&offset=100&searchParam="


//需求列表
#define PartnerRequireListUrl @"wzbAppService/require/getLastRequireList.htm?page=0&offset=20&"

//需求列表
#define PartnerRequireListUrlMore @"wzbAppService/require/getLastRequireList.htm"

//需求搜索列表
#define PartnerRequireSearchUrl @"wzbAppService/require/searchForRequire.htm"

//添加收藏
#define addCollectionUrl @"wzbAppService/collection/addCollection.htm"


//需求投标信息列表
#define ProductMarkListUrl @"wzbAppService/require/getLastBidList/"


//我发布的需求列表
#define MyPublishRequire @"wzbAppService/require/getMyAccountRequireList.htm"

#endif
