# UITableViewCellRegistration

## Instration
Install this package(https://github.com/yosshi4486/UITableViewCellRegistration) via SPM.

## Usege
### 1. Cell registration

```swift
let cellRegistration = UITableView.CellRegistration<UITableViewCell, String> { cell, indexPath, text in
    cell.textLabel?.text = "\(text):\(indexPath.row)"
}
```

### 2. Pass it into a dequeue method

```swift
dataSource = UITableViewDiffableDataSource<Section, String>(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
    return tableView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
})
```

### More details
Please open and see playground file which located at [here](https://github.com/yosshi4486/UITableViewCellRegistration/blob/main/MyPlayground.playground/Contents.swift)!

## Contribution
We are wating your contribution!😍
