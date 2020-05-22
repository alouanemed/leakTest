import Foundation
import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView
import KafkaRefresh
import SnapKit
import NSObject_Rx

class ViewController: UIViewController, NVActivityIndicatorViewable {
     var inset: CGFloat {
            return 10
        }
    
    let isLoading = BehaviorRelay(value: false)
    let activityIndicator = NVActivityIndicatorView(frame: CGRect())
    
    var automaticallyAdjustsLeftBarButtonItem = true
    
    var navigationTitle = "" {
        didSet {
            navigationItem.title = navigationTitle
        }
    }
    
    let emptyDataSetButtonTap = PublishSubject<Void>()
    
    lazy var contentView: UIView = {
        let view = UIView()
        self.view.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let subviews: [UIView] = []
        let view = UIStackView(arrangedSubviews: subviews)
        self.contentView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return view
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
        makeUI()
        bindViewModel()
           
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         
        updateUI()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    deinit {
        print("\(type(of: self)): Deinited")
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("\(type(of: self)): Received Memory Warning")
    }
    
    func makeUI() {
        
        themeService.rx
            .bind({ $0.backgroundColor }, to: view.rx.backgroundColor)
            .disposed(by: rx.disposeBag)
        updateUI()
    }
    
    func bindViewModel() {
        
    }
    
    func updateUI() {
        
    }
     
    func didBecomeActive() {
        self.updateUI()
    }
       
}
extension Reactive where Base: KafkaRefreshControl {

    public var isAnimating: Binder<Bool> {
        return Binder(self.base) { refreshControl, active in
            if active {
                refreshControl.beginRefreshing()
            } else {
                refreshControl.endRefreshing()
            }
        }
    }
}

//
//extension ViewController: DZNEmptyDataSetSource {
//
//    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//
//        let font = Configs.Font.regular(size: 14)
//        let textColor = UIColor.textGray()
//        let attributes = NSMutableDictionary()
//
//        attributes.setObject(textColor, forKey: NSAttributedString.Key.foregroundColor as NSCopying)
//        attributes.setObject(font, forKey: NSAttributedString.Key.font as NSCopying)
//
//        return NSAttributedString.init(string: emptyDataSetTitle, attributes: attributes  as? [NSAttributedString.Key : Any])
//    }
//
//    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//        return emptyDataSetImage
//    }
//
//    //    func imageTintColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
//    //        return emptyDataSetImageTintColor.value
//    //    }
//
//    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
//        return .clear
//    }
//
//    //    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
//    //        return -60
//    //    }
//
//    func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation? {
//        let animation = CABasicAnimation.init(keyPath: "transform")
//        animation.fromValue = NSValue.init(caTransform3D: CATransform3DIdentity)
//        animation.toValue = NSValue.init(caTransform3D: CATransform3DMakeRotation(.pi/2, 0.0, 0.0, 1.0))
//        animation.duration = 0.25
//        animation.isCumulative = true
//        animation.repeatCount = MAXFLOAT
//
//        return animation
//    }
//
//    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
//
//        var attributes: [NSAttributedString.Key: Any] = [:]
//        attributes[NSAttributedString.Key.underlineStyle] = emptyDataSetButton.count
//        attributes[NSAttributedString.Key.font] = Configs.Font.bold(size: 12)
//        attributes[NSAttributedString.Key.foregroundColor] = UIColor.primary()
//        return NSAttributedString.init(string: emptyDataSetButton, attributes: attributes)
//    }
//}
//
//extension ViewController: DZNEmptyDataSetDelegate {
//
//    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
//        return !isLoading.value
//    }
//
//    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
//        return true
//    }
//
//    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
//        return true
//    }
//
//    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
//        emptyDataSetButtonTap.onNext(())
//    }
//}
  
