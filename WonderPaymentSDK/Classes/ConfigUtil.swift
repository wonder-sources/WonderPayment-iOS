//
//  ConfigUtil.swift
//  Pods
//
//  Created by X on 2024/12/26.
//

class ConfigUtil {
    static func getConfigData(
        useCache:Bool = true,
        completion: @escaping (NSDictionary?, ErrorMessage?) -> Void
    ) {
        
        let configFile = "config.data"
        if useCache, let content = DiskCache.shared.getFileContent(configFile) {
            let json = DynamicJson.from(content)
            let updateAt = json["update_at"].int ?? 0
            let now = Int(Date().timeIntervalSince1970)
            let expired = updateAt + 24*3600 < now
            if (!expired) {
                completion(json.value as? NSDictionary, nil)
                return
            }
        }
        
        PaymentService.getSDKConfig { data, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            completion(data, nil)
            
            let dic = NSMutableDictionary(dictionary: data)
            let now = Int(Date().timeIntervalSince1970)
            dic["update_at"] = now
            if let data = try? JSONSerialization.data(withJSONObject: dic),
                let content = String(data: data, encoding: .utf8) {
                DiskCache.shared.writeFile(configFile, content: content)
            }
            
        }
    }
}
