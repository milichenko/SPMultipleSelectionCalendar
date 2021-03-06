//
//  SPMonthViewController.m
//  SPMultipleSelectionCalendar
//
//  Created by Vladimir Milichenko on 7/31/14.
//  Copyright (c) 2014 massinteractiveserviceslimited. All rights reserved.
//

#import "SPCalendarMonthViewController.h"

#define MONTHS_ROWS_COUNT 5
#define MONTHS_COLUMNS_COUNT 7

@interface SPCalendarMonthViewController ()

@property (strong, nonatomic) NSMutableArray *dateOfMonthButtons;
@property (strong, nonatomic) UIView *monthView;
@property (strong, nonatomic) UIButton *firstSelectedButton;
@property (strong, nonatomic) UIButton *secondSelectedButton;

@property (assign, nonatomic) CGRect monthViewFrame;
@property (assign, nonatomic) NSInteger minTagForCurrentMonth;
@property (assign, nonatomic) NSInteger maxTagForCurrentMonth;

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
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    [self.view addGestureRecognizer:panGestureRecognizer];

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
    
    for (int i = 0; i < MONTHS_ROWS_COUNT; i++)
    {
        self.dateOfMonthButtons[i] = [NSMutableArray array];
        
        CGFloat btnX = 0.0f;
        
        for (int j = 0; j < MONTHS_COLUMNS_COUNT; j++)
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
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    
    NSDateComponents *dateComponents = [calendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    
    NSRange monthRange = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[calendar dateFromComponents:dateComponents]];
    
    dateComponents.day = 1;
    
    NSDate *firstWeekDayDate = [calendar dateFromComponents:dateComponents];
    
    NSDateComponents *firstWeekDayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:firstWeekDayDate];
    
    int currentTitleValue = 1;
    
    BOOL endOfCycle = NO;
    
    self.minTagForCurrentMonth = 0;
    self.maxTagForCurrentMonth = 0;
    
    for (int i = 0; i < MONTHS_ROWS_COUNT; i++)
    {
        if (endOfCycle)
        {
            break;
        }
        
        for (int j = 0; j < MONTHS_COLUMNS_COUNT; j++)
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
                dateComponents.day = currentTitleValue;
                NSDate *dateForTag = [calendar dateFromComponents:dateComponents];
                
                UIButton *btn = self.dateOfMonthButtons[i][j];
                btn.tag = (NSInteger)dateForTag.timeIntervalSince1970;
                [btn setTitle:[NSString stringWithFormat:@"%d", currentTitleValue] forState:UIControlStateNormal];
                
                if (self.minTagForCurrentMonth == 0)
                {
                    self.minTagForCurrentMonth = btn.tag;
                }
                
                if (btn.tag > self.maxTagForCurrentMonth)
                {
                    self.maxTagForCurrentMonth = btn.tag;
                }
                
                if ((self.firstSelectedButton && self.secondSelectedButton && btn.tag >= self.firstSelectedButton.tag && btn.tag <= self.secondSelectedButton.tag) ||
                    (self.firstSelectedButton && btn.tag == self.firstSelectedButton.tag))
                {
                    [self changeAppearanceForButtons:@[btn] isHighlighted:YES];
                }
                
                currentTitleValue++;
            }
        }
    }
}

- (void)changeAppearanceForButtons:(NSArray *)buttons isHighlighted:(BOOL)isHighlighted
{
    if (self.firstSelectedButton)
    {
        NSMutableArray *datesIntervalArray = [NSMutableArray array];
        
        NSInteger firstDateInterval = self.firstSelectedButton.tag;
        NSDate *firstDate = [NSDate dateWithTimeIntervalSince1970:firstDateInterval];
        
        datesIntervalArray[0] = firstDate;
        
        if (self.secondSelectedButton)
        {
            NSInteger lastDateInterval = self.secondSelectedButton.tag;
            NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:lastDateInterval];
            
            datesIntervalArray[1] = lastDate;
        }
        
        if ([self.monthViewControllerDelegate respondsToSelector:@selector(calendarMonthViewController:didChangeDateSelection:)])
        {
            [self.monthViewControllerDelegate calendarMonthViewController:self didChangeDateSelection:datesIntervalArray];
        }
    }
    
    for (UIButton *btn in buttons)
    {
        btn.selected = isHighlighted;
        [btn setTitleColor:isHighlighted ? [UIColor lightGrayColor] : [UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (NSArray *)arrayForHighlightBetweenFirstDate:(NSInteger)firstDate andSecondDate:(NSInteger)secondDate
{
    NSMutableArray *arr = [NSMutableArray array];
    
    BOOL endOfCycle = NO;
    
    for (int i = 0; i < MONTHS_ROWS_COUNT; i++)
    {
        if (endOfCycle)
        {
            break;
        }
        
        for (int j = 0; j < MONTHS_COLUMNS_COUNT; j++)
        {
            UIButton *btn = self.dateOfMonthButtons[i][j];
            
            if (btn.tag >= firstDate && btn.tag <= secondDate)
            {
                [arr addObject:btn];
            }
            else if (btn.tag > secondDate)
            {
                endOfCycle = YES;
                
                break;
            }
        }
    }
    
    return arr;
}

#pragma mark - Actions

- (void)dayButtonAction:(UIButton *)sender
{
    if (sender.tag != 0)
    {
        if (!self.firstSelectedButton)
        {
            [self changeAppearanceForButtons:@[sender] isHighlighted:YES];
            
            self.firstSelectedButton = sender;
        }
        else if (self.firstSelectedButton && self.secondSelectedButton && sender.tag >= self.firstSelectedButton.tag && sender.tag <= self.secondSelectedButton.tag)
        {
            NSArray *buttonsForUnhighlight = [self arrayForHighlightBetweenFirstDate:self.firstSelectedButton.tag andSecondDate:self.secondSelectedButton.tag];
            
            [self changeAppearanceForButtons:buttonsForUnhighlight isHighlighted:NO];
            [self changeAppearanceForButtons:@[sender] isHighlighted:YES];
            
            self.firstSelectedButton = sender;
            self.secondSelectedButton = nil;
        }
        else if (self.firstSelectedButton)
        {
            if (sender.tag < self.firstSelectedButton.tag)
            {
                [self changeAppearanceForButtons:@[sender] isHighlighted:YES];
                
                NSInteger endDateTag = self.secondSelectedButton ? self.secondSelectedButton.tag : self.firstSelectedButton.tag;
                
                NSArray *buttonsForUnhighlight = [self arrayForHighlightBetweenFirstDate:self.firstSelectedButton.tag andSecondDate:endDateTag];
                
                [self changeAppearanceForButtons:buttonsForUnhighlight isHighlighted:NO];
                
                self.firstSelectedButton = sender;
                self.secondSelectedButton = nil;
            }
            else if (sender.tag > self.firstSelectedButton.tag)
            {
                self.secondSelectedButton = sender;
                
                NSArray *buttonsForHighlight = [self arrayForHighlightBetweenFirstDate:self.firstSelectedButton.tag andSecondDate:sender.tag];
                
                [self changeAppearanceForButtons:buttonsForHighlight isHighlighted:YES];
            }
        }
        
        MonthAnimationDirection monthAnimationDirection = MonthAnimationDirectionNone;
        
        if (sender.tag == self.maxTagForCurrentMonth)
        {
            monthAnimationDirection = MonthAnimationDirectionUp;
        }
        
        if ([self.monthViewControllerDelegate respondsToSelector:@selector(calendarMonthViewController:needChangeMonthInDirection:)])
        {
            [self.monthViewControllerDelegate calendarMonthViewController:self needChangeMonthInDirection:monthAnimationDirection];
        }
    }
}

- (void)panGestureDetected:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint gestureLocation = [gestureRecognizer locationInView:self.monthView];
    
    for (int i = 0; i < MONTHS_ROWS_COUNT; i++)
    {
        for (int j = 0; j < MONTHS_COLUMNS_COUNT; j++)
        {
            UIButton *btn = self.dateOfMonthButtons[i][j];
            
            if (btn.tag != 0 && CGRectContainsPoint(btn.frame, gestureLocation) && btn.tag > self.firstSelectedButton.tag)
            {
                if (!self.firstSelectedButton)
                {
                    self.firstSelectedButton = btn;
                }
                
                if (self.firstSelectedButton && self.firstSelectedButton != btn)
                {
                    self.secondSelectedButton = btn;
                }
                
                NSArray *buttonsForUnhighlight = nil;
                NSArray *buttonsForHighlight = nil;
                
                if (self.firstSelectedButton && self.secondSelectedButton)
                {
                    buttonsForUnhighlight = [self arrayForHighlightBetweenFirstDate:self.minTagForCurrentMonth andSecondDate:self.maxTagForCurrentMonth];
                    buttonsForHighlight = [self arrayForHighlightBetweenFirstDate:self.firstSelectedButton.tag andSecondDate:self.secondSelectedButton.tag];
                }
                else if (self.firstSelectedButton)
                {
                    buttonsForHighlight = @[self.firstSelectedButton];
                }
                
                [self changeAppearanceForButtons:buttonsForUnhighlight isHighlighted:NO];
                [self changeAppearanceForButtons:buttonsForHighlight isHighlighted:YES];
                
                if (self.secondSelectedButton.tag == self.maxTagForCurrentMonth)
                {
                    if ([self.monthViewControllerDelegate respondsToSelector:@selector(calendarMonthViewController:needChangeMonthInDirection:)])
                    {
                        [self.monthViewControllerDelegate calendarMonthViewController:self needChangeMonthInDirection:MonthAnimationDirectionUp];
                    }
                }
            }
        }
    }
}

@end
