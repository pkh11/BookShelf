//
//  MemoViewController.swift
//  BookShelf
//
//  Created by 박균호 on 2021/03/11.
//

import UIKit

class MemoViewController: UIViewController {

    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    let searchManager = SearchManager.sharedInstance
    let placeholderMessage = "메모를 입력해주세요."
    var isbn13: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memoTextView.delegate = self
        
        keyboardNotification()
        loadMemo()
    }
    
    func keyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func loadMemo() {
        if searchManager.memo.isEmpty {
            setPlaceholder()
        } else {
            memoTextView.text = searchManager.memo
        }
    }
    
    func setPlaceholder() {
        memoTextView.text = placeholderMessage
        memoTextView.textColor = .lightGray
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.size.height
            
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            memoTextView.contentInset = contentInset
            memoTextView.scrollIndicatorInsets = contentInset
            
            UIView.animate(withDuration: 0.4) {
                var height: CGFloat = 0
                if #available(iOS 13.0, *) {
                    height = 25
                 } else {
                    height = -5
                }
                
                self.saveButton.transform = CGAffineTransform(translationX: 0, y:   -keyboardHeight+height)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        memoTextView.contentInset = UIEdgeInsets.zero
        memoTextView.scrollIndicatorInsets = UIEdgeInsets.zero
        
        UIView.animate(withDuration: 0.4) {
            self.saveButton.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    @IBAction func saveMemo(_ sender: Any) {
        if let text = memoTextView.text, !text.isEmpty {
            searchManager.setMemo(text, isbn13) { result in
                if result {
                    let alertAction = UIAlertController(title: "저장완료", message: nil, preferredStyle: .alert)
                    let saveAction = UIAlertAction(title: "확인", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    alertAction.addAction(saveAction)
                    
                    self.present(alertAction, animated: true, completion: nil)
                }
            }
        }
    }
}

extension MemoViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView)
        if textView.text.isEmpty {
            setPlaceholder()
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor.gray
        } else {
            memoTextView.textColor = .black
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor.systemBlue
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let currentText: String = textView.text
        
        if currentText.elementsEqual(placeholderMessage) {
            textView.text = nil
        }

        return true
    }
    
}
