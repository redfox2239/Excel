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
class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    // collectionView
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    // 0行目の横幅
    var widthFirst: CGFloat = 90
    // 1行目の横幅
    var widthSecond: CGFloat = 90
    // 2行目の横幅
    var widthThird: CGFloat = 90
    // 0行目のデータ配列
    var data: [String] = [
        "品名",
        "単価",
        "個数",
        "金額",
    ]
    // 品名の列のデータ
    var nameData: [String] = [
        "りんご",
        "みかん",
    ]
    // 金額の列のデータ
    var amountMoneyData: [Int] = [
        0,
        0,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // labelがあるカスタムセルを登録
        let menuXib = UINib(nibName: "MenuCollectionViewCell", bundle: nil)
        self.listCollectionView.register(menuXib, forCellWithReuseIdentifier: "menuCell")
        
        // textFieldがあるカスタムセルを登録
        let textXib = UINib(nibName: "TextCollectionViewCell", bundle: nil)
        self.listCollectionView.register(textXib, forCellWithReuseIdentifier: "textCell")
        
        // 合計を計算するためのタイマーをセット
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {(timer) in
            // 品名の列のデータごとに計算する
            self.nameData.enumerated().forEach({ (value) in
                // dataの添字の数
                let index = value.offset
                
                // 添字の数+1行目の単価のセルのIndexPathを計算
                let indexPathOneMoney = IndexPath(row: index*4+5, section: 0)
                // 上で計算したIndexPathのセルを取得（単価のセル）
                guard let oneMoneyCell = self.listCollectionView.cellForItem(at: indexPathOneMoney) as? TextCollectionViewCell else {
                    // なければ終了
                    return
                }
                // 単価のセルのtextFieldの中身を取得
                let oneMoney = oneMoneyCell.textField.text
                
                // 添字の数+1行目の個数のセルのIndexPathを計算
                let indexPathNumber = IndexPath(row: index*4+6, section: 0)
                // 上で計算したIndexPathのセルを取得（個数のセル）
                guard let numberCell = self.listCollectionView.cellForItem(at: indexPathNumber) as? TextCollectionViewCell else {
                    // なければ終了
                    return
                }
                // 個数のセルのtextFieldの中身を取得
                let number = numberCell.textField.text
                
                // 単価のセルのtextFieldまたは個数のセルのtextFieldに何も入力されてなければ、合計は0
                // 単価のセルのtextFieldまたは個数のセルのtextFieldに入力されてる場合は、合計を計算する
                if number == "" || oneMoney == "" {
                    // 合計金額は0
                    self.amountMoneyData[index] = 0
                }
                else {
                    // 合計金額は、個数x単価
                    self.amountMoneyData[index] = Int(number!)! * Int(oneMoney!)!
                }
                
                // 添字の数+1行目の合計金額のセルのIndexPathを計算
                let indexPathAmount = IndexPath(row: index*4+7, section: 0)
                // 添字の数+1行目の合計金額のセルのデータを更新
                self.listCollectionView.reloadItems(at: [indexPathAmount])
            })
        }
    }
    
    // listCollectionViewとの相談
    // セクションの数どうする？
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // セルの数どうする？
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count + nameData.count*4
    }
    
    // セルの中身どうする？
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 0行目（0,1,2,3番目のセル）は、dataの項目を入力していく
        if indexPath.row < 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuCollectionViewCell
            cell.menuLabel.text = data[indexPath.row]
            return cell
        }
        
        // 列を計算する
        let column = indexPath.row % 4
        // 行を計算する
        let index = Int(indexPath.row/4) - 1
        switch column {
        case 0:
            // 0列目は品名を入力
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuCollectionViewCell
            cell.menuLabel.text = nameData[index]
            return cell
        case 1:
            // 1列目は単価を入力するセル
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textCell", for: indexPath) as! TextCollectionViewCell
            return cell
        case 2:
            // 2列目は個数を入力するセル
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textCell", for: indexPath) as! TextCollectionViewCell
            return cell
        default:
            // 3列目は合計を入力する
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textCell", for: indexPath) as! TextCollectionViewCell
            cell.textField.text = String(describing: amountMoneyData[index])
            return cell
        }
    }
    
    // セルのサイズはどうするぅ？
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 列を計算する
        let mod = indexPath.row % 4
        // セルの横幅の変数
        var width: CGFloat = 0.0
        switch mod {
        case 0:
            width = self.widthFirst
        case 1:
            width = self.widthSecond
        case 2:
            width = self.widthThird
        default:
            width = self.view.frame.size.width - widthFirst - widthSecond - widthThird
        }
        return CGSize(width: width, height: 40)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

