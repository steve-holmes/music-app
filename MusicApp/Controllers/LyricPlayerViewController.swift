//
//  LyricPlayerViewController.swift
//  MusicApp
//
//  Created by HungDo on 8/9/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class LyricPlayerViewController: UIViewController, PlayerChildViewController {
    
    
    // MARK: Models
    
    var lyrics: [String] = [
        "Anh xa nhớ anh có khoẻ không",
        "Em lâu lắm không viết thư tay",
        "Đầu thư em chẳng biết nói gì",
        "Ngoài câu em ở đây",
        "Nhớ anh vơi đầy",
        "",
        "Anh hãy cứ yên tâm công tác",
        "Em da diết thuỷ chung một lòng",
        "Ngày em nghĩ về anh thật nhiều",
        "Để đêm đêm nằm mơ về anh",
        "",
        "Anh đi hoài đường xa",
        "Em vẫn chờ nơi ấy",
        "Em yêu lắm đấy",
        "Em thương lắm đấy",
        "Em lo cho anh nhiều đấy",
        "",
        "Mong đến ngày gặp nhau",
        "[01:10.05]Dẫu cách trở bao lâu",
        "[01:13.81]Mua bao thuốc lá",
        "[01:15.81]Mua dăm gói bánh",
        "[01:17.91]Anh sang thưa chuyện",
        "[01:19.72]Cùng em nghe anh",
        "[01:24.96]",
        "[02:01.90]Anh xa nhớ anh có khoẻ không",
        "[02:05.98]Em lâu lắm không viết thư tay",
        "[02:09.99]Đầu thư em chẳng biết nói gì",
        "[02:13.07]Ngoài câu em ở đây",
        "[02:14.61]Nhớ anh vơi đầy",
        "[02:16.96]",
        "[02:18.15]Anh hãy cứ yên tâm công tác",
        "[02:22.27]Em da diết thuỷ chung một lòng",
        "[02:26.30]Ngày em nghĩ về anh thật nhiều",
        "[02:29.40]Để đêm đêm nằm mơ về anh",
        "[02:33.21]",
        "[02:35.47]Anh đi hoài đường xa",
        "[02:39.53]Em vẫn chờ nơi ấy",
        "[02:43.36]Em yêu lắm đấy",
        "[02:45.34]Em thương lắm đấy",
        "[02:47.39]Em lo cho anh nhiều đấy",
        "[02:50.58]",
        "[02:51.77]Mong đến ngày gặp nhau",
        "[02:55.82]Dẫu cách trở bao lâu",
        "[02:59.52]Mua bao thuốc lá",
        "[03:01.68]Mua dăm gói bánh",
        "[03:03.61]Anh sang thưa chuyện",
        "[03:05.45]Cùng em nghe anh",
        "[03:09.50]",
        "[03:12.12]Anh đi hoài đường xa",
        "[03:16.18]Em vẫn chờ nơi ấy",
        "[03:19.90]Yêu xa khó lắm",
        "[03:21.96]Yêu xa nhớ lắm",
        "[03:24.03]Yêu xa cô đơn nhiều lắm",
        "[03:27.59]",
        "[03:28.34]Mong đến ngày gặp nhau",
        "[03:32.39]Dẫu cách trở bao lâu",
        "[03:36.18]Mua bao thuốc lá",
        "[03:38.22]Mua dăm gói bánh",
        "[03:40.31]Anh sang thưa chuyện",
        "[03:42.19]Cùng em nghe anh",
        "[03:46.40]"
    ]
    
    var lyricTimes: [(minute: Int, second: Int, milisecond: Int)] = [
        // 01 - 10
        (00,16,16), (00,20,21), (00,24,22), (00,27,35), (00,28,84), (00,31,19), (00,32,38), (00,36,50), (00,40,53), (00,43,63),
        // 11 - 20
        (00,47,44), (00,49,70), (00,53,76), (00,57,59), (00,59,57), (01,01,67), (01,06,00), (01,10,05), (01,13,81), (01,15,81),
        // 21 - 30
        (01,17,91), (01,19,72), (01,24,96), (02,01,90), (02,05,98), (02,09,99), (02,13,07), (02,14,61), (02,16,96), (02,18,15),
        // 31 - 40
        (02,22,27), (02,26,30), (02,29,40), (02,33,21), (02,35,47), (02,39,53), (02,43,36), (02,45,34), (02,47,39), (02,50,58),
        // 41 - 50
        (02,51,77), (02,55,82), (02,59,52), (03,01,68), (03,03,61), (03,05,45), (03,09,50), (03,12,12), (03,16,18), (03,19,90),
        // 51 - 60
        (03,21,96), (03,24,03), (03,27,59), (03,28,34), (03,32,39), (03,36,18), (03,38,22), (03,40,31), (03,42,19), (03,46,40)
    ]
    
    var selectedLyricIndex: Int = -1
    
    // MARK: Outlets
    
    @IBOutlet private weak var lyricTableView: UITableView!
    
    // MARK: Actions
    
    @IBAction func scrollEnabledButtonTapped() {
        print(#function)
    }
    
    // MARK: - Delegation
    
    var delegate: PlayerChildViewControllerDelegate?
    
    // MARK: Gesture Recognizer
    
    func performSwipeGestureRecognizer(gestureRecognizer: UISwipeGestureRecognizer) {
        self.delegate?.playerChildViewController(self, didRecognizeBySwipeGestureRecognizer: gestureRecognizer)
    }
    
    func performPanGestureRecognzier(gestureRecognizer: UIPanGestureRecognizer) {
        self.delegate?.playerChildViewController(
            self,
            options: PlayerChildViewControllerPanGestureRecognizerDirection.Right,
            didRecognizeByPanGestureRecognizer: gestureRecognizer
        )
    }
    
    // MARK: View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lyricTableView.dataSource = self
        lyricTableView.delegate = self
        
        lyricTableView.rowHeight = UITableViewAutomaticDimension
        lyricTableView.estimatedRowHeight = 20
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(performSwipeGestureRecognizer(_:)))
        swipeGestureRecognizer.direction = .Right
        self.view.addGestureRecognizer(swipeGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(performPanGestureRecognzier(_:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    // MARK: Timer
    
    private var timer: NSTimer?
    
    private var timerCount = -1
    
    private var timerDurationPerScheduledTimer: NSTimeInterval {
        if timerCount == -1 {
            let lyricTime = lyricTimes[0]
            return NSTimeInterval(lyricTime.minute * 60 + lyricTime.second) + NSTimeInterval(Float(lyricTime.milisecond) / 100.0)
        }
        
        let startTimeTuple = lyricTimes[timerCount]
        let endTimeTuple = lyricTimes[timerCount + 1]
        
        let startTime = NSTimeInterval(startTimeTuple.minute * 60 + startTimeTuple.second) + NSTimeInterval(Float(startTimeTuple.milisecond) / 100.0)
        let endTime = NSTimeInterval(endTimeTuple.minute * 60 + endTimeTuple.second) + NSTimeInterval(Float(endTimeTuple.milisecond) / 100.0)
        
        return endTime - startTime
    }
    
    func setupTimer() {
        guard lyrics.count > 1 else { return }
        timerCount = selectedLyricIndex
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(timerDurationPerScheduledTimer, target: self, selector: #selector(executeTimer(_:)), userInfo: nil, repeats: false)
    }
    
    func executeTimer(timer: NSTimer) {
        timerCount += 1
        if timerCount == lyrics.count {
            stopTimer()
        }
        
        let indexPath = NSIndexPath(forRow: timerCount, inSection: 0)
        lyricTableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Middle)
        self.tableView(lyricTableView, didSelectRowAtIndexPath: indexPath)
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(timerDurationPerScheduledTimer, target: self, selector: #selector(executeTimer(_:)), userInfo: nil, repeats: false)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

}

// MARK: UITableViewDataSource

extension LyricPlayerViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lyrics.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellsIdentifier.LyricPlayerTableCell, forIndexPath: indexPath)
        
        if let lyricCell = cell as? LyricPlayerTableViewCell {
            lyricCell.lyric = lyrics[indexPath.row]
            
            lyricCell.delegate = nil
            if self.selectedLyricIndex == indexPath.row {
                lyricCell.lyricStyle = .Bold
            } else {
                lyricCell.lyricStyle = .Regular
            }
            
            lyricCell.delegate = self
        }
        
        return cell
    }
    
}

// MARK: UITableViewDegegate

extension LyricPlayerViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? LyricPlayerTableViewCell {
            switch cell.lyricStyle {
            case .Bold:
                cell.lyricStyle = .Regular
            case .Regular:
                cell.lyricStyle = .Bold
            default:
                break
            }
        }
    }
    
}

// MARK: LyricPlayerTableViewCellDelegate

extension LyricPlayerViewController: LyricPlayerTableViewCellDelegate {
    
    func lyricPlayerCell(lyricCell: LyricPlayerTableViewCell, didSelectLyricFontStyle lyricFontStyle: LyricPlayerFontStyle) {
        if let lyricCellIndexPath = self.lyricTableView.indexPathForCell(lyricCell) {
            switch lyricFontStyle {
            case .Bold where self.selectedLyricIndex == -1:
                self.selectedLyricIndex = lyricCellIndexPath.row
            case .Bold:
                self.lyricPlayerTableView(self.lyricTableView, onLyricPlayerCell: lyricCell, changeFromRow: self.selectedLyricIndex, toRow: lyricCellIndexPath.row)
            case .Regular where self.selectedLyricIndex != -1:
                self.lyricPlayerTableView(self.lyricTableView, onLyricPlayerCell: lyricCell, changeFromRow: self.selectedLyricIndex, toRow: -1)
            default:
                break
            }
        }
    }
    
    private func lyricPlayerTableView(lyricPlayerTableView: UITableView,onLyricPlayerCell lyricPlayerCell: LyricPlayerTableViewCell, changeFromRow fromRow: Int, toRow: Int) {
        lyricPlayerCell.delegate = nil
        if let previousCell = lyricPlayerTableView.cellForRowAtIndexPath(NSIndexPath(forRow: fromRow, inSection: 0)) as? LyricPlayerTableViewCell {
            previousCell.lyricStyle = .Regular
        }
        lyricPlayerCell.delegate = self
        
        self.selectedLyricIndex = toRow
    }
    
}