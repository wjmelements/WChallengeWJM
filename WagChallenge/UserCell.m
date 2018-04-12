#import "UserCell.h"
#import "StackExchange.h"

static CGFloat kLabelPadding = 7.0f;

@implementation UserCell {
    NSString *_imageHash;
    UIActivityIndicatorView *_loadingView;
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
    CGFloat width = CGRectGetWidth(bounds);
    CGRect leftFrame = CGRectMake(0, 0, height, height);
    if (_loadingView) {
        _loadingView.frame = leftFrame;
    }
    self.imageView.frame = leftFrame;
    CGFloat labelLeft = height + kLabelPadding;
    self.textLabel.frame = CGRectMake(labelLeft, 0, width - labelLeft, height);
}

- (void)loadImage:(NSString *)remoteURL hash:(NSString *)hash {
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cachedFile = [cacheDir stringByAppendingPathComponent:hash];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cachedFile]) {
        NSLog(@"Cached %@", remoteURL);
        UIImage *image = [UIImage imageWithContentsOfFile:cachedFile];
        self.imageView.image = image;
    } else {
        [self showLoadingView];
        dispatch_async(networkQueue, ^{
            NSLog(@"Fetching %@", remoteURL);
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:remoteURL]];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([hash isEqualToString:self->_imageHash]) {
                    [self hideLoadingView];
                    self.imageView.image = image;
                    //[self layoutSubviews];
                } else {
                    NSLog(@"Hash has changed:%@ -> %@", hash, self->_imageHash);
                }
            });
            [data writeToFile:cachedFile atomically:NO];
        });
    }
}

- (void)setData:(NSDictionary *)data {
    self.textLabel.text = data[@"display_name"];
    NSString *remoteURL = data[@"profile_image"];
    // hash is always a legal filename
    _imageHash = [NSString stringWithFormat:@"%lu", remoteURL.hash];
    [self loadImage:remoteURL hash:_imageHash];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _imageHash = nil;
}

@end
