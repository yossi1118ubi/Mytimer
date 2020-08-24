//
//  ViewController.swift
//  Mytimer
//
//  Created by Daichi Yoshikawa on 2020/07/08.
//  Copyright © 2020 Daichi Yoshikawa. All rights reserved.
//

import UIKit
//AVAudioを利用する
import AVFoundation

class ViewController: UIViewController {
    
    //タイマーの変数を作成
    var timer : Timer?
    
    //カウント(経過時間)の変数を作成
    var count = 0
    
    //設定値を扱うキーを設定
    let settingKey = "timer_value"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //UserDefaultsのインスタンスを生成
        let settings = UserDefaults.standard
        
        //UserDefaultsに初期値を登録
        settings.register(defaults: [settingKey:10])
    }
    
    //音楽のパスを設定
    let musicPath = Bundle.main.bundleURL.appendingPathComponent("backmusic.mp3")
    
    var musicPlayer = AVAudioPlayer()
    
    
    @IBOutlet weak var countDownLable: UILabel!
    
    @IBAction func settingButtonAction(_ sender: Any) {
        //timerをアンラップしてnowTimerに代入
        if let nowTimer = timer{
            //もしタイマーが実行中だったら停止
            if nowTimer.isValid == true{
                //タイマー停止
                nowTimer.invalidate()
            }
        }
        //画面遷移を行う
        //senderはデータの受け渡しに利用する
        performSegue(withIdentifier: "goSetting", sender: nil)
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        //timerをアンラップしてnowTimerに代入
        if let nowTimer = timer{
            //もしタイマーが, 実行中だったらスタートしない
            if nowTimer.isValid == true {
                //何もしない
                return
            }
        }
        //タイマーをスタート
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerInterrupt(_:)),userInfo: nil, repeats: true)
    }
    
    @IBAction func StopbuttonAction(_ sender: Any) {
        //timerをアンラップしてnowTimerに代入
        if let nowTimer = timer{
            //もしタイマーが実行中だったら停止
            if nowTimer.isValid == true{
                //タイマー停止
                nowTimer.invalidate()
            }
        }
    }
    
    //画面の更新をする(戻り値: remainCount:残り時間)
    func displayUpdata() ->Int{
        
        //Userdefaultsのインスタンスを生成
        let settings = UserDefaults.standard
        //取得した秒数をtimerValueに渡す
        let timerValue = settings.integer(forKey: settingKey)
        //残り時間(remainCount)を生成
        let remainCount = timerValue - count
        
        //remainCount(残り時間)をラベルに表示
        //ラベルにテキストを表示するには, IBOUTletで関係付けをして, 付けた名前に.textを付けて代入する
        countDownLable.text = "残り \(remainCount)秒"
        
        //残り時間を戻り値に設定
        return remainCount
    }
    
    //@objcはOjbect-cのコード(Timerクラス)を使うので必要になる.
    @objc func timerInterrupt(_ timer:Timer){
        
        //count(経過時間)に+1していく
        count+=1
        
        //remainCount(残り時間)が0以下の時, タイマーを止める
        if displayUpdata() <=  0{
            
            //初期化処理
            count = 0
            //タイマー停止
            timer.invalidate()
            
            do{
                musicPlayer = try AVAudioPlayer(contentsOf: musicPath, fileTypeHint: nil)
                
                musicPlayer.play()
            }catch{
                print("音楽を再生できませんでした")
            }
            
            
            
            //ダイアログを作成
            let alertController = UIAlertController(title: "終了", message: "タイマー終了時間です", preferredStyle: .alert)
            
            //ダイアログに表示させるOK簿rたんを作成
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                self.musicPlayer.stop()
            })
            
            //アクションを追加
            alertController.addAction(defaultAction)
            
            //ダイアログの表示
            present(alertController, animated: true, completion: nil)
            
        }
    }
    
    // viewDidAppearは定義している画面が表示されるたびに実行される
    //対して, viewDidLoadは最初に一回だけ呼ばれる
    override func viewDidAppear(_ animated: Bool) {
        //カウント(経過時間)をぜろにする
        count = 0
        
        //タイマーの表示を更新する
        //利用しない変数は _ で受け取る
        _ = displayUpdata()
    }
    
}

