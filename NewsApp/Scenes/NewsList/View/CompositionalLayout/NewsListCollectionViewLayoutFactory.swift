import UIKit

struct NewsListCollectionViewLayoutFactory {
    private enum Constants {
        static let estimatedHeight: CGFloat = 500
        static let groupSpacing: CGFloat = 30
        static let spacing: CGFloat = 10
    }

    static func newsFeedLayout() -> UICollectionViewCompositionalLayout {

        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let _ = NewsListSection.init(rawValue: sectionIndex) else {
                fatalError("Section layout is not implemented :(")
            }
            return self.createNewsSectionLayout()
        }
        return layout
    }
}

extension NewsListCollectionViewLayoutFactory {
    static func createNewsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Constants.estimatedHeight)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Constants.estimatedHeight)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
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
}
