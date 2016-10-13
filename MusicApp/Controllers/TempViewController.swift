//
//  TempViewController.swift
//  MusicApp
//
//  Created by HungDo on 10/13/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import UIKit

class TempViewController: UIViewController {
    
    let session = URLSession.shared
    let baseURL = "http://localhost:3000/songs"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSongs()
        getSongById(1)
        getSongs(title: "Samsung")
    }
    
    private func getData(url: URL) {
        let request = URLRequest(url: url)
        session.dataTask(with: request) { (data, response, error) in
            print(#function)
            guard let rawData = data else { return }
            do {
                let jsonData = try JSONSerialization.jsonObject(with: rawData, options: .allowFragments)
                print(jsonData)
            } catch {}
            }.resume()
    }
    
    private func getSongs() {
        let url = URL(string: baseURL)!
        getData(url: url)
    }
    
    private func getSongById(_ id: Int) {
        let url = URL(string: baseURL + "/\(id)")!
        getData(url: url)
    }
    
    private func getSongs(title: String) {
        let url = URL(string: baseURL + "/title/\(title)")!
        getData(url: url)
    }

}
