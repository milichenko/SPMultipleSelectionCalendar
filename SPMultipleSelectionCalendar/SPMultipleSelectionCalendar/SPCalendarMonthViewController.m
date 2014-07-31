//
//  SPMonthViewController.m
//  SPMultipleSelectionCalendar
//
//  Created by Vladimir Milichenko on 7/31/14.
//  Copyright (c) 2014 massinteractiveserviceslimited. All rights reserved.
//

#import "SPCalendarMonthViewController.h"

@interface SPCalendarMonthViewController ()

@property (strong, nonatomic) NSMutableArray *dateOfMonthButtons;
@property (strong, nonatomic) UIView *monthView;

@property (assign, nonatomic) CGRect monthViewFrame;

@end

@implementation SPCalendarMonthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        
    }
    
    return self;
}

- (id)initWithViewFrame:(CGRect)frame
{
    self = [super init];
    
    if (self)
    {
        self.monthViewFrame = frame;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = self.monthViewFrame;
    
    self.monthView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.monthViewFrame.size.width, self.monthViewFrame.size.height)];
    [self.view addSubview:self.monthView];
    
    [self arrangeDayButtonsForView:self.monthView withDate:[NSDate date]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public methods

- (void)changeMonthViewInDirection:(MonthAnimationDirection)animationDirection withDate:(NSDate *)date
{
    CGFloat viewToDisplayOriginY = 0.0f;
    CGFloat oldViewNewOriginY = 0.0f;
    
    if (animationDirection == MonthAnimationDirectionUp)
    {
        viewToDisplayOriginY = self.monthView.frame.size.height;
        oldViewNewOriginY = -self.monthView.frame.size.height;
    }
    else if (animationDirection == MonthAnimationDirectionDown)
    {
        viewToDisplayOriginY = -self.monthView.frame.size.height;
        oldViewNewOriginY = self.monthView.frame.origin.y + self.monthView.frame.size.height;
    }
    
    UIView *viewToDisplay = [[UIView alloc] initWithFrame:CGRectMake(self.monthViewFrame.origin.x,
                                                                     viewToDisplayOriginY,
                                                                     self.monthView.frame.size.width,
                                                                     self.monthView.frame.size.height)];
    
    [self arrangeDayButtonsForView:viewToDisplay withDate:date];
    
    [self.view addSubview:viewToDisplay];
    
    if ([self.monthViewControllerDelegate respondsToSelector:@selector(calendarMonthViewControllerAnimationWillStart:)])
    {
        [self.monthViewControllerDelegate calendarMonthViewControllerAnimationWillStart:self];
    }
    
    __weak SPCalendarMonthViewController *weakSelf = self;
    
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.monthView.frame = CGRectMake(weakSelf.monthView.frame.origin.x, oldViewNewOriginY, weakSelf.monthView.frame.size.width, weakSelf.monthView.frame.size.height);
        viewToDisplay.frame = CGRectMake(0.0, 0.0f, weakSelf.monthViewFrame.size.width, weakSelf.monthViewFrame.size.height);
    } completion:^(BOOL finished) {
        if (finished)
        {
            [weakSelf.monthView removeFromSuperview];
            weakSelf.monthView = viewToDisplay;
            
            if ([weakSelf.monthViewControllerDelegate respondsToSelector:@selector(calendarMonthViewControllerAnimationDidStop:)])
            {
                [weakSelf.monthViewControllerDelegate calendarMonthViewControllerAnimationDidStop:weakSelf];
            }
        }
    }];
}

#pragma mark - Private methods

- (void)arrangeDayButtonsForView:(UIView *)view withDate:(NSDate *)date
{
    CGFloat dayOfMonthButtonsHeight = self.monthViewFrame.size.height / 5.0f;
    
    CGFloat btnY = 0.0f;
    
    self.dateOfMonthButtons = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++)
    {
        self.dateOfMonthButtons[i] = [NSMutableArray array];
        
        CGFloat btnX = 0.0f;
        
        for (int j = 0; j < 7; j++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(btnX, btnY, CONTROLS_WIDTH, dayOfMonthButtonsHeight);
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(dayButtonAction:) forControlEvents:UIControlEventTouchDown];
            
            [view addSubview:btn];
            
            self.dateOfMonthButtons[i][j] = btn;
            
            btnX += CONTROLS_WIDTH;
        }
        
        btnY += dayOfMonthButtonsHeight;
    }
    
    [self arrangeMonthDaysInDate:date];
}

- (void)arrangeMonthDaysInDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [calendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    
    NSRange monthRange = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[calendar dateFromComponents:dateComponents]];
    
    dateComponents.day = 1;
    
    NSDate *firstWeekDayDate = [calendar dateFromComponents:dateComponents];
    
    NSDateComponents *firstWeekDayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:firstWeekDayDate];
    
    int currentTitleValue = 1;
    
    BOOL endOfCycle = NO;
    
    for (int i = 0; i < 5; i++)
    {
        if (endOfCycle)
        {
            break;
        }
        
        for (int j = 0; j < 7; j++)
        {
            if (currentTitleValue > monthRange.length)
            {
                endOfCycle = YES;
                
                break;
            }
            else if (i == 0 && j < [firstWeekDayComponents weekday] - 1)
            {
                continue;
            }
            else
            {
                UIButton *btn = self.dateOfMonthButtons[i][j];
                [btn setTitle:[NSString stringWithFormat:@"%d", currentTitleValue] forState:UIControlStateNormal];
                
                currentTitleValue++;
            }
        }
    }
}

#pragma mark - Actions

- (void)dayButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    [sender setTitleColor:sender.selected ? [UIColor lightGrayColor] : [UIColor blackColor] forState:UIControlStateNormal];
}

@end
