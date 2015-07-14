#import <libactivator/libactivator.h>

@interface EKAlarm
+ (id)alarmWithAbsoluteDate:(id)arg1;
+ (id)alarmWithRelativeOffset:(double)arg1;
@end

@interface EKCalendar
@end

@interface EKCalendarItem
@property(retain, nonatomic) EKCalendar *calendar;
@property(copy, nonatomic) NSString *title;
@property(copy, nonatomic) NSString *notes;
@property(copy, nonatomic) NSArray *alarms;
@property(copy, nonatomic) NSURL *URL;
@property(copy, nonatomic) NSURL *action;
@property(copy, nonatomic) NSString *location;
- (void)addAlarm:(id)arg1;
@end

@interface EKEventStore : NSObject
@property(readonly, nonatomic) EKCalendar *defaultCalendarForNewEvents;
- (id)init;
- (BOOL)saveReminder:(id)arg1 commit:(BOOL)arg2 error:(id *)arg3;
- (id)defaultCalendarForNewReminders;
@end

@interface EKEvent : EKCalendarItem
+ (id)eventWithEventStore:(id)arg1;

@property(readonly, copy) NSDate *initialEndDate;
@property(readonly, nonatomic) NSDate *occurrenceDate;
@property(readonly, copy) NSDate *initialStartDate;

@property(copy, nonatomic) NSDate *endDate;
@property(copy, nonatomic) NSDate *startDate;

@property(nonatomic, getter=isAllDay) BOOL allDay;
@property(readonly, nonatomic) EKEventStore *eventStore;
@end

@interface EKReminder : EKCalendarItem
+ (id)reminderWithEventStore:(id)arg1;
@property(copy, nonatomic) NSDateComponents *dueDateComponents;
@end

@interface EKReminderViewController : UIViewController
@property(retain, nonatomic) EKEventStore *eventStore;
@property(retain, nonatomic) EKReminder *reminder;
@end

@interface EKEventViewController : UIViewController
@property(nonatomic) BOOL allowsEditing;
@property(retain, nonatomic) EKEvent *event;
@end

@protocol EKEventEditViewDelegate <NSObject>
@end

@interface EKEventEditViewController : UINavigationController
@property(retain, nonatomic) EKEventStore *eventStore;
@property(retain, nonatomic) EKEvent *event;
@property(assign, nonatomic) id <EKEventEditViewDelegate> editViewDelegate;
@end


///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//
@interface myRootViewController: UIViewController
{
}
@end


@interface EventCreatorListener : NSObject <LAListener, EKEventEditViewDelegate>
@property(copy, nonatomic) UIWindow *window;
@end
