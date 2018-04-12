@import UIKit;

extern dispatch_queue_t networkQueue;

@protocol StackExchangeDelegate
- (void)onStackExchangeResult:(NSArray *)result page:(NSUInteger)page;
@end

void fetchStackExchange(__weak id<StackExchangeDelegate> delegate, NSUInteger page);
