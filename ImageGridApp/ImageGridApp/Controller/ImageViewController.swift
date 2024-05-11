//
//  ViewController.swift
//  ImageGridApp
//
//  Created by NFC User on 10/05/24.
//

import UIKit
import SwiftyJSON

class ImageViewController: UIViewController {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var imageArray = [String]()
    var imageCache = NSCache<NSString, UIImage>()
    let apiService = APIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
        title = "Image Grid"
        
        Spinner.shared.startAnimating(in: self.view)
        apiService.fetchAPI(viewController: self, callback: getresponse(response:))
        
    }
    
}

//MARK: - Collection View

extension ImageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageGridIdentifier", for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let imageUrlString = imageArray[indexPath.row]
        let imageUrl = URL(string: imageUrlString)
        
        // Check if the image is already cached
        if let cachedImage = imageCache.object(forKey: imageUrlString as NSString) {
            print("Image from cached memory")
            cell.imageGrid.image = cachedImage
            return cell
        }
        
        // Start downloading the image if not cached
        print("Downloading image from URL: \(imageUrlString)")
        downloadImage(for: imageUrl, forCell: cell, at: indexPath, in: collectionView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = (collectionViewWidth - 20) / 3
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    // Function to download the image
    func downloadImage(for imageUrl: URL?, forCell cell: ImageCollectionViewCell, at indexPath: IndexPath, in collectionView: UICollectionView) {
        guard let imageUrl = imageUrl else { return }
        
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            if let error = error {
                print("Error downloading image: \(error)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else { return }
            
            // Cache the downloaded image
            self.imageCache.setObject(image, forKey: imageUrl.absoluteString as NSString)
            
            // Display the image only if the cell is still visible at this indexPath
            DispatchQueue.main.async {
                if collectionView.indexPathsForVisibleItems.contains(indexPath) {
                    cell.imageGrid.image = image
                }
            }
        }.resume()
    }
}

//MARK: - API Response

extension ImageViewController {
    
    func getresponse(response:AnyObject)->() {
        
        if response is String {
            
            DispatchQueue.main.async {
                Spinner.shared.stopAnimatingAndRemove(from: self.view)
            }
            GeneralViewController.ShowAlertMessage(ErrorMessage:response as! String, title: "", view:self)
            
        } else {
            
            DispatchQueue.main.async {
                Spinner.shared.stopAnimatingAndRemove(from: self.view)
                print("the response from Image vc is",response)
                self.imageArray = response as! [String]
                self.imageCollectionView.reloadData()
            }
        }
   
    }

}


