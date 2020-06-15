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

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidOutlet: UILabel!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidOutlet: UILabel!
    
    @IBOutlet weak var doSomethingOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameValidOutlet.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        
        let usernameValid = usernameOutlet.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1) //共享資源，並且只存最後一次的狀態
        
        usernameValid
            .bind(to: passwordOutlet.rx.isEnabled)//綁定UI變化
            .disposed(by: disposeBag)//自動釋放
        
        usernameValid
        .bind(to: usernameValidOutlet.rx.isHidden)
        .disposed(by: disposeBag)
        
        let passwordValid = passwordOutlet.rx.text.orEmpty
            .map{ $0.count >= minimalPasswordLength }
            .share(replay: 1)
        
        passwordValid
        .bind(to: passwordValidOutlet.rx.isHidden)
        .disposed(by: disposeBag)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
        .share(replay: 1)
        
        everythingValid
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

