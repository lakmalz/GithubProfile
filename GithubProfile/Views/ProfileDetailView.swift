import Foundation
import UIKit
import SnapKit
import Kingfisher

class ProfileDetailView: UIView, ProfileInfoView {
    
    lazy var profileName: UILabel = UILabel()
    lazy var profileLoginName: UILabel = UILabel()
    lazy var emailLable: UILabel = UILabel()
    lazy var followersCountLable: UILabel = UILabel()
    lazy var followingCountLable: UILabel = UILabel()
    lazy var followersLabel: UILabel = UILabel()
    lazy var followingLabel: UILabel = UILabel()
    lazy var profileImage: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        profileImage.setRound(imageWidth: 88)
        self.addSubview(profileImage)
        
        profileImage.snp.makeConstraints { (constraint) in
            constraint.width.equalTo(88)
            constraint.height.equalTo(88)
            constraint.top.equalTo(self.snp.top)
            constraint.left.equalTo(self.snp.left)
        }
        
        profileName.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        self.addSubview(profileName)
        profileName.snp.makeConstraints { (constraint) in
            constraint.height.equalTo(40)
            constraint.centerY.equalTo(profileImage.snp.centerY).offset(-10)
            constraint.leading.equalTo(profileImage.snp.trailing).offset(8)
        }
        
        profileLoginName.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.addSubview(profileLoginName)
        profileLoginName.snp.makeConstraints { (constraint) in
            constraint.height.equalTo(24)
            constraint.leading.equalTo(profileName.snp.leading)
            constraint.top.equalTo(profileName.snp.bottom)
        }
        
        emailLable.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        self.addSubview(emailLable)
        emailLable.snp.makeConstraints { (constraint) in
            constraint.leading.equalTo(profileImage.snp.leading)
            constraint.height.equalTo(24)
            constraint.top.equalTo(profileImage.snp.bottom).offset(24)
        }
        
        followersCountLable.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        self.addSubview(followersCountLable)
        followersCountLable.snp.makeConstraints { (constraint) in
            constraint.leading.equalTo(emailLable.snp.leading)
            constraint.height.equalTo(24)
            constraint.top.equalTo(emailLable.snp.bottom).offset(16)
        }
        
        followersLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        followersLabel.text = "followers"
        followersLabel.isHidden = true
        self.addSubview(followersLabel)
        followersLabel.snp.makeConstraints { (constraint) in
            constraint.height.equalTo(24)
            constraint.leading.equalTo(followersCountLable.snp.trailing).offset(5)
            constraint.centerY.equalTo(followersCountLable.snp.centerY)
        }
        
        followingCountLable.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        self.addSubview(followingCountLable)
        followingCountLable.snp.makeConstraints { (constraint) in
            constraint.height.equalTo(24)
            constraint.leading.equalTo(followersLabel.snp.trailing)
            constraint.centerY.equalTo(followersLabel.snp.centerY)
        }
        
        followingLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        followingLabel.text = "following"
        followingLabel.isHidden = true
        self.addSubview(followingLabel)
        followingLabel.snp.makeConstraints { (constraint) in
            constraint.height.equalTo(24)
            constraint.leading.equalTo(followingCountLable.snp.trailing).offset(5)
            constraint.centerY.equalTo(followingCountLable.snp.centerY)
            constraint.bottom.equalTo(self.snp.bottomMargin)
        }
    }
}

extension ProfileDetailView {
    func display(name: String) {
        profileName.text = name
    }
    func display(loginName: String) {
        profileLoginName.text = loginName
    }
    func display(email: String) {
        emailLable.text = email
    }
    func display(followersCount: String) {
        followersLabel.isHidden = false
        followersCountLable.text = followersCount
    }
    func display(followingCount: String) {
        followingLabel.isHidden = false
        followingCountLable.text = followingCount
    }
    func display(profileUrl: String) {
        profileImage.kf.setImage(with: URL.init(string: profileUrl))
    }
}
