//
//  CollectionRowCollectionViewCell.swift
//  KidX
//
//  Created by 𝙢𝙩 on 6/6/26.
//

import UIKit

final class CollectionRowCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var viewAllButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Callbacks
    var onViewAllTapped: (() -> Void)?
    
    var items: [SavedObjectItem] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        titleLabel.font = UIFont.custom(19, .cherryBombRegular)
        viewAllButton.titleLabel?.font = UIFont.custom(14, .semiBold)
        
        // Nested horizontal CollectionView config
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Register Cell using generic extension
        collectionView.registerNib(for: SavedObjectCollectionViewCell.self)
    }
    
    @IBAction private func viewAllButtonTapped(_ sender: Any) {
        onViewAllTapped?()
    }
    
    // MARK: - Nested UICollectionView DataSource & Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SavedObjectCollectionViewCell.self)
        let item = items[indexPath.item]
        cell.configure(image: item.image, name: item.name, dateText: item.dateText)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 180)
    }
}
