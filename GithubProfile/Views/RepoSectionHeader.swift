import Foundation
import UIKit
import SnapKit


protocol RepoSectionHeaderDelegate {
    func onPressViewAll(repositoryType: eRepositoryType)
}

class RepoSectionHeader: UIView {
        
    lazy var headerLabel =  lableWithText(text: "", andFont: UIFont.systemFont(ofSize: 24, weight: .bold))
    lazy var viewAllbutton = UIButton()
    let viewAllBtnAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.underlineStyle: 1,
                                                      NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                                                      NSAttributedString.Key.foregroundColor: UIColor.black]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView(){
        self.backgroundColor = UIColor().colorFromHexString(background_color)
        self.snp.makeConstraints { (constaint) in
            constaint.height.equalTo(32)
        }
        self.addSubview(headerLabel)

        headerLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(16)
         }
        
        let attributedString = NSMutableAttributedString(string: "View all", attributes: viewAllBtnAttributes)
        viewAllbutton.setAttributedTitle(NSAttributedString(attributedString: attributedString), for: .normal)
        viewAllbutton.setTitleColor(UIColor.black, for: .normal)
        viewAllbutton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewAllbutton)
        
        viewAllbutton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self)
                            make.trailing.equalTo(self.snp.trailing).offset(-16)
                            make.height.equalTo(24)
         }
    }
}

extension RepoSectionHeader: TableSctionHeaderView {
    func setAction(forViewAll action:@escaping () -> ()) { 
        self.viewAllbutton.addAction(action)
    }
    
    func setHeder(header: String) {
        self.headerLabel.text = header
    }
    
    
    
}
