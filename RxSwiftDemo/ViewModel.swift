//
//  ViewModel.swift
//  RxSwiftDemo
//
//  Created by 郭景豪 on 2020/6/15.
//  Copyright © 2020 Tank. All rights reserved.
//

import UIKit
import RxSwift

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

class ViewModel: NSObject {
    
    // 输出
    let usernameValid: Observable<Bool>
    let passwordValid: Observable<Bool>
    let everythingValid: Observable<Bool>
    
    // 输入 -> 输出
    init(username: Observable<String>,
         password: Observable<String>) {
        
        usernameValid = username
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1)
        
        passwordValid = password
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)
        
        everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
        
    }
    
    
}
