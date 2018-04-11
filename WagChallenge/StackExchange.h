@import UIKit;

@protocol StackExchangeDelegate
- (void)onStackExchangeResult:(NSDictionary *)result;
@end

void fetchStackExchange(id<StackExchangeDelegate> delegate);
