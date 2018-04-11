#import "StackExchange.h"

static dispatch_queue_t stackExchangeQueue = 0;

static inline void ensureQueue() {
    if (!stackExchangeQueue) {
        stackExchangeQueue = dispatch_queue_create("StackExchange", DISPATCH_QUEUE_CONCURRENT);
    }
}

void fetchStackExchange(id<StackExchangeDelegate> delegate) {
    ensureQueue();
    dispatch_async(stackExchangeQueue, ^{
        NSData *result = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://api.stackexchange.com/2.2/users?site=stackoverflow"]];       
        NSDictionary *parsedResult = [NSJSONSerialization
            JSONObjectWithData:result
            options:kNilOptions
            error:nil
        ];
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate onStackExchangeResult:parsedResult];
        });
    });
}
