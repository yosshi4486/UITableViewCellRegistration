//: # Executable document of UITableViewCellRegistration

/*:
 A UITableViewCellRegistration is imspired by UICollectionView.CellRegistraion that is provied by Apple. The porpose of this library is providing declarative cell configuration syntax to UITableView and UITableViewCell.
 */

import UIKit
import UITableViewCellRegistration

/*:
 ## Here is the basic example of UITableViewCellRegistration using system-provided table view cell.
 */
class ViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var dataSource: UITableViewDiffableDataSource<Section, String>?
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureDataSource()
    }
    
    let items: [String] = [
        "Apple",
        "Banana",
        "Orange",
        "Melon",
        "Water Melon",
        "Cherry",
        "Grape",
        "Kiwi",
        "Mango",
        "Dorian"
    ]
    
    func configureDataSource() {
        
        // You can instanciate a table cell registration here.
        let cellRegistration = UITableView.CellRegistration<UITableViewCell, String> { cell, indexPath, text in
            cell.textLabel?.text = "\(text):\(indexPath.row)"
        }
        
        dataSource = UITableViewDiffableDataSource<Section, String>(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            
            // Then, pass it to `dequeueConfiguredReusableCell(using:for:item:)`.
            return tableView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, String>()
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems(items)
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }

}

//: `configureDataSource` is **core implementation of table dataSource**.
extension ViewController {
    
    func configureTableView() {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = .systemGroupedBackground
        self.tableView = tableView
    }
        
}

import PlaygroundSupport
PlaygroundPage.current.liveView = ViewController()

/*:
 ## Here is the advanced example of UITableViewCellRegistration using custom table view cell.
 */

final class CustomCellViewController : ViewController {
    
    class CustomCell : UITableViewCell {
        let label: UILabel = .init()
        
        let indexLabel: UILabel = {
            let view = UILabel()
            view.textColor = .lightGray
            return view
        }()
        
        let stackView: UIStackView
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            stackView = UIStackView(arrangedSubviews: [indexLabel, label])
            stackView.axis = .vertical
            
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            contentView.addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.top(equalTo: contentView.topAnchor)
            stackView.bottom(equalTo: contentView.bottomAnchor)
            stackView.leading(equalTo: contentView.leadingAnchor)
            stackView.trailing(equalTo: contentView.trailingAnchor)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    override func configureDataSource() {
        // You can instanciate a table cell registration here.
        let cellRegistration = UITableView.CellRegistration<CustomCell, String> { cell, indexPath, text in
            cell.label.text = text
            cell.indexLabel.text = indexPath.row.description
        }
        
        dataSource = UITableViewDiffableDataSource<Section, String>(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            
            // Then, pass it to `dequeueConfiguredReusableCell(using:for:item:)`.
            return tableView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, String>()
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems(items)
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
}

// MARK: - Helpers for Autolayout
extension UIView {
    
    func top(equalTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) {
        topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }
    
    func leading(equalTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) {
        leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }
    
    func trailing(equalTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) {
        trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }

    func bottom(equalTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) {
        bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }


}

PlaygroundPage.current.liveView = CustomCellViewController()
