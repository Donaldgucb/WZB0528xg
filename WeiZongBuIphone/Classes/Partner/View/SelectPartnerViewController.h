//
//  SelectPartnerViewController.h
//  WeiZongBuIphone
//
//  Created by Donald on 15/3/19.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    QuitWithResult1, //When confirm button is pressed
    QuitWithBackButton1, //When back button is pressed
    QuitWithCancel1, //when View outside date picker is pressed
} HSPartnerPickerQuitMethod11;



@protocol SelectPartnerViewControllerDelegate <NSObject>
/**
 *  This method is called when user touch confrim button.
 *
 *  @param date selected date and time
 */
- (void)hsPartnerPickerPickedPartner:(NSString *)partner;
@optional
/**
 *  This method is called when view will be dismissed.
 *
 *  @param method of quit the view.
 */
- (void)hsPartnerPickerWillDismissWithQuitMethod:(HSPartnerPickerQuitMethod11)method;
/**
 *  This method is called when view is dismissed.
 *
 *  @param method of quit the view.
 */
- (void)hsPartnerPickerDidDismissWithQuitMethod:(HSPartnerPickerQuitMethod11)method;

@end




@interface SelectPartnerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (weak, nonatomic) IBOutlet UILabel *partnerName;
@property (weak, nonatomic) IBOutlet UIPickerView *selectPicker;
- (IBAction)confirm:(id)sender;
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property(nonatomic,strong)NSMutableArray *pickerArray;
@property (nonatomic, weak) id<SelectPartnerViewControllerDelegate> delegate;
@property (nonatomic, strong) UIColor *mainColor;
@property (nonatomic, assign, getter=shouldDismissOnCancelTouch) BOOL dismissOnCancelTouch;

@end
