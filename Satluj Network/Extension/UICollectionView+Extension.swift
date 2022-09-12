//
//  UICollectionView+Extension.swift
//  Satluj Network
//
//  Created by Mohit on 14/03/22.
//

import Foundation
import UIKit

protocol ReusableView {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    static var nibName: String {
        return String(describing: self)
    }
}
extension UICollectionReusableView: ReusableView {}
extension UICollectionView {

    func registerCustom<T: UICollectionViewCell>(_: T.Type) {

        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func registerForSupplementaryHeader<T: UICollectionReusableView>(_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
    }
    func registerForSupplementaryFooter<T: UICollectionReusableView>(_: T.Type) {
          let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier)
      }
    func isValidIndexPath(indexpath: IndexPath) -> Bool {

        return indexpath.section < self.numberOfSections && indexpath.row < self.numberOfItems(inSection: indexpath.section)
    }
    func dequeueCell<T: UICollectionViewCell>(_: T.Type, indexPath: IndexPath) -> T? {

        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T
    }
     func scrollToTop(isAnimated: Bool = false) {
         
         let totalSections = numberOfSections
         var scrollToSection: Int? = nil
         for i in 0..<totalSections {
             
             if numberOfItems(inSection: i) > 0 {
                 scrollToSection = i
                 break
             }
         }
         if let section = scrollToSection {
             if isValidIndexPath(indexpath: IndexPath(row: 0, section: section)) {
                 self.scrollToItem(at: IndexPath(row: 0, section: section), at: .top, animated: isAnimated)
             }
         }
     }

}
