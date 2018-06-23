//
//  ViewModel.swift
//  RxSwiftMVVM
//
//  Created by Dalton Claybrook on 10/6/17.
//  Copyright © 2017 Dalton Claybrook. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

class ViewModel {
    
    // MARK: Public Properties
    
    var emailStringObservable: Observable<String> {
        return emails
            .asObservable()
            .map { emails -> String in
                return emails.joined(separator: "\n")
        }
    }
    var isLoadingObservable: Observable<Bool> {
        return isLoading.asObservable()
    }
    var tapObserver: AnyObserver<Void> {
        return tapSubject.asObserver()
    }
    
    // MARK: Private Properties
    
    private let emails = Variable([String]())
    private let isLoading = Variable(false)
    private let tapSubject = PublishSubject<Void>()
    private let apiProvider = MoyaProvider<API>()
    private let disposeBag = DisposeBag()
    
    init() {
        self.observeTap()
    }
    
    // MARK: Private
    
    private func observeTap() {
        let apiProvider = self.apiProvider
        let isLoading = self.isLoading
        let emails = self.emails
        
        tapSubject
            .asObservable()
            .do(onNext: { _ in isLoading.value = true })
            .do(onNext: { _ in emails.value = [] })
            .flatMap { _ in
                return apiProvider.rx.request(.posts)
            }
            .filterSuccessfulStatusCodes()
            .map([Post].self)
            .flatMap {posts -> Single<Response> in
                let postId = posts[0].id
                return apiProvider.rx.request(.comments(postId: postId))
            }
            .filterSuccessfulStatusCodes()
            .map([Comment].self)
            .map { comments -> [String] in
                return comments.map { $0.email }
            }
            .catchErrorJustReturn([])
            .do(onNext: { _ in isLoading.value = false })
            .do(onError: { e in
                print(e.localizedDescription)
            })
            .bind(to: self.emails)
            .disposed(by: self.disposeBag)
    }
}
