#import "headers.h"

@implementation myRootViewController
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)arg1
{
	return YES;
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleDefault; // UIStatusBarStyleLightContent
}
@end


@implementation EventCreatorListener
- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(id)action
{
	[UIView animateWithDuration:0.25
					 animations:^{
						 _window.alpha = 0;;
					 }
					 completion:^(BOOL finished){
						 [_window resignKeyWindow];
						 [_window release];
						 _window = nil;
					 }
	 ];
}

- (UIViewController *)topViewController
{
	return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
	if (rootViewController.presentedViewController == nil) {
		return rootViewController;
	}
	if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
		UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
		UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
		return [self topViewController:lastViewController];
	}
	UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
	return [self topViewController:presentedViewController];
}

- (void)createEvent
{
	EKEventStore *store = [[[EKEventStore alloc] init] autorelease];
	if (store) {
		EKEvent *event = [EKEvent eventWithEventStore:store];
		[event setTitle:@""];


		EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:0];
		[event setAlarms:@[alarm]];
		[event setStartDate:[NSDate dateWithTimeInterval:86400 sinceDate:[NSDate date]]];
		[event setEndDate:[NSDate dateWithTimeInterval:3600 sinceDate:event.startDate]];

		EKEventEditViewController *eventViewController = [[[%c(EKEventEditViewController) alloc] init] autorelease];
		eventViewController.editViewDelegate = self;
		eventViewController.eventStore = store;
		eventViewController.event = event;
		if (_window) {
			[_window release];
		}
		CGRect frame = [[UIScreen mainScreen] bounds];
		frame.origin.y = [UIApplication sharedApplication].statusBarFrame.size.height;
		frame.size.height -= frame.origin.y;
		_window = [[UIWindow alloc] initWithFrame:frame];
		_window.screen = [UIScreen mainScreen];
		[_window setWindowLevel:UIWindowLevelStatusBar];
		[_window resizesToFullScreen];

		_window.alpha = 0;

		id root = [[[myRootViewController alloc] init] autorelease];
		[_window setRootViewController:root];
		[_window makeKeyAndVisible];
		[[_window rootViewController] presentViewController:eventViewController animated:NO completion:nil];

		[UIView animateWithDuration:0.25
						 animations:^{
							 _window.alpha = 1;
						 }
						 completion:nil
		 ];
	}
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
	[event setHandled:YES];
	[self performSelector:@selector(createEvent) withObject:nil afterDelay:0.1];
}

+ (void)load
{
	if ([LASharedActivator isRunningInsideSpringBoard])
	{
		[[LAActivator sharedInstance] registerListener:[self new] forName:@"net.tateu.eventcreator"];
	}
}
@end
