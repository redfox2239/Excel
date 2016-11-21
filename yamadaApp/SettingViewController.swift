//
//  SettingViewController.swift
//  yamadaApp
//
//  Created by 原田　礼朗 on 2016/11/21.
//  Copyright © 2016年 reo harada. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
    
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
        // 次の画面にデータを渡す
        // 次の画面を呼んできます
        // 画面の正体を保証してあげる
        let next = self.storyboard?.instantiateViewController(withIdentifier: "メイン画面") as! ViewController
        next.rowNumber = Int(self.numberTextField.text!)!
        // nextって言う画面に移動してね
        self.show(next, sender: nil)
    }
}
