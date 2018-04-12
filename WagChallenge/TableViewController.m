#import "TableViewController.h"

#import "StackExchange.h"
#import "UserCell.h"

static NSString *const kUserCellReuseIdentifier = @"user";

@interface TableViewController () <UITableViewDataSource, StackExchangeDelegate>
@end

@implementation TableViewController {
    UITableView *_tableView;
    NSMutableArray *_items;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return self;
    }
    fetchStackExchange(self, 1);
    _items = [NSMutableArray array];
    return self;
}

- (void)viewDidLoad {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    [_tableView
        registerClass:[UserCell class]
        forCellReuseIdentifier:kUserCellReuseIdentifier 
    ];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;
    NSDictionary *item = _items[row];
    UserCell *cell = [_tableView dequeueReusableCellWithIdentifier:kUserCellReuseIdentifier];
    if (!cell) {
        cell = [[UserCell alloc]
            initWithStyle:UITableViewCellStyleDefault
            reuseIdentifier:kUserCellReuseIdentifier
        ];
    }
    [cell setData:item];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

#pragma mark - StackExchangeDelegate

- (void)onStackExchangeResult:(NSArray *)results page:(NSUInteger)page {
    [_items addObjectsFromArray:results];
    [_tableView reloadData];// TODO optimize
    //fetchStackExchange(self, page+1);
}

@end
