//
//  APIManager.swift
//  Digipro
//
//  Created by Jonathan Viloria M on 20/08/18.
//  Copyright © 2018 Digipro Movil. All rights reserved.
//

import Foundation

public protocol FormularioDelegate: class {
    // Access to all Resolve functions
    func resolveValor(_ id: String, _ mode: String, _ string: String, _ category: String?) -> Bool
    
    func wizardAction(id: String, validar: Bool, tipo: String, atributos: Atributos_wizard)
    func addEventAction(_ evento: Eventos)
    func obtainRules(rString rlString: String?, eString element: String?, vString vrb: String?)
    func getValueFromTitleComponent(_ id: String) -> String
    func getImagesFromElement(_ compareFaces: CompareFacesJson) -> CompareFacesResult?
    func recursiveTokenFormula(_ formul: String?,_ dict: [Formula]?, _ typefrml: String, _ encoded: Bool) -> ReturnFormulaType
    func setNotificationBanner(_ title: String, _ subtitle: String, _ style: BannerStyle, _ direction: BannerPosition)
    func setStatusBarNotificationBanner(_ title: String, _ style: BannerStyle, _ direction: BannerPosition)
}

public final class FormManager<Del: FormularioDelegate>: NSObject {
    public weak var delegate: Del?
}

@objc public protocol APIDelegate: class {
    
    @objc optional func didValidRegistro()
    @objc optional func didFormatoTransited(index: NSInteger, formato: FEFormatoData, isInEdition: Bool)
    @objc optional func didSetAnexo(_ imagen: UIImage)
    @objc optional func didSetServicioFolio(_ folio: FolioAutomaticoResult, _ mensaje: String)
    @objc optional func didSetServicioFolioError(_ folio: FolioAutomaticoResult?, _ mensaje: String)
    
    @objc optional func didSetCompareFaces(_ compareFaces: CompareFacesResult, _ mensaje: String)
    @objc optional func didSetCompareFacesError(_ compareFaces: CompareFacesResult?, _ mensaje: String)
    
    @objc optional func didValidFlujosAndProcesos()
    @objc optional func didSendToServerFormatos()
    @objc optional func didSendToServerAnexos()

    func sendStatus(message: String, error: String, isLog: Bool, isNotification: Bool)
    func sendStatusCompletition(initial: Float, current: Float, final: Float)
    func sendStatusCodeMessage(message: String, error: String)
    @objc optional func responseSplash(message: String)
    @objc optional func wrongCodeResponse(message: String)
    @objc optional func wrongPasswordResponse(message: String)
    
    @objc optional func didValidLoginIpad()
    
    func didSendError(message: String, error: String)
    func didSendResponse(message: String, error: String)
    func didSendResponseHUD(message: String, error: String, porcentage: Int)
    @objc optional func didSendResponseStatus(title: String, subtitle: String, porcentage: Float)
}

public final class APIManager<Delegate: APIDelegate>: NSObject {
    public weak var delegate: Delegate?    
    let request = Requests()
}

// MARK: - LOGIN
public extension APIManager{
    
    func detectLicence() -> FELicencia?{
        if let filepath = Bundle.main.path(forResource: "licencia", ofType: "txt") {
            do {
                var contents = try String(contentsOfFile: filepath)
                contents = contents.replacingOccurrences(of: "\n", with: "")
                let decodedData = Data(base64Encoded: contents)!
                let decodedString = String(data: decodedData, encoding: .utf8)!
                let licencia = FELicencia(json: decodedString)
                let defaults = UserDefaults.standard
                //let localDefinition = detectLocalConfiguration()
                
                ConfigurationManager.shared.codigoUIAppDelegate.Codigo = licencia.codigo
                ConfigurationManager.shared.usuarioUIAppDelegate.User = licencia.usuario
                
                defaults.set("\(licencia.codigo)",             forKey: "licence_code")
                defaults.set("\(licencia.codigo)",             forKey: "codigo_preference")
                defaults.set("\(licencia.usuario)",             forKey: "licence_user")
                defaults.set("\(licencia.usuario)",             forKey: "usuario_preference")
                defaults.synchronize()
                return licencia
            } catch {
                return nil
            }
        }
        return nil
    }
    
    // Local Licence
    func detectLocalConfiguration()->(codigo:String,user:String){
        let userDefaults_codigo = String(UserDefaults.standard.string(forKey: "licence_code") ?? "")
        let userDefaults_user = String(UserDefaults.standard.string(forKey: "licence_user") ?? "")
        return (userDefaults_codigo, userDefaults_user)
    }
    
    func verifyShortLicence(delegate: Delegate?) -> Promise<Bool>{
        
        return Promise<Bool>{ resolve, reject in
            ConfigurationManager.shared.licenciaUIAppDelegate = detectLicence()!
            if ConfigurationManager.shared.licenciaUIAppDelegate.codigo == ""{
                delegate?.sendStatus(message: "No hay una licencia instalada", error: "error", isLog: false, isNotification: true)
                delegate?.sendStatusCompletition(initial: 0, current: 1, final: 1)
                reject(APIErrorResponse.DetectLicenceError)
            }
            // Setting values to the bundle .plist
            delegate?.sendStatus(message: "Licencia detectada.", error: "success", isLog: true, isNotification: false)
            
            ConfigurationManager.shared.codigoUIAppDelegate.Codigo = ConfigurationManager.shared.licenciaUIAppDelegate.codigo
            self.validCodeOnlinePromise(delegate: nil)
                .then{ response in
                    
                    delegate?.sendStatus(message: "Código verificado.", error: "success", isLog: true, isNotification: false)
                    delegate?.sendStatusCompletition(initial: 0, current: 0.14, final: 1)
                    
                    var password = Array(ConfigurationManager.shared.licenciaUIAppDelegate.clave.utf8)
                    password = password.sha512()
                    let passwordString = password.toBase64()
                    ConfigurationManager.shared.usuarioUIAppDelegate.Password = passwordString!
                    
                    let pass = Array(ConfigurationManager.shared.licenciaUIAppDelegate.clave.utf8)
                    let passwordBase = pass.toBase64()
                    ConfigurationManager.shared.usuarioUIAppDelegate.PasswordEncoded = passwordBase!
                    
                    ConfigurationManager.shared.usuarioUIAppDelegate.User = ConfigurationManager.shared.licenciaUIAppDelegate.usuario
                    ConfigurationManager.shared.usuarioUIAppDelegate.IP = ConfigurationManager.shared.utilities.getIPAddress()
                    ConfigurationManager.shared.usuarioUIAppDelegate.AplicacionID = ConfigurationManager.shared.codigoUIAppDelegate.AplicacionID
                    ConfigurationManager.shared.usuarioUIAppDelegate.ProyectoID = ConfigurationManager.shared.codigoUIAppDelegate.ProyectoID
                    
                    self.validSkinOnlinePromise(delegate: nil)
                        .then{ response in
                            
                            delegate?.sendStatus(message: "Skin verificado.", error: "success", isLog: true, isNotification: false)
                            delegate?.sendStatusCompletition(initial: 0, current: 0.16, final: 1)
                            
                            self.validUserOnlinePromise(delegate: nil)
                                .then{ response in
                                    
                                    delegate?.sendStatus(message: "Usuario verificado.", error: "success", isLog: true, isNotification: false)
                                    delegate?.sendStatusCompletition(initial: 0, current: 0.23, final: 1)
                                    
                                    resolve(true)
                                    
                                }
                                .catch{ error in
                                    reject(APIErrorResponse.UsuarioOnlineError)
                            }
                            
                        }
                        .catch{ error in
                            reject(APIErrorResponse.SkinOnlineError)
                    }
                    
                }
                .catch{ error in
                    reject(APIErrorResponse.CodigoOnlineError)
            }
        }
        
    }
    
    func verifyLicence(delegate: Delegate?) -> Promise<Bool>{
        
        return Promise<Bool>{ resolve, reject in
            ConfigurationManager.shared.licenciaUIAppDelegate = detectLicence()!
            if ConfigurationManager.shared.licenciaUIAppDelegate.codigo == ""{
                delegate?.sendStatus(message: "No hay una licencia instalada", error: "error", isLog: false, isNotification: true)
                delegate?.sendStatusCompletition(initial: 0, current: 1, final: 1)
                reject(APIErrorResponse.DetectLicenceError)
            }
            // Setting values to the bundle .plist
            delegate?.sendStatus(message: "Licencia detectada.", error: "success", isLog: true, isNotification: false)
            
            let defaults = UserDefaults.standard
            
            ConfigurationManager.shared.codigoUIAppDelegate.Codigo = ConfigurationManager.shared.licenciaUIAppDelegate.codigo
            self.validCodeOnlinePromise(delegate: nil)
                .then{ response in
                    
                    delegate?.sendStatus(message: "Código verificado.", error: "success", isLog: true, isNotification: false)
                    delegate?.sendStatusCompletition(initial: 0, current: 0.14, final: 1)
                    
                    var password = Array(ConfigurationManager.shared.licenciaUIAppDelegate.clave.utf8)
                    password = password.sha512()
                    let passwordString = password.toBase64()
                    ConfigurationManager.shared.usuarioUIAppDelegate.Password = passwordString!
                    
                    let pass = Array(ConfigurationManager.shared.licenciaUIAppDelegate.clave.utf8)
                    let passwordBase = pass.toBase64()
                    ConfigurationManager.shared.usuarioUIAppDelegate.PasswordEncoded = passwordBase!
                    
                    ConfigurationManager.shared.usuarioUIAppDelegate.User = ConfigurationManager.shared.licenciaUIAppDelegate.usuario
                    ConfigurationManager.shared.usuarioUIAppDelegate.IP = ConfigurationManager.shared.utilities.getIPAddress()
                    ConfigurationManager.shared.usuarioUIAppDelegate.AplicacionID = ConfigurationManager.shared.codigoUIAppDelegate.AplicacionID
                    ConfigurationManager.shared.usuarioUIAppDelegate.ProyectoID = ConfigurationManager.shared.codigoUIAppDelegate.ProyectoID
                    
                    self.validSkinOnlinePromise(delegate: nil)
                        .then{ response in
                            
                            delegate?.sendStatus(message: "Skin verificado.", error: "success", isLog: true, isNotification: false)
                            delegate?.sendStatusCompletition(initial: 0, current: 0.16, final: 1)
                            
                            self.validUserOnlinePromise(delegate: nil)
                                .then{ response in
                                    
                                    delegate?.sendStatus(message: "Usuario verificado.", error: "success", isLog: true, isNotification: false)
                                    delegate?.sendStatusCompletition(initial: 0, current: 0.23, final: 1)
                                    
                                    let modeApp = defaults.string(forKey: "mode_app")
                                    switch modeApp {
                                    case "Normal":
                                        defaults.set("Normal",             forKey: "mode_app")
                                        break
                                    case "Kiosco":
                                        defaults.set("Kiosco",             forKey: "mode_app")
                                        break
                                    case "SDK":
                                        defaults.set("SDK",             forKey: "mode_app")
                                        break
                                    case "Licencia":
                                        defaults.set("Licencia",             forKey: "mode_app")
                                        break
                                    default:
                                        // Normal Mode
                                        defaults.set("Normal",             forKey: "mode_app")
                                        break
                                    }
                                    defaults.synchronize()
                                    ConfigurationManager.shared.plantillaUIAppDelegate.FechaSincronizacionPlantilla = 0
                                    ConfigurationManager.shared.isInitiated = true
                                    // Step 1 Check "PLANTILLAS"
                                    self.validaPlantillasOnlinePromise(delegate: nil)
                                        .then{ response in
                                            
                                            delegate?.sendStatus(message: "Plantilla verificada.", error: "success", isLog: true, isNotification: false)
                                            delegate?.sendStatusCompletition(initial: 0, current: 0.3, final: 1)
                                            
                                            self.validaVariablesOnlinePromise(delegate: nil)
                                                .then { response in
                                                    
                                                    delegate?.sendStatus(message: "Variables verificadas.", error: "success", isLog: true, isNotification: false)
                                                    delegate?.sendStatusCompletition(initial: 0, current: 0.41, final: 1)
                                                    
                                                    self.validFormatosOnlinePromise(delegate: nil)
                                                        .then { response in
                                                            
                                                            delegate?.sendStatus(message: "Formatos verificados.", error: "success", isLog: true, isNotification: false)
                                                            delegate?.sendStatusCompletition(initial: 0, current: 0.78, final: 1)
                                                            
                                                            self.validFlujosAndProcesosPromise(delegate: nil)
                                                                .then { response in
                                                                    delegate?.sendStatus(message: "Ordenado de información correcto.", error: "success", isLog: true, isNotification: false)
                                                                    delegate?.sendStatusCompletition(initial: 0, current: 1, final: 1)
                                                                    resolve(true)
                                                                }
                                                                .catch { error in
                                                                    reject(APIErrorResponse.FlujosAndProcesosOnlineError)
                                                            }
                                                            
                                                        }
                                                        .catch { error in
                                                            reject(APIErrorResponse.FormatosOnlineError)
                                                    }
                                                }
                                                .catch { error in
                                                    reject(APIErrorResponse.VariablesOnlineError)
                                            }
                                        }
                                        .catch{ error in
                                            reject(APIErrorResponse.PlantillasOnlineError)
                                    }
                                    
                                }
                                .catch{ error in
                                    reject(APIErrorResponse.UsuarioOnlineError)
                            }
                            
                        }
                        .catch{ error in
                            reject(APIErrorResponse.SkinOnlineError)
                    }
                    
                }
                .catch{ error in
                    reject(APIErrorResponse.CodigoOnlineError)
            }
        }
        
    }
    
    func verifyLicenceOffline(delegate: Delegate?) -> Promise<Bool>{
        
        return Promise<Bool>{ resolve, reject in
            
            ConfigurationManager.shared.licenciaUIAppDelegate = detectLicence()!
            if ConfigurationManager.shared.licenciaUIAppDelegate.codigo == ""{
                delegate?.sendStatus(message: "No hay una licencia instalada", error: "error", isLog: false, isNotification: true)
                delegate?.sendStatusCompletition(initial: 0, current: 1, final: 1)
                reject(APIErrorResponse.CodigoOfflineError)
            }
            // Setting values to the bundle .plist
            delegate?.sendStatus(message: "Licencia detectada.", error: "success", isLog: true, isNotification: false)
            let defaults = UserDefaults.standard
            defaults.set("\(ConfigurationManager.shared.licenciaUIAppDelegate.codigo)",             forKey: "licence_code")
            defaults.synchronize()
            
            ConfigurationManager.shared.codigoUIAppDelegate.Codigo = ConfigurationManager.shared.licenciaUIAppDelegate.codigo
            
            
            if ConfigurationManager.shared.utilities.getCodeInLibrary(){
                
                // Using Code
                delegate?.sendStatus(message: "Se encontró el código guardado.", error: "success", isLog: true, isNotification: false)
                
                if ConfigurationManager.shared.utilities.getSkinInLibrary(){
                    
                    // Using Skin
                    delegate?.sendStatus(message: "Se encontró el skin guardado.", error: "success", isLog: true, isNotification: false)
                    
                    if ConfigurationManager.shared.utilities.getUserInLibrary(){
                        
                        // Using User
                        delegate?.sendStatus(message: "Se encontró el usuario guardado.", error: "success", isLog: true, isNotification: false)
                        
                        if ConfigurationManager.shared.utilities.getPlantillaInLibrary(){
                            
                            // Using Plantilla
                            delegate?.sendStatus(message: "Se encontraron las plantillas guardadas.", error: "success", isLog: true, isNotification: false)
                            
                            if ConfigurationManager.shared.utilities.getVariableInLibrary(){
                                
                                // Using Variables
                                delegate?.sendStatus(message: "Se encontraron las variables guardadas.", error: "success", isLog: true, isNotification: false)
                                resolve(true)
                                
                            }else{
                                
                                // If Variables is not set do something
                                reject(APIErrorResponse.VariablesOfflineError)
                            }
                            
                        }else{
                            
                            // If Plantilla is not set do something
                            reject(APIErrorResponse.PlantillasOfflineError)
                        }
                        
                    }else{
                        
                        // If User is not set do something
                        reject(APIErrorResponse.UsuarioOfflineError)
                    }
                    
                }else {
                    // If Skin is not set do something
                    
                    if ConfigurationManager.shared.utilities.getUserInLibrary(){
                        
                        // Using User
                        delegate?.sendStatus(message: "Se encontró el usuario guardado.", error: "success", isLog: true, isNotification: false)
                        
                        if ConfigurationManager.shared.utilities.getPlantillaInLibrary(){
                            
                            // Using Plantilla
                            delegate?.sendStatus(message: "Se encontraron las plantillas guardadas.", error: "success", isLog: true, isNotification: false)
                            
                            if ConfigurationManager.shared.utilities.getVariableInLibrary(){
                                
                                // Using Variables
                                delegate?.sendStatus(message: "Se encontraron las variables guardadas.", error: "success", isLog: true, isNotification: false)
                                resolve(true)
                                
                            }else{
                                
                                // If Variables is not set do something
                                reject(APIErrorResponse.VariablesOfflineError)
                            }
                            
                        }else{
                            
                            // If Plantilla is not set do something
                            reject(APIErrorResponse.PlantillasOfflineError)
                        }
                        
                    }else{
                        
                        // If User is not set do something
                        reject(APIErrorResponse.UsuarioOfflineError)
                    }
                    
                }
                
            }
            
            self.validCodeOnlinePromise(delegate: nil)
                .then{ response in
                    
                    delegate?.sendStatus(message: "Código verificado.", error: "success", isLog: true, isNotification: false)
                    delegate?.sendStatusCompletition(initial: 0, current: 0.14, final: 1)
                    
                    var password = Array(ConfigurationManager.shared.licenciaUIAppDelegate.clave.utf8)
                    password = password.sha512()
                    let passwordString = password.toBase64()
                    ConfigurationManager.shared.usuarioUIAppDelegate.Password = passwordString!
                    
                    let pass = Array(ConfigurationManager.shared.licenciaUIAppDelegate.clave.utf8)
                    let passwordBase = pass.toBase64()
                    ConfigurationManager.shared.usuarioUIAppDelegate.PasswordEncoded = passwordBase!
                    
                    ConfigurationManager.shared.usuarioUIAppDelegate.User = ConfigurationManager.shared.licenciaUIAppDelegate.usuario
                    ConfigurationManager.shared.usuarioUIAppDelegate.IP = ConfigurationManager.shared.utilities.getIPAddress()
                    ConfigurationManager.shared.usuarioUIAppDelegate.AplicacionID = ConfigurationManager.shared.codigoUIAppDelegate.AplicacionID
                    ConfigurationManager.shared.usuarioUIAppDelegate.ProyectoID = ConfigurationManager.shared.codigoUIAppDelegate.ProyectoID
                    
                    self.validSkinOnlinePromise(delegate: nil)
                        .then{ response in
                            
                            delegate?.sendStatus(message: "Skin verificado.", error: "success", isLog: true, isNotification: false)
                            delegate?.sendStatusCompletition(initial: 0, current: 0.16, final: 1)
                            
                            self.validUserOnlinePromise(delegate: nil)
                                .then{ response in
                                    
                                    delegate?.sendStatus(message: "Usuario verificado.", error: "success", isLog: true, isNotification: false)
                                    delegate?.sendStatusCompletition(initial: 0, current: 0.23, final: 1)
                                    
                                    defaults.set("\(ConfigurationManager.shared.licenciaUIAppDelegate.usuario)",             forKey: "licence_user")
                                    
                                    let modeApp = defaults.string(forKey: "mode_app")
                                    switch modeApp {
                                    case "Normal":
                                        defaults.set("Normal",             forKey: "mode_app")
                                        break
                                    case "Kiosco":
                                        defaults.set("Kiosco",             forKey: "mode_app")
                                        break
                                    case "SDK":
                                        defaults.set("SDK",             forKey: "mode_app")
                                        break
                                    case "Licencia":
                                        defaults.set("Licencia",             forKey: "mode_app")
                                        break
                                    default:
                                        // Normal Mode
                                        defaults.set("Licencia",             forKey: "mode_app")
                                        break
                                    }
                                    defaults.synchronize()
                                    ConfigurationManager.shared.plantillaUIAppDelegate.FechaSincronizacionPlantilla = 0
                                    ConfigurationManager.shared.isInitiated = true
                                    // Step 1 Check "PLANTILLAS"
                                    self.validaPlantillasOnlinePromise(delegate: nil)
                                        .then{ response in
                                            
                                            delegate?.sendStatus(message: "Plantilla verificada.", error: "success", isLog: true, isNotification: false)
                                            delegate?.sendStatusCompletition(initial: 0, current: 0.3, final: 1)
                                            
                                            self.validaVariablesOnlinePromise(delegate: nil)
                                                .then { response in
                                                    
                                                    delegate?.sendStatus(message: "Variables verificadas.", error: "success", isLog: true, isNotification: false)
                                                    delegate?.sendStatusCompletition(initial: 0, current: 0.41, final: 1)
                                                    
                                                    self.validFormatosOnlinePromise(delegate: nil)
                                                        .then { response in
                                                            
                                                            delegate?.sendStatus(message: "Formatos verificados.", error: "success", isLog: true, isNotification: false)
                                                            delegate?.sendStatusCompletition(initial: 0, current: 0.78, final: 1)
                                                            
                                                            self.validFlujosAndProcesosPromise(delegate: nil)
                                                                .then { response in
                                                                    delegate?.sendStatus(message: "Ordenado de información correcto.", error: "success", isLog: true, isNotification: false)
                                                                    delegate?.sendStatusCompletition(initial: 0, current: 1, final: 1)
                                                                    resolve(true)
                                                                }
                                                                .catch { error in
                                                                    reject(APIErrorResponse.FlujosAndProcesosOnlineError)
                                                            }
                                                            
                                                        }
                                                        .catch { error in
                                                            reject(APIErrorResponse.FormatosOnlineError)
                                                    }
                                                }
                                                .catch { error in
                                                    reject(APIErrorResponse.VariablesOnlineError)
                                            }
                                        }
                                        .catch{ error in
                                            reject(APIErrorResponse.PlantillasOnlineError)
                                    }
                                    
                                }
                                .catch{ error in
                                    reject(APIErrorResponse.UsuarioOnlineError)
                            }
                            
                        }
                        .catch{ error in
                            reject(APIErrorResponse.SkinOnlineError)
                    }
                    
                }
                .catch{ error in
                    reject(APIErrorResponse.CodigoOnlineError)
            }
            
        }
        
    }
    
}

// MARK: - CODIGO
public extension APIManager{
    
    // MARK: - CheckCodeOnline
    func validCodeOnlinePromise(delegate: Delegate?) -> Promise<AjaxResponse>{
        
        return Promise<AjaxResponse> { resolve, reject in
            
            DispatchQueue.global(qos: .background).async {
                
                let mutableRequest: URLRequest
                do{
                    mutableRequest = try self.request.codigoRequest()
                    let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                        guard data != nil && error == nil else {
                            reject(APIErrorResponse.ServerError)
                            return
                        }
                        do{
                            let doc = try AEXMLDocument(xml: data!)
                            let getCodeResult = doc["s:Envelope"]["s:Body"]["CheckCodigoResponse"]["CheckCodigoResult"].string
                            print("CODE RESPONSE: \(getCodeResult)\n")
                            let response = AjaxResponse(json: getCodeResult)
                            if(response.Success){
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: Exitoso | \(response.Mensaje)\r\n", "log.txt")
                                ConfigurationManager.shared.codigoUIAppDelegate = FECodigo(dictionary: response.ReturnedObject!)
                                ConfigurationManager.shared.utilities.writeLogger("Se ha validado el código.\r\n", "log.txt")
                                self.salvarCodigo(delegate: delegate)
                                resolve(response)
                            }else{
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: Erróneo | \(response.Mensaje)\r\n", "error.txt")
                                reject(APIErrorResponse.ParseError)
                                delegate?.wrongCodeResponse!(message: response.Mensaje)
                                
                            }
                        }catch{
                            reject(APIErrorResponse.ServerError)
                            ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                            reject(APIErrorResponse.XMLError)
                        }
                    })
                    task.resume()
                }catch (let error){
                    ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                    ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                    reject(APIErrorResponse.ServerError)
                }
                
            }
            
        }
        
    }
    
    // MARK: - CheckCodeOffline
    func validCodeOffline(delegate: Delegate?) -> Bool{
        ConfigurationManager.shared.utilities.writeLogger("\r\n-----\r\n Validando Código offline \r\n-----\r\n", "log.txt")
        if(ConfigurationManager.shared.codigoUIAppDelegate.Codigo != "" && ConfigurationManager.shared.codigoUIAppDelegate.Codigo != "default"){
            ConfigurationManager.shared.isCodePresented = true
            /* Checking a the Local Code settings */
            guard let codigoOffline = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.codigos)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)/Codigo.cod") else {
                ConfigurationManager.shared.utilities.writeLogger("No se encontró el archivo del Código.\r\n", "error.txt")
                return false
            }
            // Set Codigo as saved in File
            ConfigurationManager.shared.codigoUIAppDelegate =  FECodigo(json: codigoOffline)
            UserDefaults.standard.set(ConfigurationManager.shared.codigoUIAppDelegate.Codigo, forKey: "codigo_preference")
            UserDefaults.standard.synchronize()
            ConfigurationManager.shared.utilities.writeLogger("El código ha sido almacenado correctamente.\r\n", "log.txt")
            /*
            DispatchQueue.main.async {
                if ConfigurationManager.shared.codigoUIAppDelegate.Codigo == "ABC"{
                    
                }else{
                    self.changeIcon()
                }
                
                
            }*/
            return true
        }
        ConfigurationManager.shared.utilities.writeLogger("No hay un código guardado en las preferencias.\r\n", "error.txt")
        return false
    }
    
    // MARK: - SalvarCodigo
    func salvarCodigo(delegate: Delegate?){
        /*
        DispatchQueue.main.async {
            if ConfigurationManager.shared.codigoUIAppDelegate.Codigo == "ABC"{
                
            }else{
                self.changeIcon()
            }
            
        }*/
        
        ConfigurationManager.shared.utilities.writeLogger("\r\n-----\r\n Salvando Código \r\n-----\r\n", "log.txt")
        let json = JSONSerializer.toJson(ConfigurationManager.shared.codigoUIAppDelegate)
        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.codigos)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)/Codigo.cod", withContent: json as NSObject, overwrite: true)
        UserDefaults.standard.set(ConfigurationManager.shared.codigoUIAppDelegate.Codigo, forKey: "codigo_preference")
        UserDefaults.standard.synchronize()
        // Function to reasing the value (FILES IN MB) in the Settings Bundle
        ConfigurationManager.shared.utilities.refreshFolderCapacity()
        // IN this API we can override de Skin validation, we need to add this feature
    }
    
    /*func changeIcon(){
        // Change Icon Disabled by Mariela - Jonathan
        if !ConfigurationManager.shared.isConsubanco{
         switch ConfigurationManager.shared.codigoUIAppDelegate.Codigo {
         case "ABC":
         if UIApplication.shared.supportsAlternateIcons == false {
         return
         }
         
         UIApplication.shared.setAlternateIconName("DIGI", completionHandler: { error in
         
         })
         case "CSBPRO":
         if UIApplication.shared.supportsAlternateIcons == false {
         return
         }
         
         UIApplication.shared.setAlternateIconName("CSB", completionHandler: { error in
         
         
         })
         default:
         if UIApplication.shared.supportsAlternateIcons == false {
         return
         }
         
         UIApplication.shared.setAlternateIconName("DIGI", completionHandler: { error in
         
         
         })
         }
         }
        
    }*/
    
}

// MARK: - SKIN
public extension APIManager{
    
    // MARK: - CheckSkinOnline
    func validSkinOnlinePromise(delegate: Delegate?) -> Promise<AjaxResponse>{
        
        return Promise<AjaxResponse>{ resolve, reject in
            
            DispatchQueue.global(qos: .background).async {
                
                let mutableRequest: URLRequest
                do{
                    mutableRequest = try self.request.skinRequest()
                    let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                        guard data != nil && error == nil else {
                            reject(APIErrorResponse.ServerError)
                            return
                        }
                        do{
                            let doc = try AEXMLDocument(xml: data!)
                            let getCodeResult = doc["s:Envelope"]["s:Body"]["ObtieneSkinResponse"]["ObtieneSkinResult"].string
                            let bodyData = Data(base64Encoded: getCodeResult)!
                            let decompressedData: Data
                            if bodyData.isGzipped {
                                decompressedData = try! bodyData.gunzipped()
                            } else {
                                decompressedData = bodyData
                            }
                            let decodedString = String(data: decompressedData, encoding: .utf8)!
                            let response = AjaxResponse(json: decodedString)
                            if(response.Success){
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                                if (response.ReturnedObject != nil) {
                                    var toolbarTexto = response.ReturnedObject!.value(forKeyPath: "ToolBarColorTexto") ?? ""
                                    toolbarTexto = (toolbarTexto as! String).replacingOccurrences(of: "#", with: "")
                                    var toolbarColor = response.ReturnedObject!.value(forKeyPath: "ToolBarColor") ?? ""
                                    toolbarColor = (toolbarColor as! String).replacingOccurrences(of: "#", with: "")
                                    ConfigurationManager.shared.skinUIAppDelegate = FEAppSkin(dictionary: response.ReturnedObject!)
                                    ConfigurationManager.shared.skinUIAppDelegate.ToolBarColor = toolbarColor as! String
                                    ConfigurationManager.shared.skinUIAppDelegate.ToolBarColorTexto = toolbarTexto as! String
                                    ConfigurationManager.shared.utilities.writeLogger("Se ha validado el skin.\r\n", "log.txt")
                                    self.salvarSkin(delegate: delegate)
                                    resolve(response)
                                }else{
                                    ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                                    ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                                    resolve(response)
                                }
                            }else{
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                                reject(APIErrorResponse.XMLError)
                            }
                        }catch{
                            ConfigurationManager.shared.utilities.writeLogger("Error al obtener el XML.\r\n", "error.txt")
                            reject(APIErrorResponse.XMLError)
                        }
                        
                    })
                    task.resume()
                }catch (let error){
                    ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                    ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                    reject(APIErrorResponse.ServerError)
                }
                
            }
            
        }
        
    }
    
    // MARK: - CheckSkinOffline
    func validSkinOffline(delegate: Delegate?) -> Bool{
        ConfigurationManager.shared.utilities.writeLogger("\r\n-----\r\n Validando Skin offline \r\n-----\r\n", "log.txt")
        
        if(ConfigurationManager.shared.codigoUIAppDelegate.Codigo != "" && ConfigurationManager.shared.codigoUIAppDelegate.Codigo != "default"){
            ConfigurationManager.shared.isCodePresented = true
            /* Checking a the Local Code settings */
            guard let skinOffline = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.codigos)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)/Skin.ski") else {
                ConfigurationManager.shared.utilities.writeLogger("No se encontró el archivo del Skin.\r\n", "error.txt")
                return false
            }
            // Set Codigo as saved in File
            ConfigurationManager.shared.skinUIAppDelegate =  FEAppSkin(json: skinOffline)
            ConfigurationManager.shared.utilities.writeLogger("El skin ha sido almacenado correctamente.\r\n", "log.txt")
            return true
        }
        ConfigurationManager.shared.utilities.writeLogger("No hay un skin guardado en las preferencias.\r\n", "error.txt")
        return false
    }
    
    // MARK: - SalvarSkin
    func salvarSkin(delegate: Delegate?){
        ConfigurationManager.shared.utilities.writeLogger("\r\n-----\r\n Salvando Skin \r\n-----\r\n", "log.txt")
        let json = JSONSerializer.toJson(ConfigurationManager.shared.skinUIAppDelegate)
        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.codigos)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)/Skin.ski", withContent: json as NSObject, overwrite: true)
        // Function to reasing the value (FILES IN MB) in the Settings Bundle
        ConfigurationManager.shared.utilities.refreshFolderCapacity()
    }
    
}

// MARK: - Usuario
public extension APIManager{
    
    // MARK: - CheckUserOnline
    func validUserOnlinePromise(delegate: Delegate?) -> Promise<AjaxResponse>{
        
        return Promise<AjaxResponse>{ resolve, reject in
            
            DispatchQueue.global(qos: .background).async {
                
                let mutableRequest: URLRequest
                do{
                    mutableRequest = try self.request.usuarioRequest()
                    let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                        guard data != nil && error == nil else {
                            reject(APIErrorResponse.ServerError)
                            return
                        }
                        do{
                            let doc = try AEXMLDocument(xml: data!)
                            let getCodeResult = doc["s:Envelope"]["s:Body"]["LoginResponse"]["LoginResult"].string
                            let bodyData = Data(base64Encoded: getCodeResult)!
                            let decompressedData: Data
                            if bodyData.isGzipped {
                                decompressedData = try! bodyData.gunzipped()
                            } else {
                                decompressedData = bodyData
                            }
                            let decodedString = String(data: decompressedData, encoding: .utf8)!
                            let response = AjaxResponse(json: decodedString)
                            if(response.Success){
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                                ConfigurationManager.shared.usuarioUIAppDelegate = FEUsuario(dictionary: response.ReturnedObject!)
                                ConfigurationManager.shared.utilities.writeLogger("Se ha validado el usuario.\r\n", "log.txt")
                                self.salvarUsuario(delegate: delegate)
                                resolve(response)
                            }else{
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                                reject(APIErrorResponse.XMLError)
                            }
                        }catch{
                            ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                            reject(APIErrorResponse.XMLError)
                        }
                        
                    })
                    task.resume()
                }catch (let error){
                    ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                    ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                    reject(APIErrorResponse.ServerError)
                }
                
            }
            
        }
        
    }
    
    // MARK: - CheckUserOffline
    func validUserOffline(delegate: Delegate?) -> Bool{
        ConfigurationManager.shared.utilities.writeLogger("\r\n-----\r\n Validando Usuario offline \r\n-----\r\n", "log.txt")
        if(ConfigurationManager.shared.codigoUIAppDelegate.Codigo != "" && ConfigurationManager.shared.codigoUIAppDelegate.Codigo != "default" && ConfigurationManager.shared.usuarioUIAppDelegate.User != ""){
            ConfigurationManager.shared.isCodePresented = true
            /* Checking a the Local Code settings */
            guard let usuarioOffline = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Usuario.usu") else {
                ConfigurationManager.shared.utilities.writeLogger("No se encontró el archivo del Usuario.\r\n", "error.txt")
                return false
            }
            // Set Codigo as saved in File
            let localUser = FEUsuario(json: usuarioOffline)
            if ConfigurationManager.shared.usuarioUIAppDelegate.Password != localUser.Password || ConfigurationManager.shared.usuarioUIAppDelegate.User != localUser.User{
                return false
            }
            ConfigurationManager.shared.usuarioUIAppDelegate =  FEUsuario(json: usuarioOffline)
            UserDefaults.standard.set(ConfigurationManager.shared.usuarioUIAppDelegate.User, forKey: "usuario_preference")
            UserDefaults.standard.synchronize()
            ConfigurationManager.shared.utilities.writeLogger("El usuario ha sido almacenado correctamente.\r\n", "log.txt")
            return true
        }
        ConfigurationManager.shared.utilities.writeLogger("No hay un usuario guardado en las preferencias.\r\n", "error.txt")
        
        return false
    }
    
    // MARK: - CheckConsultasOffline
    func validConsultasOffline(delegate: Delegate?) -> Bool{
        
        ConfigurationManager.shared.utilities.writeLogger("\r\n-----\r\n Validando Consultas offline \r\n-----\r\n", "log.txt")
        if(ConfigurationManager.shared.codigoUIAppDelegate.Codigo != "" && ConfigurationManager.shared.codigoUIAppDelegate.Codigo != "default" && ConfigurationManager.shared.usuarioUIAppDelegate.User != ""){
            
            guard var consultasOffline = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Consultas.cons") else {
                ConfigurationManager.shared.utilities.writeLogger("No se encontró el archivo de las Consultas.\r\n", "error.txt")
                return false
            }
            
            // Set Codigo as saved in File
            consultasOffline = consultasOffline.replacingOccurrences(of: "\\\"", with: "\"")
            ConfigurationManager.shared.consultasUIAppDelegate = [FETipoReporte](json: consultasOffline)
            ConfigurationManager.shared.utilities.writeLogger("Las consultas han sido almacenadas correctamente.\r\n", "log.txt")
            return true
        }
        ConfigurationManager.shared.utilities.writeLogger("No hay un usuario guardado en las preferencias.\r\n", "error.txt")
        
        return false
        
    }
    
    // MARK: - SalvarUser
    func salvarUsuario(delegate: Delegate?){
        ConfigurationManager.shared.utilities.writeLogger("\r\n-----\r\n Salvando Usuario \r\n-----\r\n", "log.txt")
        
        // Lets save first Consultas
        let dummyUsuario = ConfigurationManager.shared.usuarioUIAppDelegate
        var consultas = JSONSerializer.toJson(dummyUsuario.Consultas)
        consultas = consultas.replacingOccurrences(of: "\\w", with: "*")
        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Consultas.cons", withContent: consultas as NSObject, overwrite: true)
        dummyUsuario.Consultas = [FETipoReporte]()
        let json = JSONSerializer.toJson(dummyUsuario)
        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Usuario.usu", withContent: json as NSObject, overwrite: true)
        UserDefaults.standard.set(ConfigurationManager.shared.usuarioUIAppDelegate.User, forKey: "usuario_preference")
        UserDefaults.standard.synchronize()
        // Function to reasing the value (FILES IN MB) in the Settings Bundle
        ConfigurationManager.shared.utilities.refreshFolderCapacity()
    }
    
    // MARK: - CambiarContraseña
    func cambiarUserContraseniaPromise(delegate: Delegate?) -> Promise<AjaxResponse>{
        
        return Promise<AjaxResponse>{ resolve, reject in
            
            DispatchQueue.global(qos: .background).async {
                
                let mutableRequest: URLRequest
                do{
                    mutableRequest = try self.request.cambiarContraseniaRequest()
                    let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                        guard data != nil && error == nil else {
                            reject(APIErrorResponse.ServerError)
                            return
                        }
                        do{
                            let doc = try AEXMLDocument(xml: data!)
                            let getCodeResult = doc["s:Envelope"]["s:Body"]["CambiarPasswordResponse"]["CambiarPasswordResult"].string
                            let bodyData = Data(base64Encoded: getCodeResult)!
                            let decompressedData: Data
                            if bodyData.isGzipped {
                                decompressedData = try! bodyData.gunzipped()
                            } else {
                                decompressedData = bodyData
                            }
                            let decodedString = String(data: decompressedData, encoding: .utf8)!
                            let response = AjaxResponse(json: decodedString)
                            if(response.Success){
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                                ConfigurationManager.shared.usuarioUIAppDelegate = FEUsuario(dictionary: response.ReturnedObject!)
                                ConfigurationManager.shared.utilities.writeLogger("Se ha validado el usuario.\r\n", "log.txt")
                                self.salvarUsuario(delegate: delegate)
                                resolve(response)
                            }else{
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                                delegate?.wrongPasswordResponse!(message: response.Mensaje)
                                reject(APIErrorResponse.XMLError)
                            }
                        }catch{
                            ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                            reject(APIErrorResponse.XMLError)
                        }
                        
                    })
                    task.resume()
                }catch (let error){
                    ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                    ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                    reject(APIErrorResponse.ServerError)
                }
                
            }
            
        }
        
    }
    
}

// MARK: - Registro
public extension APIManager{
    
    func validRegistroOnlinePromise(delegate: Delegate?) -> Promise<AjaxResponse>{
        
        return Promise<AjaxResponse>{ resolve, reject in
            
            DispatchQueue.global(qos: .background).async {
                
                let mutableRequest: URLRequest
                do{
                    mutableRequest = try self.request.registroRequest()
                    let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                        guard data != nil && error == nil else {
                            reject(APIErrorResponse.ServerError)
                            return
                        }
                        do{
                            let doc = try AEXMLDocument(xml: data!)
                            let getCodeResult = doc["s:Envelope"]["s:Body"]["RegistroResponse"]["RegistroResult"].string
                            let bodyData = Data(base64Encoded: getCodeResult)!
                            let decompressedData: Data
                            if bodyData.isGzipped {
                                decompressedData = try! bodyData.gunzipped()
                            } else {
                                decompressedData = bodyData
                            }
                            let decodedString = String(data: decompressedData, encoding: .utf8)!
                            let response = AjaxResponse(json: decodedString)
                            if(response.Success){
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                                ConfigurationManager.shared.registroUIAppDelegate = FERegistro(dictionary: response.ReturnedObject!)
                                ConfigurationManager.shared.utilities.writeLogger("Se ha validado el registro del usuario.\r\n", "log.txt")
                                self.salvarRegistro(delegate: delegate)
                                resolve(response)
                            }else{
                                if response.Mensaje.contains("Ya existe otro usuario con es nombre"){
                                    reject(APIErrorResponse.RegistroRegistradoOnlineError)
                                }else{
                                    reject(APIErrorResponse.RegistroOnlineError)
                                }
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                            }
                        }catch{
                            ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                            reject(APIErrorResponse.RegistroOnlineError)
                        }
                    })
                    task.resume()
                }catch (let error){
                    ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                    ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                    reject(APIErrorResponse.RegistroOnlineError)
                }
                
            }
            
        }
        
    }
    
    func validRegistroOffline(delegate: Delegate?) -> Bool{
        ConfigurationManager.shared.utilities.writeLogger("Validando el registro offline.\r\n", "log.txt")
        
        if(ConfigurationManager.shared.codigoUIAppDelegate.Codigo != "" && ConfigurationManager.shared.codigoUIAppDelegate.Codigo != "default" && ConfigurationManager.shared.usuarioUIAppDelegate.User != ""){
            ConfigurationManager.shared.isCodePresented = true
            /* Checking a the Local Code settings */
            guard let usuarioOffline = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Registro.reg") else {
                ConfigurationManager.shared.utilities.writeLogger("No se encontró el archivo del Registro.\r\n", "error.txt")
                return false
            }
            // Set Codigo as saved in File
            let localUser = FERegistro(json: usuarioOffline)
            if ConfigurationManager.shared.usuarioUIAppDelegate.Password != localUser.Password || ConfigurationManager.shared.usuarioUIAppDelegate.User != localUser.User{
                return false
            }
            ConfigurationManager.shared.registroUIAppDelegate =  FERegistro(json: usuarioOffline)
            UserDefaults.standard.set(ConfigurationManager.shared.usuarioUIAppDelegate.User, forKey: "usuario_preference")
            UserDefaults.standard.synchronize()
            ConfigurationManager.shared.utilities.writeLogger("El usuario ha sido almacenado correctamente.\r\n", "log.txt")
            return true
        }
        ConfigurationManager.shared.utilities.writeLogger("No hay un usuario guardado en las preferencias.\r\n", "error.txt")
        
        return false
    }
    
    func salvarRegistro(delegate: Delegate?){
        ConfigurationManager.shared.utilities.writeLogger("\r\n-----\r\n Salvando Registro \r\n-----\r\n", "log.txt")
        
        let json = JSONSerializer.toJson(ConfigurationManager.shared.registroUIAppDelegate)
        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)/Registro.reg", withContent: json as NSObject, overwrite: true)
        ConfigurationManager.shared.utilities.refreshFolderCapacity()
        
        self.salvarKeychain(account: ConfigurationManager.shared.registroUIAppDelegate.Email, password: ConfigurationManager.shared.registroUIAppDelegate.Password)
    }
    
    func activeRegistroPromise(delegate: Delegate?) -> Promise<AjaxResponse>{
        
        return Promise<AjaxResponse>{ resolve, reject in
            
            DispatchQueue.global(qos: .background).async {
                
                let mutableRequest: URLRequest
                do{
                    mutableRequest = try self.request.activarRegistroRequest()
                    let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                        guard data != nil && error == nil else {
                            reject(APIErrorResponse.ServerError)
                            return
                        }
                        do{
                            let doc = try AEXMLDocument(xml: data!)
                            let getCodeResult = doc["s:Envelope"]["s:Body"]["ActivarRegistroResponse"]["ActivarRegistroResult"].string
                            let bodyData = Data(base64Encoded: getCodeResult)!
                            let decompressedData: Data
                            if bodyData.isGzipped {
                                decompressedData = try! bodyData.gunzipped()
                            } else {
                                decompressedData = bodyData
                            }
                            let decodedString = String(data: decompressedData, encoding: .utf8)!
                            let response = AjaxResponse(json: decodedString)
                            if(response.Success){
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                                ConfigurationManager.shared.registroUIAppDelegate = FERegistro(dictionary: response.ReturnedObject!)
                                ConfigurationManager.shared.utilities.writeLogger("Se ha validado el registro del usuario.\r\n", "log.txt")
                                resolve(response)
                            }else{
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                                reject(APIErrorResponse.RegistroOnlineError)
                            }
                        }catch{
                            ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                            reject(APIErrorResponse.RegistroOnlineError)
                        }
                    })
                    task.resume()
                }catch (let error){
                    ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                    ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                    reject(APIErrorResponse.RegistroOnlineError)
                }
                
            }
            
        }
        
    }
    
    func salvarKeychain(account: String, password: String){
        // Setting Keychain
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: account, accessGroup: KeychainConfiguration.accessGroup)
        // Save the password for the new item.
        do{
            try passwordItem.savePassword(password)
        }catch{
            NSLog("Error")
        }
        
    }
    
    func borrarKeychain(account: String) -> Bool{
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: account, accessGroup: KeychainConfiguration.accessGroup)
        do{
            try passwordItem.deleteItem()
            return true
        }catch{
            return false
        }
    }
    
    func obtenerKeychain(account: String) -> String{
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: account, accessGroup: KeychainConfiguration.accessGroup)
        var pass: String?
        do{
            pass = try passwordItem.readPassword()
        }catch{
            NSLog("Error")
        }
        return pass ?? ""
    }
    
    func validarKeychain(account: String, password: String) -> Bool{
        let keychainpass = obtenerKeychain(account: account)
        if keychainpass == password{
            return true
        }else{
            return false
        }
    }
    
}

// MARK: - Plantillas
public extension APIManager{
    
    func validaPlantillasOnlinePromise(delegate: Delegate?) -> Promise<AjaxResponse>{
        
        return Promise<AjaxResponse>{ resolve, reject in
            
            DispatchQueue.global(qos: .background).async {
                
                ConfigurationManager.shared.plantillaUIAppDelegate.ListPlantillasPermiso = self.validPlantillasOffline()
                ConfigurationManager.shared.plantillaUIAppDelegate.User = ConfigurationManager.shared.usuarioUIAppDelegate.User
                ConfigurationManager.shared.plantillaUIAppDelegate.ProyectoID = ConfigurationManager.shared.codigoUIAppDelegate.ProyectoID
                ConfigurationManager.shared.plantillaUIAppDelegate.AplicacionID = ConfigurationManager.shared.codigoUIAppDelegate.AplicacionID
                
                let mutableRequest: URLRequest
                
                DispatchQueue.main.async {
                    delegate?.didSendResponseHUD(message: "Descargando información", error: errorType.dflt.rawValue, porcentage: 0)
                }
                do{
                    mutableRequest = try self.request.plantillasRequest()
                    
                    let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                        guard data != nil && error == nil else {
                            reject(APIErrorResponse.ServerError)
                            return
                        }
                        do{
                            let doc = try AEXMLDocument(xml: data!)
                            let getCodeResult = doc["s:Envelope"]["s:Body"]["ObtienePlantillasResponse"]["ObtienePlantillasResult"].string
                            let bodyData = Data(base64Encoded: getCodeResult)!
                            let decompressedData: Data
                            if bodyData.isGzipped {
                                decompressedData = try! bodyData.gunzipped()
                            } else {
                                decompressedData = bodyData
                            }
                            let decodedString = String(data: decompressedData, encoding: .utf8)!
                            let response = AjaxResponse(json: decodedString)
                            if(response.Success){
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                                
                                let SANDBOX_Plantilla = FEConsultaPlantilla(dictionary: response.ReturnedObject!)
                                let listPlantillasData = SANDBOX_Plantilla.ListPlantillas as [FEPlantillaData]
                                var fullPlantillasMin = [FEPlantillaMerge]()
                                
                                DispatchQueue.main.async {
                                    delegate?.didSendResponseHUD(message: "Descargando catálogos", error: errorType.dflt.rawValue, porcentage: 0)
                                }
                                
                                if listPlantillasData.count > 0{
                                    /* Creando Objetos JSON de los Catalogos */
                                    let listCatalogos = SANDBOX_Plantilla.ListCatalogos as [FEItemCatalogoEsquema]
                                    if listCatalogos.count > 0{
                                        // Deleting old data
                                        //FCFileManager.removeItem(atPath: "Digipro/Codigos/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)/Catalogos")
                                        
                                        var counter = 1
                                        for esquema in listCatalogos{
                                            let formula = ((counter * 50) / listCatalogos.count)
                                            let cod = esquema.TipoCatalogoID
                                            for catalogo in esquema.Catalogo{
                                                catalogo.Json = catalogo.Json.replacingOccurrences(of: "\"", with: "|")
                                            }
                                            esquema.Esquema = esquema.Esquema.replacingOccurrences(of: "\"", with: "|")
                                            let json = JSONSerializer.toJson(esquema)
                                            let jsonModify = json.replacingOccurrences(of: "|", with: "\\\"")
                                            FCFileManager.createFile(atPath: "\(Cnstnt.Tree.codigos)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)/\(Cnstnt.Tree.catalogos)/\(cod).cat", withContent: jsonModify as NSObject, overwrite: true)
                                            ConfigurationManager.shared.utilities.writeLogger("Guardando catálogos\r\n", "log.txt")
                                            DispatchQueue.main.async {
                                                delegate?.didSendResponseHUD(message: "Guardando catálogo \(counter) de \(listCatalogos.count)", error: errorType.dflt.rawValue, porcentage: formula)
                                            }
                                            counter += 1
                                        }
                                    }
                                    
                                    /* Creando Objetos JSON de las Plantillas */
                                    DispatchQueue.main.async() {
                                        delegate?.didSendResponseHUD(message: "Descargando \(listPlantillasData.count) Plantilla(s)", error: errorType.dflt.rawValue, porcentage: 50)
                                    }
                                    
                                    if listPlantillasData.count > 0{
                                        // Deleting old data
                                        //FCFileManager.removeItem(atPath: "Digipro/Usuarios/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Plantillas")
                                        //FCFileManager.removeItem(atPath: "Digipro/Usuarios/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Plantilla.pla")
                                        //FCFileManager.removeItem(atPath: "Digipro/Usuarios/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Plantillas.pla")
                                        
                                        for plantillasData in listPlantillasData{
                                            var json = JSONSerializer.toJson(plantillasData)
                                            FCFileManager.createFile(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.plantillas)/\(plantillasData.FlujoID)/\(plantillasData.ExpID)_\(plantillasData.TipoDocID)/\(plantillasData.ExpID)_\(plantillasData.TipoDocID).xml", withContent: plantillasData.XmlPlantilla as NSObject, overwrite: true)
                                            
                                            // Getting Rules
                                            do {
                                                let xmlDoc = try AEXMLDocument(xml: plantillasData.XmlPlantilla)
                                                
                                                // Detect if we have any rules
                                                if xmlDoc.root.children[0]["reglas"].children.count > 0{
                                                    // Saving Rules in file
                                                    FCFileManager.createFile(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.plantillas)/\(plantillasData.FlujoID)/\(plantillasData.ExpID)_\(plantillasData.TipoDocID)/\(plantillasData.ExpID)_\(plantillasData.TipoDocID).rls", withContent: xmlDoc.root.children[0]["reglas"].xml as NSObject, overwrite: true)
                                                }else{ FCFileManager.removeItem(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.plantillas)/\(plantillasData.FlujoID)/\(plantillasData.ExpID)_\(plantillasData.TipoDocID)/\(plantillasData.ExpID)_\(plantillasData.TipoDocID).rls") }
                                                
                                                // Detect if we have any services
                                                if xmlDoc.root.children[0]["servicios"].children.count > 0{
                                                    // Saving Rules in file
                                                    FCFileManager.createFile(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.plantillas)/\(plantillasData.FlujoID)/\(plantillasData.ExpID)_\(plantillasData.TipoDocID)/\(plantillasData.ExpID)_\(plantillasData.TipoDocID).srv", withContent: xmlDoc.root.children[0]["servicios"].xml as NSObject, overwrite: true)
                                                }else{ FCFileManager.removeItem(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.plantillas)/\(plantillasData.FlujoID)/\(plantillasData.ExpID)_\(plantillasData.TipoDocID)/\(plantillasData.ExpID)_\(plantillasData.TipoDocID).srv") }
                                                
                                                // Detect if we have any components
                                                if xmlDoc.root.children[0]["components"].children.count > 0{
                                                    // Saving Rules in file
                                                    FCFileManager.createFile(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.plantillas)/\(plantillasData.FlujoID)/\(plantillasData.ExpID)_\(plantillasData.TipoDocID)/\(plantillasData.ExpID)_\(plantillasData.TipoDocID).cmp", withContent: xmlDoc.root.children[0]["components"].xml as NSObject, overwrite: true)
                                                }else{ FCFileManager.removeItem(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.plantillas)/\(plantillasData.FlujoID)/\(plantillasData.ExpID)_\(plantillasData.TipoDocID)/\(plantillasData.ExpID)_\(plantillasData.TipoDocID).cmp") }
                                                
                                                // Detect if we have any mathematics
                                                if xmlDoc.root.children[0]["operacionesmatematicas"].children.count > 0{
                                                    // Saving Rules in file
                                                    FCFileManager.createFile(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.plantillas)/\(plantillasData.FlujoID)/\(plantillasData.ExpID)_\(plantillasData.TipoDocID)/\(plantillasData.ExpID)_\(plantillasData.TipoDocID).mat", withContent: xmlDoc.root.children[0]["operacionesmatematicas"].xml as NSObject, overwrite: true)
                                                }else{ FCFileManager.removeItem(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.plantillas)/\(plantillasData.FlujoID)/\(plantillasData.ExpID)_\(plantillasData.TipoDocID)/\(plantillasData.ExpID)_\(plantillasData.TipoDocID).mat") }
                                                
                                            } catch { print("\(error)") }
                                            
                                            plantillasData.XmlPlantilla = ""
                                            json = JSONSerializer.toJson(plantillasData)
                                            FCFileManager.createFile(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.plantillas)/\(plantillasData.FlujoID)/\(plantillasData.ExpID)_\(plantillasData.TipoDocID)/\(plantillasData.ExpID)_\(plantillasData.TipoDocID).pla", withContent: json as NSObject, overwrite: true)
                                        }
                                        
                                        // Settings Plantillas Data Merge
                                        let mainFolders = FCFileManager.listDirectoriesInDirectory(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.plantillas)/")
                                        
                                        for mainFolder in mainFolders!{
                                            let flujoFolderPath = mainFolder as! String
                                            let flujoFolder = flujoFolderPath.split{$0 == "/"}.map(String.init)
                                            
                                            let subFolders = FCFileManager.listDirectoriesInDirectory(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.plantillas)/\(flujoFolder.last!)/")
                                            
                                            for subFolder in subFolders!{
                                                let flujoSubfolderPath = subFolder as! String
                                                let flujoSubfolder = flujoSubfolderPath.split{$0 == "/"}.map(String.init)
                                                
                                                let flujoInfo = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.plantillas)/\(flujoFolder.last!)/\(flujoSubfolder.last!)/\(flujoSubfolder.last!).pla")
                                                let plantillaData = FEPlantillaData(json: flujoInfo)
                                                
                                                // Getting and retriving all data from plantillas
                                                let minData = FEPlantillaMerge()
                                                minData.ExpID = plantillaData.ExpID
                                                minData.FechaActualizacion = plantillaData.FechaActualizacion
                                                minData.FlujoID = plantillaData.FlujoID
                                                minData.NombreFlujo = plantillaData.NombreFlujo
                                                minData.TipoDocID = plantillaData.TipoDocID
                                                minData.MostrarExp = plantillaData.MostrarExp
                                                minData.MostrarTipoDoc = plantillaData.MostrarTipoDoc
                                                
                                                for file in subFolders!{
                                                    let flujoSubfolderPath = file as! String
                                                    let flujoSubfolder = flujoSubfolderPath.split{$0 == "/"}.map(String.init)
                                                    let eD = flujoSubfolder.last!.components(separatedBy: "_")
                                                    let expDoc = FEExpDoc()
                                                    expDoc.expediente = eD.first!
                                                    expDoc.documento = eD.last!
                                                    minData.ExpDoc.append(expDoc)
                                                }
                                                
                                                minData.Procesos.append("0")
                                                let proceso = FEProcesos()
                                                proceso.FlujoID = minData.FlujoID
                                                proceso.NombreProceso = "Documentos locales"
                                                proceso.PIID = 0
                                                minData.PProcesos.append(proceso)
                                                
                                                for evento in plantillaData.EventosTareas{
                                                    if evento.ProcesoID == 18{
                                                        
                                                        if !minData.Procesos.contains(String(evento.PIID)){
                                                            minData.Procesos.append("\(evento.PIID)")
                                                            let proceso = FEProcesos()
                                                            proceso.FlujoID = evento.FlujoID
                                                            proceso.NombreProceso = evento.NombreProceso
                                                            proceso.PIID = evento.PIID
                                                            minData.PProcesos.append(proceso)
                                                        }
                                                        
                                                    }
                                                }
                                                fullPlantillasMin.append(minData)
                                            }
                                        }
                                        let json = JSONSerializer.toJson(fullPlantillasMin)
                                        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Plantillas.pla", withContent: json as NSObject, overwrite: true)
                                        
                                        SANDBOX_Plantilla.ListCatalogos = Array<FEItemCatalogoEsquema>()
                                        SANDBOX_Plantilla.ListPlantillas = Array<FEPlantillaData>()
                                        SANDBOX_Plantilla.ListPlantillasPermiso = Array<FEPlantillaData>()
                                        
                                        ConfigurationManager.shared.plantillaUIAppDelegate = SANDBOX_Plantilla
                                        ConfigurationManager.shared.plantillaUIAppDelegate.FechaSincronizacionPlantilla = SANDBOX_Plantilla.FechaSincronizacionPlantilla
                                        ConfigurationManager.shared.utilities.writeLogger("Guardando plantillas\r\n", "log.txt")
                                    }
                                    
                                    DispatchQueue.main.async {
                                        delegate?.didSendResponseHUD(message: "Descargando plantillas", error: errorType.dflt.rawValue, porcentage: 99)
                                    }
                                    
                                    ConfigurationManager.shared.utilities.writeLogger("Se ha validado la plantilla\r\n", "log.txt")
                                    self.salvarPlantilla(delegate: delegate)
                                    resolve(response)
                                }else{
                                    ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                                    ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                                    reject(APIErrorResponse.XMLError)
                                }
                            }else{
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                                reject(APIErrorResponse.XMLError)
                            }
                        }catch{
                            ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                            reject(APIErrorResponse.XMLError)
                        }
                        
                    })
                    task.resume()
                }catch (let error){
                    ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                    ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                    reject(APIErrorResponse.ServerError)
                }
                
            }
            
        }
                
    }
    
    func getPlantillasBySections(_ flujo: String) -> Array<(String, Array<FEPlantillaData>)>{
        let folders = FCFileManager.listDirectoriesInDirectory(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.plantillas)/\(flujo)/")
        var plantillas = Array<(String, Array<FEPlantillaData>)>()
        var nombreFlujo = ""
        var pln = Array<FEPlantillaData>()
        for subFolders in folders!{
            let subFolder = FCFileManager.listFilesInDirectory(atPath: subFolders as? String, deep: true)
            for file in subFolder!{
                let archive = file as! NSString
                let pathExtention = archive.pathExtension
                if(pathExtention == "pla"){
                    let gettingXml = FCFileManager.readFileAtPath(as: file as? String)
                    let plantilla = FEPlantillaData(json: gettingXml)
                    nombreFlujo = plantilla.NombreFlujo
                    pln.append(plantilla)
                }
            }
        }
        plantillas.append((nombreFlujo, pln))
        return plantillas
    }
    
    func validPlantillasOffline() -> Array<FEPlantillaData>{
        ConfigurationManager.shared.utilities.writeLogger("\r\n-----\r\n Validando Plantilla offline \r\n-----\r\n", "log.txt")
        let folders = FCFileManager.listFilesInDirectory(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.plantillas)/", deep: true)
        
        var arrayFilesPlantillas = Array<String>()
        var arrayPlantillaData = Array<FEPlantillaData>()
        for files in folders!{
            let file = files as! NSString
            let pathExtention = file.pathExtension
            //let pathPrefix = file.deletingPathExtension
            if(pathExtention == "pla"){
                arrayFilesPlantillas.append(files as! String)
                let gettingXml = FCFileManager.readFileAtPath(as: files as? String)
                let plantilla = FEPlantillaData(json: gettingXml)
                arrayPlantillaData.append(plantilla)
            }
        }
        if arrayPlantillaData.count > 0{
            ConfigurationManager.shared.utilities.writeLogger("Se encontraron \(arrayPlantillaData.count) plantilla(s).\r\n", "log.txt")
        }else{
            ConfigurationManager.shared.utilities.writeLogger("No se encontraron plantillas guardadas.\r\n", "error.txt")
        }
        return arrayPlantillaData
    }
    
    func getPlantillas() -> Array<FEPlantillaData>{
        
        ConfigurationManager.shared.utilities.writeLogger("\r\n-----\r\n Validando Plantilla offline \r\n-----\r\n", "log.txt")
        let folders = FCFileManager.listFilesInDirectory(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.plantillas)/")
        var sectionsPlantilla = Array<String>()
        var arrayPlantillaData = Array<FEPlantillaData>()
        for files in folders!{
            let file = files as! NSString
            let pathExtention = file.pathExtension
            //let pathPrefix = file.deletingPathExtension
            if(pathExtention == "pla"){
                let gettingXml = FCFileManager.readFileAtPath(as: files as? String)
                let plantilla = FEPlantillaData(json: gettingXml)
                if !sectionsPlantilla.contains(plantilla.NombreFlujo){
                    sectionsPlantilla.append(plantilla.NombreFlujo)
                }
                arrayPlantillaData.append(plantilla)
            }
        }
        return arrayPlantillaData
    }
    
    func salvarPlantilla(delegate: Delegate?){
        ConfigurationManager.shared.utilities.writeLogger("\r\n-----\r\n Salvando Plantilla \r\n-----\r\n", "log.txt")
        let json = JSONSerializer.toJson(ConfigurationManager.shared.plantillaUIAppDelegate)
        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Plantilla.pla", withContent: json as NSObject, overwrite: true)
        // Function to reasing the value (FILES IN MB) in the Settings Bundle
        ConfigurationManager.shared.utilities.refreshFolderCapacity()
    }
    
}

// MARK: - Variables
public extension APIManager{
    
    func validaVariablesOnlinePromise(delegate: Delegate?) -> Promise<AjaxResponse>{
        
        return Promise<AjaxResponse>{ resolve, reject in
            
            DispatchQueue.global(qos: .background).async {
                
                ConfigurationManager.shared.variablesUIAppDelegate.Password = ConfigurationManager.shared.usuarioUIAppDelegate.Password
                ConfigurationManager.shared.variablesUIAppDelegate.User = ConfigurationManager.shared.usuarioUIAppDelegate.User
                ConfigurationManager.shared.variablesUIAppDelegate.ProyectoID = ConfigurationManager.shared.codigoUIAppDelegate.ProyectoID
                ConfigurationManager.shared.variablesUIAppDelegate.AplicacionID = ConfigurationManager.shared.codigoUIAppDelegate.AplicacionID
                ConfigurationManager.shared.variablesUIAppDelegate.IP = ConfigurationManager.shared.utilities.getIPAddress()
                
                let mutableRequest: URLRequest
                
                DispatchQueue.main.async {
                    delegate?.didSendResponseHUD(message: "Descargando información", error: errorType.dflt.rawValue, porcentage: 0)
                }
                
                do{
                    mutableRequest = try self.request.variablesRequest()
                    
                    let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                        guard data != nil && error == nil else {
                            reject(APIErrorResponse.ServerError)
                            return
                        }
                        do{
                            let doc = try AEXMLDocument(xml: data!)
                            let getCodeResult = doc["s:Envelope"]["s:Body"]["ObtieneVariablesResponse"]["ObtieneVariablesResult"].string
                            let bodyData = Data(base64Encoded: getCodeResult)!
                            let decompressedData: Data
                            if bodyData.isGzipped {
                                decompressedData = try! bodyData.gunzipped()
                            } else {
                                decompressedData = bodyData
                            }
                            let decodedString = String(data: decompressedData, encoding: .utf8)!
                            let response = AjaxResponse(json: decodedString)
                            DispatchQueue.main.async {
                                delegate?.didSendResponseHUD(message: "Descargando variables", error: errorType.dflt.rawValue, porcentage: 0)
                            }
                            if(response.Success){
                               
                                FCFileManager.removeItem(atPath: "Digipro/Usuarios/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Variables.var")
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                                ConfigurationManager.shared.variablesDataUIAppDelegate = FEVariablesData(dictionary: response.ReturnedObject!)
                                DispatchQueue.main.async {
                                    delegate?.didSendResponseHUD(message: "Descargando variables", error: errorType.dflt.rawValue, porcentage: 99)
                                }
                                self.salvarVariable(delegate: delegate)
                                ConfigurationManager.shared.utilities.writeLogger("Se han validado las variables\r\n", "log.txt")
                                resolve(response)
                            }else{
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                                reject(APIErrorResponse.XMLError)
                            }
                        }catch{
                            ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                            reject(APIErrorResponse.XMLError)
                        }
                        
                    })
                    task.resume()
                }catch (let error){
                    ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                    ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                    reject(APIErrorResponse.ServerError)
                }
                
            }
            
        }
        
    }
    
    func validVariablesOffline() -> Bool{
        ConfigurationManager.shared.utilities.writeLogger("\r\n-----\r\n Validando Variable offline \r\n-----\r\n", "log.txt")
        let gettingXml = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Variables.var")
        ConfigurationManager.shared.variablesDataUIAppDelegate = FEVariablesData(json: gettingXml)
        
        if ConfigurationManager.shared.variablesDataUIAppDelegate.ListVariables.count > 0{
            return true
        }else{
            return false
        }
    }
    
    func salvarVariable(delegate: Delegate?){
        ConfigurationManager.shared.utilities.writeLogger("\r\n-----\r\n Salvando Variable \r\n-----\r\n", "log.txt")
        let json = JSONSerializer.toJson(ConfigurationManager.shared.variablesDataUIAppDelegate)
        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Variables.var", withContent: json as NSObject, overwrite: true)
        // Function to reasing the value (FILES IN MB) in the Settings Bundle
        ConfigurationManager.shared.utilities.refreshFolderCapacity()
    }
    
}

//MARK: NOTIFICACION

public extension APIManager{
    func getNotification(delegate: Delegate?) -> Promise<Int>{
        return Promise<Int> { resolve, reject in
            var arrayEstadoApp: [Int] = []
           
            DispatchQueue.global(qos: .background).async {
            let files = FCFileManager.listFilesInDirectory(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.formatos)", deep: true)
            
            for file in files!{
                    let archive = file as! NSString
                    let pathExtention = archive.pathExtension
                
                    if(pathExtention == "bor"){
                        let gettingXml = FCFileManager.readFileAtPath(as: file as? String)
                        let formato = FEFormatoData(json: gettingXml)
                        let estadoApp = formato.EstadoApp
                        //print("ESTADO APP: \(estadoApp)")
                        
                        if estadoApp == 2{
                            print("ESTADO APP 2: \(estadoApp)")
            
                            arrayEstadoApp.append(estadoApp)
                            
                            //print("ARRAY ESTADO APP: \(arrayEstadoApp)")
                           print("COUNT ARRAY: \(arrayEstadoApp.count)\n\n")
                           
                           
                        }
                        
                }
               
            }
                print("NUMBER NEW: \(arrayEstadoApp.count)")
                resolve(arrayEstadoApp.count)
           
        }
            
           
        }
    }
}

// MARK: - REPOSITORIO
public extension APIManager{
    
    func validFormatosOnlinePromise(delegate: Delegate?) -> Promise<AjaxResponse> {
        
        return Promise<AjaxResponse> { resolve, reject in
            
            DispatchQueue.global(qos: .background).async {
                
                DispatchQueue.main.async() {
                    delegate?.didSendResponseStatus!(title: "Descargando Formato(s)", subtitle: "-", porcentage: 0)
                }
                
                let consultaFormato = FEConsultaFormato()
                consultaFormato.AplicacionID = ConfigurationManager.shared.codigoUIAppDelegate.AplicacionID
                consultaFormato.ProyectoID = ConfigurationManager.shared.codigoUIAppDelegate.ProyectoID
                consultaFormato.User = ConfigurationManager.shared.usuarioUIAppDelegate.User
                consultaFormato.Password = ConfigurationManager.shared.usuarioUIAppDelegate.Password
                consultaFormato.IP = ConfigurationManager.shared.utilities.getIPAddress()
                
                let mutableRequest: URLRequest
                do{
                    mutableRequest = try self.request.formatosRequest(formato: consultaFormato)
                    let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                        guard data != nil && error == nil else {
                            reject(APIErrorResponse.ServerError)
                            return
                        }
                        
                        do{
                            let doc = try AEXMLDocument(xml: data!)
                            let getCodeResult = doc["s:Envelope"]["s:Body"]["ConsultaFormatosResponse"]["ConsultaFormatosResult"].string
                            let bodyData = Data(base64Encoded: getCodeResult)!
                            let decompressedData: Data
                            if bodyData.isGzipped {
                                decompressedData = try! bodyData.gunzipped()
                            } else {
                                decompressedData = bodyData
                            }
                            let decodedString = String(data: decompressedData, encoding: .utf8)!
                            let response = AjaxResponse(json: decodedString)
                            if(response.Success){
                                // Deleting all formats
                                
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                                let SANDBOX_FORMATO = FEConsultaFormato(dictionary: response.ReturnedObject!)
                                var counter = 0
                                
                                if SANDBOX_FORMATO.Incidencias.count == 0 {
                                    
                                    ConfigurationManager.shared.utilities.writeLogger("No hay incidencias a guardar\r\n", "error.txt")
                                    ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                                    reject(APIErrorResponse.FormatosOnlineError)
                                    
                                }
                                
                                // Getting all formats and delete all less local
                                let formatDirectories = FCFileManager.listDirectoriesInDirectory(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.formatos)/", deep: true)

                                for directory in formatDirectories!{
                                    let path = directory as! String
                                    let dir = path.components(separatedBy: "/Formatos/")
                                    let folder = dir[1].split{$0 == "/"}.map(String.init)
                                    if folder.count == 1{ continue }
                                    if folder[1] == "0"{ continue }
                                    FCFileManager.removeItem(atPath: path)
                                }
                                for incidencias in SANDBOX_FORMATO.Incidencias{
                                    let formula:Float = Float(Float(counter) / Float(SANDBOX_FORMATO.Incidencias.count))
                                    
                                    DispatchQueue.main.async() {
                                        delegate?.didSendResponseStatus!(title: "Descargando Formato(s)", subtitle: "\(counter) de \(SANDBOX_FORMATO.Incidencias.count)", porcentage: Float(formula))
                                    }
                                    counter += 1
                                    
                                    // Saving JSON DATA
                                    FCFileManager.createFile(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.formatos)/\(incidencias.FlujoID)/\(incidencias.PIID)/\(incidencias.Guid)_\(incidencias.ExpID)_\(incidencias.TipoDocID)-\(incidencias.FlujoID)-\(incidencias.PIID).json", withContent: incidencias.JsonDatos as NSObject, overwrite: true)
                                    
                                    let customJson = incidencias.JsonDatos
                                    incidencias.JsonDatos = ""
                                    
                                    // Saving object Format
                                    let json = JSONSerializer.toJson(incidencias)
                                    FCFileManager.createFile(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.formatos)/\(incidencias.FlujoID)/\(incidencias.PIID)/\(incidencias.Guid)_\(incidencias.ExpID)_\(incidencias.TipoDocID)-\(incidencias.FlujoID)-\(incidencias.PIID).bor", withContent: json as NSObject, overwrite: true)
                                    
                                    // We detect if Resumen is already set
                                    // If not we're trying to get info from json and xml
                                    if incidencias.Resumen != ""{ continue }else{
                                        
                                        // Inicialización del Resumen
                                        var objectResumen: [(id: String, valor: String, orden: Int)] = [(id: String, valor: String, orden: Int)]()
                                        var resumen: [(id: String, valor: String)] = [(id: String, valor: String)]()
                                        
                                        let xml = self.getXML(flujo: String(incidencias.FlujoID), exp: String(incidencias.ExpID), doc: String(incidencias.TipoDocID))
                                        
                                        if xml.elementos?.elemento == nil, xml.elementos?.elemento[0].elementos?.elemento == nil{ continue }
                                        
                                        for element in (xml.elementos?.elemento)!{
                                            if element.elementos?.elemento != nil {
                                                for object in (element.elementos?.elemento)! {
                                                    let atributos = object.toDictionary()
                                                    let attr = atributos["atributos"] as? [String : AnyObject]
                                                    if attr == nil{ continue }
                                                    if attr!["usarcomocampoexterno"] as? Bool != nil, (attr!["usarcomocampoexterno"] as? Bool)!{
                                                        
                                                        if attr!["titulo"] as? String == ""{ continue }
                                                        objectResumen.append((id: object._idelemento, valor: attr!["titulo"] as? String ?? "", orden: attr!["ordenenresumen"] as? Int ?? 0))
                                                        objectResumen.sort(by: { $0.orden < $1.orden })
                                                    }
                                                    if objectResumen.count == 6{ break }
                                                }
                                            }
                                            if objectResumen.count == 6{ break }
                                        }
                                        
                                        if objectResumen.count > 0{
                                            do{
                                                let dict = try JSONSerializer.toDictionary(customJson)
                                                if dict.count == 0{ break }
                                                for equal in objectResumen{
                                                    for dato in dict{
                                                        let dictValor = dato.value as! NSMutableDictionary
                                                        let valor = dictValor.value(forKey: "valor") as? String ?? ""
                                                        if valor == "" { continue }
                                                        if dato.key as! String == equal.id{
                                                            resumen.append((id: "\(dato.key)", valor: valor))
                                                        }
                                                    }
                                                }
                                            }catch{ continue }
                                        }else{ continue }
                                        
                                        if resumen.count > 0{
                                            for r in resumen{
                                                if r.valor != ""{
                                                    incidencias.Resumen += "\(r.valor)||"
                                                }
                                            }
                                        }else{ continue }
                                        
                                        let json = JSONSerializer.toJson(incidencias)
                                        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.formatos)/\(incidencias.FlujoID)/\(incidencias.PIID)/\(incidencias.Guid)_\(incidencias.ExpID)_\(incidencias.TipoDocID)-\(incidencias.FlujoID)-\(incidencias.PIID).bor", withContent: json as NSObject, overwrite: true)
                                        
                                    }
                                    
                                }
                                SANDBOX_FORMATO.Incidencias = Array<FEFormatoData>()
                                ConfigurationManager.shared.utilities.writeLogger("Se han validado los formatos\r\n", "log.txt")
                                self.salvarFormato(formato: SANDBOX_FORMATO, delegate: delegate)
                                resolve(response)
                            }else{
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                                reject(APIErrorResponse.XMLError)
                            }
                        }catch{
                            ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                            reject(APIErrorResponse.XMLError)
                        }
                    })
                    task.resume()
                }catch (let error){
                    ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                    ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                    reject(APIErrorResponse.ServerError)
                }
            }
            
        }
        
    }
    
    func salvarFormato(formato: FEConsultaFormato, delegate: Delegate?){
        ConfigurationManager.shared.utilities.writeLogger("\r\n-----\r\n Salvando Formato \r\n-----\r\n", "log.txt")
        let json = JSONSerializer.toJson(formato)
        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Consulta.con", withContent: json as NSObject, overwrite: true)
        if delegate != nil{
            // Function to reasing the value (FILES IN MB) in the Settings Bundle
            ConfigurationManager.shared.utilities.refreshFolderCapacity()
        }
    }
    
    func validFlujosAndProcesosPromise(delegate: Delegate?) -> Promise<Bool>{
        
        return Promise<Bool>{ resolve, reject in
            
            ConfigurationManager.shared.utilities.writeLogger("Validando los flujos y procesos.\r\n", "log.txt")
            var flujos = Array<FEPlantillaMerge>()
            let procesos = Array<FEProcesos>()
            
            let plantillaJson = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Plantillas.pla")
            let plantillas = [FEPlantillaMerge](json: plantillaJson)
            
            for evento in plantillas{
                if flujos.first(where: { $0.NombreFlujo == evento.NombreFlujo }) != nil {
                    continue
                }
                flujos.append(evento)
            }
            flujos.sort(by: { $0.FlujoID < $1.FlujoID })
            ConfigurationManager.shared.procesosOrdered = procesos
            ConfigurationManager.shared.flujosOrdered = flujos
            resolve(true)
        }
    }
    
    func getFormatosSendToServer() -> Array<FEFormatoData>{
        var arrayFormatoData = Array<FEFormatoData>()
        let files = FCFileManager.listFilesInDirectory(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.formatos)", deep: true)
        
        for file in files!{
            let fileBor = file as! String
            if fileBor.contains(".bor"){
                let gettingXml = FCFileManager.readFileAtPath(as: fileBor)
                let formato = FEFormatoData(json: gettingXml)
                arrayFormatoData.append(formato)
            }
        }
        
        return arrayFormatoData
    }
    
    func getFormatosByFlujoAndProceso(_ flujoId: Int, _ piid: Int) -> Array<FEFormatoData>{
        var arrayFormatoData = Array<FEFormatoData>()
        let files = FCFileManager.listFilesInDirectory(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.formatos)/\(flujoId)/\(piid)/")
        
        for file in files!{
            let fileBor = file as! String
            if fileBor.contains(".bor"){
                let gettingXml = FCFileManager.readFileAtPath(as: fileBor)
                let formato = FEFormatoData(json: gettingXml)
                arrayFormatoData.append(formato)
            }
        }
        
        //arrayFormatoData.sort(by: { $0.Reserva && !$1.Reserva })
        arrayFormatoData.sort {
            if $0.Reserva == $1.Reserva {
                return $0.Guid < $1.Guid
            }
            return $0.Reserva && !$1.Reserva
        }
        //arrayFormatoData.sort(by: { $0.Guid > $1.Guid })
        return arrayFormatoData
    }
    
    func getFormatoJson(_ formato: FEFormatoData) -> String?{
        let stringJson = FCFileManager.readFile(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.formatos)/\(formato.FlujoID)/\(formato.PIID)/\(formato.Guid)_\(formato.ExpID)_\(formato.TipoDocID)-\(formato.FlujoID)-\(formato.PIID).json")
        
        return stringJson
    }
    
}

// MARK: - PLANTILLA DATA
public extension APIManager{
    
    func getXML(flujo: String, exp: String, doc: String) -> Elemento{
        guard let xmlString = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Plantillas/\(flujo)/\(exp)_\(doc)/\(exp)_\(doc).xml") else {
            return Elemento()
        }
        
        let plaString = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Plantillas/\(flujo)/\(exp)_\(doc)/\(exp)_\(doc).pla")
        ConfigurationManager.shared.plantillaDataUIAppDelegate = FEPlantillaData(json: plaString)
        
        let plantilla = Elemento(xmlString: xmlString)
        return plantilla!
    }
    
    func getRULES(flujo: String, exp: String, doc: String) -> AEXMLDocument?{
        guard let xmlString = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Plantillas/\(flujo)/\(exp)_\(doc)/\(exp)_\(doc).rls") else { return nil }
        do { let xmlDoc = try AEXMLDocument(xml: xmlString); return xmlDoc; } catch { print("\(error)"); return nil; }
    }
    
    func getSERVICES(flujo: String, exp: String, doc: String) -> AEXMLDocument?{
        guard let xmlString = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Plantillas/\(flujo)/\(exp)_\(doc)/\(exp)_\(doc).srv") else { return nil }
        do { let xmlDoc = try AEXMLDocument(xml: xmlString); return xmlDoc; } catch { print("\(error)"); return nil; }
    }
    
    func getCOMPONENTS(flujo: String, exp: String, doc: String) -> AEXMLDocument?{
        guard let xmlString = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Plantillas/\(flujo)/\(exp)_\(doc)/\(exp)_\(doc).cmp") else { return nil }
        do { let xmlDoc = try AEXMLDocument(xml: xmlString); return xmlDoc; } catch { print("\(error)"); return nil; }
    }
    
    func getMATHEMATICS(flujo: String, exp: String, doc: String) -> AEXMLDocument?{
        guard let xmlString = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Plantillas/\(flujo)/\(exp)_\(doc)/\(exp)_\(doc).mat") else { return nil }
        do { let xmlDoc = try AEXMLDocument(xml: xmlString); return xmlDoc; } catch { print("\(error)"); return nil; }
    }
    
    func salvarPlantillaData(formato: FEFormatoData){
        let json = JSONSerializer.toJson(formato)
        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Formatos/\(formato.FlujoID)/\(formato.PIID)/\(formato.Guid)_\(formato.ExpID)_\(formato.TipoDocID)-\(formato.FlujoID)-\(formato.PIID).bor", withContent: json as NSObject, overwrite: true)
        
        // Function to reasing the value (FILES IN MB) in the Settings Bundle
        ConfigurationManager.shared.utilities.refreshFolderCapacity()
    }
    
    func salvarPlantillaDataAndJson(formato: FEFormatoData, json: String){
        
        let formatoString = JSONSerializer.toJson(formato)
        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Formatos/\(formato.FlujoID)/\(formato.PIID)/\(formato.Guid)_\(formato.ExpID)_\(formato.TipoDocID)-\(formato.FlujoID)-\(formato.PIID).bor", withContent: formatoString as NSObject, overwrite: true)
        
        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Formatos/\(formato.FlujoID)/\(formato.PIID)/\(formato.Guid)_\(formato.ExpID)_\(formato.TipoDocID)-\(formato.FlujoID)-\(formato.PIID).json", withContent: json as NSObject, overwrite: true)
        
        // Function to reasing the value (FILES IN MB) in the Settings Bundle
        ConfigurationManager.shared.utilities.refreshFolderCapacity()
        
    }
}

// MARK: - UPDATE TO SERVER
public extension APIManager{
    
    func sendToServerFormatosPromise(delegate: Delegate?) -> Promise<[FEConsultaFormato]>{
        
        return Promise<[FEConsultaFormato]>{ resolve, reject in
            
            ConfigurationManager.shared.utilities.writeLogger("Enviando formatos al servidor..\r\n", "log.txt")
            
            DispatchQueue.main.async {
                delegate?.didSendResponseHUD(message: "Enviando formatos...", error: errorType.dflt.rawValue, porcentage: 0)
                ConfigurationManager.shared.console.addTextConsole("Enviando formatos al servidor...", "log")
            }
            
            let folders = FCFileManager.listFilesInDirectory(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/\(Cnstnt.Tree.formatos)/", deep: true)
            var resultFormato = [FEConsultaFormato]()
            
            for files in folders!{
                let fileString = files as! String
                if fileString.contains(".bor"){
                    let gettingXml = FCFileManager.readFileAtPath(as: fileString)
                    
                    let formato = FEFormatoData(json: gettingXml)
                    
                    if (formato.EstadoApp == 1 || formato.EstadoApp == 2) && formato.editado{
                        let fileJson = fileString.replacingOccurrences(of: ".bor", with: ".json")
                        let contentJson = FCFileManager.readFileAtPath(as: fileJson)
                        //contentJson = contentJson!.replacingOccurrences(of: "\\\"", with: "")
                        formato.JsonDatos = contentJson!
                        
                        let consultaFormato = FEConsultaFormato()
                        consultaFormato.AplicacionID = ConfigurationManager.shared.codigoUIAppDelegate.AplicacionID
                        consultaFormato.ProyectoID = ConfigurationManager.shared.codigoUIAppDelegate.ProyectoID
                        consultaFormato.User = ConfigurationManager.shared.usuarioUIAppDelegate.User
                        consultaFormato.Password = ConfigurationManager.shared.usuarioUIAppDelegate.Password
                        consultaFormato.IP = ConfigurationManager.shared.utilities.getIPAddress()
                        consultaFormato.Formato = formato
                        
                        resultFormato.append(consultaFormato)
                    }
                    
                }
            }
            
            if resultFormato.count > 0{
                DispatchQueue.main.async {
                    ConfigurationManager.shared.console.addTextConsole("\(resultFormato.count) formato(s) por enviar.", "log")
                }
                
                Bluebirdreduce(resultFormato, 0) { promise, item in
                    print("Reduce: ")
                    print(promise)
                    print(item)
                    return self.loopSendFormatoPromise(delegate: delegate, element: item).then { response in
                        return 0
                    }
                    }
                    .then { response in
                        print("RESPUESTA SUCCESS: \(response)")
                        DispatchQueue.main.async {
                            ConfigurationManager.shared.console.addTextConsole("\(resultFormato.count) formato(s) enviados.", "log")
                        }
                        resolve(resultFormato)
                    }.catch { error in
                        print("RESPUESTA ERROR: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            ConfigurationManager.shared.console.addTextConsole("Hubo un error al enviar los formatos, favor de intentarlo de nuevo.", "error")
                        }
                        reject(APIErrorResponse.ServerError)
                }
            }else{
                DispatchQueue.main.async {
                    ConfigurationManager.shared.console.addTextConsole("No hay formato(s) por enviar.", "log")
                    reject(APIErrorResponse.ServerError)
                }
            }
            
        }
        
    }
    
    func removeFormato(formato: FEConsultaFormato){
        ConfigurationManager.shared.utilities.writeLogger("Removiendo el formato de la aplicación.\r\n", "log.txt")
        DispatchQueue.main.async {
            ConfigurationManager.shared.console.addTextConsole("Removiendo el formato: \(formato.Formato.NombreExpediente) | \(formato.Formato.Guid)", "log")
        }
        FCFileManager.removeItem(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Formatos/\(formato.Formato.FlujoID)/\(formato.Formato.PIID)/\(formato.Formato.Guid)_\(formato.Formato.ExpID)_\(formato.Formato.TipoDocID)-\(formato.Formato.FlujoID)-\(formato.Formato.PIID).bor")
        FCFileManager.removeItem(atPath: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Formatos/\(formato.Formato.FlujoID)/\(formato.Formato.PIID)/\(formato.Formato.Guid)_\(formato.Formato.ExpID)_\(formato.Formato.TipoDocID)-\(formato.Formato.FlujoID)-\(formato.Formato.PIID).json")
        // Function to reasing the value (FILES IN MB) in the Settings Bundle
        ConfigurationManager.shared.utilities.refreshFolderCapacity()
    }
    
    func loopSendFormatoPromise(delegate: Delegate?, element: FEConsultaFormato) -> Promise<Bool>{
        return Promise<Bool>{ resolve, reject in
            self.sendFormatoDataPromise(delegate: delegate, formato: element)
                .then { response in
                    self.sendToServerAnexosPromise(delegate: delegate, formato: element)
                        .then({ response in
                            print(response)
                            resolve(true)
                        })
                        .catch({ error in
                            print(error)
                            reject(error)
                        })
                }.catch { error in
                    reject(error)
            }
        }
    }
    
    func sendFormatoDataPromise(delegate: Delegate?, formato: FEConsultaFormato) -> Promise<FEConsultaFormato>{
        
        return Promise<FEConsultaFormato>{ resolve, reject in
            
            let mutableRequest: URLRequest
            
            DispatchQueue.main.async() {
                delegate?.didSendResponseHUD(message: "Enviando formato: \(formato.Formato.Guid)", error: errorType.danger.rawValue, porcentage: 0)
                ConfigurationManager.shared.console.addTextConsole("ENVIANDO formato: \(formato.Formato.NombreExpediente) | \(formato.Formato.Guid)", "log")
            }
            
            do{
                mutableRequest = try request.sendFormatosRequest(formato: formato)
                let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                    guard data != nil && error == nil else {
                        reject(APIErrorResponse.ServerError)
                        return
                    }
                    do{
                        let doc = try AEXMLDocument(xml: data!)
                        let getCodeResult = doc["s:Envelope"]["s:Body"]["EnviaFormatoResponse"]["EnviaFormatoResult"].string
                        let bodyData = Data(base64Encoded: getCodeResult)!
                        let decompressedData: Data
                        if bodyData.isGzipped {
                            decompressedData = try! bodyData.gunzipped()
                        } else {
                            decompressedData = bodyData
                        }
                        let decodedString = String(data: decompressedData, encoding: .utf8)!
                        let response = AjaxResponse(json: decodedString)
                        if(response.Success){
                            DispatchQueue.main.async {
                                ConfigurationManager.shared.console.addTextConsole("Formato enviado.", "log")
                                ConfigurationManager.shared.console.addTextConsole("Mensaje del servidor: \(response.Mensaje)", "log")
                            }
                            // FORMATO POR BORRAR
                            let SANDBOX_FORMATO = FEConsultaFormato(dictionary: response.ReturnedObject!)
                            
                            if SANDBOX_FORMATO.IdDel > 0{
                                self.removeFormato(formato: formato)
                            }else if response.Mensaje.contains("DocId") || response.Mensaje.contains("DocId\n"){
                                self.removeFormato(formato: formato)
                            }
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                            resolve(formato)
                        }else{
                            DispatchQueue.main.async() {
                                ConfigurationManager.shared.console.addTextConsole("Error el enviar el formato.", "error")
                                ConfigurationManager.shared.console.addTextConsole("Mensaje del servidor: \(response.Mensaje)", "error")
                            }
                            print("MENSAJE DE ERROR SERVER: \(response.Mensaje)")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                            resolve(formato)
                        }
                    }catch{
                        DispatchQueue.main.async() {
                            ConfigurationManager.shared.console.addTextConsole("Hubo un error en la respuesta del servidor.", "error")
                        }
                        ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                        
                        reject(APIErrorResponse.ServerError)
                    }
                })
                task.resume()
            }catch (let error){
                ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                reject(APIErrorResponse.ServerError)
            }
            
        }
        
    }
    
    func deleteFormatoDataPromise(delegate: Delegate?, formato: FEConsultaFormato) -> Promise<FEConsultaFormato>{
        
        return Promise<FEConsultaFormato>{ resolve, reject in
            
            let mutableRequest: URLRequest
            
            DispatchQueue.main.async() {
                delegate?.didSendResponseHUD(message: "Borrando formato: \(formato.Formato.Guid)", error: errorType.danger.rawValue, porcentage: 0)
            }
            
            do{
                mutableRequest = try request.deleteFormatoRequest(formato: formato)
                let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                    guard data != nil && error == nil else {
                        reject(APIErrorResponse.ServerError)
                        return
                    }
                    do{
                        let doc = try AEXMLDocument(xml: data!)
                        let getCodeResult = doc["s:Envelope"]["s:Body"]["BorraFormatoBorradorResponse"]["BorraFormatoBorradorResult"].string
                        let bodyData = Data(base64Encoded: getCodeResult)!
                        let decompressedData: Data
                        if bodyData.isGzipped {
                            decompressedData = try! bodyData.gunzipped()
                        } else {
                            decompressedData = bodyData
                        }
                        let decodedString = String(data: decompressedData, encoding: .utf8)!
                        let response = AjaxResponse(json: decodedString)
                        if(response.Success){
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                            resolve(formato)
                        }else{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                            reject(APIErrorResponse.ServerError)

                        }
                    }catch{
                        DispatchQueue.main.async() {
                            ConfigurationManager.shared.console.addTextConsole("Hubo un error en la respuesta del servidor.", "error")
                        }
                        ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                        
                        reject(APIErrorResponse.ServerError)
                    }
                })
                task.resume()
            }catch (let error){
                ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                reject(APIErrorResponse.ServerError)
            }
            
        }
        
    }
    
}

// MARK: ENVIAR ANEXOS
public extension APIManager{
    
    func sendToServerAnexosPromise(delegate: Delegate?, formato: FEConsultaFormato) -> Promise<[FEConsultaAnexo]>{
        
        return Promise<[FEConsultaAnexo]>{ resolve, reject in
            
            ConfigurationManager.shared.utilities.writeLogger("Enviando anexos al servidor..\r\n", "log.txt")
            DispatchQueue.main.async {
                ConfigurationManager.shared.console.addTextConsole("Enviando anexos al servidor", "log")
                delegate?.didSendResponseHUD(message: "Enviando anexos...", error: errorType.dflt.rawValue, porcentage: 0)
            }
            
            let folders = FCFileManager.listDirectoriesInDirectory(atPath: "\(Cnstnt.Tree.anexos)")
            var resultAnexo = [FEConsultaAnexo]()
            
            for anexo in formato.Formato.Anexos{
                
                if !anexo.editado{ continue }
                
                let consultaAnexo = FEConsultaAnexo()
                consultaAnexo.AplicacionID = ConfigurationManager.shared.codigoUIAppDelegate.AplicacionID
                consultaAnexo.ProyectoID = ConfigurationManager.shared.codigoUIAppDelegate.ProyectoID
                consultaAnexo.User = ConfigurationManager.shared.usuarioUIAppDelegate.User
                consultaAnexo.Password = ConfigurationManager.shared.usuarioUIAppDelegate.Password
                consultaAnexo.IP = ConfigurationManager.shared.utilities.getIPAddress()
                consultaAnexo.EstadoApp = formato.Formato.EstadoApp
                
                for folder in folders!{
                    let fold = folder as! NSString
                    if FCFileManager.existsItem(atPath: "\(fold)/\(anexo.FileName)"){
                        let file = FCFileManager.readFileAtPath(asData: "\(fold)/\(anexo.FileName)")
                        let anexoBase64 = file?.base64EncodedData()
                        let stringBase64 = String(data: anexoBase64!, encoding: String.Encoding.utf8) as String?
                        anexo.Datos = stringBase64!
                        anexo.TareaSiguiente = formato.Formato.TareaSiguiente
                        consultaAnexo.anexo = anexo
                        if anexo.Datos != ""{
                            resultAnexo.append(consultaAnexo)
                        }
                    }
                }
            }
            
            if resultAnexo.count > 0{
                DispatchQueue.main.async {
                    ConfigurationManager.shared.console.addTextConsole("\(resultAnexo.count) anexos(s) por enviar del formato: \(formato.Formato.NombreExpediente) | \(formato.Formato.Guid)", "log")
                }
                Bluebirdreduce(resultAnexo, 0) { promise, item in
                    print("Reduce: ")
                    print(promise)
                    print(item)
                    return self.sendAnexoDataPromise(delegate: delegate, consulta: item, formato: formato).then { response in
                        return 0
                    }
                    }
                    .then { response in
                        print(response)
                        DispatchQueue.main.async {
                            ConfigurationManager.shared.console.addTextConsole("\(resultAnexo.count) anexos(s) enviados.", "log")
                        }
                        resolve(resultAnexo)
                    }.catch { error in
                        print(error)
                        DispatchQueue.main.async {
                            ConfigurationManager.shared.console.addTextConsole("Hubo un error al enviar los anexos, favor de intentar más tarde.", "log")
                        }
                        reject(APIErrorResponse.ServerError)
                }
            }else{
                DispatchQueue.main.async {
                    ConfigurationManager.shared.console.addTextConsole("No hay anexos por enviar del formato: \(formato.Formato.NombreExpediente) | \(formato.Formato.Guid)", "log")
                }
                resolve(resultAnexo)
            }
            
        }
        
    }
    
    func loopSendAnexoDataPromise(delegate: Delegate?, consulta: FEConsultaAnexo, formato: FEConsultaFormato) -> Promise<Bool>{
        return Promise<Bool>{ resolve, reject in
            self.sendAnexoDataPromise(delegate: delegate, consulta: consulta, formato: formato)
                .then { response in
                    resolve(true)
                }.catch { error in
                    reject(error)
            }
        }
    }
    
    func sendAnexoDataPromise(delegate: Delegate?, consulta: FEConsultaAnexo, formato: FEConsultaFormato) -> Promise<FEConsultaAnexo>{
        
        return Promise<FEConsultaAnexo>{ resolve, reject in
            
            DispatchQueue.main.async() {
                delegate?.didSendResponseHUD(message: "Enviando anexo: \(consulta.anexo.Guid)", error: errorType.danger.rawValue, porcentage: 0)
            }
            
            let mutableRequest: URLRequest
            do{
                mutableRequest = try request.sendAnexosRequest(consulta: consulta)
                let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                    guard data != nil && error == nil else {
                        reject(APIErrorResponse.ServerError)
                        return
                    }
                    do{
                        let doc = try AEXMLDocument(xml: data!)
                        let getCodeResult = doc["s:Envelope"]["s:Body"]["EnviaAnexoResponse"]["EnviaAnexoResult"].string
                        let bodyData = Data(base64Encoded: getCodeResult)!
                        let decompressedData: Data
                        if bodyData.isGzipped {
                            decompressedData = try! bodyData.gunzipped()
                        } else {
                            decompressedData = bodyData
                        }
                        let decodedString = String(data: decompressedData, encoding: .utf8)!
                        let response = AjaxResponse(json: decodedString)
                        if(response.Success){
                            DispatchQueue.main.async {
                                ConfigurationManager.shared.console.addTextConsole("Anexo enviado.", "log")
                                ConfigurationManager.shared.console.addTextConsole("Mensaje del servidor: \(response.Mensaje)", "log")
                            }
                            // FORMATO POR BORRAR
                            if response.Mensaje.contains("DocId") || response.Mensaje.contains("DocId\n"){
                                self.removeFormato(formato: formato)
                                self.removeAnexo(anexo: consulta.anexo)
                            }
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                            ConfigurationManager.shared.utilities.writeLogger("Se han validado los anexos\r\n", "log.txt")
                            resolve(consulta)
                        }else{
                            DispatchQueue.main.async() {
                                ConfigurationManager.shared.console.addTextConsole("Error el enviar el formato.", "error")
                                ConfigurationManager.shared.console.addTextConsole("Mensaje del servidor: \(response.Mensaje)", "error")
                                print("MENSAJE DEL SERVIDOR: \(response.Mensaje)")
                            }
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                            reject(APIErrorResponse.ParseError)
                        }
                    }catch{
                        
                        DispatchQueue.main.async() {
                            ConfigurationManager.shared.console.addTextConsole("Hubo un error en la respuesta del servidor.", "error")
                        }
                        ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                        reject(APIErrorResponse.ServerError)
                    }
                    
                })
                task.resume()
            }catch (let error){
                ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                reject(APIErrorResponse.ServerError)
            }
            
        }
        
    }
    
    func removeAnexo(anexo: FEAnexoData){
        ConfigurationManager.shared.utilities.writeLogger("Removiendo el anexo de la aplicación.\r\n", "log.txt")
        DispatchQueue.main.async {
            ConfigurationManager.shared.console.addTextConsole("Removiendo el anexo: \(anexo.FileName) | \(anexo.Guid)", "log")
        }
        FCFileManager.removeItem(atPath: "\(Cnstnt.Tree.anexos)")
        // Function to reasing the value (FILES IN MB) in the Settings Bundle
        ConfigurationManager.shared.utilities.refreshFolderCapacity()
    }
    
}

// MARK: TRANSITAR FORMATO
public extension APIManager{
    
    func obtenerEventosTareaPromise(delegate: Delegate?, _ index: NSInteger, _ formato: FEFormatoData, _ reserva: Bool, _ isInEdition: Bool) -> Promise<FEFormatoData>{
        
        return Promise<FEFormatoData>{ resolve, reject in
            
            // Obtener la actual plantilla
            DispatchQueue.main.async() {
                self.delegate?.didSendResponseHUD(message: "Reservado formato", error: errorType.danger.rawValue, porcentage: 0)
            }
            
            guard let file = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Plantillas/\(formato.FlujoID)/\(formato.ExpID)_\(formato.TipoDocID)/\(formato.ExpID)_\(formato.TipoDocID).pla") else {
                return
            }
            var tareasGuardadas = [FEEventosFlujo]()
            let plantilla = FEPlantillaData(json: file)
            for eventoTarea in plantilla.EventosTareas{
                let evento = eventoTarea as FEEventosFlujo
                if reserva{
                    if evento.TareaID == 0 && evento.EstadoIniId == formato.EstadoID{
                        tareasGuardadas.append(evento)
                        break;
                    }
                }else{
                    if evento.TareaID == 2 && evento.EstadoIniId == formato.EstadoID{
                        tareasGuardadas.append(evento)
                        break;
                    }
                }
            }
            
            let dummyFormato = formato
            if tareasGuardadas.count > 0{
                dummyFormato.JsonDatos = formato.JsonDatos.replacingOccurrences(of: "\\\"", with: "\"")
                dummyFormato.JsonDatos = formato.JsonDatos.replacingOccurrences(of: "\"", with: "\\\"")
                dummyFormato.Reserva = reserva
                dummyFormato.EstadoID = tareasGuardadas[0].EstadoFinId
                dummyFormato.NombreEstado = tareasGuardadas[0].EstadoFinal
                dummyFormato.TareaSiguiente = tareasGuardadas[0]
                isFormatoReservedPromise(delegate: delegate, index, dummyFormato, formato, isInEdition)
                    .then{ response in
                        resolve(formato)
                    }.catch{ error in
                        reject(APIErrorResponse.NoTransitedOptions)
                }
            }else{
                reject(APIErrorResponse.TransitedError)
            }
            
            
        }
        
    }
    
    func isFormatoReservedPromise(delegate: Delegate?, _ index: NSInteger, _ formato: FEFormatoData, _ original: FEFormatoData, _ isInEdition: Bool) -> Promise<AjaxResponse>{
        
        return Promise<AjaxResponse>{ resolve, reject in
            
            let consultaFormato = FEConsultaFormato()
            consultaFormato.AplicacionID = ConfigurationManager.shared.codigoUIAppDelegate.AplicacionID
            consultaFormato.ProyectoID = ConfigurationManager.shared.codigoUIAppDelegate.ProyectoID
            consultaFormato.User = ConfigurationManager.shared.usuarioUIAppDelegate.User
            consultaFormato.Password = ConfigurationManager.shared.usuarioUIAppDelegate.Password
            consultaFormato.IP = ConfigurationManager.shared.utilities.getIPAddress()
            consultaFormato.Formato = formato
            
            let mutableRequest: URLRequest
            do{
                mutableRequest = try request.transitaRequest(formato: consultaFormato)
                let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                    guard data != nil && error == nil else {
                        reject(APIErrorResponse.ServerError)
                        return
                    }
                    do{
                        let doc = try AEXMLDocument(xml: data!)
                        let getCodeResult = doc["s:Envelope"]["s:Body"]["TransitaFormatoResponse"]["TransitaFormatoResult"].string
                        let bodyData = Data(base64Encoded: getCodeResult)!
                        let decompressedData: Data
                        if bodyData.isGzipped {
                            decompressedData = try! bodyData.gunzipped()
                        } else {
                            decompressedData = bodyData
                        }
                        let decodedString = String(data: decompressedData, encoding: .utf8)!
                        let response = AjaxResponse(json: decodedString)
                        if(response.Success){
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                            ConfigurationManager.shared.utilities.writeLogger("Se han validado los formatos\r\n", "log.txt")
                            self.salvarPlantillaData(formato: original)
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                                resolve(response)
                            })
                        }else{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                            reject(APIErrorResponse.ParseError)
                        }
                        
                    }catch{
                        ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                        reject(APIErrorResponse.XMLError)
                    }
                    
                })
                task.resume()
            }catch (let error){
                ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                reject(APIErrorResponse.ServerError)
            }
            
        }
        
    }
    
}

// MARK: - CONSULTA ANEXOS
public extension APIManager{
    
    func consultaAnexoDataPromise(delegate: Delegate?, anexo: FEConsultaAnexo) -> Promise<AjaxResponse>{
        
        return Promise<AjaxResponse>{ resolve, reject in
            
            let mutableRequest: URLRequest
            do{
                mutableRequest = try request.consultaAnexosRequest(consulta: anexo)
                let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                    guard data != nil && error == nil else {
                        reject(APIErrorResponse.ServerError)
                        return
                    }
                    do{
                        let doc = try AEXMLDocument(xml: data!)
                        let getCodeResult = doc["s:Envelope"]["s:Body"]["ConsultaAnexoResponse"]["ConsultaAnexoResult"].string
                        let bodyData = Data(base64Encoded: getCodeResult)!
                        let decompressedData: Data
                        if bodyData.isGzipped {
                            decompressedData = try! bodyData.gunzipped()
                        } else {
                            decompressedData = bodyData
                        }
                        let decodedString = String(data: decompressedData, encoding: .utf8)!
                        let response = AjaxResponse(json: decodedString)
                        if(response.Success){
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                            let consulta = FEConsultaAnexo(dictionary: response.ReturnedObject!)
                            if anexo.anexo.Extension == ".PNG" || anexo.anexo.Extension == ".png" || anexo.anexo.Extension == "PNG" || anexo.anexo.Extension == "png" || anexo.anexo.Extension == ".JPEG" || anexo.anexo.Extension == ".jpeg" || anexo.anexo.Extension == "JPEG" || anexo.anexo.Extension == "jpeg" || anexo.anexo.Extension == ".JPG" || anexo.anexo.Extension == ".jpg" || anexo.anexo.Extension == "JPG" || anexo.anexo.Extension == "jpg"{
                                let image = consulta.datos.stringBase64EncodeToImage()
                                let _ = ConfigurationManager.shared.utilities.saveImageToFolder(image, "\(anexo.anexo.FileName)")
                                resolve(response)
                            }else{
                                let data = consulta.datos.stringBase64EncodeToData()
                                let _ = ConfigurationManager.shared.utilities.saveAnexoToFolder(data, "\(anexo.anexo.FileName)")
                                resolve(response)
                            }
                            ConfigurationManager.shared.utilities.writeLogger("Se ha guardado el anexo\r\n", "log.txt")
                            
                        }else{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                            reject(APIErrorResponse.ParseError)
                        }
                        
                    }catch{
                        ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                        reject(APIErrorResponse.XMLError)
                        
                    }
                    
                })
                task.resume()
            }catch (let error){
                DispatchQueue.main.async() {
                    ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                    ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                    reject(APIErrorResponse.ServerError)
                }
            }
            
        }
        
    }
    
    func consultaPDFDataPromise(delegate: Delegate?, anexo: FEConsultaAnexo) -> Promise<String>{
        
        return Promise<String>{ resolve, reject in
            
            let mutableRequest: URLRequest
            do{
                mutableRequest = try request.consultaAnexosRequest(consulta: anexo)
                let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                    guard data != nil && error == nil else {
                        reject(APIErrorResponse.ServerError)
                        return
                    }
                    do{
                        let doc = try AEXMLDocument(xml: data!)
                        let getCodeResult = doc["s:Envelope"]["s:Body"]["ConsultaAnexoResponse"]["ConsultaAnexoResult"].string
                        let bodyData = Data(base64Encoded: getCodeResult)!
                        let decompressedData: Data
                        if bodyData.isGzipped {
                            decompressedData = try! bodyData.gunzipped()
                        } else {
                            decompressedData = bodyData
                        }
                        let decodedString = String(data: decompressedData, encoding: .utf8)!
                        let response = AjaxResponse(json: decodedString)
                        if(response.Success){
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                            let consulta = FEConsultaAnexo(dictionary: response.ReturnedObject!)
                            resolve(consulta.datos)
                            ConfigurationManager.shared.utilities.writeLogger("Se ha guardado el anexo\r\n", "log.txt")
                            
                        }else{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                            reject(APIErrorResponse.ParseError)
                        }
                        
                    }catch{
                        ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                        reject(APIErrorResponse.XMLError)
                        
                    }
                    
                })
                task.resume()
            }catch (let error){
                DispatchQueue.main.async() {
                    ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                    ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                    reject(APIErrorResponse.ServerError)
                }
            }
            
        }
        
    }
    
}

// MARK: - CONSULTA CONSULTAS
public extension APIManager{
    
    func consultaConsultasPromise(delegate: Delegate?, reporte: FETipoReporte?, consulta: FEConsultaTemplate?) -> Promise<FEConsultaTemplate>{
        
        return Promise<FEConsultaTemplate>{ resolve, reject in
            
            let mutableRequest: URLRequest
            do{
                var consultaT = FEConsultaTemplate()
                if (reporte != nil){
                    consultaT.Consulta = reporte!
                    consultaT.User = ConfigurationManager.shared.usuarioUIAppDelegate.User
                    consultaT.AplicacionID = ConfigurationManager.shared.codigoUIAppDelegate.AplicacionID
                    consultaT.ProyectoID = ConfigurationManager.shared.codigoUIAppDelegate.ProyectoID
                    consultaT.GrupoAdminID = ConfigurationManager.shared.usuarioUIAppDelegate.GrupoAdminID
                    consultaT.Password = ConfigurationManager.shared.usuarioUIAppDelegate.Password
                    consultaT.IP = ConfigurationManager.shared.utilities.getIPAddress()
                }else{
                    consultaT = consulta!
                }
                
                mutableRequest = try request.consultaRequest(consulta: consultaT)
                let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                    guard data != nil && error == nil else {
                        reject(APIErrorResponse.ServerError)
                        return
                    }
                    do{
                        let doc = try AEXMLDocument(xml: data!)
                        let getCodeResult = doc["s:Envelope"]["s:Body"]["ConsultaTemplateResponse"]["ConsultaTemplateResult"].string
                        let bodyData = Data(base64Encoded: getCodeResult)!
                        let decompressedData: Data
                        if bodyData.isGzipped {
                            decompressedData = try! bodyData.gunzipped()
                        } else {
                            decompressedData = bodyData
                        }
                        let decodedString = String(data: decompressedData, encoding: .utf8)!
                        let response = AjaxResponse(json: decodedString)
                        print("RESPONSE PROMISE: \(response)")
                        if(response.Success){
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                            let consulta = FEConsultaTemplate(dictionary: response.ReturnedObject!)
                            ConfigurationManager.shared.utilities.writeLogger("Se ha guardado el anexo\r\n", "log.txt")
                            resolve(consulta)
                            
                        }else{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                            reject(APIErrorResponse.ParseError)
                        }
                        
                    }catch{
                        ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                        reject(APIErrorResponse.XMLError)
                        
                    }
                    
                })
                task.resume()
            }catch (let error){
                DispatchQueue.main.async() {
                    ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                    ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                    reject(APIErrorResponse.ServerError)
                }
            }
            
        }
        
    }
    
}

// TODO: -
// MARK: - SOAP SERVICIOS
public extension APIManager{
    
    func compareFacesPromise(delegate: Delegate?, compareFaces: CompareFacesResult) -> Promise<AjaxResponse>{
        
        return Promise<AjaxResponse>{ resolve, reject in
            
            let mutableRequest: URLRequest
            do{
                mutableRequest = try request.compareFacesRequest(compareFaces: compareFaces)
                let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                    guard data != nil && error == nil else {
                        reject(APIErrorResponse.ServerError)
                        return
                    }
                    do{
                        let doc = try AEXMLDocument(xml: data!)
                        let getCodeResult = doc["s:Envelope"]["s:Body"]["CompareFacesResponse"]["CompareFacesResult"].string
                        let response = AjaxResponse(json: getCodeResult)
                        if(response.Success){
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                            ConfigurationManager.shared.utilities.writeLogger("Se ha validado el registro del usuario.\r\n", "log.txt")
                            let mensajeResultado = CompareFacesResult(dictionary: response.ReturnedObject!)
                            delegate?.didSetCompareFaces!(mensajeResultado, response.Mensaje)
                            resolve(response)
                        }else{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                            delegate?.didSendError(message: "El registro no es válido.", error: errorType.danger.rawValue)
                            delegate?.didSetCompareFacesError!(nil, response.Mensaje)
                            reject(serverError.runtimeError("\(response.Mensaje)"))
                        }
                    }catch{
                        delegate?.didSendError(message: "No se puedo obtener el XML.", error: errorType.danger.rawValue)
                        ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                        reject(serverError.runtimeError("Error al ejecutar el servicio."))
                    }
                })
                task.resume()
            }catch (let error){
                ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                delegate?.didSendError(message: "Se obtuvo un error: \(error).", error: errorType.danger.rawValue)
                reject(serverError.runtimeError("Error al ejecutar el servicio."))
            }
            
        }
        
    }
    
    func soapNewFolioPromise(delegate: Delegate?, mParams mparams: [String], sParams sparams:[String]) -> Promise<AEXMLDocument>{
        
        return Promise<AEXMLDocument>{ resolve, reject in
            
            let mutableRequest: URLRequest
            do{
                mutableRequest = try request.soapNewFolioRequest(mParams: mparams, sParams: sparams)
                let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                    guard data != nil && error == nil else {
                        delegate?.didSetServicioFolioError?(nil, "No se pudo conectar al servidor.")
                        reject(APIErrorResponse.ServerError)
                        return
                    }
                    do{
                        let doc = try AEXMLDocument(xml: data!)
                        if doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:success"].string == "true" && doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:servicesuccess"].string == "true"{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")                            
                            resolve(doc)
                        }else{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                            delegate?.didSendError(message: "El registro no es válido.", error: errorType.danger.rawValue)
                            delegate?.didSetServicioFolioError?(nil, doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:servicemessage"].string)
                            reject(serverError.runtimeError(doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:servicemessage"].string))
                        }
                    }catch{
                        delegate?.didSendError(message: "No se puedo obtener el XML.", error: errorType.danger.rawValue)
                        ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                        delegate?.didSetServicioFolioError?(nil, "No se pudo conectar al servidor.")
                        reject(serverError.runtimeError("Error al ejecutar el servicio."))
                    }
                })
                task.resume()
            }catch (let error){
                ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                delegate?.didSendError(message: "Se obtuvo un error: \(error).", error: errorType.danger.rawValue)
                reject(serverError.runtimeError("Error al ejecutar el servicio."))
            }
            
        }
        
    }
    
    
    func soapNewSMSPromise(delegate: Delegate?, mParams mparams: [String], sParams sparams:[String]) -> Promise<AEXMLDocument>{
        
        return Promise<AEXMLDocument>{ resolve, reject in
            
            let mutableRequest: URLRequest
            do{
                mutableRequest = try request.soapNewSMSRequest(mParams: mparams, sParams: sparams)
                let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                    guard data != nil && error == nil else {
                        delegate?.didSetServicioFolioError?(nil, "No se pudo conectar al servidor.")
                        reject(APIErrorResponse.ServerError)
                        return
                    }
                    //print("DATA SMS: \(data), \nResponse\(response), \(error)")
                    do{
                        let doc = try AEXMLDocument(xml: data!)
                        print("DATA SMS: \(doc.xml)")
                        if doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:success"].string == "true" && doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:servicesuccess"].string == "true"{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                            resolve(doc)
                        }else{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                            delegate?.didSendError(message: "El registro no es válido.", error: errorType.danger.rawValue)
                            delegate?.didSetServicioFolioError?(nil, doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:servicemessage"].string)
                            reject(serverError.runtimeError(doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:servicemessage"].string))
                        }
                    }catch{
                        delegate?.didSendError(message: "No se puedo obtener el XML.", error: errorType.danger.rawValue)
                        ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                        delegate?.didSetServicioFolioError?(nil, "No se pudo conectar al servidor.")
                        reject(serverError.runtimeError("Error al ejecutar el servicio."))
                    }
                })
                task.resume()
            }catch (let error){
                ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                delegate?.didSendError(message: "Se obtuvo un error: \(error).", error: errorType.danger.rawValue)
                reject(serverError.runtimeError("Error al ejecutar el servicio."))
            }
            
        }
        
    }
    
    
    func soapNewValidateSMSPromise(delegate: Delegate?, mParams mparams: [String], sParams sparams:[String]) -> Promise<AEXMLDocument>{
        
        return Promise<AEXMLDocument>{ resolve, reject in
            
            let mutableRequest: URLRequest
            do{
                mutableRequest = try request.soapNewValidateSMSRequest(mParams: mparams, sParams: sparams)
                let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                    guard data != nil && error == nil else {
                        delegate?.didSetServicioFolioError?(nil, "No se pudo conectar al servidor.")
                        reject(APIErrorResponse.ServerError)
                        return
                    }
                    //print("DATA SMS: \(data), \nResponse\(response), \(error)")
                    do{
                        let doc = try AEXMLDocument(xml: data!)
                        print("DATA SMS: \(doc.xml)")
                        if doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:success"].string == "true" && doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:servicesuccess"].string == "true"{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                            resolve(doc)
                        }else{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                            delegate?.didSendError(message: "El registro no es válido.", error: errorType.danger.rawValue)
                            delegate?.didSetServicioFolioError?(nil, doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:servicemessage"].string)
                            reject(serverError.runtimeError(doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:servicemessage"].string))
                        }
                    }catch{
                        delegate?.didSendError(message: "No se puedo obtener el XML.", error: errorType.danger.rawValue)
                        ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                        delegate?.didSetServicioFolioError?(nil, "No se pudo conectar al servidor.")
                        reject(serverError.runtimeError("Error al ejecutar el servicio."))
                    }
                })
                task.resume()
            }catch (let error){
                ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                delegate?.didSendError(message: "Se obtuvo un error: \(error).", error: errorType.danger.rawValue)
                reject(serverError.runtimeError("Error al ejecutar el servicio."))
            }
            
        }
        
    }
    
    
    
    func soapNewSepomexPromise(delegate: Delegate?, mParams mparams: [String], sParams sparams:[String]) -> Promise<AEXMLDocument>{
        
        return Promise<AEXMLDocument>{ resolve, reject in
            
            let mutableRequest: URLRequest
            do{
                mutableRequest = try request.soapNewSepomexRequest(mParams: mparams, sParams: sparams)
                let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                    guard data != nil && error == nil else {
                        delegate?.didSetServicioFolioError?(nil, "No se pudo conectar al servidor.")
                        reject(APIErrorResponse.ServerError)
                        return
                    }
                    //print("DATA SMS: \(data), \nResponse\(response), \(error)")
                    do{
                        let doc = try AEXMLDocument(xml: data!)
                        print("DATA SMS: \(doc.xml)")
                        if doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:success"].string == "true" && doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:servicesuccess"].string == "true"{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                            resolve(doc)
                        }else{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                            delegate?.didSendError(message: "El registro no es válido.", error: errorType.danger.rawValue)
                            delegate?.didSetServicioFolioError?(nil, doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:servicemessage"].string)
                            reject(serverError.runtimeError(doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:servicemessage"].string))
                        }
                    }catch{
                        delegate?.didSendError(message: "No se puedo obtener el XML.", error: errorType.danger.rawValue)
                        ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                        delegate?.didSetServicioFolioError?(nil, "No se pudo conectar al servidor.")
                        reject(serverError.runtimeError("Error al ejecutar el servicio."))
                    }
                })
                task.resume()
            }catch (let error){
                ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                delegate?.didSendError(message: "Se obtuvo un error: \(error).", error: errorType.danger.rawValue)
                reject(serverError.runtimeError("Error al ejecutar el servicio."))
            }
            
        }
        
    }
    
    
    
    
    func soapNewRegistroPromise(delegate: Delegate?, mParams mparams: [String], sParams sparams:[String]) -> Promise<AEXMLDocument>{
        
        return Promise<AEXMLDocument>{ resolve, reject in
            
            let mutableRequest: URLRequest
            do{
                mutableRequest = try request.soapNewRegistroRequest(mParams: mparams, sParams: sparams)
                let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                    guard data != nil && error == nil else {
                        delegate?.didSetServicioFolioError?(nil, "No se pudo conectar al servidor.")
                        reject(APIErrorResponse.ServerError)
                        return
                    }
                    //print("DATA SMS: \(data), \nResponse\(response), \(error)")
                    do{
                        let doc = try AEXMLDocument(xml: data!)
                        print("DATA SMS: \(doc.xml)")
                        if doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:success"].string == "true" && doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:servicesuccess"].string == "true"{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                            resolve(doc)
                        }else{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                            delegate?.didSendError(message: "El registro no es válido.", error: errorType.danger.rawValue)
                            delegate?.didSetServicioFolioError?(nil, doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:servicemessage"].string)
                            reject(serverError.runtimeError(doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:servicemessage"].string))
                        }
                    }catch{
                        delegate?.didSendError(message: "No se puedo obtener el XML.", error: errorType.danger.rawValue)
                        ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                        delegate?.didSetServicioFolioError?(nil, "No se pudo conectar al servidor.")
                        reject(serverError.runtimeError("Error al ejecutar el servicio."))
                    }
                })
                task.resume()
            }catch (let error){
                ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                delegate?.didSendError(message: "Se obtuvo un error: \(error).", error: errorType.danger.rawValue)
                reject(serverError.runtimeError("Error al ejecutar el servicio."))
            }
            
        }
        
    }
    
    
    
    func soapNewActivacionCorreoPromise(delegate: Delegate?, mParams mparams: [String], sParams sparams:[String]) -> Promise<AEXMLDocument>{
        
        return Promise<AEXMLDocument>{ resolve, reject in
            
            let mutableRequest: URLRequest
            do{
                mutableRequest = try request.soapNewActivacionCorreoRequest(mParams: mparams, sParams: sparams)
                let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                    guard data != nil && error == nil else {
                        delegate?.didSetServicioFolioError?(nil, "No se pudo conectar al servidor.")
                        reject(APIErrorResponse.ServerError)
                        return
                    }
                    //print("DATA SMS: \(data), \nResponse\(response), \(error)")
                    do{
                        let doc = try AEXMLDocument(xml: data!)
                        print("DATA SMS: \(doc.xml)")
                        if doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:success"].string == "true" && doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:servicesuccess"].string == "true"{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                            resolve(doc)
                        }else{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                            delegate?.didSendError(message: "El registro no es válido.", error: errorType.danger.rawValue)
                            delegate?.didSetServicioFolioError?(nil, doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:servicemessage"].string)
                            reject(serverError.runtimeError(doc["s:Envelope"]["s:Body"]["ServicioGenericoResponse"]["ServicioGenericoResult"]["a:response"]["a:servicemessage"].string))
                        }
                    }catch{
                        delegate?.didSendError(message: "No se puedo obtener el XML.", error: errorType.danger.rawValue)
                        ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                        delegate?.didSetServicioFolioError?(nil, "No se pudo conectar al servidor.")
                        reject(serverError.runtimeError("Error al ejecutar el servicio."))
                    }
                })
                task.resume()
            }catch (let error){
                ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                delegate?.didSendError(message: "Se obtuvo un error: \(error).", error: errorType.danger.rawValue)
                reject(serverError.runtimeError("Error al ejecutar el servicio."))
            }
            
        }
        
    }
    
    
    
    
    
    func soapFolioPromise(delegate: Delegate?, folio: FolioAutomaticoResult) -> Promise<AjaxResponse>{
        
        return Promise<AjaxResponse>{ resolve, reject in
            
            let mutableRequest: URLRequest
            do{
                mutableRequest = try request.soapFolioRequest(folio: folio)
                let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                    guard data != nil && error == nil else {
                        delegate?.didSetServicioFolioError?(nil, "No se pudo conectar al servidor.")
                        reject(APIErrorResponse.ServerError)
                        return
                    }
                    do{
                        let doc = try AEXMLDocument(xml: data!)
                        let getCodeResult = doc["s:Envelope"]["s:Body"]["FolioAutomaticoResponse"]["FolioAutomaticoResult"].string
                        let response = AjaxResponse(json: getCodeResult)
                        if(response.Success){
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                            ConfigurationManager.shared.utilities.writeLogger("Se ha validado el registro del usuario.\r\n", "log.txt")
                            let mensajeResultado = FolioAutomaticoResult(dictionary: response.ReturnedObject!)
                            delegate?.didSetServicioFolio?(mensajeResultado, response.Mensaje)
                            resolve(response)
                        }else{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                            delegate?.didSendError(message: "El registro no es válido.", error: errorType.danger.rawValue)
                            delegate?.didSetServicioFolioError?(nil, response.Mensaje)
                            reject(serverError.runtimeError("\(response.Mensaje)"))
                        }
                    }catch{
                        delegate?.didSendError(message: "No se puedo obtener el XML.", error: errorType.danger.rawValue)
                        ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                        delegate?.didSetServicioFolioError?(nil, "No se pudo conectar al servidor.")
                        reject(serverError.runtimeError("Error al ejecutar el servicio."))
                    }
                })
                task.resume()
            }catch (let error){
                ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                delegate?.didSendError(message: "Se obtuvo un error: \(error).", error: errorType.danger.rawValue)
                reject(serverError.runtimeError("Error al ejecutar el servicio."))
            }
            
        }
        
    }
    
    func soapSMSPromise(delegate: Delegate?, sms: SmsServicio) -> Promise<AjaxResponse>{
        
        return Promise<AjaxResponse>{ resolve, reject in
            
            let mutableRequest: URLRequest
            do{
                debugPrint("\n SMS BODY: \(sms) \n")
                mutableRequest = try request.soapSMSRequest(sms: sms)
                let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                    guard data != nil && error == nil else {
                        reject(APIErrorResponse.ServerError)
                        return
                    }
                    do{
                        let doc = try AEXMLDocument(xml: data!)
                        let getCodeResult = doc["s:Envelope"]["s:Body"]["SendSmsResponse"]["SendSmsResult"].string
                        debugPrint("BODY SOAP: \(getCodeResult)")
                        let response = AjaxResponse(json: getCodeResult)
                        if(response.Success){
                            debugPrint("RESPONSE SMS PROMISE: \(response)")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                            let _ = SmsServicio(dictionary: response.ReturnedObject!)
                            ConfigurationManager.shared.utilities.writeLogger("Se ha validado el registro del usuario via sms.\r\n", "log.txt")
                            resolve(response)
                        }else{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                            reject(APIErrorResponse.SMSOnlineError)
                        }
                        
                    }catch{
                        ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                        reject(APIErrorResponse.SMSOnlineError)
                    }
                })
                task.resume()
            }catch (let error){
                ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                reject(APIErrorResponse.SMSOnlineError)
            }
            
        }
        
    }
    
    func soapValidateSMSPromise(delegate: Delegate?, sms: SmsServicio) -> Promise<AjaxResponse>{
        
        return Promise<AjaxResponse>{ resolve, reject in
            
            let mutableRequest: URLRequest
            do{
                mutableRequest = try request.soapValidateSMSRequest(sms: sms)
                let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                    guard data != nil && error == nil else {
                        reject(APIErrorResponse.ServerError)
                        return
                    }
                    do{
                        let doc = try AEXMLDocument(xml: data!)
                        let getCodeResult = doc["s:Envelope"]["s:Body"]["ValidateSmsCodeResponse"]["ValidateSmsCodeResult"].string
                        let response = AjaxResponse(json: getCodeResult)
                        if(response.Success){
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                            let _ = SmsServicio(dictionary: response.ReturnedObject!)
                            ConfigurationManager.shared.utilities.writeLogger("Se ha validado el registro del usuario via sms.\r\n", "log.txt")
                            resolve(response)
                        }else{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                            reject(APIErrorResponse.SMSOnlineError)
                        }
                    }catch{
                        ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                        reject(APIErrorResponse.SMSOnlineError)
                    }
                    
                })
                task.resume()
            }catch (let error){
                ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                reject(APIErrorResponse.SMSOnlineError)
            }
            
        }
        
    }
    
    func soapCorreoPromise(delegate: Delegate?, correo: CorreoServicio) -> Promise<AjaxResponse>{
        
        return Promise<AjaxResponse>{ resolve, reject in
            
            let mutableRequest: URLRequest
            do{
                mutableRequest = try request.soapCorreoRequest(correo: correo)
                let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                    guard data != nil && error == nil else {
                        reject(APIErrorResponse.ServerError)
                        return
                    }
                    do{
                        let doc = try AEXMLDocument(xml: data!)
                        let getCodeResult = doc["s:Envelope"]["s:Body"]["SendMailResponse"]["SendMailResult"].string
                        let response = AjaxResponse(json: getCodeResult)
                        if(response.Success){
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                            let _ = CorreoServicio(dictionary: response.ReturnedObject!)
                            ConfigurationManager.shared.utilities.writeLogger("Se ha validado el registro del usuario via sms.\r\n", "log.txt")
                            resolve(response)
                        }else{
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                            reject(APIErrorResponse.SMSOnlineError)
                        }
                    }catch{
                        ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                        reject(APIErrorResponse.SMSOnlineError)
                    }
                    
                    
                })
                task.resume()
            }catch (let error){
                ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                reject(APIErrorResponse.SMSOnlineError)
            }
            
        }
        
    }
    
}

// TODO: -
// MARK: - Extra services

public extension APIManager{
    
    func getInfoFormatoCellPromise(delegate: Delegate?, formato: FEFormatoData) -> Promise<[(id: String, valor: String)]>{
        
        return Promise<[(id: String, valor: String)]>{ resolve, reject in
            
            DispatchQueue.global(qos: .background).async {
                
                var objectResumen: [(id: String, valor: String, orden: Int)] = [(id: String, valor: String, orden: Int)]()
                var resumen: [(id: String, valor: String)] = [(id: "", valor: ""), (id: "", valor: ""), (id: "", valor: ""), (id: "", valor: "")]
                
                let xml = self.getXML(flujo: String(formato.FlujoID), exp: String(formato.ExpID), doc: String(formato.TipoDocID))
                
                for element in (xml.elementos?.elemento)!{
                    guard (element.atributos as? Atributos_pagina) != nil else{
                        reject(ErrorPromise.rejectError)
                        return
                    }
                    if element.elementos != nil{
                        for object in (element.elementos?.elemento)! {
                            let atributos = object.toDictionary()
                            let attr = atributos["atributos"] as! [String : AnyObject]
                            if attr["usarcomocampoexterno"] as? Bool != nil {
                                objectResumen.append((id: object._idelemento, valor: attr["titulo"] as? String ?? "", orden: attr["ordenenresumen"] as! Int))
                            }
                            
                        }
                    }
                    
                }
                
                if objectResumen.count > 0{
                    do{
                        let customJson = formato.JsonDatos.replacingOccurrences(of: "\r\n", with: ",")
                        let dict = try JSONSerializer.toDictionary(customJson)
                        for dato in dict{
                            let dictValor = dato.value as! NSMutableDictionary
                            let valor = dictValor.value(forKey: "valor") as? String ?? ""
                            for equal in objectResumen{
                                if dato.key as! String == equal.id{
                                    if equal.orden < 4{
                                        resumen.insert((id: "\(dato.key)", valor: valor), at: equal.orden)
                                    }
                                }
                            }
                        }
                    }catch{
                        reject(ErrorPromise.rejectError)
                    }
                }
                
                resolve(resumen)
                
            }
            
        }
        
    }
    
}


// MARK: -
// MARK: - LOGALTY SERVICES

extension APIManager{
    
    func sendFormatoDataLogaltyPromise(delegate: Delegate?, formato: FEConsultaFormato) -> Promise<FELogaltySaml>{
        
        return Promise<FELogaltySaml>{ resolve, reject in
            
            let mutableRequest: URLRequest
            
            DispatchQueue.main.async() {
                delegate?.didSendResponseHUD(message: "Enviando formato: \(formato.Formato.Guid)", error: errorType.danger.rawValue, porcentage: 0)
                ConfigurationManager.shared.console.addTextConsole("ENVIANDO formato: \(formato.Formato.NombreExpediente) | \(formato.Formato.Guid)", "log")
            }
            
            do{
                mutableRequest = try request.sendFormatosRequestLogalty(formato: formato)
                let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                    guard data != nil && error == nil else {
                        reject(APIErrorResponse.ServerError)
                        return
                    }
                    do{
                        let doc = try AEXMLDocument(xml: data!)
                        let getCodeResult = doc["s:Envelope"]["s:Body"]["GeneraPeticionLogaltyResponse"]["GeneraPeticionLogaltyResult"].string
                        let bodyData = Data(base64Encoded: getCodeResult)!
                        let decompressedData: Data
                        if bodyData.isGzipped {
                            decompressedData = try! bodyData.gunzipped()
                        } else {
                            decompressedData = bodyData
                        }
                        let decodedString = String(data: decompressedData, encoding: .utf8)!
                        let response = AjaxResponse(json: decodedString)
                        if(response.Success){
                            DispatchQueue.main.async {
                                ConfigurationManager.shared.console.addTextConsole("Formato enviado.", "log")
                                ConfigurationManager.shared.console.addTextConsole("Mensaje del servidor: \(response.Mensaje)", "log")
                            }
                            // FORMATO POR BORRAR
                            let SANDBOX_FORMATO = FELogaltySaml(dictionary: response.ReturnedObject!)
                            
                            let feLogaltySaml = FELogaltySaml()
                            feLogaltySaml.Uuid = SANDBOX_FORMATO.Uuid
                            feLogaltySaml.Guid = SANDBOX_FORMATO.Guid
                            feLogaltySaml.Url = SANDBOX_FORMATO.Url
                            feLogaltySaml.GuidFormato = formato.Formato.Guid
                           
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                            resolve(feLogaltySaml)
                        }else{
                            DispatchQueue.main.async() {
                                ConfigurationManager.shared.console.addTextConsole("Error el enviar el formato.", "error")
                                ConfigurationManager.shared.console.addTextConsole("Mensaje del servidor: \(response.Mensaje)", "error")
                            }
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                            reject(APIErrorResponse.FormatosOnlineError)
                        }
                    }catch{
                        DispatchQueue.main.async() {
                            ConfigurationManager.shared.console.addTextConsole("Hubo un error en la respuesta del servidor.", "error")
                        }
                        ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                        reject(APIErrorResponse.ServerError)
                    }
                })
                task.resume()
            }catch (let error){
                ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                reject(APIErrorResponse.ServerError)
            }
            
        }
        
    }
    
    func sendFormatoDataLogaltyEndPromise(delegate: Delegate?, formato: FELogaltySaml) -> Promise<FELogaltySaml>{
        
        return Promise<FELogaltySaml>{ resolve, reject in
            
            let mutableRequest: URLRequest
            
            DispatchQueue.main.async() {
                delegate?.didSendResponseHUD(message: "Enviando formato: \(formato.Guid)", error: errorType.danger.rawValue, porcentage: 0)
                ConfigurationManager.shared.console.addTextConsole("ENVIANDO formato: \(formato.Uuid) | \(formato.Guid)", "log")
            }
            
            do{
                mutableRequest = try request.sendFormatosRequestEndLogalty(formato: formato)
                let task = URLSession.shared.dataTask(with: mutableRequest, completionHandler: {(data, response, error) in
                    guard data != nil && error == nil else {
                        reject(APIErrorResponse.ServerError)
                        return
                    }
                    do{
                        let doc = try AEXMLDocument(xml: data!)
                        let getCodeResult = doc["s:Envelope"]["s:Body"]["TerminaProcesoLogaltyResponse"]["TerminaProcesoLogaltyResult"].string
                        let bodyData = Data(base64Encoded: getCodeResult)!
                        let decompressedData: Data
                        if bodyData.isGzipped {
                            decompressedData = try! bodyData.gunzipped()
                        } else {
                            decompressedData = bodyData
                        }
                        let decodedString = String(data: decompressedData, encoding: .utf8)!
                        let response = AjaxResponse(json: decodedString)
                        if(response.Success){
                            DispatchQueue.main.async {
                                ConfigurationManager.shared.console.addTextConsole("Formato enviado.", "log")
                                ConfigurationManager.shared.console.addTextConsole("Mensaje del servidor: \(response.Mensaje)", "log")
                            }
                            // FORMATO POR BORRAR
                            let _ = FELogaltySaml(dictionary: response.ReturnedObject!)
                            
                            // GUARDAR Objetos PDF y CERT

                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta fué exitoso.\r\n", "log.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "log.txt")
                            resolve(formato)
                        }else{
                            DispatchQueue.main.async() {
                                ConfigurationManager.shared.console.addTextConsole("Error el enviar el formato.", "error")
                                ConfigurationManager.shared.console.addTextConsole("Mensaje del servidor: \(response.Mensaje)", "error")
                            }
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje de respuesta es erróneo.\r\n", "error.txt")
                            ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(response.Success) | \(response.Mensaje)\r\n", "error.txt")
                            reject(APIErrorResponse.FormatosOnlineError)
                        }
                    }catch{
                        DispatchQueue.main.async() {
                            ConfigurationManager.shared.console.addTextConsole("Hubo un error en la respuesta del servidor.", "error")
                        }
                        ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                        reject(APIErrorResponse.ServerError)
                    }
                })
                task.resume()
            }catch (let error){
                ConfigurationManager.shared.utilities.writeLogger("La respuesta del servidor es errónea.\r\n", "error.txt")
                ConfigurationManager.shared.utilities.writeLogger("El mensaje fué: \(error) \r\n", "error.txt")
                reject(APIErrorResponse.ServerError)
            }
            
        }
        
    }
    
}
