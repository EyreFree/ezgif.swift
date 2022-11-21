//
//  ViewController.swift
//  ezgif.swift
//
//  Created by EyreFree on 11/22/2022.
//  Copyright (c) 2022 EyreFree. All rights reserved.
//

import UIKit
import WebKit
import EFFoundation
import ezgif

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let imageTodoUrl: String = "https://img.zcool.cn/community/01639c586c91bba801219c77f6efc8.gif"
        Ezgif.shared.optimize(imageUrl: imageTodoUrl) { newFileUrl, error in
            if let error = error {
                printLog("Ezgif.shared.optimize error: \(error.localizedDescription)")
            } else {
                printLog("Ezgif.shared.optimize newFileUrl: \(newFileUrl ?? "")")
            }
        }
    }
}
