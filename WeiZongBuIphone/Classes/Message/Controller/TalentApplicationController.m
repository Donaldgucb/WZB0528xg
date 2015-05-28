//
//  TalentApplicationController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/4/13.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "TalentApplicationController.h"
#import "VPImageCropperViewController.h"
#import "WZBAPI.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ProviceController.h"
#import "DemoTextField.h"
#import "CredentialsChooseController.h"
#import "StaticMethod.h"
#import "SBJson.h"
#import "PlistDB.h"
#import "SVProgressHUD.h"
#import "DomainController.h"


#define ORIGINAL_MAX_WIDTH 640.0f

@interface TalentApplicationController ()<UIActionSheetDelegate,VPImageCropperDelegate,WZBRequestDelegate,UIAlertViewDelegate>
{
    NSString *provice;
    NSString *city;
    NSString *credentialsNameType;
    NSString *imageUrl;
    BOOL isImagePost;
    NSString *sexString;
    NSString *firstField;
    NSString *secondField;
    NSString *thirdField;
    int statusInt;
    
}


@property (nonatomic, strong) UIImageView *portraitImageView;
@property (strong, nonatomic) DemoTextField *addressTextField;
@property (strong, nonatomic) DemoTextField *credentialsNameTextField;
@property (strong, nonatomic) DemoTextField *credentialsIDTextField;
@property (strong, nonatomic) DemoTextField *domainTextField;

@end

@implementation TalentApplicationController



-(void)viewDidAppear:(BOOL)animated
{
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isImagePost=NO;
    imageUrl=@"";
    sexString = @"1";
    
    [self baseSetting];
    
    [self loadPortrait];
    
    [_scroll addSubview:self.portraitImageView];
    
    [self addAddressButton];
    
    [self addTextField];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:242/255. green:242/255. blue:246/255. alpha:1.0]];
    [self setEdgesForExtendedLayout:UIRectEdgeTop];
    
    [_emailTextField setRequired:YES];
    [_emailTextField setEmailField:YES];
    [_nameTextField setRequired:YES];
    [_ageTextField setDateField:YES];
    _addressTextField.userInteractionEnabled = NO;
    _scroll.contentSize = CGSizeMake(self.view.frame.size.width, 850);
    
    //区域
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeZoneNotification:) name:@"ChangeZoneNotification" object:nil];

    //有效证件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeCredentialNotification:) name:@"ChangeCredentialNotification" object:nil];
    
    //领域
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeDomainNotification:) name:@"ChangeDomainNotification" object:nil];
    
}

- (IBAction)manButtonTouch:(id)sender {
    sexString = @"1";
    [_manButton setImage:[UIImage imageNamed:@"icon_point_on"] forState:UIControlStateNormal];
    [_womanButton setImage:[UIImage imageNamed:@"icon_point"] forState:UIControlStateNormal];
}

- (IBAction)womanButtonTouch:(id)sender {
    sexString=@"2";
    [_manButton setImage:[UIImage imageNamed:@"icon_point"] forState:UIControlStateNormal];
    [_womanButton setImage:[UIImage imageNamed:@"icon_point_on"] forState:UIControlStateNormal];
}


#pragma mark 添加后面的textField
-(void)addTextField
{
    _credentialsNameTextField=[[DemoTextField alloc] initWithFrame:CGRectMake(20, 492, 280, 40)];
    _credentialsNameTextField.placeholder = @"请选择证件类型";
    _credentialsNameTextField.textColor = [UIColor blackColor];
    _credentialsNameTextField.backgroundColor = [UIColor whiteColor];
    _credentialsNameTextField.userInteractionEnabled=NO;
    [_scroll addSubview:_credentialsNameTextField];
    
    
    _credentialsIDTextField=[[DemoTextField alloc] initWithFrame:CGRectMake(20, 540, 280, 40)];
    _credentialsIDTextField.placeholder = @"请输入证件号码";
    _credentialsIDTextField.textColor = [UIColor blackColor];
    _credentialsIDTextField.backgroundColor = [UIColor whiteColor];
    _credentialsIDTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    [_scroll addSubview:_credentialsIDTextField];
    
    
    
//    _addressTextField = [[DemoTextField alloc] initWithFrame:CGRectMake(20, 588, 280, 40)];
//    _addressTextField.placeholder = @"地区";
//    _addressTextField.textColor = [UIColor blackColor];
//    _addressTextField.backgroundColor = [UIColor whiteColor];
//    [_scroll addSubview:_addressTextField];
    
    _domainTextField = [[DemoTextField alloc] initWithFrame:CGRectMake(20, 588, 280, 40)];
    _domainTextField.placeholder = @"领域";
    _domainTextField.textColor = [UIColor blackColor];
    _domainTextField.backgroundColor = [UIColor whiteColor];
    _domainTextField.userInteractionEnabled = NO;
    [_scroll addSubview:_domainTextField];
    
}



#pragma mark 添加按钮
-(void)addAddressButton
{
    
    //有效证件
    UIButton *credentialsNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    credentialsNameButton.frame = CGRectMake(20, 492, 280, 40);
    credentialsNameButton.backgroundColor = [UIColor clearColor];
    [credentialsNameButton addTarget:self action:@selector(clickCredentialsNameButton) forControlEvents:UIControlEventTouchDown];
    [_scroll addSubview:credentialsNameButton];
    
//    //地址
//    UIButton *addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    addressButton.frame = CGRectMake(20, 588, 280, 40);
//    addressButton.backgroundColor = [UIColor clearColor];
//    [addressButton addTarget:self action:@selector(clickAddress) forControlEvents:UIControlEventTouchDown];
//    [_scroll addSubview:addressButton];
    
    //领域
    UIButton *domainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    domainButton.frame = CGRectMake(20, 588, 280, 40);
    domainButton.backgroundColor = [UIColor clearColor];
    [domainButton addTarget:self action:@selector(clickDomainButton) forControlEvents:UIControlEventTouchDown];
    [_scroll addSubview:domainButton];
    
    
    //提交按钮
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(20, 636, 280, 40);
    [submitButton setImage:[UIImage imageNamed:@"talentSubmitBtn.png"] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(clickSubmit) forControlEvents:UIControlEventTouchDown];
    [_scroll addSubview:submitButton];
    
}





#pragma mark 点击提交审核信息
-(void)clickSubmit
{
    NSString *url = @"wzbAppService/regist/registToPartner.htm";
    NSString *accountString = [StaticMethod getAccountString];
    NSMutableArray *domainArray = [NSMutableArray array];
    NSMutableDictionary *firstDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *secondDict = [NSMutableDictionary dictionary];
    [firstDict setValue:firstField forKey:@"domainId"];
    [firstDict setValue:@"1" forKey:@"domainLevel"];
    [secondDict setValue:secondField forKey:@"domainId"];
    [secondDict setValue:@"2" forKey:@"domainLevel"];
    [domainArray addObject:firstDict];
    [domainArray addObject:secondDict];
    
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    [jsonDict setValue:_aliPayAccountTextField.text forKey:@"aliPayAccount"];
    [jsonDict setValue:_ageTextField.text forKey:@"birthday"];
    [jsonDict setValue:@"1" forKey:@"cityId"];
    [jsonDict setValue:@"1" forKey:@"provinceId"];
    [jsonDict setValue:_classicalCaseTextField.text forKey:@"classicalCase"];
    [jsonDict setValue:_credentialsIDTextField.text forKey:@"credentialsId"];
    [jsonDict setValue:credentialsNameType forKey:@"credentialsType"];
    [jsonDict setValue:_detailSkillsTextField.text forKey:@"detailSkills"];
    [jsonDict setValue:_emailTextField.text forKey:@"email"];
    [jsonDict setValue:_nameTextField.text forKey:@"name"];
    [jsonDict setValue:@"0" forKey:@"nationId"];
    [jsonDict setValue:_searchKeyWordTextField.text forKey:@"searchKeyWord"];
    [jsonDict setValue:_hornorTextField.text forKey:@"serverForCom"];
    [jsonDict setValue:sexString forKey:@"sex"];
    [jsonDict setValue:_phoneTextField.text forKey:@"telphone"];
    [jsonDict setValue:@"1" forKey:@"status"];
    [jsonDict setValue:domainArray forKey:@"domainIds"];
    [jsonDict setValue:imageUrl forKey:@"imageUrl"];
    
    NSString *jsonString = [jsonDict JSONRepresentation];
    NSString *paramString = [NSString stringWithFormat:@"jsonObject=%@&",jsonString];
    paramString = [NSString stringWithFormat:@"%@%@",paramString,accountString];
    NSLog(@"%@",paramString);
    [[WZBAPI sharedWZBAPI] requestWithURL:url paramsString:paramString delegate:self];

}



-(void)clickDomainButton
{
    DomainController *domain = [[DomainController alloc] init];
    [self.navigationController pushViewController:domain animated:YES];
}



#pragma mark 点击选择有效证件
-(void)clickCredentialsNameButton
{
    CredentialsChooseController *credential = [[CredentialsChooseController alloc] init];
    [self.navigationController pushViewController:credential animated:YES];
}

#pragma mark 点击地区按钮
-(void)clickAddress
{
    ProviceController *provice11 = [[ProviceController alloc] init];
    [self.navigationController pushViewController:provice11 animated:YES];
}


#pragma mark 基本设置
-(void)baseSetting
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *statusBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 0.f)];
    if (isIos7 >= 7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)
    {
        statusBarView.frame = CGRectMake(statusBarView.frame.origin.x, statusBarView.frame.origin.y, statusBarView.frame.size.width, 20.f);
        statusBarView.backgroundColor = [UIColor clearColor];
        ((UIImageView *)statusBarView).backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:statusBarView];
    }
    
    UIView *navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, StatusbarSize, self.view.frame.size.width, 44);
    [self.view addSubview:navView];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =navView.frame;
    imageView.image = [UIImage imageNamed:@"nav_bk_long.png"];
    [navView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((navView.frame.size.width - 200)/2, StatusbarSize , 200, 40)];
    titleLabel.textColor= [UIColor blackColor];
    [titleLabel setText:@"申请成为人才"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [navView addSubview:titleLabel];
    
    
    
    
    BackButton *back = [[BackButton alloc] init];
    back.frame = CGRectMake(0, StatusbarSize+10, 0, 0);
    [back addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    
    
    
    
}

#pragma mark 返回按钮
-(void)clickBack
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"你的信息还未提交,是否退出本次申请？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag=0;
    [alert show];
}


- (void)loadPortrait {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        
        
        UIImage *protraitImg = [UIImage imageNamed:@"defaulthead.png"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            self.portraitImageView.image = protraitImg;

        });
    });
}




- (IBAction)createAccount:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提交成功" message:@"您提交的信息已经收到,工作人员正在进行审核,请您耐心等候!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    if (![self validateInputInView:self.view]){
        
        [alertView setMessage:@"您填写的信息不完整,请检查后重新提交!"];
        [alertView setTitle:@"提交失败"];
    }
    
    [alertView show];
}



- (BOOL)validateInputInView:(UIView*)view
{
    for(UIView *subView in view.subviews){
        if ([subView isKindOfClass:[UIScrollView class]])
            return [self validateInputInView:subView];
        
        if ([subView isKindOfClass:[DemoTextField class]]){
            if (![(MHTextField*)subView validate]){
                return NO;
            }
        }
    }
    
    return YES;
}


#pragma mark http请求返回值
-(void)request:(WZBRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"%@",result);
    
    NSDictionary *dict = result;
    if (isImagePost) {
        statusInt=1;
        [SVProgressHUD dismiss];

        isImagePost=NO;
        imageUrl = [dict objectForKey:@"imageRoot"];
    }
    else{
        if (dict.count>2) {
            UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您已提交过申请,请勿重复提交,谢谢!" delegate:self
                                                 cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag=1;
            [alert show];
        }
        else
        {
            NSString *token = [dict objectForKey:@"token"];
            
            PlistDB *plist= [[PlistDB alloc] init];
            NSMutableArray *array = [NSMutableArray array];
            array = [plist getDataFilePathUserInfoPlist];
            [array replaceObjectAtIndex:0 withObject:token];
            [plist setDataFilePathUserInfoPlist:array];
            
            [SVProgressHUD showSuccessWithStatus:@"信息提交成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
//            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
}


-(void)request:(WZBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"error");
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==0) {
        if (buttonIndex==1) {
//            [self dismissViewControllerAnimated:YES completion:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
//        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark 接收本地通知
-(void)ChangeZoneNotification:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    _addressTextField.text = [nameDictionary objectForKey:@"name"];
    city =[nameDictionary objectForKey:@"cityID"];
    provice = [nameDictionary objectForKey:@"proviceID"];
}

-(void)ChangeCredentialNotification:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    _credentialsNameTextField.text = [nameDictionary objectForKey:@"name"];
    credentialsNameType =[nameDictionary objectForKey:@"CredentialID"];
}


-(void)ChangeDomainNotification:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    _domainTextField.text = [nameDictionary objectForKey:@"name"];
    firstField =[nameDictionary objectForKey:@"firstField"];
    secondField =[nameDictionary objectForKey:@"secondField"];
    NSLog(@"first==%@",firstField);
     NSLog(@"second==%@",secondField);
    thirdField=@"0";
}

#pragma mark 编辑上传图片
- (void)editPortrait {

    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
    
}

-(void)showStatus
{
    if (statusInt==0) {
        [SVProgressHUD showWithStatus:@"图片上传中..." maskType:SVProgressHUDMaskTypeClear];
    }
}


#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        CGFloat w = 100.0f; CGFloat h = 100.0f;
        //        CGFloat x = (self.view.frame.size.width - w) / 2;
        //        CGFloat y = (self.view.frame.size.height - h) / 2;
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, w, h)];
        _portraitImageView.layer.masksToBounds=YES;
        _portraitImageView.layer.cornerRadius=8;
//        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
//        [_portraitImageView.layer setMasksToBounds:YES];
//        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
//        [_portraitImageView setClipsToBounds:YES];
//        _portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
//        _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
//        _portraitImageView.layer.shadowOpacity = 0.5;
//        _portraitImageView.layer.shadowRadius = 2.0;
//        _portraitImageView.layer.borderColor = [[UIColor blackColor] CGColor];
//        _portraitImageView.layer.borderWidth = 2.0f;
        _portraitImageView.userInteractionEnabled = YES;
//        _portraitImageView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
}

#pragma mark VPImageCropperDelegate 头像图片上传
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.portraitImageView.image = editedImage;
    NSData *imageData = [[NSData alloc] init];
    imageData = UIImageJPEGRepresentation(editedImage, 1);
    
    isImagePost=YES;
    
    NSString *url = @"wzbAppService/image/addImage.htm";
    [[WZBAPI sharedWZBAPI] requestWithURL:url imageData:imageData delegate:self];
    statusInt=0;
    [self performSelector:@selector(showStatus) withObject:nil afterDelay:0.1f];
    
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



@end
