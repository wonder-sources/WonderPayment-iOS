
struct DynamicJson {
    var value: Any?
    
    static func from(_ string: String) -> DynamicJson {
        if let data = string.data(using: .utf8) {
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return DynamicJson(value: json)
        }
        return DynamicJson(value: nil)
    }
    
    subscript (key: String) -> DynamicJson {
        if let dic = value as? NSDictionary {
            return DynamicJson(value: dic[key])
        }
        return DynamicJson(value: nil)
    }
    
    subscript (index: Int) -> DynamicJson {
        if let arr = value as? NSArray {
            if index < arr.count {
                return DynamicJson(value: arr[index])
            }
        }
        return DynamicJson(value: nil)
    }
    
    var string: String? {
        return value as? String
    }
    
    var int: Int? {
        return value as? Int
    }
    
    var double: Double? {
        return value as? Double
    }
    
    var bool: Bool? {
        return value as? Bool
    }
}

