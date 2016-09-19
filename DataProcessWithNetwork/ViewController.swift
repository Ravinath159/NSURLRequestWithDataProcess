//
//  ViewController.swift
//  DataProcessWithNetwork
//
//  Created by Narendra Kumar on 9/19/16.
//  Copyright © 2016 Narendra Kumar. All rights reserved.
//

/*
 {
 address: "635 Interborough Parkway, Goldfield, Marshall Islands, 5493",
 phone: "+1 (964) 487-3589",
 email: "oneal.crosby@tri@tribalog.org",
 company: "TRI@TRIBALOG",
 name: {
 last: "Crosby",
 first: "Oneal"
 },
 eyeColor: "green",
 age: 39,
 picture: "http://placehold.it/32x32",
 balance: "$2,993.28",
 isActive: false,
 guid: "60338afc-22c8-4a72-8f4c-df11ed5943d9",
 index: 0,
 _id: "57df83f3803d2743fac6a670"
 }
 */



import UIKit


class User {
    var adderess: String?
    var phone: String?
    var email: String?
    var comapny: String?
    var firstName: String?
    var lastName: String?
}


class ViewController: UIViewController {

    var users:[User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData("http://beta.json-generator.com/api/json/get/Nymzmud3-") { (responseDict, error) in
            print(responseDict)
            if let data = responseDict?["data"] as? [Dictionary<String,AnyObject>] {
                
                for(_, value) in data.enumerate() {
                  let user = User()
                    user.adderess = value["address"] as? String ?? ""
                    user.phone = value["phone"] as? String ?? ""
                    user.email = value["email"] as? String ?? ""
                    user.comapny = value["company"] as? String ?? ""
                    if let name = value["name"] as? Dictionary<String,String> {
                        user.firstName = name["first"]
                        user.lastName = name["last"]
                    }
                    self.users.append(user)
                    dispatch_async(dispatch_get_main_queue(), { 
                        //UI operations
                    })
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData(urlString : String, completion: (NSDictionary?,NSError?) ->Void ){
        let sharedSession = NSURLSession.sharedSession()
        if let url = NSURL(string: urlString) {
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            
            let task = sharedSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                if error == nil && data != nil {
                    //success
                    do {
                        if let responseJSON : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: []) {
                            print(responseJSON)
                             if responseJSON is NSDictionary{
                                completion(responseJSON as? NSDictionary,nil)
                             }else{
                                let dict : NSDictionary = ["data":responseJSON!]
                                completion(dict,nil)
                            }
                            
                        }else{
                            completion(nil,nil)

                        }
  
                    }catch{
                        completion(nil,NSError(domain: "HttpResponseErrorDomain", code: 401, userInfo: nil))
                    }
                    
                    }else{
                    //fail
                    completion(nil,error)
                }
            })
            
            task.resume()
        }
        
    }
    
}

