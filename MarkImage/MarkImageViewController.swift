//
//  MarkImageViewController.swift
//  MarkImage
//
//  Created by 黄家树 on 2017/4/25.
//  Copyright © 2017年 huangjiashu. All rights reserved.
//

import UIKit

class MarkImageViewController: UIViewController {
    
    
   var showImage:UIImage?
    //定义起始点
    
   private var startPoint:CGPoint = CGPoint.zero
   private var endPoint:CGPoint  = CGPoint.zero
   private var topView:UIView!
   private var botomView:UIView!
   private var showImageView:UIImageView!
   private var rectViewSet = Set<UIView>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.topView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64))
        self.topView.backgroundColor = UIColor.lightGray
        self.view.addSubview(self.topView)
        
        let doneBtn:UIButton = UIButton(type: .system)
        doneBtn.setTitle("完成", for: .normal)
        let width: CGFloat = 50
        
        doneBtn.frame = CGRect(x: topView.frame.maxX - width, y: (topView.frame.height - width)/2, width: width, height: width)
        self.topView.addSubview(doneBtn)
        doneBtn.addTarget(self, action: #selector(done), for: .touchUpInside)
        
        let cancelBtn = UIButton(type: .system)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.frame = CGRect(x:0, y: doneBtn.frame.minY, width: width, height: width)
        cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        self.topView.addSubview(cancelBtn)
        
        self.botomView = UIView(frame: CGRect(x: 0, y: self.view.frame.maxY - 64, width: self.view.frame.width, height: 64))
        self.botomView.backgroundColor = UIColor.lightGray
        self.view.addSubview(self.botomView)
        
        let lableInfo = UILabel(frame: self.botomView.bounds)
        lableInfo.text = "拖动到此处删除"
        lableInfo.textAlignment = .center
        self.botomView.addSubview(lableInfo)
        self.showImageView = UIImageView(frame: CGRect(x:0,y:self.topView.frame.maxY,width:self.view.frame.width, height: self.botomView.frame.minY - self.topView.frame.maxY))
        self.showImageView.image = self.showImage
        self.showImageView.contentMode = .scaleAspectFit
        self.view.addSubview(self.showImageView)
        
    }
    
    func done() {
        
    self.dismiss(animated: true) { 
        
        }
    }

    
    func cancel() {
        for view in self.rectViewSet {
            view.removeFromSuperview()
        }
        self.rectViewSet.removeAll()
        self.dismiss(animated: true) {
            
        }
    }
    
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first else {
            return
        }
        //获取开始点位置
        startPoint =  touchPoint.location(in: self.view)
        print("startPoint:\(startPoint)")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //获取结束点的位置
        guard let movePoint = touches.first else {
            return
        }
        endPoint = movePoint.location(in: self.view)
        
        print("endPoint:\(endPoint)")
        
        //画一个矩形添加到layer上
        let width = abs(endPoint.x - startPoint.x)
        let height = abs(endPoint.y - startPoint.y)
        
        guard width >= 30 && height >= 30 else {
            return
        }
        let originPoint = startPoint.y < endPoint.y ? startPoint : endPoint
        
        let frame = CGRect(origin: originPoint, size: CGSize(width: width, height: height))
        let rectView = RectView(frame:frame , topView: self.topView, bottomView: self.botomView)
        self.view.addSubview(rectView)
        self.rectViewSet.insert(rectView)
        
        rectView.panGestureEndedClosure = {
            if self.botomView.frame.intersects(rectView.frame) {
                rectView.removeFromSuperview()
                self.rectViewSet.remove(rectView)
            }
        }
    }
    
}




class RectView: UIView {
    
    let topView:UIView
    let botomView:UIView
    
    //拖动手势结束的回调
    typealias PanGestrueEndedClosure = ()->()
    
    var panGestureEndedClosure: PanGestrueEndedClosure?
    
    init(frame: CGRect, topView:UIView, bottomView:UIView) {
        self.topView = topView
        self.botomView = bottomView
        super.init(frame: frame)
        self.initliazsiton()
        self.addGesture()
    }
    
    
    func initliazsiton() {
        let path = UIBezierPath(rect: self.bounds)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = path.bounds
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3
        self.layer.addSublayer(shapeLayer)
    }
    
    
    func addGesture() {
        //添加拖动手势
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        self.addGestureRecognizer(panGesture)
    }
    
    
    func handlePanGesture(gesture:UIPanGestureRecognizer) {
        //获取拖动位置的中心
        if self.superview != nil {
            var center = self.center
            
           let point = gesture.translation(in: self)
            center.x += point.x
            center.y += point.y
            self.center = center
            gesture.setTranslation(CGPoint.zero, in: self)
        }
        
        self.topView.isHidden = true
        self.botomView.isHidden = false
        
        if gesture.state == .ended {
            if let panGestureEndedClosure = self.panGestureEndedClosure{
                panGestureEndedClosure()
            }
            
            //隐藏
            self.topView.isHidden = false
            self.botomView.isHidden = true
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

