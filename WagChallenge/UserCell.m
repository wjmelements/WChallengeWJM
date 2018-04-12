#import "UserCell.h"

#import "Color.h"
#import "StackExchange.h"

static CGFloat kLabelPadding = 7.0f;

@implementation UserCell {
    NSString *_imageHash;
    UIActivityIndicatorView *_loadingView;
    // badges
    UILabel *_bronze, *_silver, *_gold;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self ) {
        return self;
    }
    _bronze = [[UILabel alloc] initWithFrame:CGRectZero];
    _silver = [[UILabel alloc] initWithFrame:CGRectZero];
    _gold = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_bronze];
    [self addSubview:_silver];
    [self addSubview:_gold];
    _bronze.clipsToBounds = _silver.clipsToBounds = _gold.clipsToBounds = YES;
    _bronze.textAlignment = _silver.textAlignment = _gold.textAlignment = NSTextAlignmentCenter;
    _bronze.backgroundColor = [Color bronze];
    _silver.backgroundColor = [Color silver];
    _gold.backgroundColor = [Color gold];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

- (void)showLoadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc]
            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray
        ];
        [_loadingView startAnimating];
    }
    [self.contentView addSubview:_loadingView];
}

- (void)hideLoadingView {
    [_loadingView removeFromSuperview];
    [_loadingView stopAnimating];
    _loadingView = nil;
}

- (void)layoutSubviews {
    CGRect bounds = self.contentView.bounds;
    CGFloat height = CGRectGetHeight(bounds);
    _gold.layer.cornerRadius = _silver.layer.cornerRadius = _bronze.layer.cornerRadius = height / 2;
    _gold.font = _silver.font = _bronze.font = [_gold.font fontWithSize:height / 4];
    CGFloat width = CGRectGetWidth(bounds);
    CGRect leftFrame = CGRectMake(0, 0, height, height);
    if (_loadingView) {
        _loadingView.frame = leftFrame;
    }
    self.imageView.frame = leftFrame;
    CGFloat labelLeft = height + kLabelPadding;
    CGFloat right = width;
    _bronze.frame = CGRectMake(right -= height, 0, height, height);
    _silver.frame = CGRectMake(right -= height, 0, height, height);
    _gold.frame = CGRectMake(right -= height, 0, height, height);
    self.textLabel.frame = CGRectMake(labelLeft, 0, right - labelLeft, height);
}

- (void)imageDidLoad:(UIImage *)image hash:(NSString *)hash {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self->_imageHash isEqualToString:hash]) {
            [self hideLoadingView];
            self.imageView.image = image;
        } else {
            NSLog(@"Hash has changed:%@ -> %@", hash, self->_imageHash);
        }
    });
}

- (void)loadImage:(NSString *)remoteURL hash:(NSString *)hash {
    [self showLoadingView];
    dispatch_async(networkQueue, ^{
        NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *cachedFile = [cacheDir stringByAppendingPathComponent:hash];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:cachedFile]) {
            NSLog(@"Cached %@", remoteURL);
            UIImage *image = [UIImage imageWithContentsOfFile:cachedFile];
            [self imageDidLoad:image hash:hash];
        } else {
            NSLog(@"Fetching %@", remoteURL);
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:remoteURL]];
            UIImage *image = [UIImage imageWithData:data];
            [self imageDidLoad:image hash:hash];
            [data writeToFile:cachedFile atomically:NO];
        }
    });
}

- (void)setData:(NSDictionary *)data {
    self.textLabel.text = data[@"display_name"];
    NSString *remoteURL = data[@"profile_image"];
    NSDictionary *badgeCounts = data[@"badge_counts"];
    NSLog(@"%@", badgeCounts);
    _gold.text = [badgeCounts[@"gold"] stringValue];
    _silver.text = [badgeCounts[@"silver"] stringValue];
    _bronze.text = [badgeCounts[@"bronze"] stringValue];
    // hash is always a legal filename
    _imageHash = [NSString stringWithFormat:@"%lu", remoteURL.hash];
    [self loadImage:remoteURL hash:_imageHash];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _imageHash = nil;
}

@end
