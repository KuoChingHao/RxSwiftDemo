//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by 郭景豪 on 2020/6/12.
//  Copyright © 2020 Tank. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidOutlet: UILabel!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidOutlet: UILabel!
    
    @IBOutlet weak var doSomethingOutlet: UIButton!
    
    private var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameValidOutlet.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        
        viewModel = ViewModel(username: usernameOutlet.rx.text.orEmpty.asObservable(), password: passwordOutlet.rx.text.orEmpty.asObservable())
        
        
        viewModel.usernameValid
            .bind(to: passwordOutlet.rx.isEnabled)//綁定UI變化
            .disposed(by: disposeBag)//自動釋放
        
        viewModel.usernameValid
        .bind(to: usernameValidOutlet.rx.isHidden)
        .disposed(by: disposeBag)
        
        
        
        viewModel.everythingValid
            .bind(to: doSomethingOutlet.rx.isEnabled)
            .disposed(by: disposeBag)

        doSomethingOutlet.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.showAlert() })
            .disposed(by: disposeBag)

        
    }
    
    func showAlert() {
        let alertView = UIAlertView(
            title: "RxExample",
            message: "This is wonderful",
            delegate: nil,
            cancelButtonTitle: "OK"
        )

        alertView.show()
    }
}

