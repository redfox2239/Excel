//
//  ViewController.swift
//  yamadaApp
//
//  Created by 原田　礼朗 on 2016/11/06.
//  Copyright © 2016年 reo harada. All rights reserved.
//

import UIKit

// collectionViewと相談する準備
// collectionViewのレイアウトを相談する準備
class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {

    // collectionView
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    // 横幅の配列
    var widthData: [String?] = []
    // 0行目のデータ配列
    var data: [String?] = []
    // 品名の列数
    var rowNumber = 2
    // textFieldデータ
    var textFieldData: [String?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // UserDefaultsに保存されてるtitleDataを取ってくる
        let defaults = UserDefaults.standard
        if let dataTmp = defaults.object(forKey: "titleData") as? [String?] {
            data = dataTmp
        }
        if let widthDataTmp = defaults.object(forKey: "rowWidthData") as? [String?] {
            widthData = widthDataTmp
        }
        
        
        for i in 0..<(data.count + rowNumber*data.count) {
            textFieldData.append("")
        }
        print(textFieldData)
        print(textFieldData.count)
        
        // labelがあるカスタムセルを登録
        let menuXib = UINib(nibName: "MenuCollectionViewCell", bundle: nil)
        self.listCollectionView.register(menuXib, forCellWithReuseIdentifier: "menuCell")
        
        // textFieldがあるカスタムセルを登録
        let textXib = UINib(nibName: "TextCollectionViewCell", bundle: nil)
        self.listCollectionView.register(textXib, forCellWithReuseIdentifier: "textCell")
        
        // 合計を計算するためのタイマーをセット
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {(timer) in
            // 品名の列のデータごとに計算する
            for i in 0..<self.rowNumber {
                // 添字の数+1行目の単価のセルのIndexPathを計算
                let indexPathOneMoney = IndexPath(row: (i+1)*self.data.count+1, section: 0)
                // 上で計算したIndexPathのセルを取得（単価のセル）
                guard let oneMoneyCell = self.listCollectionView.cellForItem(at: indexPathOneMoney) as? TextCollectionViewCell else {
                    // なければ終了
                    return
                }
                // 単価のセルのtextFieldの中身を取得
                let oneMoney = oneMoneyCell.textField.text
                self.textFieldData[(i+1)*self.data.count+1] = oneMoneyCell.textField.text
                
                // 添字の数+2行目の個数のセルのIndexPathを計算
                let indexPathNumber = IndexPath(row: (i+1)*self.data.count+2, section: 0)
                // 上で計算したIndexPathのセルを取得（個数のセル）
                guard let numberCell = self.listCollectionView.cellForItem(at: indexPathNumber) as? TextCollectionViewCell else {
                    // なければ終了
                    return
                }
                // 個数のセルのtextFieldの中身を取得
                let number = numberCell.textField.text
                self.textFieldData[(i+1)*self.data.count+2] = numberCell.textField.text

                // 添字の数+4行目の個数のセルのIndexPathを計算
                let indexPathTax = IndexPath(row: (i+1)*self.data.count+4, section: 0)
                // 上で計算したIndexPathのセルを取得（個数のセル）
                guard let taxCell = self.listCollectionView.cellForItem(at: indexPathTax) as? TextCollectionViewCell else {
                    // なければ終了
                    return
                }
                // 消費税のセルのtextFieldの中身を取得
                let tax = taxCell.textField.text
                self.textFieldData[(i+1)*self.data.count+4] = taxCell.textField.text

                // 単価のセルのtextFieldまたは個数のセルのtextFieldに何も入力されてなければ、合計は0
                // 単価のセルのtextFieldまたは個数のセルのtextFieldに入力されてる場合は、合計を計算する
                // 添字の数+3行目の個数のセルのIndexPathを計算
                let indexPathAmount = IndexPath(row: (i+1)*self.data.count+3, section: 0)
                // 上で計算したIndexPathのセルを取得（個数のセル）
                guard let amountCell = self.listCollectionView.cellForItem(at: indexPathAmount) as? TextCollectionViewCell else {
                    // なければ終了
                    return
                }

                if number == "" || oneMoney == "" {
                    // 合計金額は0
                    amountCell.textField.text = ""
                }
                else {
                    // 合計金額は、個数x単価x消費税
                    if tax == "" {
                        if Int(number!) != nil && Int(oneMoney!) != nil {
                            let amount = Int(number!)!*Int(oneMoney!)!
                            amountCell.textField.text = amountCell.convertMoneyStringFromInt(amount)
                        }
                    }
                    else {
                        if Int(number!) != nil && Int(oneMoney!) != nil && Int(tax!) != nil {
                            let amount = Int(number!)!*Int(oneMoney!)!*(100+Int(tax!)!)/100
                            amountCell.textField.text = amountCell.convertMoneyStringFromInt(amount)
                        }
                    }
                }
                self.textFieldData[(i+1)*self.data.count+3] = amountCell.textField.text
            }
        }
    }
    
    // listCollectionViewとの相談
    // セクションの数どうする？
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // セルの数どうする？
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count + rowNumber*data.count
    }
    
    // セルの中身どうする？
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 0行目（0,1,2,3番目のセル）は、dataの項目を入力していく
        if indexPath.row < data.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuCollectionViewCell
            cell.menuLabel.text = data[indexPath.row]
            return cell
        }
        
        // 列を計算する
        let column = indexPath.row % data.count
        // 行を計算する
        let index = Int(indexPath.row/data.count) - 1
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textCell", for: indexPath) as? TextCollectionViewCell
        cell?.textField.text = textFieldData[indexPath.row]
        return cell!
    }
    
    // セルのサイズはどうするぅ？
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 列を計算する
        let mod = indexPath.row % data.count
        // セルの横幅の変数
        var width: CGFloat = 0.0
        let viewWidth = UIScreen.main.bounds.size.width
        var ratio = 0
        if let ratioString = widthData[mod] {
            if Int(ratioString) != nil {
                ratio = Int(ratioString)!
            }
        }
        width = viewWidth * CGFloat(ratio)/100
        return CGSize(width: width, height: 40)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("スクロール始まるよ")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "scroll"), object: nil)
    }
}





