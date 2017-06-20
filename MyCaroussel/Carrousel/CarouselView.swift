//
//  ViewController.swift
//  LGLinearFlowViewSwift
//
//  Created by Mohamed BOUMANSOUR on 6/7/17.
//  Copyright © 2017 Mohamed. All rights reserved.
//

import UIKit




public class CollectionViewCell: UICollectionViewCell {
    
    public var pageLabel: UILabel!
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
        
        setup()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setup()
    }
    
    func setup()
    {
        self.pageLabel = UILabel(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        self.addSubview(self.pageLabel);
    }
}


private let cellId = "CollectionViewCell"

class CarouselView: UIView {
    
    // MARK: Vars
    
    private var collectionViewLayout: LGHorizontalLinearFlowLayout!
    private var dataSource: Array<String>!
    
    private var collectionView: UICollectionView!
    private var pageControl: UIPageControl!
    
    private var animationsCount = 0
    
    private var pageWidth: CGFloat {
        return self.collectionViewLayout.itemSize.width + self.collectionViewLayout.minimumLineSpacing
    }
    
    private var contentOffset: CGFloat {
        return self.collectionView.contentOffset.x + self.collectionView.contentInset.left
    }

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.configureDataSource()
        self.configureCollectionView()
        self.configurePageControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuration
    
    private func configureDataSource() {
        self.dataSource = Array()
        for index in 1...10 {
            self.dataSource.append("Page \(index)")
        }
    }
    
    private func configureCollectionView() {
        
        self.collectionView = UICollectionView(frame: CGRectMake(0, 0, self.frame.size.width, 250), collectionViewLayout: UICollectionViewLayout())
        self.collectionView.backgroundColor = UIColor.whiteColor()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionViewLayout = LGHorizontalLinearFlowLayout.configureLayout(collectionView: self.collectionView, itemSize: CGSizeMake(180, 180), minimumLineSpacing: 0)
        self.addSubview(self.collectionView)
        
    }
    
    private func configurePageControl() {
        
        let y = self.collectionView.frame.origin.y + self.collectionView.frame.size.height //self.frame.size.height-20
        self.pageControl = UIPageControl(frame: CGRectMake(0, y, self.frame.size.width, 20))
        self.pageControl.backgroundColor = UIColor.grayColor()
        self.addSubview(self.pageControl)
        self.pageControl.numberOfPages = self.dataSource.count
        self.pageControl.addTarget(self, action:#selector(pageControlValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    // MARK: Actions
    
    @objc private func pageControlValueChanged(sender: AnyObject) {
        self.scrollToPage(self.pageControl.currentPage, animated: true)
    }

    private func scrollToPage(page: Int, animated: Bool) {
        self.collectionView.userInteractionEnabled = false
        self.animationsCount += 1
        let pageOffset = CGFloat(page) * self.pageWidth - self.collectionView.contentInset.left
        self.collectionView.setContentOffset(CGPointMake(pageOffset, 0), animated: true)
        self.pageControl.currentPage = page
    }
}

extension CarouselView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! CollectionViewCell
        collectionViewCell.pageLabel.text = self.dataSource[indexPath.row]
        collectionViewCell.backgroundColor = UIColor.greenColor()
        return collectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView.dragging || collectionView.decelerating || collectionView.tracking {
            return
        }
        
        let selectedPage = indexPath.row
        
        if selectedPage == self.pageControl.currentPage {
            NSLog("Did select center item")
        }
        else {
            self.scrollToPage(selectedPage, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(self.contentOffset / self.pageWidth)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.animationsCount -= 1;
        if self.animationsCount == 0 {
            self.collectionView.userInteractionEnabled = true
        }
    }
    
}


