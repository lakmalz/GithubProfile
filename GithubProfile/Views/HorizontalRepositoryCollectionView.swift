import Foundation
import Foundation
import UIKit
import SnapKit
import Kingfisher

let kHorizontalRepositoryCollectionCellIdentifier = "HorizontalRepositoryCollectionView"

class HorizontalRepositoryCollectionView: UICollectionViewCell {
    
    lazy var userNameLable: UILabel = UILabel()
    lazy var repositoryNameLabel: UILabel = UILabel()
    lazy var repositoryDescriptionLabel: UILabel = UILabel()
    lazy var starCountLabel: UILabel = UILabel()
    lazy var languageLabel: UILabel = UILabel()

    lazy var mainContainerView = UIView()
    
    lazy var profileImageView: UIImageView = UIImageView()
    lazy var starImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "star")
        view.tintColor = .yellow
        return view
    }()
    lazy var roundImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "circle")
        view.tintColor = .orange
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        
        userNameLable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        repositoryNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        repositoryDescriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        starCountLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        languageLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.backgroundColor = UIColor().colorFromHexString(background_color)
        addSubview(mainContainerView)
        mainContainerView.cornerRadius = 10
        mainContainerView.borderWidth = 0.5
        mainContainerView.borderColor = UIColor.lightGray
        mainContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(layoutMarginsGuide.snp.left)
            make.right.equalTo(layoutMarginsGuide.snp.right)
            make.top.equalTo(layoutMarginsGuide.snp.top)
            make.bottom.equalTo(layoutMarginsGuide.snp.bottom)
        }
                
        self.addSubview(profileImageView)
        profileImageView.setRound(imageWidth: 32)
        profileImageView.snp.makeConstraints { (make) in
            make.width.equalTo(32)
            make.height.equalTo(32)
            make.top.equalTo(mainContainerView.snp.top).offset(16)
            make.leading.equalTo(mainContainerView.snp.leading).offset(16)
        }
        
        self.addSubview(userNameLable)
        userNameLable.snp.makeConstraints { (make) in
            make.top.equalTo(mainContainerView.snp.top).offset(20)
            make.leading.equalTo(profileImageView.snp.trailing).offset(7)
        }
        
        self.addSubview(repositoryNameLabel)
        repositoryNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(5)
            make.leading.equalTo(mainContainerView.snp.leading).offset(16)
        }
        
        self.addSubview(repositoryDescriptionLabel)
        repositoryDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(repositoryNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(mainContainerView.snp.leading).offset(16)
            make.trailing.equalTo(mainContainerView.snp.trailing).offset(-16)
        }
        
        self.addSubview(starImageView)
        starImageView.snp.makeConstraints { (make) in
            make.width.equalTo(12)
            make.height.equalTo(12)
            make.top.equalTo(repositoryDescriptionLabel.snp.bottom).offset(20)
            make.leading.equalTo(mainContainerView.snp.leading).offset(16)
        }
        
        self.addSubview(starCountLabel)
        starCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(repositoryDescriptionLabel.snp.bottom).offset(16)
            make.leading.equalTo(starImageView.snp.trailing).offset(2)
        }
        
        self.addSubview(roundImageView)
        roundImageView.snp.makeConstraints { (make) in
            make.width.equalTo(12)
            make.height.equalTo(12)
            make.top.equalTo(repositoryDescriptionLabel.snp.bottom).offset(19)
            make.leading.equalTo(starCountLabel.snp.trailing).offset(24)
        }
        
        self.addSubview(languageLabel)
        languageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(repositoryDescriptionLabel.snp.bottom).offset(16)
            make.leading.equalTo(roundImageView.snp.trailing).offset(2)
        }
    }
}

extension HorizontalRepositoryCollectionView: RepositoryView {

    func display(userName: String) {
        userNameLable.text = userName
    }
    
    func display(repositoryName: String) {
        repositoryNameLabel.text = repositoryName
    }
    
    func display(repositoryDescription: String) {
        repositoryDescriptionLabel.text = repositoryDescription
    }
    
    func display(starCount: String) {
        starCountLabel.text = starCount
    }
    
    func display(language: String) {
        languageLabel.text = language
    }
    
    func display(languageColor: String) {
        roundImageView.tintColor = UIColor().colorFromHexString(languageColor)
    }
    
    func display(profileUrl: String) {
        profileImageView.kf.setImage(with: URL.init(string: profileUrl))
    }
}
