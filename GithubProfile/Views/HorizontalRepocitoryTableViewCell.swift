import Foundation
import UIKit
import SnapKit
import Kingfisher

let kHorizontalRepocitoryCellIdentifier = "HorizontalRepocitoryTableViewCell"

class HorizontalRepocitoryTableViewCell: UITableViewCell {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor().colorFromHexString(background_color)
        collectionView.register(HorizontalRepositoryCollectionView.self, forCellWithReuseIdentifier: kHorizontalRepositoryCollectionCellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
        self.backgroundColor = UIColor().colorFromHexString(background_color)
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(16)
            make.left.equalTo(self.snp.left).offset(8)
            make.right.equalTo(self.snp.right).offset(-8)
            make.height.equalTo(180)
        }
    }
}
