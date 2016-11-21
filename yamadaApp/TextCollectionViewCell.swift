//
//  TextCollectionViewCell.swift
//  yamadaApp
//
//  Created by 原田　礼朗 on 2016/11/06.
//  Copyright © 2016年 reo harada. All rights reserved.
//

import UIKit

class TextCollectionViewCell: UICollectionViewCell,UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    var moneyString: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.delegate = self
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "scroll"), object: nil, queue: nil, using: {(Notification) -> Void in
            self.textField.resignFirstResponder()
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = moneyString
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let temp = textField.text {
            moneyString = temp
            if Int(moneyString) != nil {
                textField.text = convertMoneyStringFromInt(Int(moneyString)!)
            }
        }
    }

    func convertMoneyStringFromInt(_ money: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        if let moneyString = formatter.string(from: NSNumber(integerLiteral: money)) {
            return moneyString
        }
        else {
            return ""
        }
    }
    
}
