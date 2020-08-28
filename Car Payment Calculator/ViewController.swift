//
//  ViewController.swift
//  Car Payment Calculator
//
//  Created by Jonathan Daniel on 8/27/20.
//  Copyright © 2020 Jonathan Daniel. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func HideKeyboard() {
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(Tap)
    }

    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
}

extension Double {
    func addCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}

class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
}


class ViewController: UIViewController {

    @IBOutlet weak var carPriceField: UITextField!
    @IBOutlet weak var destinationFeeField: UITextField!
    @IBOutlet weak var msrpLabel: UILabel!
    @IBOutlet weak var dealerDiscountField: UITextField!
    @IBOutlet weak var salesTaxField: UITextField!
    @IBOutlet weak var registrationFeesField: UITextField!
    @IBOutlet weak var warrantyPlanField: UITextField!
    @IBOutlet weak var totalPurchasePriceLabel: UILabel!
    @IBOutlet weak var downPaymentField: UITextField!
    @IBOutlet weak var tradeInValueField: UITextField!
    @IBOutlet weak var totalAmountFinancedLabel: UILabel!
    @IBOutlet weak var interestRateField: UITextField!
    @IBOutlet weak var loanTermField: UITextField!
    @IBOutlet weak var monthlyPaymentLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.HideKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisapear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    var isExpand : Bool = false
    @objc func keyboardAppear(notification: Notification) {
        if !isExpand {
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + 250)
            isExpand = true
        }
    }
    
    @objc func keyboardDisapear(notification: Notification) {
        if !isExpand {
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + 250)
            isExpand = false
        }
    }
    
    @IBAction func calculateCarPayment(_ sender: UIButton) {
        let carPrice = Double(carPriceField.text!)
        let destinationFee = Double(destinationFeeField.text!)
        let dealerDiscount = Double(dealerDiscountField.text!)
        let salesTaxRate = Double(salesTaxField.text!)
        let registrationFees = Double(registrationFeesField.text!)
        let warrantyPlan = Double(warrantyPlanField.text!)
        let downPayment = Double(downPaymentField.text!)
        let tradeInValue = Double(tradeInValueField.text!)
        let interestRate = Double(interestRateField.text!)
        let loanTerm = Double(loanTermField.text!)
        
        var msrp = carPrice! + destinationFee!
        msrp = Double(round(100*msrp)/100)
        
        let totalCarPrice = carPrice! + destinationFee! - dealerDiscount!
        let totalSalesTax = (carPrice! - dealerDiscount!) * salesTaxRate!/100
        var totalPurchasePrice = totalCarPrice + totalSalesTax + registrationFees! + warrantyPlan!
        totalPurchasePrice = Double(round(100*totalPurchasePrice)/100)
        
        var totalAmountFinanced = totalPurchasePrice - downPayment! - tradeInValue!
        totalAmountFinanced = Double(round(100*totalAmountFinanced)/100)
        
        let r = (interestRate!/100)/12
        var monthlyPayment = (totalAmountFinanced * r) / (1 - pow(1+r, -loanTerm!))
        monthlyPayment = Double(round(100*monthlyPayment)/100)
        
        msrpLabel.text = String("$" + msrp.addCommas())
        totalPurchasePriceLabel.text = String("$" + totalPurchasePrice.addCommas())
        totalAmountFinancedLabel.text = String("$" + totalAmountFinanced.addCommas())
        monthlyPaymentLabel.text = String("$" + monthlyPayment.addCommas())
    }
    
}

