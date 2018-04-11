@import UIKit;

@protocol StackExchangeDelegate
- (void)onStackExchangeResult:(NSArray *)result page:(NSUInteger)page;
@end

void fetchStackExchange(__weak id<StackExchangeDelegate> delegate, NSUInteger page);
