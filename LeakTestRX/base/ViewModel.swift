//
//  ViewModel.swift
//  LeakTestRX
//
//  Created by Mohamed Alouane on 5/22/20.
//  Copyright © 2020 malouane. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum EmptyStates: Int {
    case empty, error, auth
}

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

class ViewModel: NSObject {
    let provider: API

    var page = 1

    let loading = ActivityIndicator()
    let headerLoading = ActivityIndicator()
    let footerLoading = ActivityIndicator()

    var error = ErrorTracker()
    var showSuccess = PublishSubject<Bool>()
    
    var state = EmptyStates.error

    init(provider: API) {
        self.provider = provider
        super.init()

        error.asDriver().drive(onNext: {[weak self] (error) in
            self?.state = .error
            print("ViewModel : \(error.localizedDescription)")
        }).disposed(by: rx.disposeBag)
         
    }

    deinit {
        print("\(type(of: self)): Deinited")
    }
} 
