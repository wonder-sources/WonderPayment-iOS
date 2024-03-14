struct CountryItem: JSONDecodable {  // <-- here
    let countryName: String
    let alpha2: String
    let callingCode: String
    
    enum CodingKeys: String, CodingKey {
        case countryName = "country_name"
        case alpha2 = "alpha_2"
        case callingCode = "calling_code"
    }
    
    static func from(json: NSDictionary?) -> CountryItem {
        let dynamicJson = DynamicJson(value: json)
        let locale = WonderPayment.paymentConfig.locale.rawValue
        let nameItem = dynamicJson["translations"].array.first(where: {
            $0["languages_code"].string == locale
        })
        let countryName = nameItem?["country_name"].string ?? ""
        let alpha2 = dynamicJson["alpha_2"].string ?? ""
        let callingCode = dynamicJson["calling_code"].string ?? ""
        
        return CountryItem(countryName: countryName, alpha2: alpha2, callingCode: callingCode)
    }
    
}


class CountryData {
    
    static var get: [CountryItem]? {
        let data = CountryData().data.data(using: .utf8)!
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
            return CountryItem.from(jsonArray: json as? NSArray)
        }
        
        return nil
    }
    
    lazy var data =
"""
[
  {
    "country_name": "Afghanistan",
    "alpha_2": "AF",
    "alpha_3": "AFG",
    "nationality": "Afghan",
    "calling_code": "93",
    "country_image": null,
    "translations": [
      {
        "id": 600,
        "country_codes_alpha_2": "AF",
        "languages_code": "en-US",
        "country_name": "Afghanistan",
        "nationality": "Afghan"
      },
      {
        "id": 601,
        "country_codes_alpha_2": "AF",
        "languages_code": "zh-CN",
        "country_name": "阿富汗",
        "nationality": "阿富汗"
      },
      {
        "id": 692,
        "country_codes_alpha_2": "AF",
        "languages_code": "zh-HK",
        "country_name": "阿富汗",
        "nationality": "阿富汗"
      }
    ]
  },
  {
    "country_name": "Albania",
    "alpha_2": "AL",
    "alpha_3": "ALB",
    "nationality": "Albanian",
    "calling_code": "355",
    "country_image": null,
    "translations": [
      {
        "id": 955,
        "country_codes_alpha_2": "AL",
        "languages_code": "en-US",
        "country_name": "Albania",
        "nationality": "Albanian"
      },
      {
        "id": 759,
        "country_codes_alpha_2": "AL",
        "languages_code": "zh-HK",
        "country_name": "阿爾巴尼亞共和國",
        "nationality": "阿爾巴尼亞"
      },
      {
        "id": 954,
        "country_codes_alpha_2": "AL",
        "languages_code": "zh-CN",
        "country_name": "阿尔巴尼亚共和国",
        "nationality": "阿尔巴尼亚"
      }
    ]
  },
  {
    "country_name": "Algeria",
    "alpha_2": "DZ",
    "alpha_3": "DZA",
    "nationality": "Algerian",
    "calling_code": "213",
    "country_image": null,
    "translations": [
      {
        "id": 163,
        "country_codes_alpha_2": "DZ",
        "languages_code": "zh-CN",
        "country_name": "阿尔及利亚",
        "nationality": "阿尔及利亚"
      },
      {
        "id": 162,
        "country_codes_alpha_2": "DZ",
        "languages_code": "en-US",
        "country_name": "Algeria",
        "nationality": "Algerian"
      },
      {
        "id": 642,
        "country_codes_alpha_2": "DZ",
        "languages_code": "zh-HK",
        "country_name": "阿爾及利亞",
        "nationality": "阿爾及利亞"
      }
    ]
  },
  {
    "country_name": "American Samoa",
    "alpha_2": "AS",
    "alpha_3": "ASM",
    "nationality": "American (American Samoa)",
    "calling_code": "1684",
    "country_image": null,
    "translations": [
      {
        "id": 882,
        "country_codes_alpha_2": "AS",
        "languages_code": "en-US",
        "country_name": "American Samoa",
        "nationality": "American (American Samoa)"
      },
      {
        "id": 881,
        "country_codes_alpha_2": "AS",
        "languages_code": "zh-CN",
        "country_name": "美属萨摩亚",
        "nationality": "美属萨摩亚"
      },
      {
        "id": 986,
        "country_codes_alpha_2": "AS",
        "languages_code": "zh-HK",
        "country_name": "美屬薩摩亞",
        "nationality": "美屬薩摩亞"
      }
    ]
  },
  {
    "country_name": "Andorra",
    "alpha_2": "AD",
    "alpha_3": "AND",
    "nationality": "Andorran",
    "calling_code": "376",
    "country_image": null,
    "translations": [
      {
        "id": 655,
        "country_codes_alpha_2": "AD",
        "languages_code": "zh-HK",
        "country_name": "安道爾",
        "nationality": "安道爾"
      },
      {
        "id": 263,
        "country_codes_alpha_2": "AD",
        "languages_code": "zh-CN",
        "country_name": "安道尔",
        "nationality": "安道尔"
      },
      {
        "id": 262,
        "country_codes_alpha_2": "AD",
        "languages_code": "en-US",
        "country_name": "Andorra",
        "nationality": "Andorran"
      }
    ]
  },
  {
    "country_name": "Angola",
    "alpha_2": "AO",
    "alpha_3": "AGO",
    "nationality": "Angolan",
    "calling_code": "244",
    "country_image": null,
    "translations": [
      {
        "id": 733,
        "country_codes_alpha_2": "AO",
        "languages_code": "zh-HK",
        "country_name": "安哥拉",
        "nationality": "安哥拉"
      },
      {
        "id": 199,
        "country_codes_alpha_2": "AO",
        "languages_code": "zh-CN",
        "country_name": "安哥拉",
        "nationality": "安哥拉"
      },
      {
        "id": 198,
        "country_codes_alpha_2": "AO",
        "languages_code": "en-US",
        "country_name": "Angola",
        "nationality": "Angolan"
      }
    ]
  },
  {
    "country_name": "Anguilla",
    "alpha_2": "AI",
    "alpha_3": "AIA",
    "nationality": "Anguillan",
    "calling_code": "1264",
    "country_image": null,
    "translations": [
      {
        "id": 861,
        "country_codes_alpha_2": "AI",
        "languages_code": "zh-CN",
        "country_name": "安圭拉",
        "nationality": "安圭拉"
      },
      {
        "id": 859,
        "country_codes_alpha_2": "AI",
        "languages_code": "zh-HK",
        "country_name": "安圭拉",
        "nationality": "安圭拉"
      },
      {
        "id": 860,
        "country_codes_alpha_2": "AI",
        "languages_code": "en-US",
        "country_name": "Anguilla",
        "nationality": "Anguillan"
      }
    ]
  },
  {
    "country_name": "Antarctica",
    "alpha_2": "AQ",
    "alpha_3": "ATA",
    "nationality": "Antarctica citizen",
    "calling_code": "672",
    "country_image": null,
    "translations": [
      {
        "id": 944,
        "country_codes_alpha_2": "AQ",
        "languages_code": "en-US",
        "country_name": "Antarctica",
        "nationality": "Antarctica citizen"
      },
      {
        "id": 742,
        "country_codes_alpha_2": "AQ",
        "languages_code": "zh-HK",
        "country_name": "南極洲",
        "nationality": "南極洲"
      },
      {
        "id": 943,
        "country_codes_alpha_2": "AQ",
        "languages_code": "zh-CN",
        "country_name": "南极洲",
        "nationality": "南极洲"
      }
    ]
  },
  {
    "country_name": "Antigua and Barbuda",
    "alpha_2": "AG",
    "alpha_3": "ATG",
    "nationality": "Antigua and Barbuda citizen",
    "calling_code": "1268",
    "country_image": null,
    "translations": [
      {
        "id": 879,
        "country_codes_alpha_2": "AG",
        "languages_code": "zh-CN",
        "country_name": "安提瓜和巴布达",
        "nationality": "安提瓜和巴布达"
      },
      {
        "id": 880,
        "country_codes_alpha_2": "AG",
        "languages_code": "en-US",
        "country_name": "Antigua and Barbuda",
        "nationality": "Antigua and Barbuda citizen"
      },
      {
        "id": 985,
        "country_codes_alpha_2": "AG",
        "languages_code": "zh-HK",
        "country_name": "安提瓜和巴布達",
        "nationality": "安提瓜和巴布達"
      }
    ]
  },
  {
    "country_name": "Argentina",
    "alpha_2": "AR",
    "alpha_3": "ARG",
    "nationality": "Argentine",
    "calling_code": "54",
    "country_image": null,
    "translations": [
      {
        "id": 307,
        "country_codes_alpha_2": "AR",
        "languages_code": "zh-CN",
        "country_name": "阿根廷",
        "nationality": "阿根廷"
      },
      {
        "id": 306,
        "country_codes_alpha_2": "AR",
        "languages_code": "en-US",
        "country_name": "Argentina",
        "nationality": "Argentine"
      },
      {
        "id": 732,
        "country_codes_alpha_2": "AR",
        "languages_code": "zh-HK",
        "country_name": "阿根廷",
        "nationality": "阿根廷"
      }
    ]
  },
  {
    "country_name": "Armenia",
    "alpha_2": "AM",
    "alpha_3": "ARM",
    "nationality": "Armenian",
    "calling_code": "374",
    "country_image": null,
    "translations": [
      {
        "id": 165,
        "country_codes_alpha_2": "AM",
        "languages_code": "zh-CN",
        "country_name": "亚美尼亚",
        "nationality": "亚美尼亚"
      },
      {
        "id": 164,
        "country_codes_alpha_2": "AM",
        "languages_code": "en-US",
        "country_name": "Armenia",
        "nationality": "Armenian"
      },
      {
        "id": 646,
        "country_codes_alpha_2": "AM",
        "languages_code": "zh-HK",
        "country_name": "亞美尼亞",
        "nationality": "亞美尼亞"
      }
    ]
  },
  {
    "country_name": "Aruba",
    "alpha_2": "AW",
    "alpha_3": "ABW",
    "nationality": "Dutch (Aruba)",
    "calling_code": "297",
    "country_image": null,
    "translations": [
      {
        "id": 184,
        "country_codes_alpha_2": "AW",
        "languages_code": "en-US",
        "country_name": "Aruba",
        "nationality": "Dutch (Aruba)"
      },
      {
        "id": 185,
        "country_codes_alpha_2": "AW",
        "languages_code": "zh-CN",
        "country_name": "阿鲁巴",
        "nationality": "阿鲁巴岛"
      },
      {
        "id": 686,
        "country_codes_alpha_2": "AW",
        "languages_code": "zh-HK",
        "country_name": "阿魯巴",
        "nationality": "阿魯巴島"
      }
    ]
  },
  {
    "country_name": "Australia",
    "alpha_2": "AU",
    "alpha_3": "AUS",
    "nationality": "Australian",
    "calling_code": "61",
    "country_image": null,
    "translations": [
      {
        "id": 557,
        "country_codes_alpha_2": "AU",
        "languages_code": "zh-CN",
        "country_name": "澳大利亚",
        "nationality": "澳大利亚"
      },
      {
        "id": 753,
        "country_codes_alpha_2": "AU",
        "languages_code": "zh-HK",
        "country_name": "澳大利亞",
        "nationality": "澳大利亞"
      },
      {
        "id": 556,
        "country_codes_alpha_2": "AU",
        "languages_code": "en-US",
        "country_name": "Australia",
        "nationality": "Australian"
      }
    ]
  },
  {
    "country_name": "Austria",
    "alpha_2": "AT",
    "alpha_3": "AUT",
    "nationality": "Austrian",
    "calling_code": "43",
    "country_image": null,
    "translations": [
      {
        "id": 177,
        "country_codes_alpha_2": "AT",
        "languages_code": "zh-CN",
        "country_name": "奥地利",
        "nationality": "奧地利"
      },
      {
        "id": 176,
        "country_codes_alpha_2": "AT",
        "languages_code": "en-US",
        "country_name": "Austria",
        "nationality": "Austrian"
      },
      {
        "id": 645,
        "country_codes_alpha_2": "AT",
        "languages_code": "zh-HK",
        "country_name": "奧地利",
        "nationality": "奧地利"
      }
    ]
  },
  {
    "country_name": "Azerbaijan",
    "alpha_2": "AZ",
    "alpha_3": "AZE",
    "nationality": "Azerbaijani",
    "calling_code": "994",
    "country_image": null,
    "translations": [
      {
        "id": 197,
        "country_codes_alpha_2": "AZ",
        "languages_code": "zh-CN",
        "country_name": "阿塞拜疆",
        "nationality": "阿塞拜疆"
      },
      {
        "id": 196,
        "country_codes_alpha_2": "AZ",
        "languages_code": "en-US",
        "country_name": "Azerbaijan",
        "nationality": "Azerbaijani"
      },
      {
        "id": 741,
        "country_codes_alpha_2": "AZ",
        "languages_code": "zh-HK",
        "country_name": "阿塞拜疆",
        "nationality": "阿塞拜疆"
      }
    ]
  },
  {
    "country_name": "Bahamas",
    "alpha_2": "BS",
    "alpha_3": "BHS",
    "nationality": "Bahamian",
    "calling_code": "1242",
    "country_image": null,
    "translations": [
      {
        "id": 917,
        "country_codes_alpha_2": "BS",
        "languages_code": "zh-CN",
        "country_name": "巴哈马",
        "nationality": "巴哈马"
      },
      {
        "id": 918,
        "country_codes_alpha_2": "BS",
        "languages_code": "en-US",
        "country_name": "Bahamas",
        "nationality": "Bahamian"
      },
      {
        "id": 988,
        "country_codes_alpha_2": "BS",
        "languages_code": "zh-HK",
        "country_name": "巴哈馬",
        "nationality": "巴哈馬"
      }
    ]
  },
  {
    "country_name": "Bahrain",
    "alpha_2": "BH",
    "alpha_3": "BHR",
    "nationality": "Bahraini",
    "calling_code": "973",
    "country_image": null,
    "translations": [
      {
        "id": 436,
        "country_codes_alpha_2": "BH",
        "languages_code": "en-US",
        "country_name": "Bahrain",
        "nationality": "Bahraini"
      },
      {
        "id": 437,
        "country_codes_alpha_2": "BH",
        "languages_code": "zh-CN",
        "country_name": "巴林",
        "nationality": "巴林"
      },
      {
        "id": 739,
        "country_codes_alpha_2": "BH",
        "languages_code": "zh-HK",
        "country_name": "巴林",
        "nationality": "巴林"
      }
    ]
  },
  {
    "country_name": "Bangladesh",
    "alpha_2": "BD",
    "alpha_3": "BGD",
    "nationality": "Bangladeshi",
    "calling_code": "880",
    "country_image": null,
    "translations": [
      {
        "id": 172,
        "country_codes_alpha_2": "BD",
        "languages_code": "en-US",
        "country_name": "Bangladesh",
        "nationality": "Bangladeshi"
      },
      {
        "id": 173,
        "country_codes_alpha_2": "BD",
        "languages_code": "zh-CN",
        "country_name": "孟加拉国",
        "nationality": "孟加拉国"
      },
      {
        "id": 737,
        "country_codes_alpha_2": "BD",
        "languages_code": "zh-HK",
        "country_name": "孟加拉國",
        "nationality": "孟加拉國"
      }
    ]
  },
  {
    "country_name": "Barbados",
    "alpha_2": "BB",
    "alpha_3": "BRB",
    "nationality": "Barbadian",
    "calling_code": "1246",
    "country_image": null,
    "translations": [
      {
        "id": 877,
        "country_codes_alpha_2": "BB",
        "languages_code": "zh-CN",
        "country_name": "巴巴多斯",
        "nationality": "巴巴多斯"
      },
      {
        "id": 878,
        "country_codes_alpha_2": "BB",
        "languages_code": "en-US",
        "country_name": "Barbados",
        "nationality": "Barbadian"
      },
      {
        "id": 992,
        "country_codes_alpha_2": "BB",
        "languages_code": "zh-HK",
        "country_name": "巴巴多斯",
        "nationality": "巴巴多斯"
      }
    ]
  },
  {
    "country_name": "Belarus",
    "alpha_2": "BY",
    "alpha_3": "BLR",
    "nationality": "Belarusian",
    "calling_code": "375",
    "country_image": null,
    "translations": [
      {
        "id": 298,
        "country_codes_alpha_2": "BY",
        "languages_code": "en-US",
        "country_name": "Belarus",
        "nationality": "Belarusian"
      },
      {
        "id": 299,
        "country_codes_alpha_2": "BY",
        "languages_code": "zh-CN",
        "country_name": "白俄罗斯",
        "nationality": "白俄罗斯"
      },
      {
        "id": 818,
        "country_codes_alpha_2": "BY",
        "languages_code": "zh-HK",
        "country_name": "白俄羅斯",
        "nationality": "白俄羅斯"
      }
    ]
  },
  {
    "country_name": "Belgium",
    "alpha_2": "BE",
    "alpha_3": "BEL",
    "nationality": "Belgian",
    "calling_code": "32",
    "country_image": null,
    "translations": [
      {
        "id": 351,
        "country_codes_alpha_2": "BE",
        "languages_code": "zh-CN",
        "country_name": "比利时",
        "nationality": "比利时"
      },
      {
        "id": 350,
        "country_codes_alpha_2": "BE",
        "languages_code": "en-US",
        "country_name": "Belgium",
        "nationality": "Belgian"
      },
      {
        "id": 744,
        "country_codes_alpha_2": "BE",
        "languages_code": "zh-HK",
        "country_name": "比利時",
        "nationality": "比利時"
      }
    ]
  },
  {
    "country_name": "Belize",
    "alpha_2": "BZ",
    "alpha_3": "BLZ",
    "nationality": "Belizean",
    "calling_code": "501",
    "country_image": null,
    "translations": [
      {
        "id": 228,
        "country_codes_alpha_2": "BZ",
        "languages_code": "en-US",
        "country_name": "Belize",
        "nationality": "Belizean"
      },
      {
        "id": 229,
        "country_codes_alpha_2": "BZ",
        "languages_code": "zh-CN",
        "country_name": "伯利兹",
        "nationality": "伯利兹"
      },
      {
        "id": 832,
        "country_codes_alpha_2": "BZ",
        "languages_code": "zh-HK",
        "country_name": "伯利茲",
        "nationality": "伯利兹"
      }
    ]
  },
  {
    "country_name": "Benin",
    "alpha_2": "BJ",
    "alpha_3": "BEN",
    "nationality": "Beninese",
    "calling_code": "229",
    "country_image": null,
    "translations": [
      {
        "id": 588,
        "country_codes_alpha_2": "BJ",
        "languages_code": "en-US",
        "country_name": "Benin",
        "nationality": "Beninese"
      },
      {
        "id": 589,
        "country_codes_alpha_2": "BJ",
        "languages_code": "zh-CN",
        "country_name": "贝宁",
        "nationality": "贝宁"
      },
      {
        "id": 666,
        "country_codes_alpha_2": "BJ",
        "languages_code": "zh-HK",
        "country_name": "貝甯",
        "nationality": "貝寧"
      }
    ]
  },
  {
    "country_name": "Bermuda",
    "alpha_2": "BM",
    "alpha_3": "BMU",
    "nationality": "Bermudian",
    "calling_code": "1441",
    "country_image": null,
    "translations": [
      {
        "id": 891,
        "country_codes_alpha_2": "BM",
        "languages_code": "zh-CN",
        "country_name": "百慕大",
        "nationality": "百慕大"
      },
      {
        "id": 892,
        "country_codes_alpha_2": "BM",
        "languages_code": "en-US",
        "country_name": "Bermuda",
        "nationality": "Bermudian"
      },
      {
        "id": 994,
        "country_codes_alpha_2": "BM",
        "languages_code": "zh-HK",
        "country_name": "百慕大",
        "nationality": "百慕大"
      }
    ]
  },
  {
    "country_name": "Bhutan",
    "alpha_2": "BT",
    "alpha_3": "BTN",
    "nationality": "Bhutanese",
    "calling_code": "975",
    "country_image": null,
    "translations": [
      {
        "id": 487,
        "country_codes_alpha_2": "BT",
        "languages_code": "zh-CN",
        "country_name": "不丹",
        "nationality": "不丹"
      },
      {
        "id": 486,
        "country_codes_alpha_2": "BT",
        "languages_code": "en-US",
        "country_name": "Bhutan",
        "nationality": "Bhutanese"
      },
      {
        "id": 697,
        "country_codes_alpha_2": "BT",
        "languages_code": "zh-HK",
        "country_name": "不丹",
        "nationality": "不丹"
      }
    ]
  },
  {
    "country_name": "Bolivia (Plurinational State of)",
    "alpha_2": "BO",
    "alpha_3": "BOL",
    "nationality": "Bolivian",
    "calling_code": "591",
    "country_image": null,
    "translations": [
      {
        "id": 254,
        "country_codes_alpha_2": "BO",
        "languages_code": "en-US",
        "country_name": "Bolivia (Plurinational State of)",
        "nationality": "Bolivian"
      },
      {
        "id": 255,
        "country_codes_alpha_2": "BO",
        "languages_code": "zh-CN",
        "country_name": "玻利维亚（多民族国）",
        "nationality": "玻利维亚"
      },
      {
        "id": 729,
        "country_codes_alpha_2": "BO",
        "languages_code": "zh-HK",
        "country_name": "玻利維亞(多民族國)",
        "nationality": "玻利維亞"
      }
    ]
  },
  {
    "country_name": "Bosnia and Herzegovina",
    "alpha_2": "BA",
    "alpha_3": "BIH",
    "nationality": "Bosnia and Herzegovina citizen",
    "calling_code": "387",
    "country_image": null,
    "translations": [
      {
        "id": 218,
        "country_codes_alpha_2": "BA",
        "languages_code": "en-US",
        "country_name": "Bosnia and Herzegovina",
        "nationality": "Bosnia and Herzegovina citizen"
      },
      {
        "id": 219,
        "country_codes_alpha_2": "BA",
        "languages_code": "zh-CN",
        "country_name": "波斯尼亚和黑塞哥维那",
        "nationality": "波斯尼亚 黑塞哥维那"
      },
      {
        "id": 688,
        "country_codes_alpha_2": "BA",
        "languages_code": "zh-HK",
        "country_name": "波斯尼亞和黑塞哥維那",
        "nationality": "波斯尼亞 黑塞哥維那"
      }
    ]
  },
  {
    "country_name": "Botswana",
    "alpha_2": "BW",
    "alpha_3": "BWA",
    "nationality": "Botswanan",
    "calling_code": "267",
    "country_image": null,
    "translations": [
      {
        "id": 516,
        "country_codes_alpha_2": "BW",
        "languages_code": "en-US",
        "country_name": "Botswana",
        "nationality": "Botswanan"
      },
      {
        "id": 517,
        "country_codes_alpha_2": "BW",
        "languages_code": "zh-CN",
        "country_name": "博茨瓦纳",
        "nationality": "博茨瓦纳"
      },
      {
        "id": 634,
        "country_codes_alpha_2": "BW",
        "languages_code": "zh-HK",
        "country_name": "博茨瓦納",
        "nationality": "博茨瓦納"
      }
    ]
  },
  {
    "country_name": "Brazil",
    "alpha_2": "BR",
    "alpha_3": "BRA",
    "nationality": "Brazilian",
    "calling_code": "55",
    "country_image": null,
    "translations": [
      {
        "id": 585,
        "country_codes_alpha_2": "BR",
        "languages_code": "zh-CN",
        "country_name": "巴西",
        "nationality": "巴西"
      },
      {
        "id": 584,
        "country_codes_alpha_2": "BR",
        "languages_code": "en-US",
        "country_name": "Brazil",
        "nationality": "Brazilian"
      },
      {
        "id": 828,
        "country_codes_alpha_2": "BR",
        "languages_code": "zh-HK",
        "country_name": "巴西",
        "nationality": "巴西"
      }
    ]
  },
  {
    "country_name": "British Indian Ocean Territory",
    "alpha_2": "IO",
    "alpha_3": "IOT",
    "nationality": "British (British Indian Ocean Territory)",
    "calling_code": "246",
    "country_image": null,
    "translations": [
      {
        "id": 371,
        "country_codes_alpha_2": "IO",
        "languages_code": "zh-CN",
        "country_name": "英属印度洋领地",
        "nationality": "英属印度洋领地"
      },
      {
        "id": 370,
        "country_codes_alpha_2": "IO",
        "languages_code": "en-US",
        "country_name": "British Indian Ocean Territory",
        "nationality": "British (British Indian Ocean Territory)"
      },
      {
        "id": 691,
        "country_codes_alpha_2": "IO",
        "languages_code": "zh-HK",
        "country_name": "英屬印度洋領土",
        "nationality": "英屬印度洋領地"
      }
    ]
  },
  {
    "country_name": "Brunei Darussalam",
    "alpha_2": "BN",
    "alpha_3": "BRN",
    "nationality": "Bruneian",
    "calling_code": "673",
    "country_image": null,
    "translations": [
      {
        "id": 812,
        "country_codes_alpha_2": "BN",
        "languages_code": "zh-HK",
        "country_name": "文萊達魯薩蘭國",
        "nationality": "文萊"
      },
      {
        "id": 342,
        "country_codes_alpha_2": "BN",
        "languages_code": "en-US",
        "country_name": "Brunei Darussalam",
        "nationality": "Bruneian"
      },
      {
        "id": 343,
        "country_codes_alpha_2": "BN",
        "languages_code": "zh-CN",
        "country_name": "文莱达鲁萨兰国",
        "nationality": "文莱"
      }
    ]
  },
  {
    "country_name": "Bulgaria",
    "alpha_2": "BG",
    "alpha_3": "BGR",
    "nationality": "Bulgarian",
    "calling_code": "359",
    "country_image": null,
    "translations": [
      {
        "id": 520,
        "country_codes_alpha_2": "BG",
        "languages_code": "en-US",
        "country_name": "Bulgaria",
        "nationality": "Bulgarian"
      },
      {
        "id": 738,
        "country_codes_alpha_2": "BG",
        "languages_code": "zh-HK",
        "country_name": "保加利亞",
        "nationality": "保加利亞"
      },
      {
        "id": 521,
        "country_codes_alpha_2": "BG",
        "languages_code": "zh-CN",
        "country_name": "保加利亚",
        "nationality": "保加利亚"
      }
    ]
  },
  {
    "country_name": "Burkina Faso",
    "alpha_2": "BF",
    "alpha_3": "BFA",
    "nationality": "Burkinan",
    "calling_code": "226",
    "country_image": null,
    "translations": [
      {
        "id": 214,
        "country_codes_alpha_2": "BF",
        "languages_code": "en-US",
        "country_name": "Burkina Faso",
        "nationality": "Burkinan"
      },
      {
        "id": 215,
        "country_codes_alpha_2": "BF",
        "languages_code": "zh-CN",
        "country_name": "布基纳法索",
        "nationality": "布基纳法索"
      },
      {
        "id": 687,
        "country_codes_alpha_2": "BF",
        "languages_code": "zh-HK",
        "country_name": "布基納法索",
        "nationality": "布基納法索"
      }
    ]
  },
  {
    "country_name": "Burundi",
    "alpha_2": "BI",
    "alpha_3": "BDI",
    "nationality": "Burundian",
    "calling_code": "257",
    "country_image": null,
    "translations": [
      {
        "id": 210,
        "country_codes_alpha_2": "BI",
        "languages_code": "en-US",
        "country_name": "Burundi",
        "nationality": "Burundian"
      },
      {
        "id": 211,
        "country_codes_alpha_2": "BI",
        "languages_code": "zh-CN",
        "country_name": "布隆迪",
        "nationality": "布隆迪"
      },
      {
        "id": 829,
        "country_codes_alpha_2": "BI",
        "languages_code": "zh-HK",
        "country_name": "布隆迪",
        "nationality": "布隆迪"
      }
    ]
  },
  {
    "country_name": "Cabo Verde",
    "alpha_2": "CV",
    "alpha_3": "CPV",
    "nationality": "Cape Verdean",
    "calling_code": "238",
    "country_image": null,
    "translations": [
      {
        "id": 216,
        "country_codes_alpha_2": "CV",
        "languages_code": "en-US",
        "country_name": "Cabo Verde",
        "nationality": "Cape Verdean"
      },
      {
        "id": 217,
        "country_codes_alpha_2": "CV",
        "languages_code": "zh-CN",
        "country_name": "佛得角",
        "nationality": "佛得角"
      },
      {
        "id": 650,
        "country_codes_alpha_2": "CV",
        "languages_code": "zh-HK",
        "country_name": "佛得角",
        "nationality": "佛得角"
      }
    ]
  },
  {
    "country_name": "Cambodia",
    "alpha_2": "KH",
    "alpha_3": "KHM",
    "nationality": "Cambodian",
    "calling_code": "855",
    "country_image": null,
    "translations": [
      {
        "id": 441,
        "country_codes_alpha_2": "KH",
        "languages_code": "zh-CN",
        "country_name": "柬埔寨",
        "nationality": "柬埔寨"
      },
      {
        "id": 440,
        "country_codes_alpha_2": "KH",
        "languages_code": "en-US",
        "country_name": "Cambodia",
        "nationality": "Cambodian"
      },
      {
        "id": 761,
        "country_codes_alpha_2": "KH",
        "languages_code": "zh-HK",
        "country_name": "柬埔寨",
        "nationality": "柬埔寨"
      }
    ]
  },
  {
    "country_name": "Cameroon",
    "alpha_2": "CM",
    "alpha_3": "CMR",
    "nationality": "Cameroonian",
    "calling_code": "237",
    "country_image": null,
    "translations": [
      {
        "id": 212,
        "country_codes_alpha_2": "CM",
        "languages_code": "en-US",
        "country_name": "Cameroon",
        "nationality": "Cameroonian"
      },
      {
        "id": 213,
        "country_codes_alpha_2": "CM",
        "languages_code": "zh-CN",
        "country_name": "喀麦隆",
        "nationality": "喀麦隆"
      },
      {
        "id": 632,
        "country_codes_alpha_2": "CM",
        "languages_code": "zh-HK",
        "country_name": "喀麥隆",
        "nationality": "喀麥隆"
      }
    ]
  },
  {
    "country_name": "Canada",
    "alpha_2": "CA",
    "alpha_3": "CAN",
    "nationality": "Canadian",
    "calling_code": "1",
    "country_image": null,
    "translations": [
      {
        "id": 540,
        "country_codes_alpha_2": "CA",
        "languages_code": "en-US",
        "country_name": "Canada",
        "nationality": "Canadian"
      },
      {
        "id": 695,
        "country_codes_alpha_2": "CA",
        "languages_code": "zh-HK",
        "country_name": "加拿大",
        "nationality": "加拿大"
      },
      {
        "id": 541,
        "country_codes_alpha_2": "CA",
        "languages_code": "zh-CN",
        "country_name": "加拿大",
        "nationality": "加拿大"
      }
    ]
  },
  {
    "country_name": "Cayman Islands",
    "alpha_2": "KY",
    "alpha_3": "CYM",
    "nationality": "Cayman Islander",
    "calling_code": "1345",
    "country_image": null,
    "translations": [
      {
        "id": 929,
        "country_codes_alpha_2": "KY",
        "languages_code": "zh-CN",
        "country_name": "开曼群岛",
        "nationality": "开曼群岛"
      },
      {
        "id": 930,
        "country_codes_alpha_2": "KY",
        "languages_code": "en-US",
        "country_name": "Cayman Islands",
        "nationality": "Cayman Islander"
      },
      {
        "id": 1015,
        "country_codes_alpha_2": "KY",
        "languages_code": "zh-HK",
        "country_name": "開曼群島",
        "nationality": "開曼群島"
      }
    ]
  },
  {
    "country_name": "Central African Republic",
    "alpha_2": "CF",
    "alpha_3": "CAF",
    "nationality": "Central African",
    "calling_code": "236",
    "country_image": null,
    "translations": [
      {
        "id": 474,
        "country_codes_alpha_2": "CF",
        "languages_code": "en-US",
        "country_name": "Central African Republic",
        "nationality": "Central African"
      },
      {
        "id": 836,
        "country_codes_alpha_2": "CF",
        "languages_code": "zh-HK",
        "country_name": "中非共和國",
        "nationality": "中非共和國"
      },
      {
        "id": 475,
        "country_codes_alpha_2": "CF",
        "languages_code": "zh-CN",
        "country_name": "中非共和国",
        "nationality": "中非共和国"
      }
    ]
  },
  {
    "country_name": "Chad",
    "alpha_2": "TD",
    "alpha_3": "TCD",
    "nationality": "Chadian",
    "calling_code": "235",
    "country_image": null,
    "translations": [
      {
        "id": 570,
        "country_codes_alpha_2": "TD",
        "languages_code": "en-US",
        "country_name": "Chad",
        "nationality": "Chadian"
      },
      {
        "id": 571,
        "country_codes_alpha_2": "TD",
        "languages_code": "zh-CN",
        "country_name": "乍得",
        "nationality": "查德"
      },
      {
        "id": 756,
        "country_codes_alpha_2": "TD",
        "languages_code": "zh-HK",
        "country_name": "乍得",
        "nationality": "查德"
      }
    ]
  },
  {
    "country_name": "Chile",
    "alpha_2": "CL",
    "alpha_3": "CHL",
    "nationality": "Chilean",
    "calling_code": "56",
    "country_image": null,
    "translations": [
      {
        "id": 335,
        "country_codes_alpha_2": "CL",
        "languages_code": "zh-CN",
        "country_name": "智利",
        "nationality": "智利"
      },
      {
        "id": 334,
        "country_codes_alpha_2": "CL",
        "languages_code": "en-US",
        "country_name": "Chile",
        "nationality": "Chilean"
      },
      {
        "id": 728,
        "country_codes_alpha_2": "CL",
        "languages_code": "zh-HK",
        "country_name": "智利",
        "nationality": "智利"
      }
    ]
  },
  {
    "country_name": "China",
    "alpha_2": "CN",
    "alpha_3": "CHN",
    "nationality": "Chinese",
    "calling_code": "86",
    "country_image": null,
    "translations": [
      {
        "id": 461,
        "country_codes_alpha_2": "CN",
        "languages_code": "zh-CN",
        "country_name": "中国",
        "nationality": "中国"
      },
      {
        "id": 460,
        "country_codes_alpha_2": "CN",
        "languages_code": "en-US",
        "country_name": "China",
        "nationality": "Chinese"
      },
      {
        "id": 826,
        "country_codes_alpha_2": "CN",
        "languages_code": "zh-HK",
        "country_name": "中國",
        "nationality": "中國"
      }
    ]
  },
  {
    "country_name": "Christmas Island",
    "alpha_2": "CX",
    "alpha_3": "CXR",
    "nationality": "Australian (Christmas Island)",
    "calling_code": "61",
    "country_image": null,
    "translations": [
      {
        "id": 939,
        "country_codes_alpha_2": "CX",
        "languages_code": "zh-CN",
        "country_name": "圣诞岛",
        "nationality": "圣诞岛"
      },
      {
        "id": 940,
        "country_codes_alpha_2": "CX",
        "languages_code": "en-US",
        "country_name": "Christmas Island",
        "nationality": "Australian (Christmas Island)"
      },
      {
        "id": 993,
        "country_codes_alpha_2": "CX",
        "languages_code": "zh-HK",
        "country_name": "聖誕島",
        "nationality": "聖誕島"
      }
    ]
  },
  {
    "country_name": "Cocos (Keeling) Islands",
    "alpha_2": "CC",
    "alpha_3": "CCK",
    "nationality": "Australian (Cocos Islands)",
    "calling_code": "61",
    "country_image": null,
    "translations": [
      {
        "id": 853,
        "country_codes_alpha_2": "CC",
        "languages_code": "en-US",
        "country_name": "Cocos (Keeling) Islands",
        "nationality": "Australian (Cocos Islands)"
      },
      {
        "id": 854,
        "country_codes_alpha_2": "CC",
        "languages_code": "zh-CN",
        "country_name": "科科斯(基林)群岛",
        "nationality": "科科斯群岛"
      },
      {
        "id": 855,
        "country_codes_alpha_2": "CC",
        "languages_code": "zh-HK",
        "country_name": "科科斯(基林)群島",
        "nationality": "科科斯群島"
      }
    ]
  },
  {
    "country_name": "Colombia",
    "alpha_2": "CO",
    "alpha_3": "COL",
    "nationality": "Colombian",
    "calling_code": "57",
    "country_image": null,
    "translations": [
      {
        "id": 205,
        "country_codes_alpha_2": "CO",
        "languages_code": "zh-CN",
        "country_name": "哥伦比亚",
        "nationality": "哥伦比亚"
      },
      {
        "id": 204,
        "country_codes_alpha_2": "CO",
        "languages_code": "en-US",
        "country_name": "Colombia",
        "nationality": "Colombian"
      },
      {
        "id": 694,
        "country_codes_alpha_2": "CO",
        "languages_code": "zh-HK",
        "country_name": "哥倫比亞",
        "nationality": "哥倫比亞"
      }
    ]
  },
  {
    "country_name": "Comoros",
    "alpha_2": "KM",
    "alpha_3": "COM",
    "nationality": "Comoran",
    "calling_code": "269",
    "country_image": null,
    "translations": [
      {
        "id": 477,
        "country_codes_alpha_2": "KM",
        "languages_code": "zh-CN",
        "country_name": "科摩罗",
        "nationality": "科摩罗"
      },
      {
        "id": 476,
        "country_codes_alpha_2": "KM",
        "languages_code": "en-US",
        "country_name": "Comoros",
        "nationality": "Comoran"
      },
      {
        "id": 698,
        "country_codes_alpha_2": "KM",
        "languages_code": "zh-HK",
        "country_name": "科摩羅",
        "nationality": "科摩羅"
      }
    ]
  },
  {
    "country_name": "Congo",
    "alpha_2": "CG",
    "alpha_3": "COG",
    "nationality": "Congolese (Congo Republic)",
    "calling_code": "242",
    "country_image": null,
    "translations": [
      {
        "id": 683,
        "country_codes_alpha_2": "CG",
        "languages_code": "zh-HK",
        "country_name": "剛果",
        "nationality": "剛果共和國"
      },
      {
        "id": 178,
        "country_codes_alpha_2": "CG",
        "languages_code": "en-US",
        "country_name": "Congo",
        "nationality": "Congolese (Congo Republic)"
      },
      {
        "id": 179,
        "country_codes_alpha_2": "CG",
        "languages_code": "zh-CN",
        "country_name": "刚果",
        "nationality": "刚果共和国"
      }
    ]
  },
  {
    "country_name": "Congo, Democratic Republic of the",
    "alpha_2": "CD",
    "alpha_3": "COD",
    "nationality": "Congolese (DRC)",
    "calling_code": "243",
    "country_image": null,
    "translations": [
      {
        "id": 174,
        "country_codes_alpha_2": "CD",
        "languages_code": "en-US",
        "country_name": "Democratic Republic of the Congo",
        "nationality": "Congolese (DRC)"
      },
      {
        "id": 651,
        "country_codes_alpha_2": "CD",
        "languages_code": "zh-HK",
        "country_name": "剛果民主共和國",
        "nationality": "剛果民主共和國"
      },
      {
        "id": 175,
        "country_codes_alpha_2": "CD",
        "languages_code": "zh-CN",
        "country_name": "刚果民主共和国",
        "nationality": "刚果民主共和国"
      }
    ]
  },
  {
    "country_name": "Cook Islands",
    "alpha_2": "CK",
    "alpha_3": "COK",
    "nationality": "Cook Islander",
    "calling_code": "682",
    "country_image": null,
    "translations": [
      {
        "id": 294,
        "country_codes_alpha_2": "CK",
        "languages_code": "en-US",
        "country_name": "Cook Islands",
        "nationality": "Cook Islander"
      },
      {
        "id": 819,
        "country_codes_alpha_2": "CK",
        "languages_code": "zh-HK",
        "country_name": "庫克群島",
        "nationality": "庫克群島"
      },
      {
        "id": 295,
        "country_codes_alpha_2": "CK",
        "languages_code": "zh-CN",
        "country_name": "库克群岛",
        "nationality": "库克群岛"
      }
    ]
  },
  {
    "country_name": "Costa Rica",
    "alpha_2": "CR",
    "alpha_3": "CRI",
    "nationality": "Costa Rican",
    "calling_code": "506",
    "country_image": null,
    "translations": [
      {
        "id": 498,
        "country_codes_alpha_2": "CR",
        "languages_code": "en-US",
        "country_name": "Costa Rica",
        "nationality": "Costa Rican"
      },
      {
        "id": 689,
        "country_codes_alpha_2": "CR",
        "languages_code": "zh-HK",
        "country_name": "哥斯達黎加",
        "nationality": "哥斯達黎加"
      },
      {
        "id": 499,
        "country_codes_alpha_2": "CR",
        "languages_code": "zh-CN",
        "country_name": "哥斯达黎加",
        "nationality": "哥斯达黎加"
      }
    ]
  },
  {
    "country_name": "Côte d'Ivoire",
    "alpha_2": "CI",
    "alpha_3": "CIV",
    "nationality": "Ivorian",
    "calling_code": "225",
    "country_image": null,
    "translations": [
      {
        "id": 458,
        "country_codes_alpha_2": "CI",
        "languages_code": "en-US",
        "country_name": "Côte d'Ivoire",
        "nationality": "Ivorian"
      },
      {
        "id": 459,
        "country_codes_alpha_2": "CI",
        "languages_code": "zh-CN",
        "country_name": "科特迪瓦",
        "nationality": "科特迪瓦"
      },
      {
        "id": 817,
        "country_codes_alpha_2": "CI",
        "languages_code": "zh-HK",
        "country_name": "科特迪瓦",
        "nationality": "科特迪瓦"
      }
    ]
  },
  {
    "country_name": "Croatia",
    "alpha_2": "HR",
    "alpha_3": "HRV",
    "nationality": "Croatian",
    "calling_code": "385",
    "country_image": null,
    "translations": [
      {
        "id": 450,
        "country_codes_alpha_2": "HR",
        "languages_code": "en-US",
        "country_name": "Croatia",
        "nationality": "Croatian"
      },
      {
        "id": 451,
        "country_codes_alpha_2": "HR",
        "languages_code": "zh-CN",
        "country_name": "克罗地亚",
        "nationality": "克罗地亚"
      },
      {
        "id": 684,
        "country_codes_alpha_2": "HR",
        "languages_code": "zh-HK",
        "country_name": "克羅地亞",
        "nationality": "克羅地亞"
      }
    ]
  },
  {
    "country_name": "Cuba",
    "alpha_2": "CU",
    "alpha_3": "CUB",
    "nationality": "Cuban",
    "calling_code": "53",
    "country_image": null,
    "translations": [
      {
        "id": 566,
        "country_codes_alpha_2": "CU",
        "languages_code": "en-US",
        "country_name": "Cuba",
        "nationality": "Cuban"
      },
      {
        "id": 763,
        "country_codes_alpha_2": "CU",
        "languages_code": "zh-HK",
        "country_name": "古巴",
        "nationality": "古巴"
      },
      {
        "id": 567,
        "country_codes_alpha_2": "CU",
        "languages_code": "zh-CN",
        "country_name": "古巴",
        "nationality": "古巴"
      }
    ]
  },
  {
    "country_name": "Curaçao",
    "alpha_2": "CW",
    "alpha_3": "CUW",
    "nationality": "Dutch (Curaçao)",
    "calling_code": "599",
    "country_image": null,
    "translations": [
      {
        "id": 640,
        "country_codes_alpha_2": "CW",
        "languages_code": "zh-HK",
        "country_name": "庫拉索",
        "nationality": "庫拉索"
      },
      {
        "id": 946,
        "country_codes_alpha_2": "CW",
        "languages_code": "en-US",
        "country_name": "Curaçao",
        "nationality": "Dutch (Curaçao)"
      },
      {
        "id": 945,
        "country_codes_alpha_2": "CW",
        "languages_code": "zh-CN",
        "country_name": "库拉索",
        "nationality": "库拉索"
      }
    ]
  },
  {
    "country_name": "Cyprus",
    "alpha_2": "CY",
    "alpha_3": "CYP",
    "nationality": "Cypriot",
    "calling_code": "357",
    "country_image": null,
    "translations": [
      {
        "id": 339,
        "country_codes_alpha_2": "CY",
        "languages_code": "zh-CN",
        "country_name": "塞浦路斯",
        "nationality": "塞浦路斯"
      },
      {
        "id": 338,
        "country_codes_alpha_2": "CY",
        "languages_code": "en-US",
        "country_name": "Cyprus",
        "nationality": "Cypriot"
      },
      {
        "id": 726,
        "country_codes_alpha_2": "CY",
        "languages_code": "zh-HK",
        "country_name": "塞浦路斯",
        "nationality": "塞浦路斯"
      }
    ]
  },
  {
    "country_name": "Czechia",
    "alpha_2": "CZ",
    "alpha_3": "CZE",
    "nationality": "Czech",
    "calling_code": "420",
    "country_image": null,
    "translations": [
      {
        "id": 448,
        "country_codes_alpha_2": "CZ",
        "languages_code": "en-US",
        "country_name": "Czech Republic",
        "nationality": "Czech"
      },
      {
        "id": 723,
        "country_codes_alpha_2": "CZ",
        "languages_code": "zh-HK",
        "country_name": "捷克",
        "nationality": "捷克共和國"
      },
      {
        "id": 449,
        "country_codes_alpha_2": "CZ",
        "languages_code": "zh-CN",
        "country_name": "捷克共和国",
        "nationality": "捷克共和国"
      }
    ]
  },
  {
    "country_name": "Denmark",
    "alpha_2": "DK",
    "alpha_3": "DNK",
    "nationality": "Danish",
    "calling_code": "45",
    "country_image": null,
    "translations": [
      {
        "id": 849,
        "country_codes_alpha_2": "DK",
        "languages_code": "zh-HK",
        "country_name": "丹麥",
        "nationality": "丹麥"
      },
      {
        "id": 352,
        "country_codes_alpha_2": "DK",
        "languages_code": "en-US",
        "country_name": "Denmark",
        "nationality": "Danish"
      },
      {
        "id": 353,
        "country_codes_alpha_2": "DK",
        "languages_code": "zh-CN",
        "country_name": "丹麦",
        "nationality": "丹麦"
      }
    ]
  },
  {
    "country_name": "Djibouti",
    "alpha_2": "DJ",
    "alpha_3": "DJI",
    "nationality": "Djiboutian",
    "calling_code": "253",
    "country_image": null,
    "translations": [
      {
        "id": 167,
        "country_codes_alpha_2": "DJ",
        "languages_code": "zh-CN",
        "country_name": "吉布提",
        "nationality": "吉布提"
      },
      {
        "id": 166,
        "country_codes_alpha_2": "DJ",
        "languages_code": "en-US",
        "country_name": "Djibouti",
        "nationality": "Djiboutian"
      },
      {
        "id": 825,
        "country_codes_alpha_2": "DJ",
        "languages_code": "zh-HK",
        "country_name": "吉布提",
        "nationality": "吉布提"
      }
    ]
  },
  {
    "country_name": "Dominica",
    "alpha_2": "DM",
    "alpha_3": "DMA",
    "nationality": "Dominican",
    "calling_code": "1767",
    "country_image": null,
    "translations": [
      {
        "id": 894,
        "country_codes_alpha_2": "DM",
        "languages_code": "en-US",
        "country_name": "Dominica",
        "nationality": "Dominican"
      },
      {
        "id": 893,
        "country_codes_alpha_2": "DM",
        "languages_code": "zh-CN",
        "country_name": "多米尼克",
        "nationality": "多米尼克"
      },
      {
        "id": 1012,
        "country_codes_alpha_2": "DM",
        "languages_code": "zh-HK",
        "country_name": "多米尼克",
        "nationality": "多米尼克"
      }
    ]
  },
  {
    "country_name": "Dominican Republic",
    "alpha_2": "DO",
    "alpha_3": "DOM",
    "nationality": "Dominican Republic citizen",
    "calling_code": "1809,1829,1849",
    "country_image": null,
    "translations": [
      {
        "id": 909,
        "country_codes_alpha_2": "DO",
        "languages_code": "zh-CN",
        "country_name": "多米尼加",
        "nationality": "多米尼加共和国 "
      },
      {
        "id": 990,
        "country_codes_alpha_2": "DO",
        "languages_code": "zh-HK",
        "country_name": "多米尼加",
        "nationality": "多米尼加共和國"
      },
      {
        "id": 910,
        "country_codes_alpha_2": "DO",
        "languages_code": "en-US",
        "country_name": "Dominican Republic",
        "nationality": "Dominican Republic citizen"
      }
    ]
  },
  {
    "country_name": "Ecuador",
    "alpha_2": "EC",
    "alpha_3": "ECU",
    "nationality": "Ecuadorean",
    "calling_code": "593",
    "country_image": null,
    "translations": [
      {
        "id": 250,
        "country_codes_alpha_2": "EC",
        "languages_code": "en-US",
        "country_name": "Ecuador",
        "nationality": "Ecuadorean"
      },
      {
        "id": 251,
        "country_codes_alpha_2": "EC",
        "languages_code": "zh-CN",
        "country_name": "厄瓜多尔",
        "nationality": "厄瓜多尔"
      },
      {
        "id": 787,
        "country_codes_alpha_2": "EC",
        "languages_code": "zh-HK",
        "country_name": "厄瓜多爾",
        "nationality": "厄瓜多爾"
      }
    ]
  },
  {
    "country_name": "Egypt",
    "alpha_2": "EG",
    "alpha_3": "EGY",
    "nationality": "Egyptian",
    "calling_code": "20",
    "country_image": null,
    "translations": [
      {
        "id": 633,
        "country_codes_alpha_2": "EG",
        "languages_code": "zh-HK",
        "country_name": "埃及",
        "nationality": "埃及"
      },
      {
        "id": 368,
        "country_codes_alpha_2": "EG",
        "languages_code": "en-US",
        "country_name": "Egypt",
        "nationality": "Egyptian"
      },
      {
        "id": 369,
        "country_codes_alpha_2": "EG",
        "languages_code": "zh-CN",
        "country_name": "埃及",
        "nationality": "埃及"
      }
    ]
  },
  {
    "country_name": "El Salvador",
    "alpha_2": "SV",
    "alpha_3": "SLV",
    "nationality": "Salvadorean",
    "calling_code": "503",
    "country_image": null,
    "translations": [
      {
        "id": 765,
        "country_codes_alpha_2": "SV",
        "languages_code": "zh-HK",
        "country_name": "薩爾瓦多",
        "nationality": "薩爾瓦多"
      },
      {
        "id": 282,
        "country_codes_alpha_2": "SV",
        "languages_code": "en-US",
        "country_name": "El Salvador",
        "nationality": "Salvadorean"
      },
      {
        "id": 283,
        "country_codes_alpha_2": "SV",
        "languages_code": "zh-CN",
        "country_name": "萨尔瓦多",
        "nationality": "萨尔瓦多"
      }
    ]
  },
  {
    "country_name": "Equatorial Guinea",
    "alpha_2": "GQ",
    "alpha_3": "GNQ",
    "nationality": "Equatorial Guinean",
    "calling_code": "240",
    "country_image": null,
    "translations": [
      {
        "id": 194,
        "country_codes_alpha_2": "GQ",
        "languages_code": "en-US",
        "country_name": "Equatorial Guinea",
        "nationality": "Equatorial Guinean"
      },
      {
        "id": 647,
        "country_codes_alpha_2": "GQ",
        "languages_code": "zh-HK",
        "country_name": "赤道幾內亞",
        "nationality": "赤道幾內亞"
      },
      {
        "id": 195,
        "country_codes_alpha_2": "GQ",
        "languages_code": "zh-CN",
        "country_name": "赤道几内亚",
        "nationality": "赤道几内亚"
      }
    ]
  },
  {
    "country_name": "Eritrea",
    "alpha_2": "ER",
    "alpha_3": "ERI",
    "nationality": "Eritrean",
    "calling_code": "291",
    "country_image": null,
    "translations": [
      {
        "id": 271,
        "country_codes_alpha_2": "ER",
        "languages_code": "zh-CN",
        "country_name": "厄立特里亚",
        "nationality": "厄立特里亚"
      },
      {
        "id": 270,
        "country_codes_alpha_2": "ER",
        "languages_code": "en-US",
        "country_name": "Eritrea",
        "nationality": "Eritrean"
      },
      {
        "id": 724,
        "country_codes_alpha_2": "ER",
        "languages_code": "zh-HK",
        "country_name": "厄立特裏亞",
        "nationality": "厄立特里亞"
      }
    ]
  },
  {
    "country_name": "Estonia",
    "alpha_2": "EE",
    "alpha_3": "EST",
    "nationality": "Estonian",
    "calling_code": "372",
    "country_image": null,
    "translations": [
      {
        "id": 345,
        "country_codes_alpha_2": "EE",
        "languages_code": "zh-CN",
        "country_name": "爱沙尼亚",
        "nationality": "爱沙尼亚"
      },
      {
        "id": 344,
        "country_codes_alpha_2": "EE",
        "languages_code": "en-US",
        "country_name": "Estonia",
        "nationality": "Estonian"
      },
      {
        "id": 839,
        "country_codes_alpha_2": "EE",
        "languages_code": "zh-HK",
        "country_name": "愛沙尼亞",
        "nationality": "愛沙尼亞"
      }
    ]
  },
  {
    "country_name": "Eswatini",
    "alpha_2": "SZ",
    "alpha_3": "SWZ",
    "nationality": "Swazi",
    "calling_code": "268",
    "country_image": null,
    "translations": [
      {
        "id": 241,
        "country_codes_alpha_2": "SZ",
        "languages_code": "zh-CN",
        "country_name": "斯威士兰",
        "nationality": "斯威士兰"
      },
      {
        "id": 240,
        "country_codes_alpha_2": "SZ",
        "languages_code": "en-US",
        "country_name": "Swaziland",
        "nationality": "Swazi"
      },
      {
        "id": 837,
        "country_codes_alpha_2": "SZ",
        "languages_code": "zh-HK",
        "country_name": "斯威士蘭",
        "nationality": "斯威士蘭"
      }
    ]
  },
  {
    "country_name": "Ethiopia",
    "alpha_2": "ET",
    "alpha_3": "ETH",
    "nationality": "Ethiopian",
    "calling_code": "251",
    "country_image": null,
    "translations": [
      {
        "id": 169,
        "country_codes_alpha_2": "ET",
        "languages_code": "zh-CN",
        "country_name": "埃塞俄比亚",
        "nationality": "埃塞俄比亚"
      },
      {
        "id": 168,
        "country_codes_alpha_2": "ET",
        "languages_code": "en-US",
        "country_name": "Ethiopia",
        "nationality": "Ethiopian"
      },
      {
        "id": 743,
        "country_codes_alpha_2": "ET",
        "languages_code": "zh-HK",
        "country_name": "埃塞俄比亞",
        "nationality": "埃塞俄比亞"
      }
    ]
  },
  {
    "country_name": "Falkland Islands (Malvinas)",
    "alpha_2": "FK",
    "alpha_3": "FLK",
    "nationality": "British (Falkland Islands)",
    "calling_code": "500",
    "country_image": null,
    "translations": [
      {
        "id": 949,
        "country_codes_alpha_2": "FK",
        "languages_code": "zh-CN",
        "country_name": "福克兰群岛(马尔维纳斯)",
        "nationality": "福克兰群岛"
      },
      {
        "id": 950,
        "country_codes_alpha_2": "FK",
        "languages_code": "en-US",
        "country_name": "Falkland Islands (Malvinas)",
        "nationality": "British (Falkland Islands)"
      },
      {
        "id": 754,
        "country_codes_alpha_2": "FK",
        "languages_code": "zh-HK",
        "country_name": "福克蘭群島(馬爾維納斯)",
        "nationality": "福克蘭群島"
      }
    ]
  },
  {
    "country_name": "Faroe Islands",
    "alpha_2": "FO",
    "alpha_3": "FRO",
    "nationality": "Danish (Faroe Islands)",
    "calling_code": "298",
    "country_image": null,
    "translations": [
      {
        "id": 471,
        "country_codes_alpha_2": "FO",
        "languages_code": "zh-CN",
        "country_name": "法罗群岛",
        "nationality": "法罗群岛"
      },
      {
        "id": 470,
        "country_codes_alpha_2": "FO",
        "languages_code": "en-US",
        "country_name": "Faroe Islands",
        "nationality": "Danish (Faroe Islands)"
      },
      {
        "id": 844,
        "country_codes_alpha_2": "FO",
        "languages_code": "zh-HK",
        "country_name": "法羅群島",
        "nationality": "法羅群島"
      }
    ]
  },
  {
    "country_name": "Fiji",
    "alpha_2": "FJ",
    "alpha_3": "FJI",
    "nationality": "Fijian",
    "calling_code": "679",
    "country_image": null,
    "translations": [
      {
        "id": 830,
        "country_codes_alpha_2": "FJ",
        "languages_code": "zh-HK",
        "country_name": "斐濟",
        "nationality": "斐濟"
      },
      {
        "id": 456,
        "country_codes_alpha_2": "FJ",
        "languages_code": "en-US",
        "country_name": "Fiji",
        "nationality": "Fijian"
      },
      {
        "id": 457,
        "country_codes_alpha_2": "FJ",
        "languages_code": "zh-CN",
        "country_name": "斐济",
        "nationality": "斐济"
      }
    ]
  },
  {
    "country_name": "Finland",
    "alpha_2": "FI",
    "alpha_3": "FIN",
    "nationality": "Finnish",
    "calling_code": "358",
    "country_image": null,
    "translations": [
      {
        "id": 764,
        "country_codes_alpha_2": "FI",
        "languages_code": "zh-HK",
        "country_name": "奧蘭群島",
        "nationality": "芬蘭"
      },
      {
        "id": 871,
        "country_codes_alpha_2": "FI",
        "languages_code": "zh-CN",
        "country_name": "奥兰群岛",
        "nationality": "芬兰"
      },
      {
        "id": 872,
        "country_codes_alpha_2": "FI",
        "languages_code": "en-US",
        "country_name": "Åland Islands",
        "nationality": "Finnish"
      }
    ]
  },
  {
    "country_name": "France",
    "alpha_2": "FR",
    "alpha_3": "FRA",
    "nationality": "French",
    "calling_code": "33",
    "country_image": null,
    "translations": [
      {
        "id": 558,
        "country_codes_alpha_2": "FR",
        "languages_code": "en-US",
        "country_name": "France",
        "nationality": "French"
      },
      {
        "id": 559,
        "country_codes_alpha_2": "FR",
        "languages_code": "zh-CN",
        "country_name": "法国",
        "nationality": "法国"
      },
      {
        "id": 638,
        "country_codes_alpha_2": "FR",
        "languages_code": "zh-HK",
        "country_name": "法國",
        "nationality": "法國"
      }
    ]
  },
  {
    "country_name": "French Polynesia",
    "alpha_2": "PF",
    "alpha_3": "PYF",
    "nationality": "French (French Polynesia)",
    "calling_code": "689",
    "country_image": null,
    "translations": [
      {
        "id": 665,
        "country_codes_alpha_2": "PF",
        "languages_code": "zh-HK",
        "country_name": "法屬波利尼西亞",
        "nationality": "法屬波利尼西亞"
      },
      {
        "id": 372,
        "country_codes_alpha_2": "PF",
        "languages_code": "en-US",
        "country_name": "French Polynesia",
        "nationality": "French (French Polynesia)"
      },
      {
        "id": 373,
        "country_codes_alpha_2": "PF",
        "languages_code": "zh-CN",
        "country_name": "法属玻里尼西亚",
        "nationality": "法属波利尼西亚"
      }
    ]
  },
  {
    "country_name": "Gabon",
    "alpha_2": "GA",
    "alpha_3": "GAB",
    "nationality": "Gabonese",
    "calling_code": "241",
    "country_image": null,
    "translations": [
      {
        "id": 415,
        "country_codes_alpha_2": "GA",
        "languages_code": "zh-CN",
        "country_name": "加蓬",
        "nationality": "加蓬"
      },
      {
        "id": 414,
        "country_codes_alpha_2": "GA",
        "languages_code": "en-US",
        "country_name": "Gabon",
        "nationality": "Gabonese"
      },
      {
        "id": 778,
        "country_codes_alpha_2": "GA",
        "languages_code": "zh-HK",
        "country_name": "加蓬",
        "nationality": "加蓬"
      }
    ]
  },
  {
    "country_name": "Gambia",
    "alpha_2": "GM",
    "alpha_3": "GMB",
    "nationality": "Gambian",
    "calling_code": "220",
    "country_image": null,
    "translations": [
      {
        "id": 492,
        "country_codes_alpha_2": "GM",
        "languages_code": "en-US",
        "country_name": "Gambia",
        "nationality": "Gambian"
      },
      {
        "id": 725,
        "country_codes_alpha_2": "GM",
        "languages_code": "zh-HK",
        "country_name": "岡比亞",
        "nationality": "岡比亞"
      },
      {
        "id": 493,
        "country_codes_alpha_2": "GM",
        "languages_code": "zh-CN",
        "country_name": "冈比亚",
        "nationality": "冈比亚"
      }
    ]
  },
  {
    "country_name": "Georgia",
    "alpha_2": "GE",
    "alpha_3": "GEO",
    "nationality": "Georgian",
    "calling_code": "995",
    "country_image": null,
    "translations": [
      {
        "id": 834,
        "country_codes_alpha_2": "GE",
        "languages_code": "zh-HK",
        "country_name": "格魯吉亞",
        "nationality": "格魯吉亞"
      },
      {
        "id": 336,
        "country_codes_alpha_2": "GE",
        "languages_code": "en-US",
        "country_name": "Georgia",
        "nationality": "Georgian"
      },
      {
        "id": 337,
        "country_codes_alpha_2": "GE",
        "languages_code": "zh-CN",
        "country_name": "格鲁吉亚",
        "nationality": "格鲁吉亚"
      }
    ]
  },
  {
    "country_name": "Germany",
    "alpha_2": "DE",
    "alpha_3": "DEU",
    "nationality": "German",
    "calling_code": "49",
    "country_image": null,
    "translations": [
      {
        "id": 563,
        "country_codes_alpha_2": "DE",
        "languages_code": "zh-CN",
        "country_name": "德国",
        "nationality": "德国"
      },
      {
        "id": 562,
        "country_codes_alpha_2": "DE",
        "languages_code": "en-US",
        "country_name": "Germany",
        "nationality": "German"
      },
      {
        "id": 851,
        "country_codes_alpha_2": "DE",
        "languages_code": "zh-HK",
        "country_name": "德國",
        "nationality": "德國"
      }
    ]
  },
  {
    "country_name": "Ghana",
    "alpha_2": "GH",
    "alpha_3": "GHA",
    "nationality": "Ghanaian",
    "calling_code": "233",
    "country_image": null,
    "translations": [
      {
        "id": 386,
        "country_codes_alpha_2": "GH",
        "languages_code": "en-US",
        "country_name": "Ghana",
        "nationality": "Ghanaian"
      },
      {
        "id": 639,
        "country_codes_alpha_2": "GH",
        "languages_code": "zh-HK",
        "country_name": "加納",
        "nationality": "加納"
      },
      {
        "id": 387,
        "country_codes_alpha_2": "GH",
        "languages_code": "zh-CN",
        "country_name": "加纳",
        "nationality": "加纳"
      }
    ]
  },
  {
    "country_name": "Gibraltar",
    "alpha_2": "GI",
    "alpha_3": "GIB",
    "nationality": "Gibraltarian",
    "calling_code": "350",
    "country_image": null,
    "translations": [
      {
        "id": 278,
        "country_codes_alpha_2": "GI",
        "languages_code": "en-US",
        "country_name": "Gibraltar",
        "nationality": "Gibraltarian"
      },
      {
        "id": 279,
        "country_codes_alpha_2": "GI",
        "languages_code": "zh-CN",
        "country_name": "直布罗陀",
        "nationality": "直布罗陀"
      },
      {
        "id": 730,
        "country_codes_alpha_2": "GI",
        "languages_code": "zh-HK",
        "country_name": "直布羅陀",
        "nationality": "直布羅陀"
      }
    ]
  },
  {
    "country_name": "Greece",
    "alpha_2": "GR",
    "alpha_3": "GRC",
    "nationality": "Greek",
    "calling_code": "30",
    "country_image": null,
    "translations": [
      {
        "id": 547,
        "country_codes_alpha_2": "GR",
        "languages_code": "zh-CN",
        "country_name": "希腊",
        "nationality": "希腊"
      },
      {
        "id": 810,
        "country_codes_alpha_2": "GR",
        "languages_code": "zh-HK",
        "country_name": "希臘",
        "nationality": "希臘"
      },
      {
        "id": 546,
        "country_codes_alpha_2": "GR",
        "languages_code": "en-US",
        "country_name": "Greece",
        "nationality": "Greek"
      }
    ]
  },
  {
    "country_name": "Greenland",
    "alpha_2": "GL",
    "alpha_3": "GRL",
    "nationality": "Danish (Greenland)",
    "calling_code": "299",
    "country_image": null,
    "translations": [
      {
        "id": 220,
        "country_codes_alpha_2": "GL",
        "languages_code": "en-US",
        "country_name": "Greenland",
        "nationality": "Danish (Greenland)"
      },
      {
        "id": 221,
        "country_codes_alpha_2": "GL",
        "languages_code": "zh-CN",
        "country_name": "格陵兰",
        "nationality": "格陵兰"
      },
      {
        "id": 668,
        "country_codes_alpha_2": "GL",
        "languages_code": "zh-HK",
        "country_name": "格陵蘭",
        "nationality": "格陵蘭"
      }
    ]
  },
  {
    "country_name": "Grenada",
    "alpha_2": "GD",
    "alpha_3": "GRD",
    "nationality": "Grenadian",
    "calling_code": "1473",
    "country_image": null,
    "translations": [
      {
        "id": 902,
        "country_codes_alpha_2": "GD",
        "languages_code": "en-US",
        "country_name": "Grenada",
        "nationality": "Grenadian"
      },
      {
        "id": 901,
        "country_codes_alpha_2": "GD",
        "languages_code": "zh-CN",
        "country_name": "格林纳达",
        "nationality": "格林纳达"
      },
      {
        "id": 1017,
        "country_codes_alpha_2": "GD",
        "languages_code": "zh-HK",
        "country_name": "格林納達",
        "nationality": "格林納達"
      }
    ]
  },
  {
    "country_name": "Guam",
    "alpha_2": "GU",
    "alpha_3": "GUM",
    "nationality": "Guamanian",
    "calling_code": "1671",
    "country_image": null,
    "translations": [
      {
        "id": 883,
        "country_codes_alpha_2": "GU",
        "languages_code": "zh-CN",
        "country_name": "关岛",
        "nationality": "关岛"
      },
      {
        "id": 884,
        "country_codes_alpha_2": "GU",
        "languages_code": "en-US",
        "country_name": "Guam",
        "nationality": "Guamanian"
      },
      {
        "id": 1011,
        "country_codes_alpha_2": "GU",
        "languages_code": "zh-HK",
        "country_name": "關島",
        "nationality": "關島"
      }
    ]
  },
  {
    "country_name": "Guatemala",
    "alpha_2": "GT",
    "alpha_3": "GTM",
    "nationality": "Guatemalan",
    "calling_code": "502",
    "country_image": null,
    "translations": [
      {
        "id": 243,
        "country_codes_alpha_2": "GT",
        "languages_code": "zh-CN",
        "country_name": "危地马拉",
        "nationality": "危地马拉"
      },
      {
        "id": 242,
        "country_codes_alpha_2": "GT",
        "languages_code": "en-US",
        "country_name": "Guatemala",
        "nationality": "Guatemalan"
      },
      {
        "id": 745,
        "country_codes_alpha_2": "GT",
        "languages_code": "zh-HK",
        "country_name": "危地馬拉",
        "nationality": "危地馬拉"
      }
    ]
  },
  {
    "country_name": "Guernsey",
    "alpha_2": "GG",
    "alpha_3": "GGY",
    "nationality": "British (Guernsey)",
    "calling_code": "441481",
    "country_image": null,
    "translations": [
      {
        "id": 942,
        "country_codes_alpha_2": "GG",
        "languages_code": "en-US",
        "country_name": "Guernsey",
        "nationality": "British (Guernsey)"
      },
      {
        "id": 941,
        "country_codes_alpha_2": "GG",
        "languages_code": "zh-CN",
        "country_name": "根西",
        "nationality": "根西岛"
      },
      {
        "id": 1006,
        "country_codes_alpha_2": "GG",
        "languages_code": "zh-HK",
        "country_name": "根西",
        "nationality": "根西島"
      }
    ]
  },
  {
    "country_name": "Guinea",
    "alpha_2": "GN",
    "alpha_3": "GIN",
    "nationality": "Guinean",
    "calling_code": "224",
    "country_image": null,
    "translations": [
      {
        "id": 402,
        "country_codes_alpha_2": "GN",
        "languages_code": "en-US",
        "country_name": "Guinea",
        "nationality": "Guinean"
      },
      {
        "id": 403,
        "country_codes_alpha_2": "GN",
        "languages_code": "zh-CN",
        "country_name": "几内亚",
        "nationality": "几内亚"
      },
      {
        "id": 748,
        "country_codes_alpha_2": "GN",
        "languages_code": "zh-HK",
        "country_name": "幾內亞",
        "nationality": "幾內亞"
      }
    ]
  },
  {
    "country_name": "Guinea-Bissau",
    "alpha_2": "GW",
    "alpha_3": "GNB",
    "nationality": "Guinea-Bissau citizen",
    "calling_code": "245",
    "country_image": null,
    "translations": [
      {
        "id": 180,
        "country_codes_alpha_2": "GW",
        "languages_code": "en-US",
        "country_name": "Guinea-Bissau",
        "nationality": "Guinea-Bissau citizen"
      },
      {
        "id": 822,
        "country_codes_alpha_2": "GW",
        "languages_code": "zh-HK",
        "country_name": "幾內亞比紹",
        "nationality": "幾內亞比索"
      },
      {
        "id": 181,
        "country_codes_alpha_2": "GW",
        "languages_code": "zh-CN",
        "country_name": "几内亚比绍",
        "nationality": "几内亚比索"
      }
    ]
  },
  {
    "country_name": "Guyana",
    "alpha_2": "GY",
    "alpha_3": "GUY",
    "nationality": "Guyanese",
    "calling_code": "592",
    "country_image": null,
    "translations": [
      {
        "id": 272,
        "country_codes_alpha_2": "GY",
        "languages_code": "en-US",
        "country_name": "Guyana",
        "nationality": "Guyanese"
      },
      {
        "id": 660,
        "country_codes_alpha_2": "GY",
        "languages_code": "zh-HK",
        "country_name": "圭亞那",
        "nationality": "圭亞那"
      },
      {
        "id": 273,
        "country_codes_alpha_2": "GY",
        "languages_code": "zh-CN",
        "country_name": "圭亚那",
        "nationality": "圭亚那"
      }
    ]
  },
  {
    "country_name": "Haiti",
    "alpha_2": "HT",
    "alpha_3": "HTI",
    "nationality": "Haitian",
    "calling_code": "509",
    "country_image": null,
    "translations": [
      {
        "id": 377,
        "country_codes_alpha_2": "HT",
        "languages_code": "zh-CN",
        "country_name": "海地",
        "nationality": "海地"
      },
      {
        "id": 376,
        "country_codes_alpha_2": "HT",
        "languages_code": "en-US",
        "country_name": "Haiti",
        "nationality": "Haitian"
      },
      {
        "id": 799,
        "country_codes_alpha_2": "HT",
        "languages_code": "zh-HK",
        "country_name": "海地",
        "nationality": "海地"
      }
    ]
  },
  {
    "country_name": "Holy See",
    "alpha_2": "VA",
    "alpha_3": "VAT",
    "nationality": "Vatican citizen",
    "calling_code": "379",
    "country_image": null,
    "translations": [
      {
        "id": 903,
        "country_codes_alpha_2": "VA",
        "languages_code": "zh-CN",
        "country_name": "教廷",
        "nationality": "梵帝冈"
      },
      {
        "id": 904,
        "country_codes_alpha_2": "VA",
        "languages_code": "en-US",
        "country_name": "Holy See",
        "nationality": "Vatican citizen"
      },
      {
        "id": 1002,
        "country_codes_alpha_2": "VA",
        "languages_code": "zh-HK",
        "country_name": "教廷",
        "nationality": "梵帝岡"
      }
    ]
  },
  {
    "country_name": "Honduras",
    "alpha_2": "HN",
    "alpha_3": "HND",
    "nationality": "Honduran",
    "calling_code": "504",
    "country_image": null,
    "translations": [
      {
        "id": 669,
        "country_codes_alpha_2": "HN",
        "languages_code": "zh-HK",
        "country_name": "洪都拉斯",
        "nationality": "洪都拉斯"
      },
      {
        "id": 626,
        "country_codes_alpha_2": "HN",
        "languages_code": "en-US",
        "country_name": "Honduras",
        "nationality": "Honduran"
      },
      {
        "id": 627,
        "country_codes_alpha_2": "HN",
        "languages_code": "zh-CN",
        "country_name": "洪都拉斯",
        "nationality": "洪都拉斯"
      }
    ]
  },
  {
    "country_name": "Hong Kong",
    "alpha_2": "HK",
    "alpha_3": "HKG",
    "nationality": "Chinese (Hong Kong)",
    "calling_code": "852",
    "country_image": null,
    "translations": [
      {
        "id": 582,
        "country_codes_alpha_2": "HK",
        "languages_code": "en-US",
        "country_name": "Hong Kong",
        "nationality": "Chinese (Hong Kong)"
      },
      {
        "id": 583,
        "country_codes_alpha_2": "HK",
        "languages_code": "zh-CN",
        "country_name": "中国香港特别行政区",
        "nationality": "中国（香港）"
      },
      {
        "id": 635,
        "country_codes_alpha_2": "HK",
        "languages_code": "zh-HK",
        "country_name": "中國香港特別行政區",
        "nationality": "中國（香港）"
      }
    ]
  },
  {
    "country_name": "Hungary",
    "alpha_2": "HU",
    "alpha_3": "HUN",
    "nationality": "Hungarian",
    "calling_code": "36",
    "country_image": null,
    "translations": [
      {
        "id": 420,
        "country_codes_alpha_2": "HU",
        "languages_code": "en-US",
        "country_name": "Hungary",
        "nationality": "Hungarian"
      },
      {
        "id": 747,
        "country_codes_alpha_2": "HU",
        "languages_code": "zh-HK",
        "country_name": "匈牙利",
        "nationality": "匈牙利"
      },
      {
        "id": 421,
        "country_codes_alpha_2": "HU",
        "languages_code": "zh-CN",
        "country_name": "匈牙利",
        "nationality": "匈牙利"
      }
    ]
  },
  {
    "country_name": "Iceland",
    "alpha_2": "IS",
    "alpha_3": "ISL",
    "nationality": "Icelandic",
    "calling_code": "354",
    "country_image": null,
    "translations": [
      {
        "id": 522,
        "country_codes_alpha_2": "IS",
        "languages_code": "en-US",
        "country_name": "Iceland",
        "nationality": "Icelandic"
      },
      {
        "id": 523,
        "country_codes_alpha_2": "IS",
        "languages_code": "zh-CN",
        "country_name": "冰岛",
        "nationality": "冰岛"
      },
      {
        "id": 802,
        "country_codes_alpha_2": "IS",
        "languages_code": "zh-HK",
        "country_name": "冰島",
        "nationality": "冰島"
      }
    ]
  },
  {
    "country_name": "India",
    "alpha_2": "IN",
    "alpha_3": "IND",
    "nationality": "Indian",
    "calling_code": "91",
    "country_image": null,
    "translations": [
      {
        "id": 182,
        "country_codes_alpha_2": "IN",
        "languages_code": "en-US",
        "country_name": "India",
        "nationality": "Indian"
      },
      {
        "id": 183,
        "country_codes_alpha_2": "IN",
        "languages_code": "zh-CN",
        "country_name": "印度",
        "nationality": "印度"
      },
      {
        "id": 696,
        "country_codes_alpha_2": "IN",
        "languages_code": "zh-HK",
        "country_name": "印度",
        "nationality": "印度"
      }
    ]
  },
  {
    "country_name": "Indonesia",
    "alpha_2": "ID",
    "alpha_3": "IDN",
    "nationality": "Indonesian",
    "calling_code": "62",
    "country_image": null,
    "translations": [
      {
        "id": 237,
        "country_codes_alpha_2": "ID",
        "languages_code": "zh-CN",
        "country_name": "印度尼西亚",
        "nationality": "印度尼西亚"
      },
      {
        "id": 236,
        "country_codes_alpha_2": "ID",
        "languages_code": "en-US",
        "country_name": "Indonesia",
        "nationality": "Indonesian"
      },
      {
        "id": 814,
        "country_codes_alpha_2": "ID",
        "languages_code": "zh-HK",
        "country_name": "印度尼西亞",
        "nationality": "印度尼西亞"
      }
    ]
  },
  {
    "country_name": "Iran (Islamic Republic of)",
    "alpha_2": "IR",
    "alpha_3": "IRN",
    "nationality": "Iranian",
    "calling_code": "98",
    "country_image": null,
    "translations": [
      {
        "id": 356,
        "country_codes_alpha_2": "IR",
        "languages_code": "en-US",
        "country_name": "Iran (Islamic Republic of)",
        "nationality": "Iranian"
      },
      {
        "id": 357,
        "country_codes_alpha_2": "IR",
        "languages_code": "zh-CN",
        "country_name": "伊朗（伊斯兰共和国）",
        "nationality": "伊朗"
      },
      {
        "id": 796,
        "country_codes_alpha_2": "IR",
        "languages_code": "zh-HK",
        "country_name": "伊朗(伊斯蘭共和國)",
        "nationality": "伊朗"
      }
    ]
  },
  {
    "country_name": "Iraq",
    "alpha_2": "IQ",
    "alpha_3": "IRQ",
    "nationality": "Iraqi",
    "calling_code": "964",
    "country_image": null,
    "translations": [
      {
        "id": 408,
        "country_codes_alpha_2": "IQ",
        "languages_code": "en-US",
        "country_name": "Iraq",
        "nationality": "Iraqi"
      },
      {
        "id": 409,
        "country_codes_alpha_2": "IQ",
        "languages_code": "zh-CN",
        "country_name": "伊拉克",
        "nationality": "伊拉克"
      },
      {
        "id": 777,
        "country_codes_alpha_2": "IQ",
        "languages_code": "zh-HK",
        "country_name": "伊拉克",
        "nationality": "伊拉克"
      }
    ]
  },
  {
    "country_name": "Ireland",
    "alpha_2": "IE",
    "alpha_3": "IRL",
    "nationality": "Irish",
    "calling_code": "353",
    "country_image": null,
    "translations": [
      {
        "id": 433,
        "country_codes_alpha_2": "IE",
        "languages_code": "zh-CN",
        "country_name": "爱尔兰",
        "nationality": "爱尔兰"
      },
      {
        "id": 432,
        "country_codes_alpha_2": "IE",
        "languages_code": "en-US",
        "country_name": "Ireland",
        "nationality": "Irish"
      },
      {
        "id": 664,
        "country_codes_alpha_2": "IE",
        "languages_code": "zh-HK",
        "country_name": "愛爾蘭",
        "nationality": "愛爾蘭"
      }
    ]
  },
  {
    "country_name": "Isle of Man",
    "alpha_2": "IM",
    "alpha_3": "IMN",
    "nationality": "British (Isle of Man)",
    "calling_code": "441624",
    "country_image": null,
    "translations": [
      {
        "id": 907,
        "country_codes_alpha_2": "IM",
        "languages_code": "zh-CN",
        "country_name": "马恩岛",
        "nationality": "马恩岛"
      },
      {
        "id": 1005,
        "country_codes_alpha_2": "IM",
        "languages_code": "zh-HK",
        "country_name": "馬恩島",
        "nationality": "馬恩島"
      },
      {
        "id": 908,
        "country_codes_alpha_2": "IM",
        "languages_code": "en-US",
        "country_name": "Isle of Man",
        "nationality": "British (Isle of Man)"
      }
    ]
  },
  {
    "country_name": "Israel",
    "alpha_2": "IL",
    "alpha_3": "ISR",
    "nationality": "Israeli",
    "calling_code": "972",
    "country_image": null,
    "translations": [
      {
        "id": 253,
        "country_codes_alpha_2": "IL",
        "languages_code": "zh-CN",
        "country_name": "以色列",
        "nationality": "以色列"
      },
      {
        "id": 252,
        "country_codes_alpha_2": "IL",
        "languages_code": "en-US",
        "country_name": "Israel",
        "nationality": "Israeli"
      },
      {
        "id": 734,
        "country_codes_alpha_2": "IL",
        "languages_code": "zh-HK",
        "country_name": "以色列",
        "nationality": "以色列"
      }
    ]
  },
  {
    "country_name": "Italy",
    "alpha_2": "IT",
    "alpha_3": "ITA",
    "nationality": "Italian",
    "calling_code": "39",
    "country_image": null,
    "translations": [
      {
        "id": 462,
        "country_codes_alpha_2": "IT",
        "languages_code": "en-US",
        "country_name": "Italy",
        "nationality": "Italian"
      },
      {
        "id": 807,
        "country_codes_alpha_2": "IT",
        "languages_code": "zh-HK",
        "country_name": "意大利",
        "nationality": "意大利"
      },
      {
        "id": 463,
        "country_codes_alpha_2": "IT",
        "languages_code": "zh-CN",
        "country_name": "意大利",
        "nationality": "意大利"
      }
    ]
  },
  {
    "country_name": "Jamaica",
    "alpha_2": "JM",
    "alpha_3": "JAM",
    "nationality": "Jamaican",
    "calling_code": "1876",
    "country_image": null,
    "translations": [
      {
        "id": 928,
        "country_codes_alpha_2": "JM",
        "languages_code": "en-US",
        "country_name": "Jamaica",
        "nationality": "Jamaican"
      },
      {
        "id": 927,
        "country_codes_alpha_2": "JM",
        "languages_code": "zh-CN",
        "country_name": "牙买加",
        "nationality": "牙买加"
      },
      {
        "id": 987,
        "country_codes_alpha_2": "JM",
        "languages_code": "zh-HK",
        "country_name": "牙買加",
        "nationality": "牙買加"
      }
    ]
  },
  {
    "country_name": "Japan",
    "alpha_2": "JP",
    "alpha_3": "JPN",
    "nationality": "Japanese",
    "calling_code": "81",
    "country_image": null,
    "translations": [
      {
        "id": 424,
        "country_codes_alpha_2": "JP",
        "languages_code": "en-US",
        "country_name": "Japan",
        "nationality": "Japanese"
      },
      {
        "id": 751,
        "country_codes_alpha_2": "JP",
        "languages_code": "zh-HK",
        "country_name": "日本",
        "nationality": "日本"
      },
      {
        "id": 425,
        "country_codes_alpha_2": "JP",
        "languages_code": "zh-CN",
        "country_name": "日本",
        "nationality": "日本"
      }
    ]
  },
  {
    "country_name": "Jersey",
    "alpha_2": "JE",
    "alpha_3": "JEY",
    "nationality": "British (Jersey)",
    "calling_code": "441534",
    "country_image": null,
    "translations": [
      {
        "id": 1003,
        "country_codes_alpha_2": "JE",
        "languages_code": "zh-HK",
        "country_name": "澤西",
        "nationality": "澤西島"
      },
      {
        "id": 906,
        "country_codes_alpha_2": "JE",
        "languages_code": "en-US",
        "country_name": "Jersey",
        "nationality": "British (Jersey)"
      },
      {
        "id": 905,
        "country_codes_alpha_2": "JE",
        "languages_code": "zh-CN",
        "country_name": "泽西",
        "nationality": "泽西岛"
      }
    ]
  },
  {
    "country_name": "Jordan",
    "alpha_2": "JO",
    "alpha_3": "JOR",
    "nationality": "Jordanian",
    "calling_code": "962",
    "country_image": null,
    "translations": [
      {
        "id": 960,
        "country_codes_alpha_2": "JO",
        "languages_code": "zh-CN",
        "country_name": "约旦哈希姆王国",
        "nationality": "约旦"
      },
      {
        "id": 961,
        "country_codes_alpha_2": "JO",
        "languages_code": "en-US",
        "country_name": "Jordan",
        "nationality": "Jordanian"
      },
      {
        "id": 711,
        "country_codes_alpha_2": "JO",
        "languages_code": "zh-HK",
        "country_name": "約旦",
        "nationality": "約旦"
      }
    ]
  },
  {
    "country_name": "Kazakhstan",
    "alpha_2": "KZ",
    "alpha_3": "KAZ",
    "nationality": "Kazakh",
    "calling_code": "7",
    "country_image": null,
    "translations": [
      {
        "id": 707,
        "country_codes_alpha_2": "KZ",
        "languages_code": "zh-HK",
        "country_name": "俄羅斯聯邦",
        "nationality": "哈薩克斯坦"
      },
      {
        "id": 418,
        "country_codes_alpha_2": "KZ",
        "languages_code": "en-US",
        "country_name": "Kazakhstan",
        "nationality": "Kazakh"
      },
      {
        "id": 419,
        "country_codes_alpha_2": "KZ",
        "languages_code": "zh-CN",
        "country_name": "哈萨克斯坦",
        "nationality": "哈萨克斯坦"
      }
    ]
  },
  {
    "country_name": "Kenya",
    "alpha_2": "KE",
    "alpha_3": "KEN",
    "nationality": "Kenyan",
    "calling_code": "254",
    "country_image": null,
    "translations": [
      {
        "id": 613,
        "country_codes_alpha_2": "KE",
        "languages_code": "zh-CN",
        "country_name": "肯尼亚",
        "nationality": "肯尼亚"
      },
      {
        "id": 612,
        "country_codes_alpha_2": "KE",
        "languages_code": "en-US",
        "country_name": "Kenya",
        "nationality": "Kenyan"
      },
      {
        "id": 715,
        "country_codes_alpha_2": "KE",
        "languages_code": "zh-HK",
        "country_name": "肯尼亞",
        "nationality": "肯尼亞"
      }
    ]
  },
  {
    "country_name": "Kiribati",
    "alpha_2": "KI",
    "alpha_3": "KIR",
    "nationality": "Kiribati citizen",
    "calling_code": "686",
    "country_image": null,
    "translations": [
      {
        "id": 268,
        "country_codes_alpha_2": "KI",
        "languages_code": "en-US",
        "country_name": "Kiribati",
        "nationality": "Kiribati citizen"
      },
      {
        "id": 712,
        "country_codes_alpha_2": "KI",
        "languages_code": "zh-HK",
        "country_name": "基裏巴斯",
        "nationality": "基里巴斯"
      },
      {
        "id": 269,
        "country_codes_alpha_2": "KI",
        "languages_code": "zh-CN",
        "country_name": "基里巴斯",
        "nationality": "基里巴斯"
      }
    ]
  },
  {
    "country_name": "Korea (Democratic People's Republic of)",
    "alpha_2": "KP",
    "alpha_3": "PRK",
    "nationality": "North Korean",
    "calling_code": "850",
    "country_image": null,
    "translations": [
      {
        "id": 604,
        "country_codes_alpha_2": "KP",
        "languages_code": "en-US",
        "country_name": "Democratic People's Republic of Korea",
        "nationality": "North Korean"
      },
      {
        "id": 605,
        "country_codes_alpha_2": "KP",
        "languages_code": "zh-CN",
        "country_name": "朝鲜民主主义人民共和国",
        "nationality": "朝鲜"
      },
      {
        "id": 831,
        "country_codes_alpha_2": "KP",
        "languages_code": "zh-HK",
        "country_name": "朝鮮民主主義人民共和國",
        "nationality": "朝鮮"
      }
    ]
  },
  {
    "country_name": "Korea, Republic of",
    "alpha_2": "KR",
    "alpha_3": "KOR",
    "nationality": "South Korean",
    "calling_code": "82",
    "country_image": null,
    "translations": [
      {
        "id": 466,
        "country_codes_alpha_2": "KR",
        "languages_code": "en-US",
        "country_name": "Republic of Korea",
        "nationality": "South Korean"
      },
      {
        "id": 703,
        "country_codes_alpha_2": "KR",
        "languages_code": "zh-HK",
        "country_name": "大韓民國",
        "nationality": "韓國"
      },
      {
        "id": 467,
        "country_codes_alpha_2": "KR",
        "languages_code": "zh-CN",
        "country_name": "大韩民国",
        "nationality": "韩国"
      }
    ]
  },
  {
    "country_name": "Kuwait",
    "alpha_2": "KW",
    "alpha_3": "KWT",
    "nationality": "Kuwaiti",
    "calling_code": "965",
    "country_image": null,
    "translations": [
      {
        "id": 637,
        "country_codes_alpha_2": "KW",
        "languages_code": "zh-HK",
        "country_name": "科威特",
        "nationality": "科威特"
      },
      {
        "id": 287,
        "country_codes_alpha_2": "KW",
        "languages_code": "zh-CN",
        "country_name": "科威特",
        "nationality": "科威特"
      },
      {
        "id": 286,
        "country_codes_alpha_2": "KW",
        "languages_code": "en-US",
        "country_name": "Kuwait",
        "nationality": "Kuwaiti"
      }
    ]
  },
  {
    "country_name": "Kyrgyzstan",
    "alpha_2": "KG",
    "alpha_3": "KGZ",
    "nationality": "Kyrgyz",
    "calling_code": "996",
    "country_image": null,
    "translations": [
      {
        "id": 374,
        "country_codes_alpha_2": "KG",
        "languages_code": "en-US",
        "country_name": "Kyrgyzstan",
        "nationality": "Kyrgyz"
      },
      {
        "id": 670,
        "country_codes_alpha_2": "KG",
        "languages_code": "zh-HK",
        "country_name": "吉爾吉斯斯坦",
        "nationality": "吉爾吉斯斯坦"
      },
      {
        "id": 375,
        "country_codes_alpha_2": "KG",
        "languages_code": "zh-CN",
        "country_name": "吉尔吉斯斯坦",
        "nationality": "吉尔吉斯斯坦"
      }
    ]
  },
  {
    "country_name": "Lao People's Democratic Republic",
    "alpha_2": "LA",
    "alpha_3": "LAO",
    "nationality": "Lao",
    "calling_code": "856",
    "country_image": null,
    "translations": [
      {
        "id": 554,
        "country_codes_alpha_2": "LA",
        "languages_code": "en-US",
        "country_name": "Lao People's Democratic Republic",
        "nationality": "Lao"
      },
      {
        "id": 555,
        "country_codes_alpha_2": "LA",
        "languages_code": "zh-CN",
        "country_name": "老挝人民民主共和国",
        "nationality": "老挝"
      },
      {
        "id": 676,
        "country_codes_alpha_2": "LA",
        "languages_code": "zh-HK",
        "country_name": "老撾人民民主共和國",
        "nationality": "老撾"
      }
    ]
  },
  {
    "country_name": "Latvia",
    "alpha_2": "LV",
    "alpha_3": "LVA",
    "nationality": "Latvian",
    "calling_code": "371",
    "country_image": null,
    "translations": [
      {
        "id": 275,
        "country_codes_alpha_2": "LV",
        "languages_code": "zh-CN",
        "country_name": "拉脱维亚",
        "nationality": "拉脱维亚"
      },
      {
        "id": 274,
        "country_codes_alpha_2": "LV",
        "languages_code": "en-US",
        "country_name": "Latvia",
        "nationality": "Latvian"
      },
      {
        "id": 746,
        "country_codes_alpha_2": "LV",
        "languages_code": "zh-HK",
        "country_name": "拉脫維亞",
        "nationality": "拉脫維亞"
      }
    ]
  },
  {
    "country_name": "Lebanon",
    "alpha_2": "LB",
    "alpha_3": "LBN",
    "nationality": "Lebanese",
    "calling_code": "961",
    "country_image": null,
    "translations": [
      {
        "id": 300,
        "country_codes_alpha_2": "LB",
        "languages_code": "en-US",
        "country_name": "Lebanon",
        "nationality": "Lebanese"
      },
      {
        "id": 704,
        "country_codes_alpha_2": "LB",
        "languages_code": "zh-HK",
        "country_name": "黎巴嫩",
        "nationality": "黎巴嫩"
      },
      {
        "id": 301,
        "country_codes_alpha_2": "LB",
        "languages_code": "zh-CN",
        "country_name": "黎巴嫩",
        "nationality": "黎巴嫩"
      }
    ]
  },
  {
    "country_name": "Lesotho",
    "alpha_2": "LS",
    "alpha_3": "LSO",
    "nationality": "Lesotho citizen",
    "calling_code": "266",
    "country_image": null,
    "translations": [
      {
        "id": 318,
        "country_codes_alpha_2": "LS",
        "languages_code": "en-US",
        "country_name": "Lesotho",
        "nationality": "Lesotho citizen"
      },
      {
        "id": 319,
        "country_codes_alpha_2": "LS",
        "languages_code": "zh-CN",
        "country_name": "莱索托",
        "nationality": "莱索托"
      },
      {
        "id": 679,
        "country_codes_alpha_2": "LS",
        "languages_code": "zh-HK",
        "country_name": "萊索托",
        "nationality": "萊索托"
      }
    ]
  },
  {
    "country_name": "Liberia",
    "alpha_2": "LR",
    "alpha_3": "LBR",
    "nationality": "Liberian",
    "calling_code": "231",
    "country_image": null,
    "translations": [
      {
        "id": 280,
        "country_codes_alpha_2": "LR",
        "languages_code": "en-US",
        "country_name": "Liberia",
        "nationality": "Liberian"
      },
      {
        "id": 281,
        "country_codes_alpha_2": "LR",
        "languages_code": "zh-CN",
        "country_name": "利比里亚",
        "nationality": "利比里亚"
      },
      {
        "id": 658,
        "country_codes_alpha_2": "LR",
        "languages_code": "zh-HK",
        "country_name": "利比裏亞",
        "nationality": "利比里亞"
      }
    ]
  },
  {
    "country_name": "Libya",
    "alpha_2": "LY",
    "alpha_3": "LBY",
    "nationality": "Libyan",
    "calling_code": "218",
    "country_image": null,
    "translations": [
      {
        "id": 526,
        "country_codes_alpha_2": "LY",
        "languages_code": "en-US",
        "country_name": "Libya",
        "nationality": "Libyan"
      },
      {
        "id": 813,
        "country_codes_alpha_2": "LY",
        "languages_code": "zh-HK",
        "country_name": "利比亞",
        "nationality": "利比亞"
      },
      {
        "id": 527,
        "country_codes_alpha_2": "LY",
        "languages_code": "zh-CN",
        "country_name": "利比亚",
        "nationality": "利比亚"
      }
    ]
  },
  {
    "country_name": "Liechtenstein",
    "alpha_2": "LI",
    "alpha_3": "LIE",
    "nationality": "Liechtenstein citizen",
    "calling_code": "423",
    "country_image": null,
    "translations": [
      {
        "id": 480,
        "country_codes_alpha_2": "LI",
        "languages_code": "en-US",
        "country_name": "Liechtenstein",
        "nationality": "Liechtenstein citizen"
      },
      {
        "id": 481,
        "country_codes_alpha_2": "LI",
        "languages_code": "zh-CN",
        "country_name": "列支敦士登",
        "nationality": "列支敦士登"
      },
      {
        "id": 824,
        "country_codes_alpha_2": "LI",
        "languages_code": "zh-HK",
        "country_name": "列支敦士登",
        "nationality": "列支敦士登"
      }
    ]
  },
  {
    "country_name": "Lithuania",
    "alpha_2": "LT",
    "alpha_3": "LTU",
    "nationality": "Lithuanian",
    "calling_code": "370",
    "country_image": null,
    "translations": [
      {
        "id": 381,
        "country_codes_alpha_2": "LT",
        "languages_code": "zh-CN",
        "country_name": "立陶宛",
        "nationality": "立陶宛"
      },
      {
        "id": 380,
        "country_codes_alpha_2": "LT",
        "languages_code": "en-US",
        "country_name": "Lithuania",
        "nationality": "Lithuanian"
      },
      {
        "id": 809,
        "country_codes_alpha_2": "LT",
        "languages_code": "zh-HK",
        "country_name": "立陶宛",
        "nationality": "立陶宛"
      }
    ]
  },
  {
    "country_name": "Luxembourg",
    "alpha_2": "LU",
    "alpha_3": "LUX",
    "nationality": "Luxembourger",
    "calling_code": "352",
    "country_image": null,
    "translations": [
      {
        "id": 326,
        "country_codes_alpha_2": "LU",
        "languages_code": "en-US",
        "country_name": "Luxembourg",
        "nationality": "Luxembourger"
      },
      {
        "id": 708,
        "country_codes_alpha_2": "LU",
        "languages_code": "zh-HK",
        "country_name": "盧森堡",
        "nationality": "盧森堡"
      },
      {
        "id": 327,
        "country_codes_alpha_2": "LU",
        "languages_code": "zh-CN",
        "country_name": "卢森堡",
        "nationality": "卢森堡"
      }
    ]
  },
  {
    "country_name": "Macao",
    "alpha_2": "MO",
    "alpha_3": "MAC",
    "nationality": "Chinese (Macau)",
    "calling_code": "853",
    "country_image": null,
    "translations": [
      {
        "id": 445,
        "country_codes_alpha_2": "MO",
        "languages_code": "zh-CN",
        "country_name": "中国澳门特别行政区",
        "nationality": "中国（澳门）"
      },
      {
        "id": 444,
        "country_codes_alpha_2": "MO",
        "languages_code": "en-US",
        "country_name": "Macau",
        "nationality": "Chinese (Macau)"
      },
      {
        "id": 852,
        "country_codes_alpha_2": "MO",
        "languages_code": "zh-HK",
        "country_name": "中國澳門特別行政區",
        "nationality": "中國（澳門）"
      }
    ]
  },
  {
    "country_name": "Madagascar",
    "alpha_2": "MG",
    "alpha_3": "MDG",
    "nationality": "Malagasy",
    "calling_code": "261",
    "country_image": null,
    "translations": [
      {
        "id": 233,
        "country_codes_alpha_2": "MG",
        "languages_code": "zh-CN",
        "country_name": "马达加斯加",
        "nationality": "马达加斯加岛"
      },
      {
        "id": 232,
        "country_codes_alpha_2": "MG",
        "languages_code": "en-US",
        "country_name": "Madagascar",
        "nationality": "Malagasy"
      },
      {
        "id": 710,
        "country_codes_alpha_2": "MG",
        "languages_code": "zh-HK",
        "country_name": "馬達加斯加",
        "nationality": "马达加斯加岛"
      }
    ]
  },
  {
    "country_name": "Malawi",
    "alpha_2": "MW",
    "alpha_3": "MWI",
    "nationality": "Malawian",
    "calling_code": "265",
    "country_image": null,
    "translations": [
      {
        "id": 438,
        "country_codes_alpha_2": "MW",
        "languages_code": "en-US",
        "country_name": "Malawi",
        "nationality": "Malawian"
      },
      {
        "id": 439,
        "country_codes_alpha_2": "MW",
        "languages_code": "zh-CN",
        "country_name": "马拉维",
        "nationality": "马拉维"
      },
      {
        "id": 714,
        "country_codes_alpha_2": "MW",
        "languages_code": "zh-HK",
        "country_name": "馬拉維",
        "nationality": "馬拉維"
      }
    ]
  },
  {
    "country_name": "Malaysia",
    "alpha_2": "MY",
    "alpha_3": "MYS",
    "nationality": "Malaysian",
    "calling_code": "60",
    "country_image": null,
    "translations": [
      {
        "id": 615,
        "country_codes_alpha_2": "MY",
        "languages_code": "zh-CN",
        "country_name": "马来西亚",
        "nationality": "马来西亚"
      },
      {
        "id": 614,
        "country_codes_alpha_2": "MY",
        "languages_code": "en-US",
        "country_name": "Malaysia",
        "nationality": "Malaysian"
      },
      {
        "id": 838,
        "country_codes_alpha_2": "MY",
        "languages_code": "zh-HK",
        "country_name": "馬來西亞",
        "nationality": "馬來西亞"
      }
    ]
  },
  {
    "country_name": "Maldives",
    "alpha_2": "MV",
    "alpha_3": "MDV",
    "nationality": "Maldivian",
    "calling_code": "960",
    "country_image": null,
    "translations": [
      {
        "id": 223,
        "country_codes_alpha_2": "MV",
        "languages_code": "zh-CN",
        "country_name": "马尔代夫",
        "nationality": "马尔代夫"
      },
      {
        "id": 222,
        "country_codes_alpha_2": "MV",
        "languages_code": "en-US",
        "country_name": "Maldives",
        "nationality": "Maldivian"
      },
      {
        "id": 848,
        "country_codes_alpha_2": "MV",
        "languages_code": "zh-HK",
        "country_name": "馬爾代夫",
        "nationality": "馬爾代夫"
      }
    ]
  },
  {
    "country_name": "Mali",
    "alpha_2": "ML",
    "alpha_3": "MLI",
    "nationality": "Malian",
    "calling_code": "223",
    "country_image": null,
    "translations": [
      {
        "id": 366,
        "country_codes_alpha_2": "ML",
        "languages_code": "en-US",
        "country_name": "Mali",
        "nationality": "Malian"
      },
      {
        "id": 367,
        "country_codes_alpha_2": "ML",
        "languages_code": "zh-CN",
        "country_name": "马里",
        "nationality": "马里"
      },
      {
        "id": 735,
        "country_codes_alpha_2": "ML",
        "languages_code": "zh-HK",
        "country_name": "馬裏",
        "nationality": "馬里"
      }
    ]
  },
  {
    "country_name": "Malta",
    "alpha_2": "MT",
    "alpha_3": "MLT",
    "nationality": "Maltese",
    "calling_code": "356",
    "country_image": null,
    "translations": [
      {
        "id": 431,
        "country_codes_alpha_2": "MT",
        "languages_code": "zh-CN",
        "country_name": "马耳他",
        "nationality": "马耳他"
      },
      {
        "id": 430,
        "country_codes_alpha_2": "MT",
        "languages_code": "en-US",
        "country_name": "Malta",
        "nationality": "Maltese"
      },
      {
        "id": 806,
        "country_codes_alpha_2": "MT",
        "languages_code": "zh-HK",
        "country_name": "馬耳他",
        "nationality": "馬耳他"
      }
    ]
  },
  {
    "country_name": "Marshall Islands",
    "alpha_2": "MH",
    "alpha_3": "MHL",
    "nationality": "Marshallese",
    "calling_code": "692",
    "country_image": null,
    "translations": [
      {
        "id": 496,
        "country_codes_alpha_2": "MH",
        "languages_code": "en-US",
        "country_name": "Marshall Islands",
        "nationality": "Marshallese"
      },
      {
        "id": 749,
        "country_codes_alpha_2": "MH",
        "languages_code": "zh-HK",
        "country_name": "馬紹爾群島",
        "nationality": "馬紹爾群島"
      },
      {
        "id": 497,
        "country_codes_alpha_2": "MH",
        "languages_code": "zh-CN",
        "country_name": "马绍尔群岛",
        "nationality": "马绍尔群岛"
      }
    ]
  },
  {
    "country_name": "Mauritania",
    "alpha_2": "MR",
    "alpha_3": "MRT",
    "nationality": "Mauritanian",
    "calling_code": "222",
    "country_image": null,
    "translations": [
      {
        "id": 260,
        "country_codes_alpha_2": "MR",
        "languages_code": "en-US",
        "country_name": "Mauritania",
        "nationality": "Mauritanian"
      },
      {
        "id": 261,
        "country_codes_alpha_2": "MR",
        "languages_code": "zh-CN",
        "country_name": "毛里塔尼亚",
        "nationality": "毛里塔尼亚"
      },
      {
        "id": 758,
        "country_codes_alpha_2": "MR",
        "languages_code": "zh-HK",
        "country_name": "毛裏塔尼亞",
        "nationality": "毛里塔尼亞"
      }
    ]
  },
  {
    "country_name": "Mauritius",
    "alpha_2": "MU",
    "alpha_3": "MUS",
    "nationality": "Mauritian",
    "calling_code": "230",
    "country_image": null,
    "translations": [
      {
        "id": 207,
        "country_codes_alpha_2": "MU",
        "languages_code": "zh-CN",
        "country_name": "毛里求斯",
        "nationality": "毛里求斯"
      },
      {
        "id": 206,
        "country_codes_alpha_2": "MU",
        "languages_code": "en-US",
        "country_name": "Mauritius",
        "nationality": "Mauritian"
      },
      {
        "id": 755,
        "country_codes_alpha_2": "MU",
        "languages_code": "zh-HK",
        "country_name": "毛裏求斯",
        "nationality": "毛里求斯"
      }
    ]
  },
  {
    "country_name": "Mayotte",
    "alpha_2": "YT",
    "alpha_3": "MYT",
    "nationality": "French (Mayotte)",
    "calling_code": "262",
    "country_image": null,
    "translations": [
      {
        "id": 899,
        "country_codes_alpha_2": "YT",
        "languages_code": "zh-CN",
        "country_name": "马约特",
        "nationality": "马约特"
      },
      {
        "id": 900,
        "country_codes_alpha_2": "YT",
        "languages_code": "en-US",
        "country_name": "Mayotte",
        "nationality": "French (Mayotte)"
      },
      {
        "id": 995,
        "country_codes_alpha_2": "YT",
        "languages_code": "zh-HK",
        "country_name": "馬約特",
        "nationality": "馬約特"
      }
    ]
  },
  {
    "country_name": "Mexico",
    "alpha_2": "MX",
    "alpha_3": "MEX",
    "nationality": "Mexican",
    "calling_code": "52",
    "country_image": null,
    "translations": [
      {
        "id": 968,
        "country_codes_alpha_2": "MX",
        "languages_code": "zh-CN",
        "country_name": "墨西哥",
        "nationality": "墨西哥"
      },
      {
        "id": 969,
        "country_codes_alpha_2": "MX",
        "languages_code": "en-US",
        "country_name": "Mexico",
        "nationality": "Mexican"
      },
      {
        "id": 843,
        "country_codes_alpha_2": "MX",
        "languages_code": "zh-HK",
        "country_name": "墨西哥",
        "nationality": "墨西哥"
      }
    ]
  },
  {
    "country_name": "Micronesia (Federated States of)",
    "alpha_2": "FM",
    "alpha_3": "FSM",
    "nationality": "Micronesian",
    "calling_code": "691",
    "country_image": null,
    "translations": [
      {
        "id": 360,
        "country_codes_alpha_2": "FM",
        "languages_code": "en-US",
        "country_name": "Micronesia (Federated States of)",
        "nationality": "Micronesian"
      },
      {
        "id": 361,
        "country_codes_alpha_2": "FM",
        "languages_code": "zh-CN",
        "country_name": "密克罗尼西亚（联邦）",
        "nationality": "密克罗尼西亚联邦"
      },
      {
        "id": 675,
        "country_codes_alpha_2": "FM",
        "languages_code": "zh-HK",
        "country_name": "密克羅尼西亞(聯邦)",
        "nationality": "密克羅尼西亞聯邦"
      }
    ]
  },
  {
    "country_name": "Moldova, Republic of",
    "alpha_2": "MD",
    "alpha_3": "MDA",
    "nationality": "Moldovan",
    "calling_code": "373",
    "country_image": null,
    "translations": [
      {
        "id": 310,
        "country_codes_alpha_2": "MD",
        "languages_code": "en-US",
        "country_name": "Republic of Moldova",
        "nationality": "Moldovan"
      },
      {
        "id": 685,
        "country_codes_alpha_2": "MD",
        "languages_code": "zh-HK",
        "country_name": "摩爾多瓦共和國",
        "nationality": "摩爾多瓦"
      },
      {
        "id": 311,
        "country_codes_alpha_2": "MD",
        "languages_code": "zh-CN",
        "country_name": "摩尔多瓦共和国",
        "nationality": "摩尔多瓦"
      }
    ]
  },
  {
    "country_name": "Monaco",
    "alpha_2": "MC",
    "alpha_3": "MCO",
    "nationality": "Monegasque",
    "calling_code": "377",
    "country_image": null,
    "translations": [
      {
        "id": 561,
        "country_codes_alpha_2": "MC",
        "languages_code": "zh-CN",
        "country_name": "摩纳哥",
        "nationality": "摩纳哥"
      },
      {
        "id": 560,
        "country_codes_alpha_2": "MC",
        "languages_code": "en-US",
        "country_name": "Monaco",
        "nationality": "Monegasque"
      },
      {
        "id": 644,
        "country_codes_alpha_2": "MC",
        "languages_code": "zh-HK",
        "country_name": "摩納哥",
        "nationality": "摩納哥"
      }
    ]
  },
  {
    "country_name": "Mongolia",
    "alpha_2": "MN",
    "alpha_3": "MNG",
    "nationality": "Mongolian",
    "calling_code": "976",
    "country_image": null,
    "translations": [
      {
        "id": 190,
        "country_codes_alpha_2": "MN",
        "languages_code": "en-US",
        "country_name": "Mongolia",
        "nationality": "Mongolian"
      },
      {
        "id": 191,
        "country_codes_alpha_2": "MN",
        "languages_code": "zh-CN",
        "country_name": "蒙古",
        "nationality": "蒙古"
      },
      {
        "id": 671,
        "country_codes_alpha_2": "MN",
        "languages_code": "zh-HK",
        "country_name": "蒙古",
        "nationality": "蒙古"
      }
    ]
  },
  {
    "country_name": "Montenegro",
    "alpha_2": "ME",
    "alpha_3": "MNE",
    "nationality": "Montenegrin",
    "calling_code": "382",
    "country_image": null,
    "translations": [
      {
        "id": 315,
        "country_codes_alpha_2": "ME",
        "languages_code": "zh-CN",
        "country_name": "黑山",
        "nationality": "黑山"
      },
      {
        "id": 314,
        "country_codes_alpha_2": "ME",
        "languages_code": "en-US",
        "country_name": "Montenegro",
        "nationality": "Montenegrin"
      },
      {
        "id": 827,
        "country_codes_alpha_2": "ME",
        "languages_code": "zh-HK",
        "country_name": "黑山",
        "nationality": "黑山"
      }
    ]
  },
  {
    "country_name": "Montserrat",
    "alpha_2": "MS",
    "alpha_3": "MSR",
    "nationality": "Montserratian",
    "calling_code": "1664",
    "country_image": null,
    "translations": [
      {
        "id": 935,
        "country_codes_alpha_2": "MS",
        "languages_code": "zh-CN",
        "country_name": "蒙特塞拉特",
        "nationality": "蒙特塞拉特"
      },
      {
        "id": 936,
        "country_codes_alpha_2": "MS",
        "languages_code": "en-US",
        "country_name": "Montserrat",
        "nationality": "Montserratian"
      },
      {
        "id": 1018,
        "country_codes_alpha_2": "MS",
        "languages_code": "zh-HK",
        "country_name": "蒙特塞拉特",
        "nationality": "蒙特塞拉特"
      }
    ]
  },
  {
    "country_name": "Morocco",
    "alpha_2": "MA",
    "alpha_3": "MAR",
    "nationality": "Moroccan",
    "calling_code": "212",
    "country_image": null,
    "translations": [
      {
        "id": 924,
        "country_codes_alpha_2": "MA",
        "languages_code": "en-US",
        "country_name": "Morocco",
        "nationality": "Moroccan"
      },
      {
        "id": 996,
        "country_codes_alpha_2": "MA",
        "languages_code": "zh-HK",
        "country_name": "摩洛哥",
        "nationality": "摩洛哥"
      },
      {
        "id": 923,
        "country_codes_alpha_2": "MA",
        "languages_code": "zh-CN",
        "country_name": "摩洛哥",
        "nationality": "摩洛哥"
      }
    ]
  },
  {
    "country_name": "Mozambique",
    "alpha_2": "MZ",
    "alpha_3": "MOZ",
    "nationality": "Mozambican",
    "calling_code": "258",
    "country_image": null,
    "translations": [
      {
        "id": 203,
        "country_codes_alpha_2": "MZ",
        "languages_code": "zh-CN",
        "country_name": "莫桑比克",
        "nationality": "莫桑比克"
      },
      {
        "id": 202,
        "country_codes_alpha_2": "MZ",
        "languages_code": "en-US",
        "country_name": "Mozambique",
        "nationality": "Mozambican"
      },
      {
        "id": 847,
        "country_codes_alpha_2": "MZ",
        "languages_code": "zh-HK",
        "country_name": "莫桑比克",
        "nationality": "莫桑比克"
      }
    ]
  },
  {
    "country_name": "Myanmar",
    "alpha_2": "MM",
    "alpha_3": "MMR",
    "nationality": "Burmese",
    "calling_code": "95",
    "country_image": null,
    "translations": [
      {
        "id": 426,
        "country_codes_alpha_2": "MM",
        "languages_code": "en-US",
        "country_name": "Myanmar",
        "nationality": "Burmese"
      },
      {
        "id": 702,
        "country_codes_alpha_2": "MM",
        "languages_code": "zh-HK",
        "country_name": "緬甸",
        "nationality": "緬甸"
      },
      {
        "id": 427,
        "country_codes_alpha_2": "MM",
        "languages_code": "zh-CN",
        "country_name": "缅甸",
        "nationality": "缅甸"
      }
    ]
  },
  {
    "country_name": "Namibia",
    "alpha_2": "NA",
    "alpha_3": "NAM",
    "nationality": "Namibian",
    "calling_code": "264",
    "country_image": null,
    "translations": [
      {
        "id": 304,
        "country_codes_alpha_2": "NA",
        "languages_code": "en-US",
        "country_name": "Namibia",
        "nationality": "Namibian"
      },
      {
        "id": 305,
        "country_codes_alpha_2": "NA",
        "languages_code": "zh-CN",
        "country_name": "纳米比亚",
        "nationality": "纳米比亚"
      },
      {
        "id": 821,
        "country_codes_alpha_2": "NA",
        "languages_code": "zh-HK",
        "country_name": "納米比亞",
        "nationality": "納米比亞"
      }
    ]
  },
  {
    "country_name": "Nauru",
    "alpha_2": "NR",
    "alpha_3": "NRU",
    "nationality": "Nauruan",
    "calling_code": "674",
    "country_image": null,
    "translations": [
      {
        "id": 422,
        "country_codes_alpha_2": "NR",
        "languages_code": "en-US",
        "country_name": "Nauru",
        "nationality": "Nauruan"
      },
      {
        "id": 423,
        "country_codes_alpha_2": "NR",
        "languages_code": "zh-CN",
        "country_name": "瑙鲁",
        "nationality": "瑙鲁"
      },
      {
        "id": 700,
        "country_codes_alpha_2": "NR",
        "languages_code": "zh-HK",
        "country_name": "瑙魯",
        "nationality": "瑙魯"
      }
    ]
  },
  {
    "country_name": "Nepal",
    "alpha_2": "NP",
    "alpha_3": "NPL",
    "nationality": "Nepalese",
    "calling_code": "977",
    "country_image": null,
    "translations": [
      {
        "id": 382,
        "country_codes_alpha_2": "NP",
        "languages_code": "en-US",
        "country_name": "Nepal",
        "nationality": "Nepalese"
      },
      {
        "id": 678,
        "country_codes_alpha_2": "NP",
        "languages_code": "zh-HK",
        "country_name": "尼泊爾",
        "nationality": "尼泊爾"
      },
      {
        "id": 383,
        "country_codes_alpha_2": "NP",
        "languages_code": "zh-CN",
        "country_name": "尼泊尔",
        "nationality": "尼泊尔"
      }
    ]
  },
  {
    "country_name": "Netherlands",
    "alpha_2": "NL",
    "alpha_3": "NLD",
    "nationality": "Dutch",
    "calling_code": "31",
    "country_image": null,
    "translations": [
      {
        "id": 841,
        "country_codes_alpha_2": "NL",
        "languages_code": "zh-HK",
        "country_name": "荷蘭",
        "nationality": "荷蘭"
      },
      {
        "id": 297,
        "country_codes_alpha_2": "NL",
        "languages_code": "zh-CN",
        "country_name": "荷兰",
        "nationality": "荷兰"
      },
      {
        "id": 296,
        "country_codes_alpha_2": "NL",
        "languages_code": "en-US",
        "country_name": "Netherlands",
        "nationality": "Dutch"
      }
    ]
  },
  {
    "country_name": "New Caledonia",
    "alpha_2": "NC",
    "alpha_3": "NCL",
    "nationality": "French (New Caledonia)",
    "calling_code": "687",
    "country_image": null,
    "translations": [
      {
        "id": 284,
        "country_codes_alpha_2": "NC",
        "languages_code": "en-US",
        "country_name": "New Caledonia",
        "nationality": "French (New Caledonia)"
      },
      {
        "id": 641,
        "country_codes_alpha_2": "NC",
        "languages_code": "zh-HK",
        "country_name": "新喀裏多尼亞",
        "nationality": "新喀裡多尼亞"
      },
      {
        "id": 285,
        "country_codes_alpha_2": "NC",
        "languages_code": "zh-CN",
        "country_name": "新喀里多尼亚",
        "nationality": "新喀里多尼亚"
      }
    ]
  },
  {
    "country_name": "New Zealand",
    "alpha_2": "NZ",
    "alpha_3": "NZL",
    "nationality": "New Zealander",
    "calling_code": "64",
    "country_image": null,
    "translations": [
      {
        "id": 209,
        "country_codes_alpha_2": "NZ",
        "languages_code": "zh-CN",
        "country_name": "新西兰",
        "nationality": "新西兰"
      },
      {
        "id": 208,
        "country_codes_alpha_2": "NZ",
        "languages_code": "en-US",
        "country_name": "New Zealand",
        "nationality": "New Zealander"
      },
      {
        "id": 731,
        "country_codes_alpha_2": "NZ",
        "languages_code": "zh-HK",
        "country_name": "新西蘭",
        "nationality": "新西蘭"
      }
    ]
  },
  {
    "country_name": "Nicaragua",
    "alpha_2": "NI",
    "alpha_3": "NIC",
    "nationality": "Nicaraguan",
    "calling_code": "505",
    "country_image": null,
    "translations": [
      {
        "id": 293,
        "country_codes_alpha_2": "NI",
        "languages_code": "zh-CN",
        "country_name": "尼加拉瓜",
        "nationality": "尼加拉瓜 "
      },
      {
        "id": 292,
        "country_codes_alpha_2": "NI",
        "languages_code": "en-US",
        "country_name": "Nicaragua",
        "nationality": "Nicaraguan"
      },
      {
        "id": 659,
        "country_codes_alpha_2": "NI",
        "languages_code": "zh-HK",
        "country_name": "尼加拉瓜",
        "nationality": "尼加拉瓜 "
      }
    ]
  },
  {
    "country_name": "Niger",
    "alpha_2": "NE",
    "alpha_3": "NER",
    "nationality": "Nigerien",
    "calling_code": "227",
    "country_image": null,
    "translations": [
      {
        "id": 346,
        "country_codes_alpha_2": "NE",
        "languages_code": "en-US",
        "country_name": "Niger",
        "nationality": "Nigerien"
      },
      {
        "id": 347,
        "country_codes_alpha_2": "NE",
        "languages_code": "zh-CN",
        "country_name": "尼日尔",
        "nationality": "尼日尔"
      },
      {
        "id": 717,
        "country_codes_alpha_2": "NE",
        "languages_code": "zh-HK",
        "country_name": "尼日爾",
        "nationality": "尼日爾"
      }
    ]
  },
  {
    "country_name": "Nigeria",
    "alpha_2": "NG",
    "alpha_3": "NGA",
    "nationality": "Nigerian",
    "calling_code": "234",
    "country_image": null,
    "translations": [
      {
        "id": 302,
        "country_codes_alpha_2": "NG",
        "languages_code": "en-US",
        "country_name": "Nigeria",
        "nationality": "Nigerian"
      },
      {
        "id": 303,
        "country_codes_alpha_2": "NG",
        "languages_code": "zh-CN",
        "country_name": "尼日利亚",
        "nationality": "尼日利亚"
      },
      {
        "id": 750,
        "country_codes_alpha_2": "NG",
        "languages_code": "zh-HK",
        "country_name": "尼日利亞",
        "nationality": "尼日利亚"
      }
    ]
  },
  {
    "country_name": "Niue",
    "alpha_2": "NU",
    "alpha_3": "NIU",
    "nationality": "Niuean",
    "calling_code": "683",
    "country_image": null,
    "translations": [
      {
        "id": 435,
        "country_codes_alpha_2": "NU",
        "languages_code": "zh-CN",
        "country_name": "纽埃",
        "nationality": "纽埃"
      },
      {
        "id": 434,
        "country_codes_alpha_2": "NU",
        "languages_code": "en-US",
        "country_name": "Niue",
        "nationality": "Niuean"
      },
      {
        "id": 662,
        "country_codes_alpha_2": "NU",
        "languages_code": "zh-HK",
        "country_name": "紐埃",
        "nationality": "纽埃"
      }
    ]
  },
  {
    "country_name": "Northern Mariana Islands",
    "alpha_2": "MP",
    "alpha_3": "MNP",
    "nationality": "American (Northern Mariana Islands)",
    "calling_code": "1670",
    "country_image": null,
    "translations": [
      {
        "id": 873,
        "country_codes_alpha_2": "MP",
        "languages_code": "zh-CN",
        "country_name": "北马里亚纳群岛",
        "nationality": "北马里亚纳群岛"
      },
      {
        "id": 874,
        "country_codes_alpha_2": "MP",
        "languages_code": "en-US",
        "country_name": "Northern Mariana Islands",
        "nationality": "American (Northern Mariana Islands)"
      },
      {
        "id": 1013,
        "country_codes_alpha_2": "MP",
        "languages_code": "zh-HK",
        "country_name": "北馬裏亞納群島",
        "nationality": "北馬里亞納群島"
      }
    ]
  },
  {
    "country_name": "North Macedonia",
    "alpha_2": "MK",
    "alpha_3": "MKD",
    "nationality": "Macedonian",
    "calling_code": "389",
    "country_image": null,
    "translations": [
      {
        "id": 478,
        "country_codes_alpha_2": "MK",
        "languages_code": "en-US",
        "country_name": "the former Yugoslav Republic of Macedonia",
        "nationality": "Macedonian"
      },
      {
        "id": 768,
        "country_codes_alpha_2": "MK",
        "languages_code": "zh-HK",
        "country_name": "前南斯拉夫的馬其頓共和國",
        "nationality": "馬其頓"
      },
      {
        "id": 479,
        "country_codes_alpha_2": "MK",
        "languages_code": "zh-CN",
        "country_name": "前南斯拉夫的马其顿共和国",
        "nationality": "马其顿"
      }
    ]
  },
  {
    "country_name": "Norway",
    "alpha_2": "NO",
    "alpha_3": "NOR",
    "nationality": "Norwegian",
    "calling_code": "47",
    "country_image": null,
    "translations": [
      {
        "id": 404,
        "country_codes_alpha_2": "NO",
        "languages_code": "en-US",
        "country_name": "Norway",
        "nationality": "Norwegian"
      },
      {
        "id": 405,
        "country_codes_alpha_2": "NO",
        "languages_code": "zh-CN",
        "country_name": "挪威",
        "nationality": "挪威"
      },
      {
        "id": 706,
        "country_codes_alpha_2": "NO",
        "languages_code": "zh-HK",
        "country_name": "挪威",
        "nationality": "挪威"
      }
    ]
  },
  {
    "country_name": "Oman",
    "alpha_2": "OM",
    "alpha_3": "OMN",
    "nationality": "Omani",
    "calling_code": "968",
    "country_image": null,
    "translations": [
      {
        "id": 663,
        "country_codes_alpha_2": "OM",
        "languages_code": "zh-HK",
        "country_name": "阿曼",
        "nationality": "阿曼"
      },
      {
        "id": 544,
        "country_codes_alpha_2": "OM",
        "languages_code": "en-US",
        "country_name": "Oman",
        "nationality": "Omani"
      },
      {
        "id": 545,
        "country_codes_alpha_2": "OM",
        "languages_code": "zh-CN",
        "country_name": "阿曼",
        "nationality": "阿曼"
      }
    ]
  },
  {
    "country_name": "Pakistan",
    "alpha_2": "PK",
    "alpha_3": "PAK",
    "nationality": "Pakistani",
    "calling_code": "92",
    "country_image": null,
    "translations": [
      {
        "id": 611,
        "country_codes_alpha_2": "PK",
        "languages_code": "zh-CN",
        "country_name": "巴基斯坦",
        "nationality": "巴基斯坦"
      },
      {
        "id": 610,
        "country_codes_alpha_2": "PK",
        "languages_code": "en-US",
        "country_name": "Pakistan",
        "nationality": "Pakistani"
      },
      {
        "id": 803,
        "country_codes_alpha_2": "PK",
        "languages_code": "zh-HK",
        "country_name": "巴基斯坦",
        "nationality": "巴基斯坦"
      }
    ]
  },
  {
    "country_name": "Palau",
    "alpha_2": "PW",
    "alpha_3": "PLW",
    "nationality": "Palauan",
    "calling_code": "680",
    "country_image": null,
    "translations": [
      {
        "id": 276,
        "country_codes_alpha_2": "PW",
        "languages_code": "en-US",
        "country_name": "Palau",
        "nationality": "Palauan"
      },
      {
        "id": 277,
        "country_codes_alpha_2": "PW",
        "languages_code": "zh-CN",
        "country_name": "帕劳",
        "nationality": "帛琉"
      },
      {
        "id": 713,
        "country_codes_alpha_2": "PW",
        "languages_code": "zh-HK",
        "country_name": "帕勞",
        "nationality": "帛琉"
      }
    ]
  },
  {
    "country_name": "Palestine, State of",
    "alpha_2": "PS",
    "alpha_3": "PSE",
    "nationality": "Palestinian",
    "calling_code": "970",
    "country_image": null,
    "translations": [
      {
        "id": 234,
        "country_codes_alpha_2": "PS",
        "languages_code": "en-US",
        "country_name": "State of Palestine",
        "nationality": "Palestinian"
      },
      {
        "id": 235,
        "country_codes_alpha_2": "PS",
        "languages_code": "zh-CN",
        "country_name": "巴勒斯坦国",
        "nationality": "巴勒斯坦"
      },
      {
        "id": 705,
        "country_codes_alpha_2": "PS",
        "languages_code": "zh-HK",
        "country_name": "巴勒斯坦國",
        "nationality": "巴勒斯坦"
      }
    ]
  },
  {
    "country_name": "Panama",
    "alpha_2": "PA",
    "alpha_3": "PAN",
    "nationality": "Panamanian",
    "calling_code": "507",
    "country_image": null,
    "translations": [
      {
        "id": 514,
        "country_codes_alpha_2": "PA",
        "languages_code": "en-US",
        "country_name": "Panama",
        "nationality": "Panamanian"
      },
      {
        "id": 760,
        "country_codes_alpha_2": "PA",
        "languages_code": "zh-HK",
        "country_name": "巴拿馬",
        "nationality": "巴拿馬"
      },
      {
        "id": 515,
        "country_codes_alpha_2": "PA",
        "languages_code": "zh-CN",
        "country_name": "巴拿马",
        "nationality": "巴拿马"
      }
    ]
  },
  {
    "country_name": "Papua New Guinea",
    "alpha_2": "PG",
    "alpha_3": "PNG",
    "nationality": "Papua New Guinean",
    "calling_code": "675",
    "country_image": null,
    "translations": [
      {
        "id": 590,
        "country_codes_alpha_2": "PG",
        "languages_code": "en-US",
        "country_name": "Papua New Guinea",
        "nationality": "Papua New Guinean"
      },
      {
        "id": 591,
        "country_codes_alpha_2": "PG",
        "languages_code": "zh-CN",
        "country_name": "巴布亚新几内亚",
        "nationality": "巴布亚新几内亚"
      },
      {
        "id": 833,
        "country_codes_alpha_2": "PG",
        "languages_code": "zh-HK",
        "country_name": "巴布亞新幾內亞",
        "nationality": "巴布亞新幾內亞"
      }
    ]
  },
  {
    "country_name": "Paraguay",
    "alpha_2": "PY",
    "alpha_3": "PRY",
    "nationality": "Paraguayan",
    "calling_code": "595",
    "country_image": null,
    "translations": [
      {
        "id": 188,
        "country_codes_alpha_2": "PY",
        "languages_code": "en-US",
        "country_name": "Paraguay",
        "nationality": "Paraguayan"
      },
      {
        "id": 797,
        "country_codes_alpha_2": "PY",
        "languages_code": "zh-HK",
        "country_name": "巴拉圭",
        "nationality": "巴拉圭"
      },
      {
        "id": 189,
        "country_codes_alpha_2": "PY",
        "languages_code": "zh-CN",
        "country_name": "巴拉圭",
        "nationality": "巴拉圭"
      }
    ]
  },
  {
    "country_name": "Peru",
    "alpha_2": "PE",
    "alpha_3": "PER",
    "nationality": "Peruvian",
    "calling_code": "51",
    "country_image": null,
    "translations": [
      {
        "id": 396,
        "country_codes_alpha_2": "PE",
        "languages_code": "en-US",
        "country_name": "Peru",
        "nationality": "Peruvian"
      },
      {
        "id": 397,
        "country_codes_alpha_2": "PE",
        "languages_code": "zh-CN",
        "country_name": "秘鲁",
        "nationality": "秘鲁"
      },
      {
        "id": 677,
        "country_codes_alpha_2": "PE",
        "languages_code": "zh-HK",
        "country_name": "秘魯",
        "nationality": "秘魯"
      }
    ]
  },
  {
    "country_name": "Philippines",
    "alpha_2": "PH",
    "alpha_3": "PHL",
    "nationality": "Filipino",
    "calling_code": "63",
    "country_image": null,
    "translations": [
      {
        "id": 784,
        "country_codes_alpha_2": "PH",
        "languages_code": "zh-HK",
        "country_name": "菲律賓",
        "nationality": "菲律賓"
      },
      {
        "id": 329,
        "country_codes_alpha_2": "PH",
        "languages_code": "zh-CN",
        "country_name": "菲律宾",
        "nationality": "菲律宾"
      },
      {
        "id": 328,
        "country_codes_alpha_2": "PH",
        "languages_code": "en-US",
        "country_name": "Philippines",
        "nationality": "Filipino"
      }
    ]
  },
  {
    "country_name": "Pitcairn",
    "alpha_2": "PN",
    "alpha_3": "PCN",
    "nationality": "British (Pitcairn)",
    "calling_code": "64",
    "country_image": null,
    "translations": [
      {
        "id": 933,
        "country_codes_alpha_2": "PN",
        "languages_code": "zh-CN",
        "country_name": "皮特凯恩",
        "nationality": "皮特凯恩群岛"
      },
      {
        "id": 934,
        "country_codes_alpha_2": "PN",
        "languages_code": "en-US",
        "country_name": "Pitcairn",
        "nationality": "British (Pitcairn)"
      },
      {
        "id": 998,
        "country_codes_alpha_2": "PN",
        "languages_code": "zh-HK",
        "country_name": "皮特凱恩",
        "nationality": "皮特凱恩群島"
      }
    ]
  },
  {
    "country_name": "Poland",
    "alpha_2": "PL",
    "alpha_3": "POL",
    "nationality": "Polish",
    "calling_code": "48",
    "country_image": null,
    "translations": [
      {
        "id": 340,
        "country_codes_alpha_2": "PL",
        "languages_code": "en-US",
        "country_name": "Poland",
        "nationality": "Polish"
      },
      {
        "id": 341,
        "country_codes_alpha_2": "PL",
        "languages_code": "zh-CN",
        "country_name": "波兰",
        "nationality": "波兰"
      },
      {
        "id": 757,
        "country_codes_alpha_2": "PL",
        "languages_code": "zh-HK",
        "country_name": "波蘭",
        "nationality": "波蘭"
      }
    ]
  },
  {
    "country_name": "Portugal",
    "alpha_2": "PT",
    "alpha_3": "PRT",
    "nationality": "Portuguese",
    "calling_code": "351",
    "country_image": null,
    "translations": [
      {
        "id": 577,
        "country_codes_alpha_2": "PT",
        "languages_code": "zh-CN",
        "country_name": "葡萄牙",
        "nationality": "葡萄牙"
      },
      {
        "id": 576,
        "country_codes_alpha_2": "PT",
        "languages_code": "en-US",
        "country_name": "Portugal",
        "nationality": "Portuguese"
      },
      {
        "id": 805,
        "country_codes_alpha_2": "PT",
        "languages_code": "zh-HK",
        "country_name": "葡萄牙",
        "nationality": "葡萄牙"
      }
    ]
  },
  {
    "country_name": "Puerto Rico",
    "alpha_2": "PR",
    "alpha_3": "PRI",
    "nationality": "Puerto Rican",
    "calling_code": "1787,1939",
    "country_image": null,
    "translations": [
      {
        "id": 864,
        "country_codes_alpha_2": "PR",
        "languages_code": "zh-CN",
        "country_name": "波多黎各",
        "nationality": "波多黎各"
      },
      {
        "id": 862,
        "country_codes_alpha_2": "PR",
        "languages_code": "zh-HK",
        "country_name": "波多黎各",
        "nationality": "波多黎各"
      },
      {
        "id": 863,
        "country_codes_alpha_2": "PR",
        "languages_code": "en-US",
        "country_name": "Puerto Rico",
        "nationality": "Puerto Rican"
      }
    ]
  },
  {
    "country_name": "Qatar",
    "alpha_2": "QA",
    "alpha_3": "QAT",
    "nationality": "Qatari",
    "calling_code": "974",
    "country_image": null,
    "translations": [
      {
        "id": 186,
        "country_codes_alpha_2": "QA",
        "languages_code": "en-US",
        "country_name": "Qatar",
        "nationality": "Qatari"
      },
      {
        "id": 187,
        "country_codes_alpha_2": "QA",
        "languages_code": "zh-CN",
        "country_name": "卡塔尔",
        "nationality": "卡塔尔"
      },
      {
        "id": 680,
        "country_codes_alpha_2": "QA",
        "languages_code": "zh-HK",
        "country_name": "卡塔爾",
        "nationality": "卡塔爾"
      }
    ]
  },
  {
    "country_name": "Réunion",
    "alpha_2": "RE",
    "alpha_3": "REU",
    "nationality": "French (Reunion)",
    "calling_code": "262",
    "country_image": null,
    "translations": [
      {
        "id": 951,
        "country_codes_alpha_2": "RE",
        "languages_code": "zh-CN",
        "country_name": "留尼汪",
        "nationality": "留尼汪"
      },
      {
        "id": 722,
        "country_codes_alpha_2": "RE",
        "languages_code": "zh-HK",
        "country_name": "留尼汪",
        "nationality": "留尼汪"
      },
      {
        "id": 952,
        "country_codes_alpha_2": "RE",
        "languages_code": "en-US",
        "country_name": "Réunion",
        "nationality": "French (Reunion)"
      }
    ]
  },
  {
    "country_name": "Romania",
    "alpha_2": "RO",
    "alpha_3": "ROU",
    "nationality": "Romanian",
    "calling_code": "40",
    "country_image": null,
    "translations": [
      {
        "id": 580,
        "country_codes_alpha_2": "RO",
        "languages_code": "en-US",
        "country_name": "Romania",
        "nationality": "Romanian"
      },
      {
        "id": 581,
        "country_codes_alpha_2": "RO",
        "languages_code": "zh-CN",
        "country_name": "罗马尼亚",
        "nationality": "罗马尼亚"
      },
      {
        "id": 681,
        "country_codes_alpha_2": "RO",
        "languages_code": "zh-HK",
        "country_name": "羅馬尼亞",
        "nationality": "羅馬尼亞"
      }
    ]
  },
  {
    "country_name": "Russian Federation",
    "alpha_2": "RU",
    "alpha_3": "RUS",
    "nationality": "Russian",
    "calling_code": "7",
    "country_image": null,
    "translations": [
      {
        "id": 1007,
        "country_codes_alpha_2": "RU",
        "languages_code": "zh-HK",
        "country_name": "俄羅斯聯邦",
        "nationality": "俄羅斯"
      },
      {
        "id": 916,
        "country_codes_alpha_2": "RU",
        "languages_code": "en-US",
        "country_name": "Russian Federation",
        "nationality": "Russian"
      },
      {
        "id": 915,
        "country_codes_alpha_2": "RU",
        "languages_code": "zh-CN",
        "country_name": "俄罗斯联邦",
        "nationality": "俄罗斯"
      }
    ]
  },
  {
    "country_name": "Rwanda",
    "alpha_2": "RW",
    "alpha_3": "RWA",
    "nationality": "Rwandan",
    "calling_code": "250",
    "country_image": null,
    "translations": [
      {
        "id": 411,
        "country_codes_alpha_2": "RW",
        "languages_code": "zh-CN",
        "country_name": "卢旺达",
        "nationality": "卢旺达"
      },
      {
        "id": 672,
        "country_codes_alpha_2": "RW",
        "languages_code": "zh-HK",
        "country_name": "盧旺達",
        "nationality": "盧旺達"
      },
      {
        "id": 410,
        "country_codes_alpha_2": "RW",
        "languages_code": "en-US",
        "country_name": "Rwanda",
        "nationality": "Rwandan"
      }
    ]
  },
  {
    "country_name": "Saint Barthélemy",
    "alpha_2": "BL",
    "alpha_3": "BLM",
    "nationality": "French (Saint Barthelemy)",
    "calling_code": "590",
    "country_image": null,
    "translations": [
      {
        "id": 959,
        "country_codes_alpha_2": "BL",
        "languages_code": "en-US",
        "country_name": "Saint Barthélemy",
        "nationality": "French (Saint Barthelemy)"
      },
      {
        "id": 701,
        "country_codes_alpha_2": "BL",
        "languages_code": "zh-HK",
        "country_name": "聖巴泰勒米",
        "nationality": "聖巴泰勒米"
      },
      {
        "id": 958,
        "country_codes_alpha_2": "BL",
        "languages_code": "zh-CN",
        "country_name": "圣巴泰勒米",
        "nationality": "圣巴泰勒米"
      }
    ]
  },
  {
    "country_name": "Saint Helena, Ascension and Tristan da Cunha",
    "alpha_2": "SH",
    "alpha_3": "SHN",
    "nationality": "British (Saint Helena)",
    "calling_code": "290",
    "country_image": null,
    "translations": [
      {
        "id": 308,
        "country_codes_alpha_2": "SH",
        "languages_code": "en-US",
        "country_name": "Saint Helena",
        "nationality": "British (Saint Helena)"
      },
      {
        "id": 309,
        "country_codes_alpha_2": "SH",
        "languages_code": "zh-CN",
        "country_name": "圣赫勒拿岛，阿森松岛和特里斯坦达库尼亚岛",
        "nationality": "圣赫勒拿岛"
      },
      {
        "id": 674,
        "country_codes_alpha_2": "SH",
        "languages_code": "zh-HK",
        "country_name": "聖赫勒拿島，阿森松島和特里斯坦達庫尼亞島",
        "nationality": "聖赫勒拿島"
      }
    ]
  },
  {
    "country_name": "Saint Kitts and Nevis",
    "alpha_2": "KN",
    "alpha_3": "KNA",
    "nationality": "Kittitian and Nevisian",
    "calling_code": "1869",
    "country_image": null,
    "translations": [
      {
        "id": 926,
        "country_codes_alpha_2": "KN",
        "languages_code": "en-US",
        "country_name": "Saint Kitts and Nevis",
        "nationality": "Kittitian and Nevisian"
      },
      {
        "id": 925,
        "country_codes_alpha_2": "KN",
        "languages_code": "zh-CN",
        "country_name": "圣基茨和尼维斯",
        "nationality": "圣基茨和尼维斯"
      },
      {
        "id": 1008,
        "country_codes_alpha_2": "KN",
        "languages_code": "zh-HK",
        "country_name": "聖基茨和尼維斯",
        "nationality": "聖基茨和尼維斯"
      }
    ]
  },
  {
    "country_name": "Saint Lucia",
    "alpha_2": "LC",
    "alpha_3": "LCA",
    "nationality": "Saint Lucian",
    "calling_code": "1758",
    "country_image": null,
    "translations": [
      {
        "id": 919,
        "country_codes_alpha_2": "LC",
        "languages_code": "zh-CN",
        "country_name": "圣卢西亚",
        "nationality": "圣卢西亚"
      },
      {
        "id": 997,
        "country_codes_alpha_2": "LC",
        "languages_code": "zh-HK",
        "country_name": "聖盧西亞",
        "nationality": "聖盧西亞"
      },
      {
        "id": 920,
        "country_codes_alpha_2": "LC",
        "languages_code": "en-US",
        "country_name": "Saint Lucia",
        "nationality": "Saint Lucian"
      }
    ]
  },
  {
    "country_name": "Saint Martin (French part)",
    "alpha_2": "MF",
    "alpha_3": "MAF",
    "nationality": "French (Saint Martin)",
    "calling_code": "590",
    "country_image": null,
    "translations": [
      {
        "id": 962,
        "country_codes_alpha_2": "MF",
        "languages_code": "zh-CN",
        "country_name": "圣马丁(法属)",
        "nationality": "圣马丁"
      },
      {
        "id": 963,
        "country_codes_alpha_2": "MF",
        "languages_code": "en-US",
        "country_name": "Saint Martin (French part)",
        "nationality": "French (Saint Martin)"
      },
      {
        "id": 964,
        "country_codes_alpha_2": "MF",
        "languages_code": "zh-HK",
        "country_name": "聖馬丁(法屬)",
        "nationality": "聖馬丁"
      }
    ]
  },
  {
    "country_name": "Saint Pierre and Miquelon",
    "alpha_2": "PM",
    "alpha_3": "SPM",
    "nationality": "French (Saint Pierre and Miquelon)",
    "calling_code": "508",
    "country_image": null,
    "translations": [
      {
        "id": 412,
        "country_codes_alpha_2": "PM",
        "languages_code": "en-US",
        "country_name": "Saint Pierre and Miquelon",
        "nationality": "French (Saint Pierre and Miquelon)"
      },
      {
        "id": 413,
        "country_codes_alpha_2": "PM",
        "languages_code": "zh-CN",
        "country_name": "圣皮埃尔和密克隆群岛",
        "nationality": "圣皮埃尔和密克隆群岛"
      },
      {
        "id": 842,
        "country_codes_alpha_2": "PM",
        "languages_code": "zh-HK",
        "country_name": "聖皮埃爾和密克隆",
        "nationality": "聖皮埃爾和密克隆群島"
      }
    ]
  },
  {
    "country_name": "Saint Vincent and the Grenadines",
    "alpha_2": "VC",
    "alpha_3": "VCT",
    "nationality": "Vincentian",
    "calling_code": "1784",
    "country_image": null,
    "translations": [
      {
        "id": 913,
        "country_codes_alpha_2": "VC",
        "languages_code": "zh-CN",
        "country_name": "圣文森特和格林纳丁斯",
        "nationality": "圣文森与格瑞那丁"
      },
      {
        "id": 914,
        "country_codes_alpha_2": "VC",
        "languages_code": "en-US",
        "country_name": "Saint Vincent and the Grenadines",
        "nationality": "Vincentian"
      },
      {
        "id": 1009,
        "country_codes_alpha_2": "VC",
        "languages_code": "zh-HK",
        "country_name": "聖文森特和格林納丁斯",
        "nationality": "聖文森與格瑞那丁"
      }
    ]
  },
  {
    "country_name": "Samoa",
    "alpha_2": "WS",
    "alpha_3": "WSM",
    "nationality": "Samoan",
    "calling_code": "685",
    "country_image": null,
    "translations": [
      {
        "id": 648,
        "country_codes_alpha_2": "WS",
        "languages_code": "zh-HK",
        "country_name": "薩摩亞",
        "nationality": "薩摩亞"
      },
      {
        "id": 359,
        "country_codes_alpha_2": "WS",
        "languages_code": "zh-CN",
        "country_name": "萨摩亚",
        "nationality": "萨摩亚"
      },
      {
        "id": 358,
        "country_codes_alpha_2": "WS",
        "languages_code": "en-US",
        "country_name": "Samoa",
        "nationality": "Samoan"
      }
    ]
  },
  {
    "country_name": "San Marino",
    "alpha_2": "SM",
    "alpha_3": "SMR",
    "nationality": "Sammarinese",
    "calling_code": "378",
    "country_image": null,
    "translations": [
      {
        "id": 288,
        "country_codes_alpha_2": "SM",
        "languages_code": "en-US",
        "country_name": "San Marino",
        "nationality": "Sammarinese"
      },
      {
        "id": 720,
        "country_codes_alpha_2": "SM",
        "languages_code": "zh-HK",
        "country_name": "聖馬力諾",
        "nationality": "聖馬力諾"
      },
      {
        "id": 289,
        "country_codes_alpha_2": "SM",
        "languages_code": "zh-CN",
        "country_name": "圣马力诺",
        "nationality": "圣马力诺"
      }
    ]
  },
  {
    "country_name": "Sao Tome and Principe",
    "alpha_2": "ST",
    "alpha_3": "STP",
    "nationality": "Sao Tomean",
    "calling_code": "239",
    "country_image": null,
    "translations": [
      {
        "id": 606,
        "country_codes_alpha_2": "ST",
        "languages_code": "en-US",
        "country_name": "Sao Tome and Principe",
        "nationality": "Sao Tomean"
      },
      {
        "id": 607,
        "country_codes_alpha_2": "ST",
        "languages_code": "zh-CN",
        "country_name": "圣多美和普林西比",
        "nationality": "圣多美和普林西比"
      },
      {
        "id": 709,
        "country_codes_alpha_2": "ST",
        "languages_code": "zh-HK",
        "country_name": "聖多美和普林西比",
        "nationality": "聖多美和普林西比"
      }
    ]
  },
  {
    "country_name": "Saudi Arabia",
    "alpha_2": "SA",
    "alpha_3": "SAU",
    "nationality": "Saudi Arabian",
    "calling_code": "966",
    "country_image": null,
    "translations": [
      {
        "id": 718,
        "country_codes_alpha_2": "SA",
        "languages_code": "zh-HK",
        "country_name": "沙特阿拉伯",
        "nationality": "沙特阿拉伯"
      },
      {
        "id": 553,
        "country_codes_alpha_2": "SA",
        "languages_code": "zh-CN",
        "country_name": "沙特阿拉伯",
        "nationality": "沙特阿拉伯"
      },
      {
        "id": 552,
        "country_codes_alpha_2": "SA",
        "languages_code": "en-US",
        "country_name": "Saudi Arabia",
        "nationality": "Saudi Arabian"
      }
    ]
  },
  {
    "country_name": "Senegal",
    "alpha_2": "SN",
    "alpha_3": "SEN",
    "nationality": "Senegalese",
    "calling_code": "221",
    "country_image": null,
    "translations": [
      {
        "id": 596,
        "country_codes_alpha_2": "SN",
        "languages_code": "en-US",
        "country_name": "Senegal",
        "nationality": "Senegalese"
      },
      {
        "id": 597,
        "country_codes_alpha_2": "SN",
        "languages_code": "zh-CN",
        "country_name": "塞内加尔",
        "nationality": "塞内加尔"
      },
      {
        "id": 752,
        "country_codes_alpha_2": "SN",
        "languages_code": "zh-HK",
        "country_name": "塞內加爾",
        "nationality": "塞內加爾"
      }
    ]
  },
  {
    "country_name": "Serbia",
    "alpha_2": "RS",
    "alpha_3": "SRB",
    "nationality": "Serbian",
    "calling_code": "381",
    "country_image": null,
    "translations": [
      {
        "id": 550,
        "country_codes_alpha_2": "RS",
        "languages_code": "en-US",
        "country_name": "Serbia",
        "nationality": "Serbian"
      },
      {
        "id": 551,
        "country_codes_alpha_2": "RS",
        "languages_code": "zh-CN",
        "country_name": "塞尔维亚",
        "nationality": "塞尔维亚"
      },
      {
        "id": 653,
        "country_codes_alpha_2": "RS",
        "languages_code": "zh-HK",
        "country_name": "塞爾維亞",
        "nationality": "塞爾維亞"
      }
    ]
  },
  {
    "country_name": "Seychelles",
    "alpha_2": "SC",
    "alpha_3": "SYC",
    "nationality": "Seychelles citizen",
    "calling_code": "248",
    "country_image": null,
    "translations": [
      {
        "id": 953,
        "country_codes_alpha_2": "SC",
        "languages_code": "zh-HK",
        "country_name": "塞舌爾",
        "nationality": "塞舌爾"
      },
      {
        "id": 332,
        "country_codes_alpha_2": "SC",
        "languages_code": "en-US",
        "country_name": "Seychelles",
        "nationality": "Seychelles citizen"
      },
      {
        "id": 333,
        "country_codes_alpha_2": "SC",
        "languages_code": "zh-CN",
        "country_name": "塞舌尔",
        "nationality": "塞舌尔"
      }
    ]
  },
  {
    "country_name": "Sierra Leone",
    "alpha_2": "SL",
    "alpha_3": "SLE",
    "nationality": "Sierra Leonean",
    "calling_code": "232",
    "country_image": null,
    "translations": [
      {
        "id": 652,
        "country_codes_alpha_2": "SL",
        "languages_code": "zh-HK",
        "country_name": "塞拉利昂",
        "nationality": "塞拉利昂"
      },
      {
        "id": 446,
        "country_codes_alpha_2": "SL",
        "languages_code": "en-US",
        "country_name": "Sierra Leone",
        "nationality": "Sierra Leonean"
      },
      {
        "id": 447,
        "country_codes_alpha_2": "SL",
        "languages_code": "zh-CN",
        "country_name": "塞拉利昂",
        "nationality": "塞拉利昂"
      }
    ]
  },
  {
    "country_name": "Singapore",
    "alpha_2": "SG",
    "alpha_3": "SGP",
    "nationality": "Singaporean",
    "calling_code": "65",
    "country_image": null,
    "translations": [
      {
        "id": 472,
        "country_codes_alpha_2": "SG",
        "languages_code": "en-US",
        "country_name": "Singapore",
        "nationality": "Singaporean"
      },
      {
        "id": 473,
        "country_codes_alpha_2": "SG",
        "languages_code": "zh-CN",
        "country_name": "新加坡",
        "nationality": "新加坡"
      },
      {
        "id": 693,
        "country_codes_alpha_2": "SG",
        "languages_code": "zh-HK",
        "country_name": "新加坡",
        "nationality": "新加坡"
      }
    ]
  },
  {
    "country_name": "Sint Maarten (Dutch part)",
    "alpha_2": "SX",
    "alpha_3": "SXM",
    "nationality": "Dutch (Sint Maarten)",
    "calling_code": "1721",
    "country_image": null,
    "translations": [
      {
        "id": 895,
        "country_codes_alpha_2": "SX",
        "languages_code": "zh-CN",
        "country_name": "圣马丁(荷属)",
        "nationality": "圣马丁"
      },
      {
        "id": 896,
        "country_codes_alpha_2": "SX",
        "languages_code": "en-US",
        "country_name": "Sint Maarten (Dutch part)",
        "nationality": "Dutch (Sint Maarten)"
      },
      {
        "id": 1000,
        "country_codes_alpha_2": "SX",
        "languages_code": "zh-HK",
        "country_name": "聖馬丁(荷屬)",
        "nationality": "聖馬丁"
      }
    ]
  },
  {
    "country_name": "Slovakia",
    "alpha_2": "SK",
    "alpha_3": "SVK",
    "nationality": "Slovak",
    "calling_code": "421",
    "country_image": null,
    "translations": [
      {
        "id": 392,
        "country_codes_alpha_2": "SK",
        "languages_code": "en-US",
        "country_name": "Slovakia",
        "nationality": "Slovak"
      },
      {
        "id": 393,
        "country_codes_alpha_2": "SK",
        "languages_code": "zh-CN",
        "country_name": "斯洛伐克",
        "nationality": "斯洛伐克"
      },
      {
        "id": 804,
        "country_codes_alpha_2": "SK",
        "languages_code": "zh-HK",
        "country_name": "斯洛伐克",
        "nationality": "斯洛伐克"
      }
    ]
  },
  {
    "country_name": "Slovenia",
    "alpha_2": "SI",
    "alpha_3": "SVN",
    "nationality": "Slovenian",
    "calling_code": "386",
    "country_image": null,
    "translations": [
      {
        "id": 362,
        "country_codes_alpha_2": "SI",
        "languages_code": "en-US",
        "country_name": "Slovenia",
        "nationality": "Slovenian"
      },
      {
        "id": 363,
        "country_codes_alpha_2": "SI",
        "languages_code": "zh-CN",
        "country_name": "斯洛文尼亚",
        "nationality": "斯洛文尼亚"
      },
      {
        "id": 673,
        "country_codes_alpha_2": "SI",
        "languages_code": "zh-HK",
        "country_name": "斯洛文尼亞",
        "nationality": "斯洛文尼亞"
      }
    ]
  },
  {
    "country_name": "Solomon Islands",
    "alpha_2": "SB",
    "alpha_3": "SLB",
    "nationality": "Solomon Islander",
    "calling_code": "677",
    "country_image": null,
    "translations": [
      {
        "id": 398,
        "country_codes_alpha_2": "SB",
        "languages_code": "en-US",
        "country_name": "Solomon Islands",
        "nationality": "Solomon Islander"
      },
      {
        "id": 740,
        "country_codes_alpha_2": "SB",
        "languages_code": "zh-HK",
        "country_name": "所羅門群島",
        "nationality": "所羅門群島"
      },
      {
        "id": 399,
        "country_codes_alpha_2": "SB",
        "languages_code": "zh-CN",
        "country_name": "所罗门群岛",
        "nationality": "所罗门群岛"
      }
    ]
  },
  {
    "country_name": "Somalia",
    "alpha_2": "SO",
    "alpha_3": "SOM",
    "nationality": "Somali",
    "calling_code": "252",
    "country_image": null,
    "translations": [
      {
        "id": 469,
        "country_codes_alpha_2": "SO",
        "languages_code": "zh-CN",
        "country_name": "索马里",
        "nationality": "索马里"
      },
      {
        "id": 468,
        "country_codes_alpha_2": "SO",
        "languages_code": "en-US",
        "country_name": "Somalia",
        "nationality": "Somali"
      },
      {
        "id": 791,
        "country_codes_alpha_2": "SO",
        "languages_code": "zh-HK",
        "country_name": "索馬裏",
        "nationality": "索馬里"
      }
    ]
  },
  {
    "country_name": "South Africa",
    "alpha_2": "ZA",
    "alpha_3": "ZAF",
    "nationality": "South African",
    "calling_code": "27",
    "country_image": null,
    "translations": [
      {
        "id": 330,
        "country_codes_alpha_2": "ZA",
        "languages_code": "en-US",
        "country_name": "South Africa",
        "nationality": "South African"
      },
      {
        "id": 331,
        "country_codes_alpha_2": "ZA",
        "languages_code": "zh-CN",
        "country_name": "南非",
        "nationality": "南非"
      },
      {
        "id": 719,
        "country_codes_alpha_2": "ZA",
        "languages_code": "zh-HK",
        "country_name": "南非",
        "nationality": "南非"
      }
    ]
  },
  {
    "country_name": "South Sudan",
    "alpha_2": "SS",
    "alpha_3": "SSD",
    "nationality": "South Sudanese",
    "calling_code": "211",
    "country_image": null,
    "translations": [
      {
        "id": 417,
        "country_codes_alpha_2": "SS",
        "languages_code": "zh-CN",
        "country_name": "南苏丹",
        "nationality": "南苏丹"
      },
      {
        "id": 416,
        "country_codes_alpha_2": "SS",
        "languages_code": "en-US",
        "country_name": "South Sudan",
        "nationality": "South Sudanese"
      },
      {
        "id": 682,
        "country_codes_alpha_2": "SS",
        "languages_code": "zh-HK",
        "country_name": "南蘇丹",
        "nationality": "南蘇丹"
      }
    ]
  },
  {
    "country_name": "Spain",
    "alpha_2": "ES",
    "alpha_3": "ESP",
    "nationality": "Spanish",
    "calling_code": "34",
    "country_image": null,
    "translations": [
      {
        "id": 290,
        "country_codes_alpha_2": "ES",
        "languages_code": "en-US",
        "country_name": "Spain",
        "nationality": "Spanish"
      },
      {
        "id": 291,
        "country_codes_alpha_2": "ES",
        "languages_code": "zh-CN",
        "country_name": "西班牙",
        "nationality": "西班牙"
      },
      {
        "id": 801,
        "country_codes_alpha_2": "ES",
        "languages_code": "zh-HK",
        "country_name": "西班牙",
        "nationality": "西班牙"
      }
    ]
  },
  {
    "country_name": "Sri Lanka",
    "alpha_2": "LK",
    "alpha_3": "LKA",
    "nationality": "Sri Lankan",
    "calling_code": "94",
    "country_image": null,
    "translations": [
      {
        "id": 593,
        "country_codes_alpha_2": "LK",
        "languages_code": "zh-CN",
        "country_name": "斯里兰卡",
        "nationality": "斯里兰卡"
      },
      {
        "id": 592,
        "country_codes_alpha_2": "LK",
        "languages_code": "en-US",
        "country_name": "Sri Lanka",
        "nationality": "Sri Lankan"
      },
      {
        "id": 654,
        "country_codes_alpha_2": "LK",
        "languages_code": "zh-HK",
        "country_name": "斯裏蘭卡",
        "nationality": "斯里蘭卡"
      }
    ]
  },
  {
    "country_name": "Sudan",
    "alpha_2": "SD",
    "alpha_3": "SDN",
    "nationality": "Sudanese",
    "calling_code": "249",
    "country_image": null,
    "translations": [
      {
        "id": 428,
        "country_codes_alpha_2": "SD",
        "languages_code": "en-US",
        "country_name": "Sudan",
        "nationality": "Sudanese"
      },
      {
        "id": 846,
        "country_codes_alpha_2": "SD",
        "languages_code": "zh-HK",
        "country_name": "蘇丹",
        "nationality": "蘇丹"
      },
      {
        "id": 429,
        "country_codes_alpha_2": "SD",
        "languages_code": "zh-CN",
        "country_name": "苏丹",
        "nationality": "苏丹"
      }
    ]
  },
  {
    "country_name": "Suriname",
    "alpha_2": "SR",
    "alpha_3": "SUR",
    "nationality": "Surinamese",
    "calling_code": "597",
    "country_image": null,
    "translations": [
      {
        "id": 649,
        "country_codes_alpha_2": "SR",
        "languages_code": "zh-HK",
        "country_name": "蘇裏南",
        "nationality": "蘇里南"
      },
      {
        "id": 378,
        "country_codes_alpha_2": "SR",
        "languages_code": "en-US",
        "country_name": "Suriname",
        "nationality": "Surinamese"
      },
      {
        "id": 379,
        "country_codes_alpha_2": "SR",
        "languages_code": "zh-CN",
        "country_name": "苏里南",
        "nationality": "苏里南"
      }
    ]
  },
  {
    "country_name": "Svalbard and Jan Mayen",
    "alpha_2": "SJ",
    "alpha_3": "SJM",
    "nationality": "Norwegian (Svalbard and Jan Mayen)",
    "calling_code": "47",
    "country_image": null,
    "translations": [
      {
        "id": 971,
        "country_codes_alpha_2": "SJ",
        "languages_code": "en-US",
        "country_name": "Svalbard and Jan Mayen",
        "nationality": "Norwegian (Svalbard and Jan Mayen)"
      },
      {
        "id": 970,
        "country_codes_alpha_2": "SJ",
        "languages_code": "zh-CN",
        "country_name": "斯瓦尔巴岛和扬马延岛",
        "nationality": "斯瓦尔巴和扬马延"
      },
      {
        "id": 972,
        "country_codes_alpha_2": "SJ",
        "languages_code": "zh-HK",
        "country_name": "斯瓦爾巴島和揚馬延島",
        "nationality": "斯瓦爾巴和揚馬延"
      }
    ]
  },
  {
    "country_name": "Sweden",
    "alpha_2": "SE",
    "alpha_3": "SWE",
    "nationality": "Swedish",
    "calling_code": "46",
    "country_image": null,
    "translations": [
      {
        "id": 388,
        "country_codes_alpha_2": "SE",
        "languages_code": "en-US",
        "country_name": "Sweden",
        "nationality": "Swedish"
      },
      {
        "id": 389,
        "country_codes_alpha_2": "SE",
        "languages_code": "zh-CN",
        "country_name": "瑞典",
        "nationality": "瑞典"
      },
      {
        "id": 815,
        "country_codes_alpha_2": "SE",
        "languages_code": "zh-HK",
        "country_name": "瑞典",
        "nationality": "瑞典"
      }
    ]
  },
  {
    "country_name": "Switzerland",
    "alpha_2": "CH",
    "alpha_3": "CHE",
    "nationality": "Swiss",
    "calling_code": "41",
    "country_image": null,
    "translations": [
      {
        "id": 564,
        "country_codes_alpha_2": "CH",
        "languages_code": "en-US",
        "country_name": "Switzerland",
        "nationality": "Swiss"
      },
      {
        "id": 565,
        "country_codes_alpha_2": "CH",
        "languages_code": "zh-CN",
        "country_name": "瑞士",
        "nationality": "瑞士"
      },
      {
        "id": 770,
        "country_codes_alpha_2": "CH",
        "languages_code": "zh-HK",
        "country_name": "瑞士",
        "nationality": "瑞士"
      }
    ]
  },
  {
    "country_name": "Syrian Arab Republic",
    "alpha_2": "SY",
    "alpha_3": "SYR",
    "nationality": "Syrian",
    "calling_code": "963",
    "country_image": null,
    "translations": [
      {
        "id": 395,
        "country_codes_alpha_2": "SY",
        "languages_code": "zh-CN",
        "country_name": "阿拉伯叙利亚共和国",
        "nationality": "叙利亚"
      },
      {
        "id": 394,
        "country_codes_alpha_2": "SY",
        "languages_code": "en-US",
        "country_name": "Syrian Arab Republic",
        "nationality": "Syrian"
      },
      {
        "id": 781,
        "country_codes_alpha_2": "SY",
        "languages_code": "zh-HK",
        "country_name": "阿拉伯敘利亞共和國",
        "nationality": "敘利亞"
      }
    ]
  },
  {
    "country_name": "Taiwan, Province of China",
    "alpha_2": "TW",
    "alpha_3": "TWN",
    "nationality": "Taiwanese",
    "calling_code": "886",
    "country_image": null,
    "translations": [
      {
        "id": 975,
        "country_codes_alpha_2": "TW",
        "languages_code": "zh-HK",
        "country_name": "台灣",
        "nationality": "台灣"
      },
      {
        "id": 973,
        "country_codes_alpha_2": "TW",
        "languages_code": "zh-CN",
        "country_name": "台湾省，中国",
        "nationality": "台湾"
      },
      {
        "id": 974,
        "country_codes_alpha_2": "TW",
        "languages_code": "en-US",
        "country_name": "Taiwan",
        "nationality": "Taiwanese"
      }
    ]
  },
  {
    "country_name": "Tajikistan",
    "alpha_2": "TJ",
    "alpha_3": "TJK",
    "nationality": "Tajik",
    "calling_code": "992",
    "country_image": null,
    "translations": [
      {
        "id": 511,
        "country_codes_alpha_2": "TJ",
        "languages_code": "zh-CN",
        "country_name": "塔吉克斯坦",
        "nationality": "塔吉克斯坦"
      },
      {
        "id": 510,
        "country_codes_alpha_2": "TJ",
        "languages_code": "en-US",
        "country_name": "Tajikistan",
        "nationality": "Tajik"
      },
      {
        "id": 788,
        "country_codes_alpha_2": "TJ",
        "languages_code": "zh-HK",
        "country_name": "塔吉克斯坦",
        "nationality": "塔吉克斯坦"
      }
    ]
  },
  {
    "country_name": "Tanzania, United Republic of",
    "alpha_2": "TZ",
    "alpha_3": "TZA",
    "nationality": "Tanzanian",
    "calling_code": "255",
    "country_image": null,
    "translations": [
      {
        "id": 568,
        "country_codes_alpha_2": "TZ",
        "languages_code": "en-US",
        "country_name": "United Republic of Tanzania",
        "nationality": "Tanzanian"
      },
      {
        "id": 569,
        "country_codes_alpha_2": "TZ",
        "languages_code": "zh-CN",
        "country_name": "坦桑尼亚联合共和国",
        "nationality": "坦桑尼亚"
      },
      {
        "id": 783,
        "country_codes_alpha_2": "TZ",
        "languages_code": "zh-HK",
        "country_name": "坦桑尼亞聯合共和國",
        "nationality": "坦桑尼亞"
      }
    ]
  },
  {
    "country_name": "Thailand",
    "alpha_2": "TH",
    "alpha_3": "THA",
    "nationality": "Thai",
    "calling_code": "66",
    "country_image": null,
    "translations": [
      {
        "id": 850,
        "country_codes_alpha_2": "TH",
        "languages_code": "zh-HK",
        "country_name": "泰國",
        "nationality": "泰國"
      },
      {
        "id": 543,
        "country_codes_alpha_2": "TH",
        "languages_code": "zh-CN",
        "country_name": "泰国",
        "nationality": "泰国"
      },
      {
        "id": 542,
        "country_codes_alpha_2": "TH",
        "languages_code": "en-US",
        "country_name": "Thailand",
        "nationality": "Thai"
      }
    ]
  },
  {
    "country_name": "Timor-Leste",
    "alpha_2": "TL",
    "alpha_3": "TLS",
    "nationality": "East Timorese",
    "calling_code": "670",
    "country_image": null,
    "translations": [
      {
        "id": 617,
        "country_codes_alpha_2": "TL",
        "languages_code": "zh-CN",
        "country_name": "东帝汶",
        "nationality": "东帝汶"
      },
      {
        "id": 616,
        "country_codes_alpha_2": "TL",
        "languages_code": "en-US",
        "country_name": "Timor-Leste",
        "nationality": "East Timorese"
      },
      {
        "id": 792,
        "country_codes_alpha_2": "TL",
        "languages_code": "zh-HK",
        "country_name": "東帝汶",
        "nationality": "東帝汶"
      }
    ]
  },
  {
    "country_name": "Togo",
    "alpha_2": "TG",
    "alpha_3": "TGO",
    "nationality": "Togolese",
    "calling_code": "228",
    "country_image": null,
    "translations": [
      {
        "id": 575,
        "country_codes_alpha_2": "TG",
        "languages_code": "zh-CN",
        "country_name": "多哥",
        "nationality": "多哥"
      },
      {
        "id": 574,
        "country_codes_alpha_2": "TG",
        "languages_code": "en-US",
        "country_name": "Togo",
        "nationality": "Togolese"
      },
      {
        "id": 785,
        "country_codes_alpha_2": "TG",
        "languages_code": "zh-HK",
        "country_name": "多哥",
        "nationality": "多哥"
      }
    ]
  },
  {
    "country_name": "Tokelau",
    "alpha_2": "TK",
    "alpha_3": "TKL",
    "nationality": "Tokelau citizen",
    "calling_code": "690",
    "country_image": null,
    "translations": [
      {
        "id": 773,
        "country_codes_alpha_2": "TK",
        "languages_code": "zh-HK",
        "country_name": "托克勞",
        "nationality": "托克勞"
      },
      {
        "id": 531,
        "country_codes_alpha_2": "TK",
        "languages_code": "zh-CN",
        "country_name": "托克劳",
        "nationality": "托克劳"
      },
      {
        "id": 530,
        "country_codes_alpha_2": "TK",
        "languages_code": "en-US",
        "country_name": "Tokelau",
        "nationality": "Tokelau citizen"
      }
    ]
  },
  {
    "country_name": "Tonga",
    "alpha_2": "TO",
    "alpha_3": "TON",
    "nationality": "Tongan",
    "calling_code": "676",
    "country_image": null,
    "translations": [
      {
        "id": 535,
        "country_codes_alpha_2": "TO",
        "languages_code": "zh-CN",
        "country_name": "汤加",
        "nationality": "汤加"
      },
      {
        "id": 820,
        "country_codes_alpha_2": "TO",
        "languages_code": "zh-HK",
        "country_name": "湯加",
        "nationality": "湯加"
      },
      {
        "id": 534,
        "country_codes_alpha_2": "TO",
        "languages_code": "en-US",
        "country_name": "Tonga",
        "nationality": "Tongan"
      }
    ]
  },
  {
    "country_name": "Trinidad and Tobago",
    "alpha_2": "TT",
    "alpha_3": "TTO",
    "nationality": "Trinidadian",
    "calling_code": "1868",
    "country_image": null,
    "translations": [
      {
        "id": 911,
        "country_codes_alpha_2": "TT",
        "languages_code": "zh-CN",
        "country_name": "特立尼达和多巴哥",
        "nationality": "特立尼达和多巴哥"
      },
      {
        "id": 1019,
        "country_codes_alpha_2": "TT",
        "languages_code": "zh-HK",
        "country_name": "特立尼達和多巴哥",
        "nationality": "特立尼達和多巴哥"
      },
      {
        "id": 912,
        "country_codes_alpha_2": "TT",
        "languages_code": "en-US",
        "country_name": "Trinidad and Tobago",
        "nationality": "Trinidadian"
      }
    ]
  },
  {
    "country_name": "Tunisia",
    "alpha_2": "TN",
    "alpha_3": "TUN",
    "nationality": "Tunisian",
    "calling_code": "216",
    "country_image": null,
    "translations": [
      {
        "id": 573,
        "country_codes_alpha_2": "TN",
        "languages_code": "zh-CN",
        "country_name": "突尼斯",
        "nationality": "突尼斯"
      },
      {
        "id": 572,
        "country_codes_alpha_2": "TN",
        "languages_code": "en-US",
        "country_name": "Tunisia",
        "nationality": "Tunisian"
      },
      {
        "id": 771,
        "country_codes_alpha_2": "TN",
        "languages_code": "zh-HK",
        "country_name": "突尼斯",
        "nationality": "突尼斯"
      }
    ]
  },
  {
    "country_name": "Turkey",
    "alpha_2": "TR",
    "alpha_3": "TUR",
    "nationality": "Turkish",
    "calling_code": "90",
    "country_image": null,
    "translations": [
      {
        "id": 789,
        "country_codes_alpha_2": "TR",
        "languages_code": "zh-HK",
        "country_name": "土耳其",
        "nationality": "土耳其"
      },
      {
        "id": 513,
        "country_codes_alpha_2": "TR",
        "languages_code": "zh-CN",
        "country_name": "土耳其",
        "nationality": "土耳其"
      },
      {
        "id": 512,
        "country_codes_alpha_2": "TR",
        "languages_code": "en-US",
        "country_name": "Turkey",
        "nationality": "Turkish"
      }
    ]
  },
  {
    "country_name": "Turkmenistan",
    "alpha_2": "TM",
    "alpha_3": "TKM",
    "nationality": "Turkmen",
    "calling_code": "993",
    "country_image": null,
    "translations": [
      {
        "id": 529,
        "country_codes_alpha_2": "TM",
        "languages_code": "zh-CN",
        "country_name": "土库曼斯坦",
        "nationality": "土库曼斯坦"
      },
      {
        "id": 528,
        "country_codes_alpha_2": "TM",
        "languages_code": "en-US",
        "country_name": "Turkmenistan",
        "nationality": "Turkmen"
      },
      {
        "id": 779,
        "country_codes_alpha_2": "TM",
        "languages_code": "zh-HK",
        "country_name": "土庫曼斯坦",
        "nationality": "土庫曼斯坦"
      }
    ]
  },
  {
    "country_name": "Turks and Caicos Islands",
    "alpha_2": "TC",
    "alpha_3": "TCA",
    "nationality": "Turks and Caicos Islander",
    "calling_code": "1649",
    "country_image": null,
    "translations": [
      {
        "id": 856,
        "country_codes_alpha_2": "TC",
        "languages_code": "zh-HK",
        "country_name": "特克斯和凱科斯群島",
        "nationality": "特克斯和凱科斯群島"
      },
      {
        "id": 858,
        "country_codes_alpha_2": "TC",
        "languages_code": "zh-CN",
        "country_name": "特克斯和凯科斯群岛",
        "nationality": "特克斯和凯科斯群岛"
      },
      {
        "id": 857,
        "country_codes_alpha_2": "TC",
        "languages_code": "en-US",
        "country_name": "Turks and Caicos Islands",
        "nationality": "Turks and Caicos Islander"
      }
    ]
  },
  {
    "country_name": "Tuvalu",
    "alpha_2": "TV",
    "alpha_3": "TUV",
    "nationality": "Tuvaluan",
    "calling_code": "688",
    "country_image": null,
    "translations": [
      {
        "id": 482,
        "country_codes_alpha_2": "TV",
        "languages_code": "en-US",
        "country_name": "Tuvalu",
        "nationality": "Tuvaluan"
      },
      {
        "id": 845,
        "country_codes_alpha_2": "TV",
        "languages_code": "zh-HK",
        "country_name": "圖瓦盧",
        "nationality": "圖瓦盧"
      },
      {
        "id": 483,
        "country_codes_alpha_2": "TV",
        "languages_code": "zh-CN",
        "country_name": "图瓦卢",
        "nationality": "图瓦卢"
      }
    ]
  },
  {
    "country_name": "Uganda",
    "alpha_2": "UG",
    "alpha_3": "UGA",
    "nationality": "Ugandan",
    "calling_code": "256",
    "country_image": null,
    "translations": [
      {
        "id": 488,
        "country_codes_alpha_2": "UG",
        "languages_code": "en-US",
        "country_name": "Uganda",
        "nationality": "Ugandan"
      },
      {
        "id": 489,
        "country_codes_alpha_2": "UG",
        "languages_code": "zh-CN",
        "country_name": "乌干达",
        "nationality": "乌干达"
      },
      {
        "id": 767,
        "country_codes_alpha_2": "UG",
        "languages_code": "zh-HK",
        "country_name": "烏幹達",
        "nationality": "烏干達"
      }
    ]
  },
  {
    "country_name": "Ukraine",
    "alpha_2": "UA",
    "alpha_3": "UKR",
    "nationality": "Ukrainian",
    "calling_code": "380",
    "country_image": null,
    "translations": [
      {
        "id": 484,
        "country_codes_alpha_2": "UA",
        "languages_code": "en-US",
        "country_name": "Ukraine",
        "nationality": "Ukrainian"
      },
      {
        "id": 485,
        "country_codes_alpha_2": "UA",
        "languages_code": "zh-CN",
        "country_name": "乌克兰",
        "nationality": "乌克兰"
      },
      {
        "id": 774,
        "country_codes_alpha_2": "UA",
        "languages_code": "zh-HK",
        "country_name": "烏克蘭",
        "nationality": "烏克蘭"
      }
    ]
  },
  {
    "country_name": "United Arab Emirates",
    "alpha_2": "AE",
    "alpha_3": "ARE",
    "nationality": "Emirati",
    "calling_code": "971",
    "country_image": null,
    "translations": [
      {
        "id": 518,
        "country_codes_alpha_2": "AE",
        "languages_code": "en-US",
        "country_name": "United Arab Emirates",
        "nationality": "Emirati"
      },
      {
        "id": 769,
        "country_codes_alpha_2": "AE",
        "languages_code": "zh-HK",
        "country_name": "阿拉伯聯合酋長國",
        "nationality": "阿拉伯聯合酋長國"
      },
      {
        "id": 519,
        "country_codes_alpha_2": "AE",
        "languages_code": "zh-CN",
        "country_name": "阿拉伯联合酋长国",
        "nationality": "阿拉伯联合酋长国"
      }
    ]
  },
  {
    "country_name": "United Kingdom of Great Britain and Northern Ireland",
    "alpha_2": "GB",
    "alpha_3": "GBR",
    "nationality": "British",
    "calling_code": "44",
    "country_image": null,
    "translations": [
      {
        "id": 586,
        "country_codes_alpha_2": "GB",
        "languages_code": "en-US",
        "country_name": "United Kingdom of Great Britain and Northern Ireland",
        "nationality": "British"
      },
      {
        "id": 587,
        "country_codes_alpha_2": "GB",
        "languages_code": "zh-CN",
        "country_name": "大不列颠及北爱尔兰联合王国",
        "nationality": "英国"
      },
      {
        "id": 766,
        "country_codes_alpha_2": "GB",
        "languages_code": "zh-HK",
        "country_name": "大不列顛及北愛爾蘭聯合王國",
        "nationality": "英國"
      }
    ]
  },
  {
    "country_name": "United States of America",
    "alpha_2": "US",
    "alpha_3": "USA",
    "nationality": "American",
    "calling_code": "1",
    "country_image": null,
    "translations": [
      {
        "id": 887,
        "country_codes_alpha_2": "US",
        "languages_code": "zh-CN",
        "country_name": "美利坚合众国",
        "nationality": "美国"
      },
      {
        "id": 1016,
        "country_codes_alpha_2": "US",
        "languages_code": "zh-HK",
        "country_name": "美利堅合眾國",
        "nationality": "美國"
      },
      {
        "id": 888,
        "country_codes_alpha_2": "US",
        "languages_code": "en-US",
        "country_name": "United States of America",
        "nationality": "American"
      }
    ]
  },
  {
    "country_name": "Uruguay",
    "alpha_2": "UY",
    "alpha_3": "URY",
    "nationality": "Uruguayan",
    "calling_code": "598",
    "country_image": null,
    "translations": [
      {
        "id": 506,
        "country_codes_alpha_2": "UY",
        "languages_code": "en-US",
        "country_name": "Uruguay",
        "nationality": "Uruguayan"
      },
      {
        "id": 507,
        "country_codes_alpha_2": "UY",
        "languages_code": "zh-CN",
        "country_name": "乌拉圭",
        "nationality": "乌拉圭"
      },
      {
        "id": 782,
        "country_codes_alpha_2": "UY",
        "languages_code": "zh-HK",
        "country_name": "烏拉圭",
        "nationality": "烏拉圭"
      }
    ]
  },
  {
    "country_name": "Uzbekistan",
    "alpha_2": "UZ",
    "alpha_3": "UZB",
    "nationality": "Uzbek",
    "calling_code": "998",
    "country_image": null,
    "translations": [
      {
        "id": 525,
        "country_codes_alpha_2": "UZ",
        "languages_code": "zh-CN",
        "country_name": "乌兹别克斯坦",
        "nationality": "乌兹别克斯坦"
      },
      {
        "id": 524,
        "country_codes_alpha_2": "UZ",
        "languages_code": "en-US",
        "country_name": "Uzbekistan",
        "nationality": "Uzbek"
      },
      {
        "id": 794,
        "country_codes_alpha_2": "UZ",
        "languages_code": "zh-HK",
        "country_name": "烏茲別克斯坦",
        "nationality": "烏茲別克斯坦"
      }
    ]
  },
  {
    "country_name": "Vanuatu",
    "alpha_2": "VU",
    "alpha_3": "VUT",
    "nationality": "Vanuatu citizen",
    "calling_code": "678",
    "country_image": null,
    "translations": [
      {
        "id": 509,
        "country_codes_alpha_2": "VU",
        "languages_code": "zh-CN",
        "country_name": "瓦努阿图",
        "nationality": "瓦努阿图"
      },
      {
        "id": 508,
        "country_codes_alpha_2": "VU",
        "languages_code": "en-US",
        "country_name": "Vanuatu",
        "nationality": "Vanuatu citizen"
      },
      {
        "id": 762,
        "country_codes_alpha_2": "VU",
        "languages_code": "zh-HK",
        "country_name": "瓦努阿圖",
        "nationality": "瓦努阿圖"
      }
    ]
  },
  {
    "country_name": "Venezuela (Bolivarian Republic of)",
    "alpha_2": "VE",
    "alpha_3": "VEN",
    "nationality": "Venezuelan",
    "calling_code": "58",
    "country_image": null,
    "translations": [
      {
        "id": 772,
        "country_codes_alpha_2": "VE",
        "languages_code": "zh-HK",
        "country_name": "委內瑞拉(玻利瓦爾共和國)",
        "nationality": "委內瑞拉"
      },
      {
        "id": 265,
        "country_codes_alpha_2": "VE",
        "languages_code": "zh-CN",
        "country_name": "委内瑞拉(玻利瓦尔共和国)",
        "nationality": "委内瑞拉"
      },
      {
        "id": 264,
        "country_codes_alpha_2": "VE",
        "languages_code": "en-US",
        "country_name": "Venezuela (Bolivarian Republic of)",
        "nationality": "Venezuelan"
      }
    ]
  },
  {
    "country_name": "Viet Nam",
    "alpha_2": "VN",
    "alpha_3": "VNM",
    "nationality": "Vietnamese",
    "calling_code": "84",
    "country_image": null,
    "translations": [
      {
        "id": 505,
        "country_codes_alpha_2": "VN",
        "languages_code": "zh-CN",
        "country_name": "越南",
        "nationality": "越南"
      },
      {
        "id": 504,
        "country_codes_alpha_2": "VN",
        "languages_code": "en-US",
        "country_name": "Viet Nam",
        "nationality": "Vietnamese"
      },
      {
        "id": 780,
        "country_codes_alpha_2": "VN",
        "languages_code": "zh-HK",
        "country_name": "越南",
        "nationality": "越南"
      }
    ]
  },
  {
    "country_name": "Virgin Islands (British)",
    "alpha_2": "VG",
    "alpha_3": "VGB",
    "nationality": "British (British Virgin Islands)",
    "calling_code": "1284",
    "country_image": null,
    "translations": [
      {
        "id": 976,
        "country_codes_alpha_2": "VG",
        "languages_code": "zh-CN",
        "country_name": "英属维尔京群岛",
        "nationality": "英属维尔京群岛"
      },
      {
        "id": 977,
        "country_codes_alpha_2": "VG",
        "languages_code": "en-US",
        "country_name": "VIRGIN ISLANDS (BRITISH)",
        "nationality": "British (British Virgin Islands)"
      },
      {
        "id": 978,
        "country_codes_alpha_2": "VG",
        "languages_code": "zh-HK",
        "country_name": "英屬維爾京群島",
        "nationality": "英屬維爾京群島"
      }
    ]
  },
  {
    "country_name": "Virgin Islands (U.S.)",
    "alpha_2": "VI",
    "alpha_3": "VIR",
    "nationality": "American (U.S. Virgin Islands)",
    "calling_code": "1340",
    "country_image": null,
    "translations": [
      {
        "id": 979,
        "country_codes_alpha_2": "VI",
        "languages_code": "zh-CN",
        "country_name": "美属维尔京群岛",
        "nationality": "美属维尔京群岛"
      },
      {
        "id": 980,
        "country_codes_alpha_2": "VI",
        "languages_code": "en-US",
        "country_name": "Virgin Islands (U.S.)",
        "nationality": "American (U.S. Virgin Islands)"
      },
      {
        "id": 981,
        "country_codes_alpha_2": "VI",
        "languages_code": "zh-HK",
        "country_name": "美屬維爾京群島",
        "nationality": "美屬維爾京群島"
      }
    ]
  },
  {
    "country_name": "Wallis and Futuna",
    "alpha_2": "WF",
    "alpha_3": "WLF",
    "nationality": "French (Wallis and Futuna)",
    "calling_code": "681",
    "country_image": null,
    "translations": [
      {
        "id": 578,
        "country_codes_alpha_2": "WF",
        "languages_code": "en-US",
        "country_name": "Wallis and Futuna",
        "nationality": "French (Wallis and Futuna)"
      },
      {
        "id": 776,
        "country_codes_alpha_2": "WF",
        "languages_code": "zh-HK",
        "country_name": "瓦利斯群島和富圖納群島",
        "nationality": "瓦利斯和富圖納群島"
      },
      {
        "id": 579,
        "country_codes_alpha_2": "WF",
        "languages_code": "zh-CN",
        "country_name": "瓦利斯群岛和富图纳群岛",
        "nationality": "瓦利斯和富图纳群岛"
      }
    ]
  },
  {
    "country_name": "Western Sahara",
    "alpha_2": "EH",
    "alpha_3": "ESH",
    "nationality": "Western Sahara citizen",
    "calling_code": "212",
    "country_image": null,
    "translations": [
      {
        "id": 948,
        "country_codes_alpha_2": "EH",
        "languages_code": "en-US",
        "country_name": "Western Sahara",
        "nationality": "Western Sahara citizen"
      },
      {
        "id": 793,
        "country_codes_alpha_2": "EH",
        "languages_code": "zh-HK",
        "country_name": "西撒哈拉",
        "nationality": "西撒哈拉"
      },
      {
        "id": 947,
        "country_codes_alpha_2": "EH",
        "languages_code": "zh-CN",
        "country_name": "西撒哈拉",
        "nationality": "西撒哈拉"
      }
    ]
  },
  {
    "country_name": "Yemen",
    "alpha_2": "YE",
    "alpha_3": "YEM",
    "nationality": "Yemeni",
    "calling_code": "967",
    "country_image": null,
    "translations": [
      {
        "id": 532,
        "country_codes_alpha_2": "YE",
        "languages_code": "en-US",
        "country_name": "Yemen",
        "nationality": "Yemeni"
      },
      {
        "id": 533,
        "country_codes_alpha_2": "YE",
        "languages_code": "zh-CN",
        "country_name": "也门",
        "nationality": "也门"
      },
      {
        "id": 795,
        "country_codes_alpha_2": "YE",
        "languages_code": "zh-HK",
        "country_name": "也門",
        "nationality": "也門"
      }
    ]
  },
  {
    "country_name": "Zambia",
    "alpha_2": "ZM",
    "alpha_3": "ZMB",
    "nationality": "Zambian",
    "calling_code": "260",
    "country_image": null,
    "translations": [
      {
        "id": 816,
        "country_codes_alpha_2": "ZM",
        "languages_code": "zh-HK",
        "country_name": "贊比亞",
        "nationality": "贊比亞"
      },
      {
        "id": 625,
        "country_codes_alpha_2": "ZM",
        "languages_code": "zh-CN",
        "country_name": "赞比亚",
        "nationality": "赞比亚"
      },
      {
        "id": 624,
        "country_codes_alpha_2": "ZM",
        "languages_code": "en-US",
        "country_name": "Zambia",
        "nationality": "Zambian"
      }
    ]
  },
  {
    "country_name": "Zimbabwe",
    "alpha_2": "ZW",
    "alpha_3": "ZWE",
    "nationality": "Zimbabwean",
    "calling_code": "263",
    "country_image": null,
    "translations": [
      {
        "id": 503,
        "country_codes_alpha_2": "ZW",
        "languages_code": "zh-CN",
        "country_name": "津巴布韦",
        "nationality": "津巴布韦"
      },
      {
        "id": 775,
        "country_codes_alpha_2": "ZW",
        "languages_code": "zh-HK",
        "country_name": "津巴布韋",
        "nationality": "津巴布韋"
      },
      {
        "id": 502,
        "country_codes_alpha_2": "ZW",
        "languages_code": "en-US",
        "country_name": "Zimbabwe",
        "nationality": "Zimbabwean"
      }
    ]
  }
]
"""
}
