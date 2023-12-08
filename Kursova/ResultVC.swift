import UIKit

class ResultVC: UIViewController {
    var lemmatizedWords: [String]?
    var stemmedWords: [String]?
    var tokenizedWords: [String]?
    var selectedWords: [String]?
    
    @IBOutlet weak var serviceChoice: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "TextTableViewCell")
        selectedWords = lemmatizedWords
    }
    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedWords = lemmatizedWords
            tableView.reloadData()
        case 1:
            selectedWords = stemmedWords
            tableView.reloadData()
        default:
            break
        }
        
    }
    
}

extension ResultVC: UITableViewDelegate {
    
}

extension ResultVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tokenizedWords?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as? TextTableViewCell else { return UITableViewCell()}
        guard let tokenizedWords = tokenizedWords, let selectedWords = selectedWords else { return UITableViewCell() }
        cell.tokenized.text = tokenizedWords[indexPath.row]
        cell.processed.text = selectedWords[indexPath.row]
        
        return cell
    }
    
    
}

