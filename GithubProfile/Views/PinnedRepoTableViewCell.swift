import Foundation
import UIKit
import SnapKit
import Kingfisher

class PinnedRepoTableViewCell: UITableViewCell {
    
    lazy var userNameLable: UILabel = UILabel()
    lazy var repositoryNameLable: UILabel = UILabel()
    lazy var repositoryDescriptionLable: UILabel = UILabel()
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        
        userNameLable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        repositoryNameLable.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        repositoryDescriptionLable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        starCountLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        languageLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.backgroundColor = UIColor().colorFromHexString(background_color)
        addSubview(mainContainerView)
        mainContainerView.cornerRadius = 10
        mainContainerView.borderWidth = 0.5
        mainContainerView.borderColor = UIColor.lightGray
        mainContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(16)
            make.right.equalTo(self.snp.right).offset(-16)
            make.top.equalTo(self.snp.top).offset(16)
            make.bottom.equalTo(self.snp.bottom)
        }
                
        self.contentView.addSubview(profileImageView)
        profileImageView.setRound(imageWidth: 32)
        profileImageView.snp.makeConstraints { (make) in
            make.width.equalTo(32)
            make.height.equalTo(32)
            make.top.equalTo(mainContainerView.snp.top).offset(16)
            make.leading.equalTo(mainContainerView.snp.leading).offset(16)
        }
        
        self.contentView.addSubview(userNameLable)
        userNameLable.snp.makeConstraints { (make) in
            make.top.equalTo(mainContainerView.snp.top).offset(20)
            make.leading.equalTo(profileImageView.snp.trailing).offset(7)
        }
        
        self.contentView.addSubview(repositoryNameLable)
        repositoryNameLable.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(5)
            make.leading.equalTo(mainContainerView.snp.leading).offset(16)
        }
        
        self.contentView.addSubview(repositoryDescriptionLable)
        repositoryDescriptionLable.snp.makeConstraints { (make) in
            make.top.equalTo(repositoryNameLable.snp.bottom).offset(5)
            make.leading.equalTo(mainContainerView.snp.leading).offset(16)
            make.trailing.equalTo(mainContainerView.snp.trailing).offset(-16)
        }
        
        self.contentView.addSubview(starImageView)
        starImageView.snp.makeConstraints { (make) in
            make.width.equalTo(12)
            make.height.equalTo(12)
            make.top.equalTo(repositoryDescriptionLable.snp.bottom).offset(20)
            make.leading.equalTo(mainContainerView.snp.leading).offset(16)
        }
        
        self.contentView.addSubview(starCountLabel)
        starCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(repositoryDescriptionLable.snp.bottom).offset(16)
            make.leading.equalTo(starImageView.snp.trailing).offset(2)
        }
        
        self.contentView.addSubview(roundImageView)
        roundImageView.snp.makeConstraints { (make) in
            make.width.equalTo(12)
            make.height.equalTo(12)
            make.top.equalTo(repositoryDescriptionLable.snp.bottom).offset(19)
            make.leading.equalTo(starCountLabel.snp.trailing).offset(24)
        }
        
        self.contentView.addSubview(languageLabel)
        languageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(repositoryDescriptionLable.snp.bottom).offset(16)
            make.leading.equalTo(roundImageView.snp.trailing).offset(2)
        }
    }
}

extension PinnedRepoTableViewCell: RepositoryView {

    func display(userName: String) {
        userNameLable.text = userName
    }
    
    func display(repositoryName: String) {
        repositoryNameLable.text = repositoryName
    }
    
    func display(repositoryDescription: String) {
        repositoryDescriptionLable.text = repositoryDescription
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
