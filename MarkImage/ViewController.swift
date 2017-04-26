//
//  ViewController.swift
//  MarkImage
//
//  Created by 黄家树 on 2017/4/25.
//  Copyright © 2017年 huangjiashu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //创建按钮选择图片
        let pickImageBtn = UIButton(type: .system)
        pickImageBtn.setTitle("获取图片", for: .normal)
        pickImageBtn.sizeToFit()
        pickImageBtn.center = self.view.center
        pickImageBtn.addTarget(self, action: #selector(takePick), for: .touchUpInside)
        self.view.addSubview(pickImageBtn)
        
        
        
    }
    
    func takePick() -> () {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let imagePickCtr = UIImagePickerController()
            imagePickCtr.sourceType = .photoLibrary
            imagePickCtr.allowsEditing = true
            imagePickCtr.delegate = self
            self.present(imagePickCtr, animated: true, completion: { 
                
            })
            
            
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if  let pickimage: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage ?? info[UIImagePickerControllerOriginalImage] as? UIImage {
            
           let markImageView = MarkImageViewController()
            
            markImageView.showImage = pickimage
            
            picker.dismiss(animated: true, completion: { 
               self.present(markImageView, animated: true, completion: nil)
            })
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    

}









