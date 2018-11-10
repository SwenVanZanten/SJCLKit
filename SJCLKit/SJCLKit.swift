import JavaScriptCore

public class SJCL {
    let encrypt: JSValue?
    let decrypt: JSValue?
    let base64: JSValue?
    
    public init() {
        let bundle = Bundle(for: type(of: self))
        let jsPath = bundle.path(forResource: "sjcl", ofType: "js")!
        let text = try! String(contentsOfFile: jsPath)
        
        let js = JSContext()
        js?.evaluateScript(text)
        
        js?.evaluateScript("var encrypt = function(password, plaintext, params) { return sjcl.encrypt(password, plaintext, params); }")
        js?.evaluateScript("var decrypt = function(password, ciphertext, params) { return sjcl.decrypt(password, ciphertext, params); }")
        js?.evaluateScript("var toBits = function(encryptingKey) { return sjcl.codec.base64.toBits(encryptingKey); }")
        
        encrypt = js?.objectForKeyedSubscript("encrypt")
        decrypt = js?.objectForKeyedSubscript("decrypt")
        base64 = js?.objectForKeyedSubscript("toBits")
    }
    
    public func encrypt(password: Any, plaintext: String, params: Any) -> String {
        return self.encrypt?.call(withArguments: [password, plaintext, params]).toString() ?? ""
    }
    
    public func decrypt(password: Any, ciphertext: String, params: Any) -> String {
        return self.decrypt?.call(withArguments: [password, ciphertext, params]).toString() ?? ""
    }
    
    public func base64ToBits(encryptingKey: String) -> [Int] {
        return self.base64?.call(withArguments: [encryptingKey])?.toArray() as! [Int]
    }
}
