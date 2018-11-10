import JavaScriptCore

public class SJCL {
    let encrypt: JSValue?
    let decrypt: JSValue?
    
    public init() {
        let bundle = Bundle(for: type(of: self))
        let jsPath = bundle.path(forResource: "sjcl", ofType: "js")!
        let text = try! String(contentsOfFile: jsPath)
        
        let js = JSContext()
        js?.evaluateScript(text)
        
        js?.evaluateScript("var encrypt = function(pw, data) { return sjcl.encrypt(pw, data); }")
        js?.evaluateScript("var decrypt = function(pw, data) { return sjcl.decrypt(pw, data); }")
        
        encrypt = js?.objectForKeyedSubscript("encrypt")
        decrypt = js?.objectForKeyedSubscript("decrypt")
    }
    
    public func encrypt(password: String, data: String)-> String {
        return self.encrypt?.call(withArguments: [password, data]).toString() ?? ""
    }
    
    public func decrypt(password: String, data: String) -> String {
        return self.decrypt?.call(withArguments: [password, data]).toString() ?? ""
    }
}
