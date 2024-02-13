import UIKit
import Foundation
import NaturalLanguage
import CoreData

class EnterWordsVC: UIViewController {

    @IBOutlet weak var words: UITextView!
    @IBOutlet weak var startAnalysisButton: UIButton!
    @IBOutlet weak var pickFileButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    lazy var toolbar = UIToolbar()
    lazy var flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    lazy var doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
    
    var openHistory: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        words.delegate = self
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        toolbar.sizeToFit()
        toolbar.setItems([flexible, doneButton], animated: false)
        words.inputAccessoryView = toolbar
        configureView()
    }
    
    private func configureView() {
        words.layer.cornerRadius = 20
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ResultVC {
            if openHistory {
                let wordsData: [Word]
                do {
                    wordsData = try context.fetch(Word.fetchRequest())
                    vc.tokenizedWords = wordsData.map{ $0.content ?? "" }
                    vc.lemmatizedWords = wordsData.map{ $0.lem ?? ""}
                    vc.stemmedWords = wordsData.map{ $0.stem ?? ""}
                    vc.title = "History"
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
            } else {
                if let text = words.text {
                    let tokenized = Words(text: text)
                    let service = Service()
                    vc.tokenizedWords = tokenized.words
                    vc.lemmatizedWords = service.processWords(tokenized.words).lemmatized
                    vc.stemmedWords = service.processWords(tokenized.words).stemed
                    vc.title = "Result"
                }
            }
        }
    }
    
    @IBAction func uploadFile(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text"], in: .import)
                documentPicker.delegate = self
                documentPicker.allowsMultipleSelection = false
                present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func onStartButtonTouched(_ sender: Any) {
        performSegue(withIdentifier: "toResultVC", sender: self)
    }
    
    @objc func doneButtonTapped() {
        words.resignFirstResponder()
    }
    
    
    @IBAction func openHistoryButtonClicked(_ sender: Any) {
        openHistory = true
        performSegue(withIdentifier: "toResultVC", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func isUrkainian(_ text: String) -> Bool {
        if NSLinguisticTagger.dominantLanguage(for: text) == "uk" || NSLinguisticTagger.dominantLanguage(for: text) == "ru" {
            return true
        } else {
            let alert = UIAlertController(title: "Некоректні дані", message: "Введіть дані українською", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Добре", style: UIAlertAction.Style.default, handler: { _ in
                self.words.text = ""
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
    }
}

extension EnterWordsVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != nil, !textView.text.isEmpty, isUrkainian(textView.text) {
            startAnalysisButton.isEnabled = true
        } else {
            startAnalysisButton.isEnabled = false
        }
    }
    
}
extension EnterWordsVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            return
        }
        
        do {
            let text = try String(contentsOf: selectedFileURL)
            print("Text content of the selected file: \(text)")
            if !text.isEmpty, isUrkainian(text) {
                words.text = text
                startAnalysisButton.isEnabled = true
            }
        } catch {
            print("Error reading file: \(error)")
        }
    }
}

