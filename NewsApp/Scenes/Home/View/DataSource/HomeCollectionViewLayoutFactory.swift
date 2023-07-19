import UIKit

struct HomeCollectionViewLayoutFactory {
    private enum Constants {
        static let newsEstimatedHeight: CGFloat = 500
        static let blogEstimatedHeight: CGFloat = 60
        static let groupSpacing: CGFloat = 16
        static let spacing: CGFloat = 8
    }

    static func contentLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = HomeSection.init(rawValue: sectionIndex) else {
                fatalError("Section layout is not implemented :(")
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
    static func createNewsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(Constants.newsEstimatedHeight)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Constants.newsEstimatedHeight)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.accessibilityScroll(.down)
        section.contentInsets = .init(
            top: Constants.spacing,
            leading:  Constants.spacing,
            bottom:  Constants.spacing,
            trailing:  Constants.spacing
        )
        section.interGroupSpacing = Constants.groupSpacing
        return section
    }
    
    static func createBlogSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Constants.blogEstimatedHeight)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Constants.blogEstimatedHeight)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = Constants.groupSpacing
        return section
    }
}
