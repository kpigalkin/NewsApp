//
//  NewsApp
//  github.com/kpigalkin
//
//  Created by Kirill Pigalkin on July 2023.
//

import UIKit

    // MARK: - LayoutFactory

struct HomeCollectionViewLayoutFactory {
    
    // MARK: - Private
    
    private enum Constants {
        static let newsEstimatedHeight: CGFloat = 500
        static let blogEstimatedHeight: CGFloat = 80
        static let headerEstimatedHeight: CGFloat = 50
        static let sectionSpacing: CGFloat = 25
        static let groupSpacing: CGFloat = 16
        static let spacing: CGFloat = 12
    }

    static func contentLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = HomeSection.init(rawValue: sectionIndex) else {
                fatalError("Section layout is not implemented")
            }
            switch section {
            case .news:
                return self.createNewsSectionLayout()
            case .blog:
                return self.createBlogSectionLayout()
            }
        }
        return layout
    }
}

extension HomeCollectionViewLayoutFactory {
    
    // MARK: - BlogSection Layout
    
    static func createBlogSectionLayout() -> NSCollectionLayoutSection {
        
    // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Constants.blogEstimatedHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
    // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .estimated(Constants.blogEstimatedHeight)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
    // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Constants.headerEstimatedHeight)
        )
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        headerItem.pinToVisibleBounds = true
        
    // Section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [headerItem]
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        section.contentInsets = .init(
            top: Constants.spacing,
            leading: Constants.spacing,
            bottom: Constants.spacing + Constants.sectionSpacing,
            trailing: Constants.spacing
        )
        return section
    }
    
    // MARK: - NewsSection Layout
    
    static func createNewsSectionLayout() -> NSCollectionLayoutSection {
        
    // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Constants.newsEstimatedHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
    // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Constants.newsEstimatedHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
    // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Constants.headerEstimatedHeight)
        )
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        headerItem.pinToVisibleBounds = true
        
    // Section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [headerItem]
        section.accessibilityScroll(.down)
        
        section.interGroupSpacing = Constants.groupSpacing
        section.contentInsets = .init(
            top: Constants.spacing,
            leading: Constants.spacing,
            bottom: Constants.spacing,
            trailing: Constants.spacing
        )
        return section
    }
}
