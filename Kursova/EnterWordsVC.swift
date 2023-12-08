import UIKit

class EnterWordsVC: UIViewController {

    @IBOutlet weak var words: UITextView!
    @IBOutlet weak var startAnalysisButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        words.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ResultVC {
            if let text = words.text {
                let tokenized = Words(text: text)
                let lemmatizer = Lemmatizer(words: tokenized.words)
                let stemmer = Stemmer(words: tokenized.words)
                vc.tokenizedWords = tokenized.words
                vc.lemmatizedWords = lemmatizer.processWords()
                vc.stemmedWords = stemmer.processWords()
            }
        }
    }
    
    
    @IBAction func onStartButtonTouched(_ sender: Any) {
        performSegue(withIdentifier: "toResultVC", sender: self)
    }
}

extension EnterWordsVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != nil, textView.text != "" {
            startAnalysisButton.isEnabled = true
        } else {
            startAnalysisButton.isEnabled = false
        }
    }
}

