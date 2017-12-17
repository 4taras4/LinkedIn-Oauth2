//
//  WebOauthViewController.swift
//  LinkedIn-Oauth
//
//  Created by Taras on 12/15/17.
//  Copyright © 2017 Taras. All rights reserved.
//

import UIKit

class WebOauthViewController: UIViewController,UIWebViewDelegate {
    let webView:UIWebView = UIWebView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
    //linkedIn Api Key
    let linkedInKey = ""
    //State some uniq identifier for get login code
    let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
    // LinkedIn secret token
    let linkedInSecret = ""
    
    let authorizationEndPoint = "https://www.linkedin.com/oauth/v2/authorization"
    
    let accessTokenEndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        
        webView.delegate = self
        startAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startAuthorization() {
        let responseType = "code"
        //your redirect url, DON'T forget add this to developer portal Oauth2 section
        let redirectURL = "http://localhost".addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        
        let scope = "r_basicprofile,r_emailaddress"
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(linkedInKey)&"
        authorizationURL += "redirect_uri=\(redirectURL)&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"
        
        // logout already logined user or revoke tokens
        logout()
        
        // Create a URL request and load it in the web view.
        let request = URLRequest(url: URL(string: authorizationURL)!)
        print(authorizationURL)
        
        webView.loadRequest(request)
        
        
    }
    
    func logout(){
        let revokeUrl = "https://api.linkedin.com/uas/oauth/invalidateToken"
        let request = URLRequest(url: URL(string: revokeUrl)! as URL)
        webView.loadRequest(request)
    }
    
    
    func webView(_ webView: UIWebView,shouldStartLoadWith request: URLRequest,navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url!
        // catch oauth code and state, state should bee like your send state
        if url.host == "localhost" {
            if url.absoluteString.range(of:"code") != nil {
                let urlParts = url.absoluteString.components(separatedBy:"?")
                let code = urlParts[1].components(separatedBy:"=")[1]
                print("Code:", String(code.dropLast(6)))
                //Url code only for get auth token
                requestForAccessToken(authorizationCode:String(code.dropLast(6) ))
            }
        }
        return true
    }
    
    
    func  requestForAccessToken(authorizationCode:String) {
        let grantType = "authorization_code"
        //Enter redirect url here
        let redirectURL = "http://localhost".addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        // Set the POST parameters.
        var postParams = "grant_type=\(grantType)&"
        postParams += "code=\(authorizationCode)&"
        postParams += "redirect_uri=\(redirectURL)&"
        postParams += "client_id=\(linkedInKey)&"
        postParams += "client_secret=\(linkedInSecret)"
        
        
        let postData = postParams.data(using: String.Encoding.utf8)
        
        let request = NSMutableURLRequest(url: URL(string: accessTokenEndPoint)! as URL)
        
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            // Get the HTTP status code of the request.
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("Status code", statusCode)
            if statusCode == 200 {
                // Convert the received JSON data into a dictionary.
                do {
                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                    print("dataDictionary\(dataDictionary)")
                    let accessToken = dataDictionary["access_token"] as! String
                    // Now you get access token and you can use it for get profile info and other operations
                    UserDefaults.standard.set(accessToken, forKey: "LIAccessToken")
                    UserDefaults.standard.synchronize()
                    print("START sentData")
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                } catch {
                    print("Could not convert JSON data into a dictionary.")
                }
            } else {
                print("cancel clicked")
            }
        }
        task.resume()
    }
    

}
