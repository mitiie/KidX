//
//  PopularTableCell.swift
//  MV_2570
//
//  Created by Bui Minh Tien on 28/6/25.
//

import UIKit

protocol PopularTableCellDelegate: AnyObject {
    func popularTableCell(_ cell: PopularTableCell, didSelectCategory category: PopularFlashCardCategory)
}

class PopularTableCell: UITableViewCell {
    private enum Constants {
        static let peekWidth: CGFloat = 48
        static let lineSpacing: CGFloat = 16
        static let animationDuration: TimeInterval = 0.2
    }
    
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var pageIndicator: PageIndicatorView!
    
    weak var delegate: PopularTableCellDelegate?
    private var categories: [PopularFlashCardCategory] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        popularCollectionView.delegate = self
        popularCollectionView.dataSource = self
        popularCollectionView.registerNib(for: PopularCollectionCell.self)
        
        let layout = CenteredPagingFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.lineSpacing
        
        popularCollectionView.collectionViewLayout = layout
        popularCollectionView.decelerationRate = .fast
        popularCollectionView.showsHorizontalScrollIndicator = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    private func updateLayout() {
        guard let layout = popularCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let width = popularCollectionView.bounds.width - Constants.peekWidth
        let height = popularCollectionView.bounds.height
        layout.itemSize = CGSize(width: width, height: height)
        let inset = (popularCollectionView.bounds.width - width) / 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    func configure(with categories: [PopularFlashCardCategory]) {
        self.categories = categories
        pageIndicator.setPage(0, totalPages: categories.count)
        popularCollectionView.reloadData()
    }
}

extension PopularTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PopularCollectionCell = popularCollectionView.dequeueReusableCell(for: indexPath)
        let category = categories[indexPath.item]
        cell.configure(title: category.category, imageName: category.imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.item]
        delegate?.popularTableCell(self, didSelectCategory: category)
    }
}

extension PopularTableCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let layout = popularCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let step = layout.itemSize.width + layout.minimumLineSpacing
        let offsetX = scrollView.contentOffset.x
        let currentPage = Int(round(offsetX / step))
        pageIndicator.setPage(currentPage, totalPages: categories.count)
    }
}
