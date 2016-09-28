//
//  ViewController.swift
//  KituraClient
//
//  Created by Siavash Abbasalipour on 26/9/16.
//  Copyright © 2016 MobileDen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var output: UILabel!
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backEndTap(_ sender: UIButton) {
        let session = URLSession.shared
        let url = URL(string: "https://microservice1.mybluemix.net/\(input.text ?? "hello")")
        guard let safeURL = url else {
            print("ERRRRR")
            return
        }
        session.dataTask(with: safeURL) { (data, response, err) in
            if err == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    DispatchQueue.main.async {
                        self.output.text = "\(json)"
                    }
                } catch let error {
                    print("err! \(error)")
                }
            } else {
                print(err?.localizedDescription)
            }
        }.resume()
    }
    
    @IBAction func serviceTwoTap(_ sender: UIButton) {
        
        let session = URLSession.shared
        let url = URL(string: "https://microservice2.mybluemix.net/\(input.text ?? "hello")")
        guard let safeURL = url else {
            print("ERRRRR")
            return
        }
        session.dataTask(with: safeURL) { (data, response, err) in
            if err == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    DispatchQueue.main.async {
                        self.output.text = "\(json)"
                    }
                } catch let error {
                    print("err! \(error)")
                }
            } else {
                print(err?.localizedDescription)
            }
            }.resume()
    }

    @IBAction func addToPostgreSQL(_ sender: UIButton) {
        let url = URL(string: "https://microservice1.mybluemix.net/addtodb")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let json = ["fname":fname.text!,"lname":lname.text!]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            /// insert json data to the request
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, err) in
                if err == nil {
                    print(response)
                    do {
                        let j = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        print("DATA:\(j)")
                    } catch _ {
                        
                    }
                } else {
                    print("ERERERERERE\(response)")
                }
            }).resume()
        } catch let err {
            print("ERRR!\(err)")
        }

        
    }
}

