//
//  MyMessageViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 14/11/21.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "MyMessageViewController.h"
#import "LoginViewController.h"
#import "BackButton.h"
#import "MessageListController.h"
#import "LoginViewController.h"
#import "UserButton.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "WZBAPI.h"
#import "PlistDB.h"
#import "SVProgressHUD.h"
#import "SqliteDB.h"
#import "FixPasswordController.h"
#import "SettingViewController.h"
#import "MyReqireListController.h"
#import "MyOrderListController.h"
#import "MyPublishRequireController.h"
#import "PublishNewRequireController.h"
#import "TalentApplicationController.h"
#import "TalentInfoViewController.h"
#import "StaticMethod.h"
#import "WZBImageTool.h"
#import "ContactUsController.h"
#import "RecommendedToMeListController.h"
#define ORIGINAL_MAX_WIDTH 640.0f


@interface MyMessageViewController ()<UITableViewDataSource,UITableViewDelegate,LoginViewDelegate, UIActionSheetDelegate, VPImageCropperDelegate,WZBRequestDelegate,UIAlertViewDelegate>
{
    UIView *_navView;
    UIView *_topNaviV;
    UIButton *_loginButton;
    UIImageView *_loginImage;
    UITableView *_messageTB;
    UILabel *_titleLabel;
    NSString *_userName;
    int statusInt;
    UIImage *accountImage;
    int accountImageInt;
    NSString *isLoginString;

}

@property (nonatomic, strong) UIImageView *portraitImageView;

@end

@implementation MyMessageViewController
@synthesize delegate;


-(void)viewWillAppear:(BOOL)animated
{
    
    
    PlistDB *plist = [[PlistDB alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    array = [plist getDataFilePathUserInfoPlist];
    
    if ([isLoginString isEqualToString:@"1"]) {
        _mseeageInt=1;
        [_messageTB reloadData];
    }
    else if (array.count>3) {
        _mseeageInt=1;
    }
    
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    [self baseSetting];

   
    
    accountImageInt =0;
    
    //领域
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginNotification:) name:@"LoginNotification" object:nil];
    
}

- (void)loadPortrait {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        
        
        UIImage *protraitImg = [UIImage imageNamed:@"icon_photo.png"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            PlistDB *plist = [[PlistDB alloc] init];
            NSMutableArray *array = [NSMutableArray array];
            array = [plist getDataFilePathAccountImagePlist];
            if (array.count>0&&accountImageInt==0) {
                accountImageInt++;
                NSData *imageData = [array firstObject];
                accountImage = [UIImage imageWithData:imageData];
            }
            if (accountImage) {
                self.portraitImageView.image = accountImage;
            }
            else
                self.portraitImageView.image = protraitImg;
        });
    });
}

#pragma mark 基本设置
-(void)baseSetting
{
    self.view.backgroundColor = RGBA(241, 241, 241, 1.0);
    UIView *statusBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 0.f)];
    if (isIos7 >= 7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)
    {
        statusBarView.frame = CGRectMake(statusBarView.frame.origin.x, statusBarView.frame.origin.y, statusBarView.frame.size.width, 20.f);
        statusBarView.backgroundColor = [UIColor clearColor];
        ((UIImageView *)statusBarView).backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:statusBarView];
    }
    
    _navView = [[UIView alloc] init];
    _navView.frame = CGRectMake(0, StatusbarSize, self.view.frame.size.width, 44);
    [self.view addSubview:_navView];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =_navView.frame;
    imageView.image = [UIImage imageNamed:@"nav_bk_long.png"];
    [_navView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_navView.frame.size.width - 200)/2, StatusbarSize , 200, 40)];
    titleLabel.textColor= [UIColor blackColor];
    [titleLabel setText:@"我的帐户"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [_navView addSubview:titleLabel];
    
    
    
//    BackButton *back = [[BackButton alloc] init];
//    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
//    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:back];

    
    //设置按钮
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.frame = CGRectMake(self.view.frame.size.width-45, StatusbarSize+10, 44, 44);
    [settingButton setBackgroundImage:[UIImage imageNamed:@"icon_setting.png"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(clickSetting) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:settingButton];
    
    
    
    UITableView *messageTb = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    messageTb.delegate =self;
    messageTb.dataSource =self;
    [self.view addSubview:messageTb];
    _messageTB=messageTb;
    
    
    
}

#pragma mark 点击返回
-(void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 点击设置
-(void)clickSetting
{
    if (_mseeageInt!=0) {
        SettingViewController *setting = [[SettingViewController alloc] init];
        setting.userName = _userName;
        [self.navigationController pushViewController:setting animated:YES];
        
    }
    else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.delegate=self;
        [self presentViewController:login animated:YES completion:nil];
    }
}

#pragma mark 点击登录
-(void)clickLogin
{
    if (_mseeageInt==0) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.delegate=self;
        [self presentViewController:login animated:YES completion:nil];
    }
}


#pragma mark tableView 数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_mseeageInt==1) {
        return 3;
    }
    else
        return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return 5;
    }
    else
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 98;
    }
    else
        return 50;
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    UITableViewCell  *cell;
    if (cell==nil) {
        cell = [[UITableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
        
    }
    if (indexPath.section==0) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, self.view.frame.size.width, 98);
        [cell addSubview:view];
        
        
        //登录按钮
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = view.frame;
        [loginButton addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
        [loginButton setBackgroundImage:[UIImage imageNamed:@"user_bk.png"] forState:UIControlStateNormal];
        [view addSubview:loginButton];
        [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [loginButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 90, 0, 50)];
        _loginButton =loginButton;
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame =CGRectMake(90, 29, self.view.frame.size.width-130, 40);
        titleLabel.text=@"";
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor blackColor];
        [view addSubview:titleLabel];
        _titleLabel= titleLabel;
        _titleLabel.hidden=YES;
        
        //登录按钮图片
        UIImageView *loginImage= [[UIImageView alloc] init];
        loginImage.image= [UIImage imageNamed:@"user_button.png"];
        loginImage.frame =CGRectMake(108, 40, 103, 33);
        [view addSubview:loginImage];
        _loginImage = loginImage;
        
        
        
        //头像图片
        [self loadPortrait];

        [view addSubview:self.portraitImageView];
//        self.portraitImageView.hidden=YES;
        
        
        //在登录状态下的UI显示
        if (_mseeageInt==1) {
            PlistDB *plist = [[PlistDB alloc] init];
            NSMutableArray *array = [NSMutableArray array];
            array = [plist getDataFilePathUserInfoPlist];
            NSString *title=@"";
            if (array.count>0) {
                title=[array objectAtIndex:3];
            }
            titleLabel.hidden=NO;
            [_loginButton setBackgroundImage:[UIImage imageNamed:@"user_bk.png"] forState:UIControlStateNormal];
            _titleLabel.text=title;
            _userName = title;
            _loginImage.hidden =YES;
            self.portraitImageView.hidden=NO;
            
        }
        
        
        
        
    }
    else if(indexPath.section==1)
    {
        UIImageView *cellImageView = [[UIImageView alloc] init];
        cellImageView.frame = CGRectMake(15, 8, 28, 28);
        UILabel *cellTitleLabel = [[UILabel alloc] init];
        cellTitleLabel.frame = CGRectMake(55,8, 250, 30);

         if (indexPath.row==0)
        {
            cellImageView.image = [UIImage imageNamed:@"icon_myRequire.png"];
            cellTitleLabel.text =@"我已发布的需求";
            
        }
         else if (indexPath.row==1)
        {
            cellImageView.image = [UIImage imageNamed:@"icon_message.png"];
            cellTitleLabel.text =@"系统消息";

        }
        else if (indexPath.row==2)
        {
            cellImageView.image = [UIImage imageNamed:@"icon_publishRequire.png"];
            cellTitleLabel.text =@"修改密码";
            
        }
        else if (indexPath.row==3)
        {
            cellImageView.image = [UIImage imageNamed:@"icon_Talentedperson.png"];
            cellTitleLabel.text =@"联系我们";
            
        }
        else if (indexPath.row==4)
        {
            cellImageView.image = [UIImage imageNamed:@"icon_myRequire.png"];
            cellTitleLabel.text =@"推荐给我的需求";
            
        }
    
        [cell addSubview:cellImageView];
        [cell addSubview:cellTitleLabel];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(indexPath.section==2)
    {
        UIButton *loginOut= [UIButton buttonWithType:UIButtonTypeCustom];
        loginOut.frame =CGRectMake(10, 5, self.view.frame.size.width-20, 40);
        [loginOut setTitle:@"退出登录" forState:UIControlStateNormal];
        [loginOut setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [loginOut addTarget:self action:@selector(clickLoginOut) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:loginOut];
    }
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark 点击退出登录
-(void)clickLoginOut
{
    NSLog(@"点击退出登录");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"是否确定退出登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
}


#pragma mark alertView代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [SVProgressHUD showSuccessWithStatus:@"退出登陆成功!"];
        PlistDB *plist = [[PlistDB alloc] init];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [plist setDataFilePathUserInfoPlist:array];
        [plist setDataFilePathCollcetionCheckPlist:array];
        [plist setDataFilePathAccountImagePlist:array];
        _mseeageInt=0;
        [self.delegate returnMessageInt:[NSString stringWithFormat:@"%d",_mseeageInt]];
        isLoginString=@"0";
        accountImage=[UIImage imageNamed:@"icon_photo.png"];
        [_messageTB reloadData];
        
        
    }
}


#pragma mark tableView代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (_mseeageInt==1) {
        if (section==0) {
            
        }
        else if(section==1)
        {
            if (row==0) {
                MyPublishRequireController *require = [[MyPublishRequireController alloc] init];
                [self.navigationController pushViewController:require animated:YES];
            }
            else if (row==1) {
                MessageListController *list = [[MessageListController alloc] init];
                [self.navigationController pushViewController:list animated:YES];
            }
            else if (row==2) {
                
                FixPasswordController *fix=[[FixPasswordController alloc] init];
                [self.navigationController pushViewController:fix animated:YES];
            }
            
            else if (row==3) {
                
                ContactUsController *contact = [[ContactUsController alloc] init];
                [self.navigationController pushViewController:contact animated:YES];
                
            }
            else if(row==4)
            {
                RecommendedToMeListController *toMe = [[RecommendedToMeListController alloc] init];
                [self.navigationController pushViewController:toMe animated:YES];
            }

        }
        else if(section==2)
        {
            NSLog(@"点击section2");
        }
        
    }
    else
    {
        [self clickLogin];
    }
}




-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}


#pragma mark 获取人才信息
-(void)requestAndGetTalentInfo
{
    NSString *accountString =[StaticMethod getAccountString];
    NSString *url = @"wzbAppService/regist/findPartnerAccount.htm";
    [[WZBAPI sharedWZBAPI] requestWithURL:url paramsString:accountString delegate:self];
}


#pragma mark 图片上传方法返回值
-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    NSDictionary *dict = result;
    if (dict.count>4) {
        TalentInfoViewController *info = [[TalentInfoViewController alloc] init];
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 100, 100)];
//        [WZBImageTool downLoadImage:[dict objectForKey:@"imageWebUrl"] imageView:imageView];
//        info.portraitImageView=imageView;
        
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:info];
        nav.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        nav.navigationBarHidden=YES;
        [self presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        TalentApplicationController *require = [[TalentApplicationController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:require];
        nav.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        nav.navigationBarHidden=YES;
        [self presentViewController:nav animated:YES completion:nil];
    }
    
}

-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"error");
}



#pragma mark LoginView代理方法，返回登录判断值
-(void)returnButtonInfo:(NSString *)imageUrl :(NSString *)userName :(NSString *)messageInt
{
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"user_bk.png"] forState:UIControlStateNormal];
    _titleLabel.hidden=NO;
    _titleLabel.text =userName;
    self.portraitImageView.hidden=NO;
    _loginImage.hidden=YES;
    _mseeageInt = [messageInt intValue];
    
    [self.delegate returnMessageInt:messageInt];
}

-(void)returnUserInfo:(NSString *)userName :(NSString *)messageInt
{
    _titleLabel.hidden=NO;
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"user_bk.png"] forState:UIControlStateNormal];
    _titleLabel.text=userName;
    self.portraitImageView.hidden=NO;
    _loginImage.hidden=YES;
    _mseeageInt = [messageInt intValue];
    [self.delegate returnMessageInt:messageInt];
}


#pragma mark 缩放图片
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}






- (void)editPortrait {
    if (_mseeageInt==1) {
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照", @"从相册中选取", nil];
        [choiceSheet showInView:self.view];
    }
}

#pragma mark VPImageCropperDelegate 头像图片上传
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.portraitImageView.image = editedImage;
    PlistDB *plist = [[PlistDB alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    NSData *imageData = [[NSData alloc] init];
    imageData = UIImageJPEGRepresentation(editedImage, 1);
    
    
    
    
    
    [array addObject:imageData];
    [plist setDataFilePathAccountImagePlist:array];
    accountImage = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                                 
                                 
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        CGFloat w = 60.0f; CGFloat h = w;
//        CGFloat x = (self.view.frame.size.width - w) / 2;
//        CGFloat y = (self.view.frame.size.height - h) / 2;
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, w, h)];
        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        [_portraitImageView.layer setMasksToBounds:YES];
        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_portraitImageView setClipsToBounds:YES];
        _portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
        _portraitImageView.layer.shadowOpacity = 0.5;
        _portraitImageView.layer.shadowRadius = 2.0;
        _portraitImageView.layer.borderColor = [[UIColor blackColor] CGColor];
        _portraitImageView.layer.borderWidth = 2.0f;
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
}


-(void)LoginNotification:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    isLoginString = [nameDictionary objectForKey:@"name"];
}

@end
