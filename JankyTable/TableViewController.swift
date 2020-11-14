//
//  TableViewController.swift
//  JankyTable
//
//  Created by Thomas Vandegriff on 5/28/19.
//  Copyright © 2019 Make School. All rights reserved.
//

import UIKit
import Kingfisher

class TableViewController: UITableViewController {

    private var photosDict: [String: String] = [:]
    lazy var photos = NSDictionary(dictionary: photosDict)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(ImageViewCell.self, forCellReuseIdentifier: "ImageViewCell")
        
        guard let plist = Bundle.main.url(forResource: "PhotosDictionary", withExtension: "plist"),
            let contents = try? Data(contentsOf: plist),
            let serializedPlist = try? PropertyListSerialization.propertyList(from: contents, format: nil),
            let serialUrls = serializedPlist as? [String: String] else {
                print("error with serializedPlist")
                return
        }
        photosDict = serialUrls
    }
    
    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return photosDict.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell
        let rowKey = photos.allKeys[indexPath.row] as! String
        
        var image : UIImage?
        
        DispatchQueue.global(qos: .userInteractive).async {
            guard let imageURL = URL(string:self.photos[rowKey] as! String),
                  let imageData = try? Data(contentsOf: imageURL) else { return }
            
            // Simulate a network wait
            Thread.sleep(forTimeInterval: 1)
            print("sleeping 1 sec")
            
            let unfilteredImage = UIImage(data:imageData)

            image = self.applySepiaFilter(unfilteredImage!)
            
            DispatchQueue.main.async {
                // Configure the cell...
                cell.textLabel?.text = rowKey
                if image != nil {
//                    cell.imageView?.image = image!
                    cell.imageView?.kf.setImage(with: imageURL)
                }
            }
        }
        return cell
    }
    
    // MARK: - image processing
    
    func applySepiaFilter(_ image:UIImage) -> UIImage? {
        let inputImage = CIImage(data:image.pngData()!)
        let context = CIContext(options:nil)
        let filter = CIFilter(name:"CISepiaTone")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter!.setValue(0.8, forKey: "inputIntensity")
        
        guard let outputImage = filter!.outputImage,
            let outImage = context.createCGImage(outputImage, from: outputImage.extent) else {
                return nil
        }
        return UIImage(cgImage: outImage)
    }
}


