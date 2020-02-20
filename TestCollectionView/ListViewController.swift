//
//  ViewController.swift
//  TestCollectionView
//
//  Created by Teerawat Vanasapdamrong on 14/8/19.
//  Copyright © 2019 mrhangz. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
  @IBOutlet private var collectionView: UICollectionView!
  @IBOutlet private var loadingView: UIActivityIndicatorView!
  
  var beers: [Beer] = []
  var page = 1

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let bundle = Bundle(for: BeerCollectionViewCell.self)
    let nib = UINib(nibName: "BeerCollectionViewCell", bundle: bundle)
    collectionView.register(nib, forCellWithReuseIdentifier: "BeerCollectionViewCell")
    
    getBeers()
  }
  
  func getBeers() {
    loadingView.isHidden = false
    let apiManager = APIManager()
    apiManager.getBeers(urlString: "https://api.punkapi.com/v2/beers?page=\(page)") { [weak self] (beers) in
      self?.beers.append(contentsOf: beers)
      DispatchQueue.main.sync {
        self?.loadingView.isHidden = true
        self?.collectionView.reloadData()
        self?.page += 1
      }
    }
  }
}

extension ListViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return beers.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeerCollectionViewCell", for: indexPath) as? BeerCollectionViewCell else {
      return UICollectionViewCell()
    }
    let beer = beers[indexPath.row]
    cell.setupUI(beer: beer)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if indexPath.row == beers.count - 1 {
      getBeers()
    }
  }
}

extension ListViewController: UICollectionViewDelegate {
  
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.size.width / 2.0
    let height = width * 1.5
    return CGSize(width: width, height: height)
  }
}
