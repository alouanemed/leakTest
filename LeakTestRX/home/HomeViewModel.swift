//
//  HomeViewModel.swift
//  RxTheme_Example
//
//  Created by Mohamed Alouane on 5/21/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift 
import RxCocoa
import RxSwift

class HomeViewModel: ViewModel, ViewModelType {
    struct Input {
        let headerRefresh: Observable<Void>
        let selectedModel: Driver<HomeSectionItem>
    }
    
    struct Output {
        let items: Observable<[HomeSection]>
        let selectedModel: Driver<HomeSectionItem>
        let showSuccess: PublishSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let items = input.headerRefresh.debug().flatMapLatest { [weak self] () -> Observable<[HomeSection]> in
            
            guard let self = self else { return Observable.just([]) }
            
            let productsVm = ModelProductsViewModel(provider: self.provider)
            self.error = productsVm.error
            productsVm.onFavorited.bind(to: self.showSuccess).disposed(by: self.rx.disposeBag)
            let products = [HomeSection.ItemModel(title: "", items: [HomeSectionItem.homeTrendingItem(viewModel: productsVm)])]
            
            let sectionItems =  products
            return Observable.just(sectionItems)
            
        }
        return Output(items: items,
                      selectedModel: input.selectedModel,
                      showSuccess: showSuccess)
    }
}

import Foundation
import Foundation
import RxDataSources

enum HomeSection {
    case ItemModel(title: String, items: [HomeSectionItem])
}

enum HomeSectionItem {
     case homeTrendingItem(viewModel: ModelProductsViewModel)
}

extension HomeSection: SectionModelType {
    typealias Item = HomeSectionItem
    
    var title: String {
        switch self {
        case .ItemModel(let title, _): return title
        }
    }
    
    var items: [HomeSectionItem] {
        switch  self {
        case .ItemModel(_, let items): return items.map {$0}
        }
    }
    
    init(original: HomeSection, items: [Item]) {
        switch original {
        case .ItemModel(let title, let items): self = .ItemModel(title: title, items: items)
        }
    }
}
