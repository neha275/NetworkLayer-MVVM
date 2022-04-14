//
//  DataModel.swift
//  ApiRequest
//
//  Created by Neha Gupta on 31/07/21.
//

import Foundation


class DataModel {
    
    func registerUserWithEncodableProtocol()
    {
        //code to register user
        //let registrationUrl = URL(string: Endpoint.registerUser)
        let devURl = "https://3m9iil4wu8.execute-api.ap-southeast-2.amazonaws.com/Dev/bridge/"
        let loginnUrl = URL(string: devURl)

        let request:  [String: Any] = ["user_id": "2f1861bf-7347-4e66-a799-3670b713ec2d"]
        // UserLoginRequest(email: "vegeta@yopmail.com", password: "Qwerty@1", portal: "MOBILE" )

        do {

            let encodedRequest = try JSONSerialization.data(withJSONObject: request)
            NetworkManager.postData(requestUrl: loginnUrl!, requestBody: encodedRequest,resultType: UserLoginResponse.self, completionHandler:  { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                       print(response)
                    }
                    //completionHandler(true,String(), response)
                    break
                case .failure(let err):
                    print(err)
                    //completionHandler(false,err.localizedDescription, nil)
                }
            })
            
            

        } catch let error {

            debugPrint("error = \(error.localizedDescription)")
        }

    }
    
//    func GetList () {
//        let devURl = "https://authdev.stircrazykids.com.au/graphql"
//        let allergyURL = URL(string: "\(devURl)/login")
//        do {
//            NetworkManager.fetchData(requestUrl: allergyURL,resultType: <#T##T.Type#> ,completionHandler: {result in
//
//            })
//        }
//    }

}



struct UserData: Decodable {
    let name, email, id, joining: String
}

struct UserLoginRequest : Encodable
{
    let email, password, portal: String

    enum CodingKeys: String, CodingKey {
        case email = "email"
        case password = "password"
        case portal = "portal"
    }
}

struct UserLoginResponse: Decodable {
    let errorMessage: String
    let data: UserData
}
