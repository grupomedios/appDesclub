//
//  VoucherViewController.swift
//  DesclubiOS
//
//  Created by Sergio Maturano on 25/8/16.
//  Copyright © 2016 Grupo Medios. All rights reserved.
//

import Foundation

class VoucherViewController: UIViewController {
 
    let popupTime = 2.0
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var showMessageView: UIView!
    @IBOutlet weak var buttosContentView: UIView!

    @IBOutlet weak var lblNameApp: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var validThru: UILabel!

    @IBOutlet weak var btnCorrectOp: UIButton!
    @IBOutlet weak var btnCancelOp: UIButton!
    @IBOutlet weak var btnErrorOp: UIButton!

    private var discount:DiscountRepresentation
    private var timer = NSTimer()
    
    private let stringCorrectOption = "Yay! Si me aplicaron el descuento"
    private let stringCancelOption = "Oops! Sólo estaba probando"
    private let stringErrorOption = "No me aplicaron mi descuento"

    //MARK: - Init

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, discount:DiscountRepresentation) {
        self.discount = discount
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblNameApp.text = "Membresía DescluB"
        self.showMessageView.layer.cornerRadius = 10.0

        self.configButtons()
        self.loadTimer()
        self.showAndHideComponents()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func closeViewController() {
        self.timer.invalidate()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //MARK: - Options
    
    func configButtons(){
        
        self.btnCorrectOp.setTitle(stringCorrectOption, forState: UIControlState.Normal)
        self.btnCancelOp.setTitle(stringCancelOption, forState: UIControlState.Normal)
        self.btnErrorOp.setTitle(stringErrorOption, forState: UIControlState.Normal)
        
        self.btnCorrectOp.addTarget(self, action: #selector(VoucherViewController.voucherUsed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.btnCancelOp.addTarget(self, action: #selector(VoucherViewController.voucherCancel(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.btnErrorOp.addTarget(self, action: #selector(VoucherViewController.voucherError(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.btnCorrectOp.layer.cornerRadius = 10.0
        self.btnCancelOp.layer.cornerRadius = 10.0
        self.btnErrorOp.layer.cornerRadius = 10.0

    }
    
    //MARK: - Actions
    
    @IBAction func voucherUsed(sender: UIButton) {
        self.showPopup()
    }
    
    @IBAction func voucherCancel(sender: UIButton) {
        self.closeViewController()
    }
    
    @IBAction func voucherError(sender: UIButton) {
        // Show warranty
        let storyboard = UIStoryboard(name: "Warranty", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() {
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func close(sender: UIButton) {
        self.closeViewController()
    }
    
    //MARK: - Timer
    
    func loadTimer(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector:#selector(VoucherViewController.tick), userInfo:nil, repeats:true)
    }
    
    func tick() {
        self.clockLabel.text = NSDateFormatter.localizedStringFromDate(NSDate(),dateStyle: .MediumStyle, timeStyle: .MediumStyle)
    }

    // MARK: - User data
    
    private func showAndHideComponents(){
        if UserHelper.isLoggedIn() {
            
            self.cardView.hidden = false
            self.buttosContentView.hidden = false
            self.showMessageView.hidden = true
            
            //show card information
            let membership:CorporateMembershipRepresentation = UserHelper.getCurrentUser()!
            self.name?.text = membership.name?.uppercaseString
            self.cardNumber?.text = UserHelper.getCardNumber()
            self.validThru.text = UserHelper.getValidThru()
            
        }else{
            self.cardView.hidden = true
            self.buttosContentView.hidden = true
            self.showMessageView.hidden = false
        }
    }
    
    // MARK: -
    
    func showPopup() {

        let size : CGFloat = 38.0

        let window = UIApplication.sharedApplication().windows.first!
        let popupView = UIView(frame: window.frame)

        let backgroundView = UIView(frame: CGRectMake(0,0,popupView.frame.size.width, popupView.frame.size.height))
        backgroundView.alpha = 0.90
        backgroundView.backgroundColor = UIColor.blackColor()
        popupView.addSubview(backgroundView)

        let lblTitle = UILabel(frame: CGRectMake(0,0, popupView.frame.size.width, size))
        lblTitle.font = UIFont.boldSystemFontOfSize(18.0)
        lblTitle.text = "¡Gracias por usar tu cupón!"
        lblTitle.textAlignment = NSTextAlignment.Center
        lblTitle.textColor = UIColor.whiteColor()
        lblTitle.center = CGPointMake(popupView.frame.size.width * 0.5, popupView.frame.size.height * 0.5)
        popupView.addSubview(lblTitle)

        let img = UIImageView(image: UIImage(named: "ic_tick"))
        img.frame = CGRectMake(lblTitle.center.x - (size * 0.5), lblTitle.frame.origin.y - (size + 8), size, size)
        popupView.addSubview(img)
        
        popupView.backgroundColor = UIColor.clearColor()
        popupView.alpha = 0.0
        window.addSubview(popupView)
        
        UIView.animateWithDuration(0.5, animations: {
            popupView.alpha = 1.0
        }) { (finished) in
            if finished {
                self.closePopup(popupView)
            }
        }
        
    }
    
    func closePopup(popup: UIView) {
        
        UIView.animateWithDuration(0.5, delay: self.popupTime, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            popup.alpha = 0.0
        }) { (finished) in
            if finished {
                popup.removeFromSuperview()
                self.timer.invalidate()
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }

    }
}