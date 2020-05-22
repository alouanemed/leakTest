import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources

//private let titleIdentifier = R.reuseIdentifier.modelTitleViewCell.identifier
private let trendingIdentifier = R.reuseIdentifier.modelProductsCell.identifier
//private let suppliersIdentifier = R.reuseIdentifier.modelSuppliersCell.identifier


class HomeViewController: TableViewController, ProductItemsDelegate {
    func didTapOnItem(p: ProductEntity) {
        
    }
    
    var viewModel: HomeViewModel!
    
    override func makeUI() {
        super.makeUI()
                 
        tableView.rowHeight = UITableView.automaticDimension
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
        tableView.separatorStyle = .none
        
//        tableView.register(R.nib.modelTitleViewCell)
        tableView.register(R.nib.modelProductsCell)
//        tableView.register(R.nib.modelSuppliersCell)
//
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        setupViews()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let networkProvider =  Networking.newDefaultNetworking()
        
        let restApi = RestApi(provider: networkProvider) 
        
        viewModel = HomeViewModel(provider: restApi)
        
        let refresh = Observable.of(Observable.just(()), emptyDataSetButtonTap).merge()
        
        let input = HomeViewModel.Input(
            headerRefresh: refresh, selectedModel: tableView.rx.modelSelected(HomeSectionItem.self).asDriver())
        
        let output = viewModel.transform(input: input)
        
        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        
        viewModel.loading.asDriver().drive(onNext: { [weak self] (isLoading) in
            guard let self = self else { return }
            
            if isLoading {
                self.activityIndicator.startAnimating()
            }else{
                self.activityIndicator.stopAnimating()
            }
        }).disposed(by: rx.disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<HomeSection>(configureCell:  { [weak self] dataSource, tableView, indexPath, item in

            guard let self = self else { return UITableViewCell() }

            switch item {
            case .homeTrendingItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: trendingIdentifier, for: indexPath) as? ModelProductsCell)!
                cell.delegate = self
                cell.bind(to: viewModel)
                return cell
//            case .homeSuppliersItem(let viewModel):
//                let cell = (tableView.dequeueReusableCell(withIdentifier: suppliersIdentifier, for: indexPath) as? ModelSuppliersCell)!
//                cell.delegate = self
//                cell.bind(to: viewModel)
                return cell
            }
        }, titleForHeaderInSection: { dataSource, index in
            let section = dataSource[index]
            return section.title
        })
        
        output.items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        output.selectedModel.drive(onNext: { [weak self] (item) in
            guard let self = self else { return }
            
            self.deselectSelectedRow()
        }).disposed(by: rx.disposeBag)
        
        viewModel.error.asDriver().drive(onNext: { (error) in
            print("error")
        }).disposed(by: rx.disposeBag)
        
        output.showSuccess.subscribe(onNext: { (isSuccess) in
                        print("showSuccess")
        }).disposed(by: rx.disposeBag)
    }
     
}
 
