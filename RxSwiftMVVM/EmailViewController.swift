//
//  ViewController.swift
//  RxSwiftMVVM
//
//  Created by Sha on 6/23/18.
//

import RxCocoa
import RxSwift
import UIKit

class EmailViewController: UIViewController {
    
    @IBOutlet private var lbl_emails: UILabel!
    @IBOutlet private var btn_emails: UIButton!
    @IBOutlet private var aiv: UIActivityIndicatorView!
    
    let disposeBag = DisposeBag()
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getComments()
        loading()
        bindComments()
    }
    
    // MARK: Private
    
    private func getComments() {
        self.btn_emails
            .rx
            .tap
            .asObservable()
            .bind(to: self.viewModel.tapObserver)
            .disposed(by: disposeBag)
    }
    
    private func loading() {
        self.viewModel
            .isLoadingObservable
            .bind(to: self.aiv.rx.isAnimating)
            .disposed(by: self.disposeBag)
    }
    
    private func bindComments() {
        self.viewModel
            .emailStringObservable
            .bind(to: self.lbl_emails.rx.text)
            .disposed(by: disposeBag)
    }
}
