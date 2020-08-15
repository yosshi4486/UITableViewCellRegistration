import UIKit

extension UITableView {
    
    /// A registration for the table view's cells
    ///
    /// Use a cell registration to register cells with your table view and configure each cell for
    /// display. Yout create a cell registration with your cell type and data item type ad the registration's
    /// generic parameters, passing in a registration handler to configure the cell. In the registration
    /// handler, you specify how to configure the the content and appearance of that type of cell.
    ///
    /// The following example creates a cell registration for cells of type `UITableViewCell`.
    ///
    ///     let cellRegistration = UITableView.CellRegistration<UITableViewCell, String> { cell, indexPath, text in
    ///         cell.textLabel?.text = "\(text):\(indexPath.row)"
    ///     }
    ///
    /// After you create a cell registration, you pass it in to `dequeueConfiguredReusableCell(using:for:item:),
    /// which you call from your data source's cell provider.`
    ///
    ///     dataSource = UITableViewDiffableDataSource<Section, String>(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
    ///         return tableView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
    ///     })
    ///
    /// You don't need to call `register(_:forCellWithReuseIdentifier:)` or `register(_:forCellWeithReuseIdentifier:)`.
    /// The registration occurs automatically when you pass the cell registration to `dequeueConfiguredReusableCell(using:for:item:)`.
    public struct CellRegistration<Cell, Item> where Cell : UITableViewCell {
        public typealias Handler = (Cell, IndexPath, Item) -> Void
        
        fileprivate var handler: Handler
        
        public init(handler: @escaping UITableView.CellRegistration<Cell, Item>.Handler) {
            self.handler = handler
        }
        
    }
    
    /// Dequeues a configured reusable cell object.
    ///
    /// - Parameters:
    ///   - registration: The cell registration for configuring the cell object. See UITableView.CellRegistration described above.
    ///   - indexPath: The index path that specified the location of the cell in the collection view.
    ///   - item: The item that provides data for the cell.
    /// - Returns: A configured reusable cell object.
    ///
    /// - Attention: In the source implementation of `UICollectionView.dequeueConfiguredReusableCell(using:for:item:)`, the type of item is optional.
    /// but I can't understand the reason to do so, therefore I adopt non-optional type to the item.
    public func dequeueConfiguredReusableCell<Cell, Item>(using registration: UITableView.CellRegistration<Cell, Item>, for indexPath: IndexPath, item: Item) -> Cell where Cell : UITableViewCell {
        
        // Register the cell class and identifier to table view with its Metatype.
        let identifier = String(describing: type(of: Cell.self))
        self.register(Cell.self, forCellReuseIdentifier: identifier)
        
        let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Cell
        registration.handler(cell, indexPath, item)
        return cell
    }
    
}

