#import "TableViewController.h"

#import "StackExchange.h"

@interface TableViewController () <UITableViewDataSource, StackExchangeDelegate>
@end

@implementation TableViewController {
    UITableView *_tableView;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return self;
    }
    fetchStackExchange(self);
    return self;
}

- (void)viewDidLoad {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.backgroundColor = UIColor.redColor;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
    return 0;
}

#pragma mark - StackExchangeDelegate

- (void)onStackExchangeResult:(NSDictionary *)result {
    NSLog(@"%@", result);
}

@end
