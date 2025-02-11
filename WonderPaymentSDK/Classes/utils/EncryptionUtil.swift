
import Foundation
import CommonCrypto
import CryptoKit

// MARK: - 加密工具类
class EncryptionUtil {
    
    static let stagingCert = """
    -----BEGIN CERTIFICATE-----
    MIID3DCCAsSgAwIBAgIUcMe5qrYVYQKPqvrLyJABlJZEjfcwDQYJKoZIhvcNAQEL
    BQAwgacxJTAjBgkqhkiG9w0BCQEWFnBheW1lbnQudGVhbUBiaW5kby5jb20xCzAJ
    BgNVBAYTAkNOMREwDwYDVQQIDAhIb25nS29uZzERMA8GA1UEBwwISG9uZ0tvbmcx
    GzAZBgNVBAoMEkJpbmRvIExhYnMgTGltaXRlZDEVMBMGA1UECwwMUGF5bWVudCBU
    ZWFtMRcwFQYDVQQDDA5zZWN1cmUga2V5IHN0ZzAeFw0yNTAxMjQwMzA0MjJaFw0z
    NTAxMjQwMzA0MjJaMIGnMSUwIwYJKoZIhvcNAQkBFhZwYXltZW50LnRlYW1AYmlu
    ZG8uY29tMQswCQYDVQQGEwJDTjERMA8GA1UECAwISG9uZ0tvbmcxETAPBgNVBAcM
    CEhvbmdLb25nMRswGQYDVQQKDBJCaW5kbyBMYWJzIExpbWl0ZWQxFTATBgNVBAsM
    DFBheW1lbnQgVGVhbTEXMBUGA1UEAwwOc2VjdXJlIGtleSBzdGcwggEiMA0GCSqG
    SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDASiTJToYtRs1aIdq27rj5eAd4vIBejBFq
    /oiOzojGXKO11YXjL9W+Bw+DBwtx6RmUkeCYYw9yq+Yp7vgxxLWYu7gpNwFySvCS
    x+dWluTyID+WeOfskJSaffRi7eCE4js/KDbeHcCzuG630vK111kDFJSqr6sYJleq
    8BVyiB5DV8lKTotLbPfAKRWqu2zZqCvDp6gxesOPt/o7RZV9O9oPC6Lf1UFgmlPt
    v1phKGYdI3HGEwOw5viYYmwWcDqwpTuGHg0u4/pwvSapAroGRKuJyAzszGFmp9so
    iL+GCFGXDxImE7y4qtJ2JIKXD44FVvRiSILPQ5hzSjhq9stVzKA7AgMBAAEwDQYJ
    KoZIhvcNAQELBQADggEBADDZ9plTtwmjKgNHJw7EvL2Mc1bgVUWPqEcrZolOa3F8
    IskKRRFj8xa0HSmj3Ww5xrXxPGTszpWlU3FYpYnI6+Sb00CBvifLi717V+Roeg0b
    sKbWJYHPVDPvJRKigYzPYJRvNUpOqdOFhI7qKzk3nG7Xu55tOO812X07U0i8PLhG
    Mq8cNmBayqsBHM318KcJb9OzoaJqwe6gXp6q26SNDE67hxeDT3c19YuEk8vCh6UI
    NC26kPsIEjrwQ9ITtEgsckvgD/eoOjYVrm+T01PfaAvcfB/3pnjOqo7i6rDdxb/z
    Fd/EGyz6c/XQk8BDIioFH46V3snYyt10pxY+6249DXQ=
    -----END CERTIFICATE-----
    """
    
    static let alphaCert = """
    -----BEGIN CERTIFICATE-----
    MIID6jCCAtKgAwIBAgIUfr/otXbED/SWdByYZM4BlPLbynIwDQYJKoZIhvcNAQEL
    BQAwga4xJTAjBgkqhkiG9w0BCQEWFnBheW1lbnQudGVhbUBiaW5kby5jb20xCzAJ
    BgNVBAYTAkNOMREwDwYDVQQIDAhIb25nS29uZzERMA8GA1UEBwwISG9uZ0tvbmcx
    GzAZBgNVBAoMEkJpbmRvIExhYnMgTGltaXRlZDEVMBMGA1UECwwMUGF5bWVudCBU
    ZWFtMR4wHAYDVQQDDBVwcm9kIHZhdWx0IHNlY3VyZSBrZXkwHhcNMjUwMjExMDIz
    NDM4WhcNNDUwMjExMDIzNDM4WjCBrjElMCMGCSqGSIb3DQEJARYWcGF5bWVudC50
    ZWFtQGJpbmRvLmNvbTELMAkGA1UEBhMCQ04xETAPBgNVBAgMCEhvbmdLb25nMREw
    DwYDVQQHDAhIb25nS29uZzEbMBkGA1UECgwSQmluZG8gTGFicyBMaW1pdGVkMRUw
    EwYDVQQLDAxQYXltZW50IFRlYW0xHjAcBgNVBAMMFXByb2QgdmF1bHQgc2VjdXJl
    IGtleTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANnaOnfayL+My21X
    Nfiv8tq1Dj/oUe43R4x8NP7VlDLrtYPSW7tlTKtFTwdHuAxBPS9VG4qIUJG8ZEIx
    isGeZIKjsQcNFn9OxTc5fS8S1GhFc2YvSeDLiL2pg+iNVeIGqOmiBtgqvtf2XRtg
    t147m8DONPUetrS07qzSLoLBRyVlFpyczhaQeRqIdQNo2u6nd+6YjOh76K3U8NLC
    J9mcYlWKRswgrnTxRo0e4+RhYRUDVH03/w6BsQJIJmzU2eb1orlI50c+fGCUXRSg
    6IkHCd5hNL0f0MT8QUAjXpf9tqMUm8FrzSN+GVQpiKFAxmw/SCU5CoekdV3zG+ua
    eN3Q7dMCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAzq7C4Pbr2ffJ9r/3BpcwdpOn
    zY+oRxtMFlApF0qksYzo4C8XOGlIEobdPNvWM8wvQUSLa9h8Yfc9KbuP7B8mVyYZ
    u+V8tQ9ljSpOMzB6T7rOSg1H5wDCp0rx2PCTLgwNz8k8Ldw7Na1NQ3dfDWgPcogf
    qxWp/30BX//AHETBlQgTcqdBg/jFiSp/x60IQftd9igbEVLXoLEzDFCbf8IVrAjK
    F6PzUTqw+kvLb43hU5qKdPkKx402eyAZhbGX7UJuZgV0dKetT4qT81OEKaS91NwU
    teMPBLBL6Vxbm6ETYguUTzgx/bWgoL0HO63FX0QL0Au8vLO0tKUTvy2SGKYY0g==
    -----END CERTIFICATE-----
    """
    
    static let productionCert = """
    -----BEGIN CERTIFICATE-----
    MIID6jCCAtKgAwIBAgIUfr/otXbED/SWdByYZM4BlPLbynIwDQYJKoZIhvcNAQEL
    BQAwga4xJTAjBgkqhkiG9w0BCQEWFnBheW1lbnQudGVhbUBiaW5kby5jb20xCzAJ
    BgNVBAYTAkNOMREwDwYDVQQIDAhIb25nS29uZzERMA8GA1UEBwwISG9uZ0tvbmcx
    GzAZBgNVBAoMEkJpbmRvIExhYnMgTGltaXRlZDEVMBMGA1UECwwMUGF5bWVudCBU
    ZWFtMR4wHAYDVQQDDBVwcm9kIHZhdWx0IHNlY3VyZSBrZXkwHhcNMjUwMjExMDIz
    NDM4WhcNNDUwMjExMDIzNDM4WjCBrjElMCMGCSqGSIb3DQEJARYWcGF5bWVudC50
    ZWFtQGJpbmRvLmNvbTELMAkGA1UEBhMCQ04xETAPBgNVBAgMCEhvbmdLb25nMREw
    DwYDVQQHDAhIb25nS29uZzEbMBkGA1UECgwSQmluZG8gTGFicyBMaW1pdGVkMRUw
    EwYDVQQLDAxQYXltZW50IFRlYW0xHjAcBgNVBAMMFXByb2QgdmF1bHQgc2VjdXJl
    IGtleTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANnaOnfayL+My21X
    Nfiv8tq1Dj/oUe43R4x8NP7VlDLrtYPSW7tlTKtFTwdHuAxBPS9VG4qIUJG8ZEIx
    isGeZIKjsQcNFn9OxTc5fS8S1GhFc2YvSeDLiL2pg+iNVeIGqOmiBtgqvtf2XRtg
    t147m8DONPUetrS07qzSLoLBRyVlFpyczhaQeRqIdQNo2u6nd+6YjOh76K3U8NLC
    J9mcYlWKRswgrnTxRo0e4+RhYRUDVH03/w6BsQJIJmzU2eb1orlI50c+fGCUXRSg
    6IkHCd5hNL0f0MT8QUAjXpf9tqMUm8FrzSN+GVQpiKFAxmw/SCU5CoekdV3zG+ua
    eN3Q7dMCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAzq7C4Pbr2ffJ9r/3BpcwdpOn
    zY+oRxtMFlApF0qksYzo4C8XOGlIEobdPNvWM8wvQUSLa9h8Yfc9KbuP7B8mVyYZ
    u+V8tQ9ljSpOMzB6T7rOSg1H5wDCp0rx2PCTLgwNz8k8Ldw7Na1NQ3dfDWgPcogf
    qxWp/30BX//AHETBlQgTcqdBg/jFiSp/x60IQftd9igbEVLXoLEzDFCbf8IVrAjK
    F6PzUTqw+kvLb43hU5qKdPkKx402eyAZhbGX7UJuZgV0dKetT4qT81OEKaS91NwU
    teMPBLBL6Vxbm6ETYguUTzgx/bWgoL0HO63FX0QL0Au8vLO0tKUTvy2SGKYY0g==
    -----END CERTIFICATE-----
    """
    
    static var publicCertificate: String {
        let env = WonderPayment.paymentConfig.environment
        switch(env) {
        case .staging:
            return stagingCert
        case .alpha:
            return alphaCert
        case .production:
            return productionCert
        }
    }
    
    static func encrypt(content: [String: Any]) throws -> [String: Any] {
        // 1. Extract public key
        guard let pubKey = try? extractPublicKey(from: publicCertificate) else {
            throw NSError(domain: "CertificateError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to extract public key"])
        }
        
        // 2. Generate key hash
        guard let pubKeyHash = try getPublicKeyHash(pubKey: pubKey) else {
            throw NSError(domain: "CertificateError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate key hash"])
        }
        
        // 3.Generate AES key
        let aeskey = SymmetricKey(size: .bits256) // 256 位（32 字节）
        let aesKeyData = aeskey.withUnsafeBytes { Data($0) }
        
        // 4. Encrypt AES key with RSA
        guard let encryptedAesKey = try rsaEncrypt(data: aesKeyData, publicKey: pubKey) else {
            throw NSError(domain: "EncryptError", code: 1, userInfo: [NSLocalizedDescriptionKey: "RSA encryption failed"])
        }
        let encryptedAesKeyBase64 = encryptedAesKey.base64EncodedString()
        
        // 5. Encode content string
        guard let contentString = dictionaryToJSONString(content) else {
            throw NSError(domain: "JSONSerializationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate contentString"])
        }
//        guard let contentHexString = contentString.data(using: .utf8)?.hexEncodedString() else {
//            throw NSError(domain: "DataError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate contentHexString"])
//        }
        
        // 6. Prepare timestamp and nonce
        let timeStamp = "\(Int(Date().timeIntervalSince1970))"
        var nonce = Data(count: 12)
        let status = nonce.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, 12, $0.baseAddress!) }
        guard status == errSecSuccess else {
            throw NSError(domain: "DataError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate nonce"])
        }
        let nonceBase64 = nonce.base64EncodedString()
        
        // 7. AES-GCM encrypt
        let plaintext = Data((contentString + timeStamp).utf8)
        guard let encryptedData = try aesGcmEncrypt(plaintext: plaintext, key: aesKeyData, nonce: nonce) else {
            throw NSError(domain: "AESGcmEncryptError", code: 1, userInfo: [NSLocalizedDescriptionKey: "AES-GCM encryption failed"])
        }
        let encryptedContentBase64 = encryptedData.base64EncodedString().trimPrefix(nonceBase64)
        
        // 8. Build secure data map
        let secureData: [String: Any] = [
            "secure_data": [
                "data": encryptedContentBase64,
                "enc_key": encryptedAesKeyBase64,
                "pub_key_hash": pubKeyHash,
                "timestamp": timeStamp,
                "nonce": nonceBase64
            ]
        ]
        
        return secureData
    }
    
    static func extractPublicKey(from pemCertificate: String) throws -> SecKey {
        // 1. PEM 转 DER
        let pemLines = pemCertificate.components(separatedBy: .newlines)
        let base64String = pemLines.filter { !$0.hasPrefix("-----") }.joined()
        guard let derData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) else {
            throw NSError(domain: "CertificateError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid Base64"])
        }
        
        // 2. 创建证书对象
        guard let certificate = SecCertificateCreateWithData(nil, derData as CFData) else {
            throw NSError(domain: "CertificateError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid certificate data"])
        }
        
        // 3. 创建信任对象
        var trust: SecTrust?
        let policy = SecPolicyCreateBasicX509()
        guard SecTrustCreateWithCertificates(certificate, policy, &trust) == errSecSuccess else {
            throw NSError(domain: "CertificateError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Trust creation failed"])
        }
        
        // 4. 提取公钥
        guard let trust = trust, let publicKey = SecTrustCopyPublicKey(trust) else {
            throw NSError(domain: "CertificateError", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to copy public key"])
        }
        
        return publicKey
    }
    
    static func getPublicKeyHash(pubKey: SecKey) throws -> String? {
        if let pubKeyData = try? secKeyToData(pubKey)  {
            let data = convertPKCS1ToX509(data: pubKeyData)
            let hash = SHA256.hash(data: data)
            let hashBase64 = Data(hash).base64EncodedString()
            return hashBase64
        }
        return nil
    }
    
    static func secKeyToData(_ secKey: SecKey) throws -> Data {
        var error: Unmanaged<CFError>?
        guard let keyData = SecKeyCopyExternalRepresentation(secKey, &error) as Data? else {
            throw error?.takeRetainedValue() as Error? ?? NSError(domain: "SecKeyError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to copy SecKey data"])
        }
        return keyData
    }
    
    static func convertPKCS1ToX509(data: Data) -> Data {
        let pkcs1Header: [UInt8] = [
            0x30, 0x82, 0x01, 0x22, 0x30, 0x0D, 0x06, 0x09, 0x2A, 0x86, 0x48, 0x86,
            0xF7, 0x0D, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0F, 0x00
        ]
        var result = Data(pkcs1Header)
        result.append(data)
        return result
    }
    
    static func dictionaryToJSONString(_ dictionary: [String: Any]) -> String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }
    
    static func rsaEncrypt(data: Data, publicKey: SecKey) throws -> Data? {
        let algorithm: SecKeyAlgorithm = .rsaEncryptionOAEPSHA256
        guard SecKeyIsAlgorithmSupported(publicKey, .encrypt, algorithm) else { return nil }
        
        var error: Unmanaged<CFError>?
        return SecKeyCreateEncryptedData(publicKey, algorithm, data as CFData, &error) as Data?
    }
    
    static func aesGcmEncrypt(plaintext: Data, key: Data, nonce: Data) throws -> Data? {
        let symmetricKey = SymmetricKey(data: key)
        let nonce = try AES.GCM.Nonce(data: nonce)
        let sealedBox = try AES.GCM.seal(plaintext, using: symmetricKey, nonce: nonce)
        return sealedBox.combined
    }

}

private extension Data {
    init?(hexString: String) {
        var data = Data()
        var hex = hexString
        while !hex.isEmpty {
            let endIndex = hex.index(hex.startIndex, offsetBy: 2)
            let bytes = String(hex[..<endIndex])
            hex = String(hex[endIndex...])
            guard let byte = UInt8(bytes, radix: 16) else { return nil }
            data.append(byte)
        }
        self = data
    }
    
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

private extension String {
    func trimPrefix(_ prefixToRemove: String) -> String {
        if self.hasPrefix(prefixToRemove) {
            return String(self.dropFirst(prefixToRemove.count))
        }
        return self
    }
}
