import UIKit

// Protocol to notify font selection
protocol FontSelectorDelegate: AnyObject {
    func didSelectFont(_ font: UIFont)
}

class FontSelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Sample data: an array of font names
    var systemFonts: [String] = []
    
    var fontObjects: [UIFont] = []

    // UITableView to display the list
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // Delegate to notify font selection
    weak var delegate: FontSelectorDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        systemFonts = UIFont.familyNames.flatMap { UIFont.fontNames(forFamilyName: $0) }
        
        fontObjects = systemFonts.map { UIFont(name: $0, size: 17.0) ?? UIFont.systemFont(ofSize: 17.0) }

        // Set up the table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        // Add the table view to the view hierarchy
        view.addSubview(tableView)

        // Set up constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fontObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = systemFonts[indexPath.row]
        cell.textLabel?.font = fontObjects[indexPath.row]

        // Set a checkmark accessory for the selected row
        cell.accessoryType = (tableView.indexPathForSelectedRow == indexPath) ? .checkmark : .none

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the previously selected row, if any
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }

        // Toggle the checkmark accessory for the selected row
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = (cell.accessoryType == .checkmark) ? .none : .checkmark
        }

        // Notify the delegate that a font was selected
//        let selectedFont = fontObjects[indexPath.row]
        delegate?.didSelectFont(UIFont(name: systemFonts[indexPath.row], size: 55.0) ?? UIFont.systemFont(ofSize: 17))
    }
    
    @objc private func doneButtonTapped() {
        // Call the delegate method to notify that the font selection is done
        dismiss(animated: true)
    }
}
