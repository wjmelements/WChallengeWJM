#import "StackExchange.h"

static dispatch_queue_t stackExchangeQueue = 0;

static inline void ensureQueue() {
    if (!stackExchangeQueue) {
        stackExchangeQueue = dispatch_queue_create("StackExchange", DISPATCH_QUEUE_CONCURRENT);
    }
}

void fetchStackExchange(__weak id<StackExchangeDelegate> delegate, NSUInteger page) {
    ensureQueue();
    dispatch_async(stackExchangeQueue, ^{
        NSData *result = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.stackexchange.com/2.2/users?site=stackoverflow&page=%lu", page]]];       
        NSDictionary *parsedResult = [NSJSONSerialization
            JSONObjectWithData:result
            options:kNilOptions
            error:nil
        ];
        NSArray *items = parsedResult[@"items"];
        NSLog(@"%@", items);
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate onStackExchangeResult:items page:page];
        });
    });
}
