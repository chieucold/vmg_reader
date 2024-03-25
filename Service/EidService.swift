//
//  ApiService.swift
//  eidsdk
//
//  Created by zach on 26/06/2023.
//

import Foundation

public let EIDSERVICE = EidService.shared

public class EidService {
    public static var shared: EidService = EidService()
    
    public static var EID_PROTOCOL = "https"
    public static var EID_HOSTNAME = "api-sandbox.gwork.vn";

    private static var EID_VERIFY_ENDPOINT = "/eid_verify/sdk/verify";
    private static var HEADER_X_API_KEY = "x-api-key";
    
    private var network: NetworkService?
    
    private init() {
    }
    
    public func initialize(apiKey: String) {
        self.network = NetworkService(proto: EidService.EID_PROTOCOL, hostname: EidService.EID_HOSTNAME, customHeaders: [EidService.HEADER_X_API_KEY: apiKey])
    }
    
    public func initialize(apiKey: String, apiBaseUrl: String) {
        self.network = NetworkService(proto: EidService.EID_PROTOCOL, hostname: apiBaseUrl, customHeaders: [EidService.HEADER_X_API_KEY: apiKey])
    }
        
    public func verifyEid(path: String, idCard: String, dsCert: String, deviceType: String, province: String, code: String, completion: @escaping (Result<EidVerifyModel, Error>) -> Void) {
        
        var parameters = [String: Any]()
        parameters["id_card"] = idCard
        parameters["ds_cert"] = dsCert
        parameters["device_type"] = deviceType
        parameters["province"] = province
        parameters["code"] = code
        
        network?.post(path: path == "" ? EidService.EID_VERIFY_ENDPOINT : path, parameters: parameters, completion: completion)
    }
}
