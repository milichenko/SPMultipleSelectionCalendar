//
//  SPCalendarMonthView.m
//  SPMultipleSelectionCalendar
//
//  Created by Vladimir Milichenko on 7/30/14.
//  Copyright (c) 2014 massinteractiveserviceslimited. All rights reserved.
//

#import "SPCalendarMonthView.h"

@interface SPCalendarMonthView ()

@property (strong, nonatomic) NSArray *dateOfMonthButtons;

@end

@implementation SPCalendarMonthView

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame date:[NSDate date]];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame date:(NSDate *)date
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        NSMutableArray *buttonsArray = [NSMutableArray array];
        
        for (int i = 0; i < 35; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [buttonsArray addObject:btn];
        }
        
        self.dateOfMonthButtons = @[@[buttonsArray[0], buttonsArray[1], buttonsArray[2], buttonsArray[3], buttonsArray[4], buttonsArray[5], buttonsArray[6]],
                                    @[buttonsArray[7], buttonsArray[8], buttonsArray[9], buttonsArray[10], buttonsArray[11], buttonsArray[12], buttonsArray[13]],
                                    @[buttonsArray[14], buttonsArray[15], buttonsArray[16], buttonsArray[17], buttonsArray[18], buttonsArray[19], buttonsArray[20]],
                                    @[buttonsArray[21], buttonsArray[22], buttonsArray[23], buttonsArray[24], buttonsArray[25], buttonsArray[26], buttonsArray[27]],
                                    @[buttonsArray[28], buttonsArray[29], buttonsArray[30], buttonsArray[31], buttonsArray[32], buttonsArray[33], buttonsArray[34]]];
        
        CGFloat dayOfMonthButtonsHeight = self.frame.size.height / 5.0f;
        
        CGFloat btnY = 0.0f;
        
        for (int i = 0; i < 5; i++)
        {
            CGFloat btnX = 0.0f;
            
            for (int j = 0; j < 7; j++)
            {
                UIButton *btn = self.dateOfMonthButtons[i][j];
                btn.frame = CGRectMake(btnX, btnY, CONTROLS_WIDTH, dayOfMonthButtonsHeight);
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self addSubview:btn];
                
                btnX += CONTROLS_WIDTH;
            }
            
            btnY += dayOfMonthButtonsHeight;
        }
        
        [self arrangeMonthDaysInDate:date];
    }
    
    return self;
}

#pragma mark - Private methods

- (void)arrangeMonthDaysInDate:(NSDate *)date
{
    for (int i = 0; i < 5; i++)
    {
        for (int j = 0; j < 7; j++)
        {
            UIButton *btn = self.dateOfMonthButtons[i][j];
            [btn setTitle:@"" forState:UIControlStateNormal];
        }
    }
    
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
                [btn setTitle:[NSString stringWithFormat:@"%d",currentTitleValue] forState:UIControlStateNormal];
                
                currentTitleValue++;
            }
        }
    }
}

@end
