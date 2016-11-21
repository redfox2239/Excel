//
//  DefinitionViewController.swift
//  yamadaApp
//
//  Created by 原田　礼朗 on 2016/11/21.
//  Copyright © 2016年 reo harada. All rights reserved.
//

import UIKit

class DefinitionViewController: UIViewController {

    @IBOutlet weak var firstTitleTextField: UITextField!
    @IBOutlet weak var secondTitleTextField: UITextField!
    @IBOutlet weak var thirdTitleTextField: UITextField!
    @IBOutlet weak var fourthTitleTextField: UITextField!
    @IBOutlet weak var fifthTitleTextField: UITextField!
    @IBOutlet weak var firstRowWidthTextField: UITextField!
    @IBOutlet weak var secondRowWidthTextField: UITextField!
    @IBOutlet weak var thirdRowWidthTextField: UITextField!
    @IBOutlet weak var fourthRowWidthTextField: UITextField!
    @IBOutlet weak var fifthRowWidthTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func tapDecideButton(_ sender: Any) {
        // iPhoneのストレージに入力項目を保存する
        // 保存してくれる人を呼ぶ
        let defaults = UserDefaults.standard
        // 保存するデータを用意
        let titleData: [String?] = [
            self.firstTitleTextField.text,
            self.secondTitleTextField.text,
            self.thirdTitleTextField.text,
            self.fourthTitleTextField.text,
            self.fifthTitleTextField.text,
        ]
        // 保存する
        defaults.set(titleData, forKey: "titleData")
        
        let rowWidthData: [String?] = [
            self.firstRowWidthTextField.text,
            self.secondRowWidthTextField.text,
            self.thirdRowWidthTextField.text,
            self.fourthRowWidthTextField.text,
            self.fifthRowWidthTextField.text,
        ]
        
        defaults.set(rowWidthData, forKey: "rowWidthData")
        
        // 今すぐ保存してね
        defaults.synchronize()
        
        // 画面戻る
        self.navigationController?.popViewController(animated: true)
    }
}



