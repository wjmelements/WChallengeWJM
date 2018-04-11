#import "UserCell.h"


@implementation UserCell {

}

- (void)setData:(NSDictionary *)data {
    NSLog(@"%@", data);
    // TODO
    self.textLabel.text = data[@"display_name"];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    // TODO
}

@end
