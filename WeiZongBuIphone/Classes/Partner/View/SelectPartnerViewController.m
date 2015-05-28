//
//  SelectPartnerViewController.m
//  WeiZongBuIphone
//
//  Created by Donald on 15/3/19.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "SelectPartnerViewController.h"

@interface SelectPartnerViewController () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, assign) UIStatusBarStyle previousStatusBarStyle;

@end

@implementation SelectPartnerViewController



#pragma mark - Controller lifecycle

-(instancetype)init {
    if ( self = [super init] ) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        
        self.dismissOnCancelTouch = YES;
        
        //Min and max data test
        //self.minDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*-60 + 3*60*60];
        //self.maxDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*60 - 3*60*60];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //This option only works when "View controller-based status bar appearance" in .plist is set to NO
    self.previousStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:self.previousStatusBarStyle animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.backgroundView.layer.cornerRadius = 10.0;
    self.backgroundView.layer.borderColor = self.mainColor.CGColor;
    self.backgroundView.layer.borderWidth = 1.0;
    
    
    _pickerArray = [NSMutableArray arrayWithObjects:@"动物",@"植物",@"石头",@"天空", nil];
    _selectPicker.delegate = self;
    _selectPicker.dataSource = self;
    _selectPicker.frame = CGRectMake(0, 480, 320, 216);
    
    
    //Add gesture recognizer to superview...
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelTapGesture:)];
    [self.backgroundView.superview addGestureRecognizer:gestureRecognizer];
    //...but turn off gesture recognition on lower views
    gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [self.backgroundView addGestureRecognizer:gestureRecognizer];
    
    //Set hours and minutes to selected values
//    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self.date];
//    [self setPickerView:_selectPicker rowInComponent:HourPicker toIntagerValue:[components hour] decrementing:NO animated:NO];
//    [self setPickerView:_selectPicker rowInComponent:MinutePicker toIntagerValue:[components minute]  decrementing:NO animated:NO];

}


#pragma mark - Properties
- (UIColor *)mainColor {
    if (!_mainColor) {
        _mainColor = [UIColor whiteColor];
    }
    return _mainColor;
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_pickerArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_pickerArray objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat width = 0.0;
    width = 140;
    return width;
}


//确认
- (IBAction)confirm:(id)sender {
    [self.delegate hsPartnerPickerPickedPartner:@"1"];
    
    [self.delegate hsPartnerPickerWillDismissWithQuitMethod:QuitWithResult1];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate hsPartnerPickerDidDismissWithQuitMethod:QuitWithResult1];
    }];
}


//取消
- (IBAction)cancel:(id)sender {
    [self.delegate hsPartnerPickerWillDismissWithQuitMethod:QuitWithBackButton1];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate hsPartnerPickerDidDismissWithQuitMethod:QuitWithBackButton1];
    }];
    
}


- (void)cancelTapGesture:(UITapGestureRecognizer *)sender {
    if (self.shouldDismissOnCancelTouch) {
        [self.delegate hsPartnerPickerWillDismissWithQuitMethod:QuitWithCancel1];
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate hsPartnerPickerDidDismissWithQuitMethod:QuitWithCancel1];
        }];
    }
}

@end
