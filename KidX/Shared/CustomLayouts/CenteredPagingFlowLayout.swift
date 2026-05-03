//
//  CenteredPagingFlowLayout.swift
//  FingerSpinner
//

import UIKit

class CenteredPagingFlowLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposed: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let cv = collectionView else { return proposed }
        let step = itemSize.width + minimumLineSpacing
        let page = cv.contentOffset.x / step
        let target = velocity.x > 0.2 ? ceil(page) : (velocity.x < -0.2 ? floor(page) : round(page))
        let maxPage = CGFloat(cv.numberOfItems(inSection: 0) - 1)
        return CGPoint(x: max(0, min(target, maxPage)) * step, y: proposed.y)
    }
}
