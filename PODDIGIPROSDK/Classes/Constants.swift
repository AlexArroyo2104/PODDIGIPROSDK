//
//  Constants.swift
//  DigiproEssentials
//
//  Created by Jonathan Viloria M on 4/18/19.
//  Copyright © 2019 Jonathan Viloria M. All rights reserved.
//

import Foundation
import UserNotifications
import CFNetwork
import SystemConfiguration
import LocalAuthentication

// MARK: - Global Constants
public struct Cnstnt{
    
    public struct Path{
        
        public static let main = Bundle(identifier: "com.digipro.movil")
        public static let ui = Bundle(identifier: "com.digipro.movil.DIGIPROSDKUI")
        public static let framework = Bundle(identifier: "com.digipro.movil.DIGIPROSDK")
        public static let so = Bundle(identifier: "com.digipro.movil.DIGIPROSDKSO")
        public static let sso = Bundle(identifier: "com.digipro.movil.DIGIPROSDKSSO")
        public static let ato = Bundle(identifier: "com.digipro.movil.DIGIPROSDKATO")
        public static let fo = Bundle(identifier: "com.digipro.movil.DIGIPROSDKFO")
        public static let vo = Bundle(identifier: "com.digipro.movil.DIGIPROSDKVO")
    }
    
    public struct Conf{
        
        // Configuration
        public static let version = "1.22"
        public static let bundle = "9"
        public static let validacion = "Sin configuración"
        
    }
    
    public struct Tree{
        
        // Folder & Files Structure
        public static let main = "Digipro"
        public static let collector = "\(Cnstnt.Tree.main)/Collector"
        public static let codigos = "\(Cnstnt.Tree.main)/Codigos"
        public static let usuarios = "\(Cnstnt.Tree.main)/Usuarios"
        public static let anexos = "\(Cnstnt.Tree.main)/Anexos"
        public static let presets = "\(Cnstnt.Tree.main)/Presets"
        public static let customBorrador = "\(Cnstnt.Tree.main)/Borrador"
        
        public static let plantillas = "Plantillas"
        public static let formatos = "Formatos"
        public static let catalogos = "Catalogos"
        
        public static let imageProfile = "\(Cnstnt.Tree.anexos)/ImageProfile"
        
        public static let logs = "\(Cnstnt.Tree.main)/Logs"
        
    }
    
    public struct BundlePrf{
        
        public static let version = "version_preference"
        public static let bundle = "bundle_preference"
        public static let validacion = "estado_validacion"
        public static let delete = "delete_data_preference"
        
        public static let serial = "serial_developer"
        public static let data = "data_preference"
        public static let log = "data_log"
        
        public static let image = "img_saved"
        public static let print = "huellas_saved"
        public static let sign = "firm_saved"
        public static let video = "video_saved"
        public static let audio = "audio_saved"
        public static let map = "map_saved"
        public static let face = "face_saved"
        
        public static let codigo = "codigo_preference"
        public static let usuario = "usuario_preference"
        
        public static let nombre = "nombre_validacion"
        public static let paterno = "apellido_paterno_validacion"
        public static let materno = "apellido_materno_validacion"
        public static let email = "correo_electronico_validacion"
        public static let tel = "telefono_celular_validacion"
        public static let estado = "estado_validacion"
        
        public static let tutorial = "data_tutorial"
        public static let touchid = "touchid_auth"
        
        public static let licenceCode = "licence_code"
        public static let licenceUser = "licence_user"
        public static let licenceMode = "mode_app"
        
    }
    
    public struct ThemeDefault{
        public static let blueHex = UIColor(hexString: "#00B2F2")
        public static let blueRGB = UIColor(red: 0/255, green: 178/255, blue: 242/255, alpha: 1.0)
        
        public static let greenHex = UIColor(hexString: "#68B848")
        public static let greenRGB = UIColor(red: 104/255, green: 184/255, blue: 72/255, alpha: 1.0)
        
        public static let grayHex = UIColor(hexString: "#E8ECEE")
        public static let grayRGB = UIColor(red: 232/255, green: 236/255, blue: 238/255, alpha: 1.0)
        
        public static let blackHex = UIColor(hexString: "#000000")
        public static let blackRGB = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        
        public static let blueDarkHex = UIColor(hexString: "#011520")
        public static let blueDarkRGB = UIColor(red: 1/255, green: 21/255, blue: 32/255, alpha: 1.0)
        
        public static let redHex = UIColor(hexString: "#D3342C")
        public static let redRGB = UIColor(red: 211/255, green: 52/255, blue: 44/255, alpha: 1.0)
        
        public static let socialBlueHex = UIColor(hexString: "#374E8A")
        public static let socialBlueRGB = UIColor(red: 55/255, green: 78/255, blue: 138/255, alpha: 1.0)
        
        public static let socialGreenHex = UIColor(hexString: "#266497")
        public static let socialGreenRGB = UIColor(red: 38/255, green: 100/255, blue: 151/255, alpha: 1.0)
    }
    
}

// MARK: - API Configuration
public class ConfigurationManager{
    
    public static let shared = ConfigurationManager()
    
    public var uiapplication: UIApplication?
    public var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
    public var isCodePresented = false
    public var isInitiated = false
    
    public var isShortcutItemLaunchActived = false
    
    public var hasNewFormat = false
    public var isConsubanco = false
    public var isNotification = false
    
    public var deviceToken = ""
    
    // All public variables from file structure
    public var licenciaUIAppDelegate = FELicencia()
    public var codigoUIAppDelegate = FECodigo()
    public var skinUIAppDelegate = FEAppSkin()
    public var usuarioUIAppDelegate = FEUsuario()
    public var plantillaUIAppDelegate = FEConsultaPlantilla()
    public var plantillaDataUIAppDelegate = FEPlantillaData()
    public var variablesUIAppDelegate = FEConsultaVariable()
    public var variablesDataUIAppDelegate = FEVariablesData()
    public var registroUIAppDelegate = FERegistro()
    public var consultasUIAppDelegate = Array<FETipoReporte>()
    public var flujosOrdered = Array<FEPlantillaMerge>()
    public var procesosOrdered = Array<FEProcesos>()
    public var utilities = Utilities()
    
    // Console for uploading formats and attachments
    public var viewConsole: UIView?
    public var textConsole: UITextView?
    public var console = Console()
    
    // Garbage Collector
    public var garbageCollector = [(id: String, value: String, desc: String)]()
    
    // public guid for attachments
    public var guid = ""
    public var longitud = ""
    public var latitud = ""
    
    // IPAD ambient
    public var isLoading = false
    public var isContentDownloaded = false
    
    // public init
    public init(){}
    
    public func configure(){
        ConfigurationManager.shared.utilities.resetAppForNewVersion()
        ConfigurationManager.shared.utilities.settingFolderTree()
        ConfigurationManager.shared.utilities.detectResources()
        ConfigurationManager.shared.utilities.detectFrameworks()
        ConfigurationManager.shared.utilities.registerNotification(0)
        ConfigurationManager.shared.utilities.registerShorcutItems()
        ConfigurationManager.shared.utilities.setEVReflection()
        ConfigurationManager.shared.utilities.settingGlobalPreferencesInfo()
    }
    
}

// MARK: - Functions Utilities
public struct Utilities{
    
    public func resetAppForNewVersion(){
        // Getting old version of app
        let getUsers = FCFileManager.listDirectoriesInDirectory(atPath: "Digipro/Usuarios/")
        for user in getUsers!{
            let codigoUsuario = (user as! String).split{$0 == "/"}.map(String.init)
            let formatos = FCFileManager.listFilesInDirectory(atPath: "Digipro/Usuarios/\(codigoUsuario.last!)/Formatos/")
            if (formatos?.count)! > 0{
                FCFileManager.removeItem(atPath: "Digipro/")
                break
            }
        }
        let folderAnexo = FCFileManager.existsItem(atPath: "Digipro/Anexos/Imagenes/")
        if folderAnexo{
            FCFileManager.removeItem(atPath: "Digipro/")
        }
    }
    
    public func setEVReflection(){
        EVReflection.setBundleIdentifier(Atributos.self)
        EVReflection.setBundleIdentifier(Atributos_formula.self)
        EVReflection.setBundleIdentifier(Eventos.self)
        EVReflection.setBundleIdentifier(Expresion.self)
        EVReflection.setBundleIdentifier(Atributos_Expresion.self)
        EVReflection.setBundleIdentifier(Elemento.self)
        EVReflection.setBundleIdentifier(Elementos.self)
        EVReflection.setBundleIdentifier(Validacion.self)
        EVReflection.setBundleIdentifier(FECodigo.self)
        EVReflection.setBundleIdentifier(FECatalogo.self)
        EVReflection.setBundleIdentifier(FEAppSkinSplash.self)
        EVReflection.setBundleIdentifier(FEConsultaPlantilla.self)
        EVReflection.setBundleIdentifier(FEItemCatalogoEsquema.self)
        EVReflection.setBundleIdentifier(FEVariablesData.self)
        EVReflection.setBundleIdentifier(FEEstadistica.self)
        EVReflection.setBundleIdentifier(FEConsultaAnexo.self)
        EVReflection.setBundleIdentifier(FEPlantillaData.self)
        EVReflection.setBundleIdentifier(FEItemCatalogo.self)
        EVReflection.setBundleIdentifier(FEFormatoData.self)
        EVReflection.setBundleIdentifier(FEConsultaVariable.self)
        EVReflection.setBundleIdentifier(FELicencia.self)
        EVReflection.setBundleIdentifier(FERegistro.self)
        EVReflection.setBundleIdentifier(FEAnexoData.self)
        EVReflection.setBundleIdentifier(FEUsuario.self)
        EVReflection.setBundleIdentifier(FEVariableData.self)
        EVReflection.setBundleIdentifier(FEAppSkinLogin.self)
        EVReflection.setBundleIdentifier(FEEventosFlujo.self)
        EVReflection.setBundleIdentifier(FEAppSkin.self)
        EVReflection.setBundleIdentifier(FESkin.self)
        EVReflection.setBundleIdentifier(FEConsultaFormato.self)
        EVReflection.setBundleIdentifier(FETipoReporte.self)
        EVReflection.setBundleIdentifier(FECampoReporte.self)
        EVReflection.setBundleIdentifier(FELogError.self)
        EVReflection.setBundleIdentifier(AjaxResponse.self)
        EVReflection.setBundleIdentifier(FolioAutomaticoResult.self)
        EVReflection.setBundleIdentifier(FolioResponse.self)
        EVReflection.setBundleIdentifier(HuellaDigitalRespuesta.self)
        EVReflection.setBundleIdentifier(FingerPrintsData.self)
        EVReflection.setBundleIdentifier(CaptureDateData.self)
        EVReflection.setBundleIdentifier(FingerImpressionImageData.self)
        EVReflection.setBundleIdentifier(IneResultOcrFormulas.self)
        EVReflection.setBundleIdentifier(IneResultOcr.self)
        EVReflection.setBundleIdentifier(SmsServicio.self)
        EVReflection.setBundleIdentifier(CorreoServicio.self)
    }
    
    public func detectResources(){
        /*guard Bundle.main.path(forResource: "Settings", ofType: "bundle") != nil else {
            NSLog("El archivo Settings.Bundle no se encuentra en la aplicación, favor de agregar el archivo así como su parámetros necesarios para el buen funcionamiento descritos en el manual de instalación.")
            fatalError("No se encuentra el archivo Settings.bundle")
        }
        guard Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil else {
            NSLog("El archivo Settings.Bundle no se encuentra en la aplicación, favor de agregar el archivo así como su parámetros necesarios para el buen funcionamiento descritos en el manual de instalación.")
            fatalError("No se encuentra el archivo Settings.bundle")
        }*/
    }
    
    // MARK: - Detect if frameworks exists
    public func detectFrameworks(){
        
    }
    
    // MARK: - Register App for Push Notifications
    public func registerNotification(_ number: Int){
        let badgeCount: Int = 0
        let application = UIApplication.shared
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // TODO: - Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
        application.applicationIconBadgeNumber = badgeCount
    }
    
    
    
    // MARK: - Register shorcut items for the app
    public func registerShorcutItems(){
        if let shortcutItem = ConfigurationManager.shared.launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            if shortcutItem.type == "nuevo.formato" {
                ConfigurationManager.shared.isShortcutItemLaunchActived = true
            }
        }
    }
    
    // MARK: - Restart all services
    public func restartAllServices(){
        // This is to restore and reset Workflow in App for security reasons
        ConfigurationManager.shared.isCodePresented = false
        ConfigurationManager.shared.isInitiated = false
        ConfigurationManager.shared.skinUIAppDelegate = FEAppSkin()
        ConfigurationManager.shared.usuarioUIAppDelegate = FEUsuario()
        ConfigurationManager.shared.plantillaUIAppDelegate = FEConsultaPlantilla()
        ConfigurationManager.shared.plantillaDataUIAppDelegate = FEPlantillaData()
    }
    
    // MARK: - Check Preferences
    public func checkPreferences(){
        ConfigurationManager.shared.utilities.writeLogger("------\r\n", "log.txt")
        ConfigurationManager.shared.utilities.writeLogger("Inicializando preferencias del sistema.\r\n", "log.txt")
        
        // Setting app Defaults
        let defaults = UserDefaults.standard
        defaults.set(Cnstnt.Conf.version,           forKey: Cnstnt.BundlePrf.version)
        defaults.set(Cnstnt.Conf.bundle,            forKey: Cnstnt.BundlePrf.bundle)
        defaults.set(Cnstnt.Conf.validacion,        forKey: Cnstnt.BundlePrf.validacion)
        defaults.synchronize()
        
        // Detecting if we need to delete all data of the App no matter the user, clear all up
        let reset = defaults.bool(forKey: Cnstnt.BundlePrf.delete)
        if(reset){
            // We need to reset all to defaults and erase all data
            ConfigurationManager.shared.isCodePresented = false
            ConfigurationManager.shared.isInitiated = false
            
            ConfigurationManager.shared.codigoUIAppDelegate = FECodigo()
            ConfigurationManager.shared.skinUIAppDelegate = FEAppSkin()
            ConfigurationManager.shared.usuarioUIAppDelegate = FEUsuario()
            ConfigurationManager.shared.plantillaUIAppDelegate = FEConsultaPlantilla()
            ConfigurationManager.shared.plantillaDataUIAppDelegate = FEPlantillaData()
            
            defaults.set("", forKey:        Cnstnt.BundlePrf.serial)
            defaults.set("0", forKey:       Cnstnt.BundlePrf.data)
            defaults.set("0", forKey:       Cnstnt.BundlePrf.log)
            
            defaults.set("0", forKey:       Cnstnt.BundlePrf.image)
            defaults.set("0", forKey:       Cnstnt.BundlePrf.print)
            defaults.set("0", forKey:       Cnstnt.BundlePrf.sign)
            defaults.set("0", forKey:       Cnstnt.BundlePrf.video)
            defaults.set("0", forKey:       Cnstnt.BundlePrf.audio)
            defaults.set("0", forKey:       Cnstnt.BundlePrf.map)
            defaults.set("0", forKey:       Cnstnt.BundlePrf.face)
            
            defaults.set("", forKey:        Cnstnt.BundlePrf.codigo)
            defaults.set("", forKey:        Cnstnt.BundlePrf.usuario)
            
            defaults.set("", forKey:        Cnstnt.BundlePrf.nombre)
            defaults.set("", forKey:        Cnstnt.BundlePrf.paterno)
            defaults.set("", forKey:        Cnstnt.BundlePrf.materno)
            defaults.set("", forKey:        Cnstnt.BundlePrf.email)
            defaults.set("", forKey:        Cnstnt.BundlePrf.tel)
            defaults.set("", forKey:        Cnstnt.BundlePrf.estado)
            
            defaults.set("YES", forKey:     Cnstnt.BundlePrf.tutorial)
            defaults.set("NO", forKey:      Cnstnt.BundlePrf.touchid)
            
            defaults.set("", forKey:        Cnstnt.BundlePrf.serial)
            
            if ConfigurationManager.shared.isConsubanco{
                defaults.set("CSBPRO", forKey:        Cnstnt.BundlePrf.licenceCode)
            }else{
                defaults.set("", forKey:        Cnstnt.BundlePrf.licenceCode)
            }
            defaults.set("", forKey:        Cnstnt.BundlePrf.licenceUser)
            defaults.set("Normal", forKey:  Cnstnt.BundlePrf.licenceMode)
            
            defaults.synchronize()
            
            FCFileManager.removeItem(atPath: "\(Cnstnt.Tree.main)")
            ConfigurationManager.shared.utilities.writeLogger("Reiniciando preferencias del sistema.\r\n", "log.txt")
        }
        
        guard let _ = defaults.string(forKey: Cnstnt.BundlePrf.serial) else{
            defaults.set("Indefinido", forKey: Cnstnt.BundlePrf.serial)
            defaults.synchronize()
            return
        }
    }
    
    // MARK: - Get IP Address
    public func getIPAddress() -> String {
        var wifiIp = ""
        let allInterface = Interface.allInterfaces()
        for interf in allInterface {
            if interf.name == "en0" && interf.family == Interface.Family.ipv4 {
                if let address = interf.address {
                    wifiIp = address
                    return wifiIp
                }
            }
        }
        return "0.0.0.0"
    }
    
    // MARK: - Check Internet Connection
    
    public func isConnectedToNetwork() -> Promise<Bool> {
        
        return Promise<Bool>{ resolve, reject in
            
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                    SCNetworkReachabilityCreateWithAddress(nil, $0)
                }
            }) else {
                reject(InternetConnectionError.NoConnected)
                return
            }
            
            var flags: SCNetworkReachabilityFlags = []
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
                reject(InternetConnectionError.NoConnected)
            }
            if flags.isEmpty {
                reject(InternetConnectionError.NoConnected)
            }
            
            let isReachable = flags.contains(.reachable)
            let needsConnection = flags.contains(.connectionRequired)
            
            resolve((isReachable && !needsConnection))
        }
        
    }
    
    // MARK: - REFRESH|UPDATE Folder capacity
    public func refreshFolderCapacity(){
        
        let codigoFolderExists = FCFileManager.existsItem(atPath: "\(Cnstnt.Tree.codigos)")
        let usuarioFolderExists = FCFileManager.existsItem(atPath: "\(Cnstnt.Tree.usuarios)")
        let anexosFolderExists = FCFileManager.existsItem(atPath: "\(Cnstnt.Tree.anexos)")
        
        let codigoSizeFolder = FCFileManager.sizeOfDirectory(atPath: "\(Cnstnt.Tree.codigos)")
        let usuarioSizeFolder = FCFileManager.sizeOfDirectory(atPath: "\(Cnstnt.Tree.usuarios)")
        let anexoSizeFolder = FCFileManager.sizeOfDirectory(atPath: ".\(Cnstnt.Tree.anexos)")
        
        let codigosSize: Int64
        if codigoFolderExists && codigoSizeFolder != nil{
            codigosSize = Int64(truncating: codigoSizeFolder!) }else{ codigosSize = Int64(0) }
        let usuariosSize: Int64
        if usuarioFolderExists && usuarioSizeFolder != nil{
            usuariosSize = Int64(truncating: usuarioSizeFolder!) }else{ usuariosSize = Int64(0) }
        let anexosSize: Int64
        if anexosFolderExists && anexoSizeFolder != nil{
            anexosSize = Int64(truncating: anexoSizeFolder!) }else{ anexosSize = Int64(0) }
        let fileSizeWithUnit = ByteCountFormatter.string(fromByteCount: (codigosSize + usuariosSize + anexosSize), countStyle: .file)
        let defaults = UserDefaults.standard
        
        defaults.set(fileSizeWithUnit, forKey: Cnstnt.BundlePrf.data)
        
        defaults.synchronize()
        ConfigurationManager.shared.utilities.writeLogger("Actualizando el tamaño de los archivos en la app: \(fileSizeWithUnit).\r\n", "log.txt")
        
        refreshFileLogCapacity()
        
        return
    }
    
    public func settingGlobalPreferencesInfo(){
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = UIColor.black
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
        EasyTipView.globalPreferences = preferences
    }
    
    public func refreshFileLogCapacity(){
        let logFileExists = FCFileManager.existsItem(atPath: "\(Cnstnt.Tree.logs)/log.txt")
        let logFileSize: Int64
        if logFileExists {
            logFileSize = Int64(truncating: FCFileManager.sizeOfFile(atPath: "\(Cnstnt.Tree.logs)/log.txt"))
        } else { logFileSize = Int64(0) }
        let fileSizeWithUnit = ByteCountFormatter.string(fromByteCount: (logFileSize), countStyle: .file)
        let defaults = UserDefaults.standard
        defaults.set(fileSizeWithUnit, forKey: Cnstnt.BundlePrf.log)
        defaults.synchronize()
        
        ConfigurationManager.shared.utilities.writeLogger("Actualizando el tamaño de los logs en la app: \(fileSizeWithUnit).\r\n", "log.txt")
        
        return
    }
    
    public func getCodeInLibrary() -> Bool{
        let userDefaults_codigo = String(UserDefaults.standard.string(forKey: Cnstnt.BundlePrf.codigo) ?? "")
        if(userDefaults_codigo != "" && userDefaults_codigo != "default"){
            guard let codeJson = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.codigos)/\(userDefaults_codigo)/Codigo.cod") else {
                ConfigurationManager.shared.codigoUIAppDelegate = FECodigo()
                ConfigurationManager.shared.utilities.writeLogger("No se encuentra el código guardado en la aplicación.\r\n", "error.txt")
                return false
            }
            ConfigurationManager.shared.codigoUIAppDelegate = FECodigo(json: codeJson)
            ConfigurationManager.shared.isCodePresented = true
            ConfigurationManager.shared.utilities.writeLogger("El código se encuentra guardado en la aplicación.\r\n", "log.txt")
            return true
        }
        ConfigurationManager.shared.utilities.writeLogger("No se encuentra el código guardado en la aplicación.\r\n", "error.txt")
        return false
    }
    
    public func getSkinInLibrary() -> Bool{
        let userDefaults_codigo = String(UserDefaults.standard.string(forKey: Cnstnt.BundlePrf.codigo) ?? "")
        guard let skinJson = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.codigos)/\(userDefaults_codigo)/Skin.ski") else{
            ConfigurationManager.shared.skinUIAppDelegate = FEAppSkin()
            ConfigurationManager.shared.utilities.writeLogger("No se encuentra el skin guardado en la aplicación.\r\n", "error.txt")
            return false
        }
        ConfigurationManager.shared.skinUIAppDelegate = FEAppSkin(json: skinJson)
        ConfigurationManager.shared.utilities.writeLogger("El skin se encuentra guardado en la aplicación.\r\n", "log.txt")
        return true
    }
    
    public func getUserInLibrary() -> Bool{
        let userDefaults_codigo = String(UserDefaults.standard.string(forKey: Cnstnt.BundlePrf.codigo) ?? "")
        let userDefaults_user = String(UserDefaults.standard.string(forKey: Cnstnt.BundlePrf.usuario) ?? "")
        if(userDefaults_user != "" && userDefaults_codigo != ""){
            guard let usuarioJson = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.usuarios)/\(userDefaults_codigo.uppercased())_\(userDefaults_user)/Usuario.usu") else{
                ConfigurationManager.shared.usuarioUIAppDelegate = FEUsuario()
                ConfigurationManager.shared.utilities.writeLogger("No se encuentra el usuario guardado en la aplicación.\r\n", "error.txt")
                return false
            }
            ConfigurationManager.shared.usuarioUIAppDelegate = FEUsuario(json: usuarioJson)
            ConfigurationManager.shared.utilities.writeLogger("El usuario se encuentra guardado en la aplicación.\r\n", "log.txt")
            return true
        }
        ConfigurationManager.shared.utilities.writeLogger("No se encuentra el usuario guardado en la aplicación.\r\n", "error.txt")
        return false
    }
    
    public func getPlantillaInLibrary() -> Bool{
        let userDefaults_codigo = String(UserDefaults.standard.string(forKey: Cnstnt.BundlePrf.codigo) ?? "")
        let userDefaults_user = String(UserDefaults.standard.string(forKey: Cnstnt.BundlePrf.usuario) ?? "")
        guard let plantillaJson = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.usuarios)/\(userDefaults_codigo.uppercased())_\(userDefaults_user)/Plantilla.pla") else{
            ConfigurationManager.shared.plantillaUIAppDelegate = FEConsultaPlantilla()
            ConfigurationManager.shared.utilities.writeLogger("No se encuentra la plantilla guardada en la aplicación.\r\n", "error.txt")
            return false
        }
        ConfigurationManager.shared.plantillaUIAppDelegate = FEConsultaPlantilla(json: plantillaJson)
        ConfigurationManager.shared.utilities.writeLogger("La plantilla se encuentra guardada en la aplicación.\r\n", "log.txt")
        return true
    }
    
    public func getVariableInLibrary() -> Bool{
        let userDefaults_codigo = String(UserDefaults.standard.string(forKey: Cnstnt.BundlePrf.codigo) ?? "")
        let userDefaults_user = String(UserDefaults.standard.string(forKey: Cnstnt.BundlePrf.usuario) ?? "")
        guard let plantillaJson = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.usuarios)/\(userDefaults_codigo.uppercased())_\(userDefaults_user)/Variables.var") else{
            ConfigurationManager.shared.variablesDataUIAppDelegate = FEVariablesData()
            ConfigurationManager.shared.utilities.writeLogger("No se encuentran las variables guardadas en la aplicación.\r\n", "error.txt")
            return false
        }
        ConfigurationManager.shared.variablesDataUIAppDelegate = FEVariablesData(json: plantillaJson)
        ConfigurationManager.shared.utilities.writeLogger("Las variables se encuentran guardadas en la aplicación.\r\n", "log.txt")
        return true
    }
    
    public func getCatalogoInLibrary(_ catId: String) -> FEItemCatalogoEsquema?{
        let userDefaults_codigo = String(UserDefaults.standard.string(forKey: Cnstnt.BundlePrf.codigo) ?? "")
        guard let catalogoJson = FCFileManager.readFileAtPath(as: "\(Cnstnt.Tree.codigos)/\(userDefaults_codigo)/Catalogos/\(catId).cat") else{
            ConfigurationManager.shared.utilities.writeLogger("No se encuentra el catalogo guardado en la aplicación.\r\n", "error.txt")
            return nil
        }
        ConfigurationManager.shared.utilities.writeLogger("El skin se encuentra guardado en la aplicación.\r\n", "log.txt")
        return FEItemCatalogoEsquema(json: catalogoJson)
    }
    
    public func settingFolderTree(){
        ConfigurationManager.shared.utilities.writeLogger("Creando la estructura de archivos.\r\n", "log.txt")
        
        FCFileManager.createDirectories(forPath: "\(Cnstnt.Tree.main)")
        FCFileManager.createDirectories(forPath: "\(Cnstnt.Tree.anexos)")
        FCFileManager.createDirectories(forPath: "\(Cnstnt.Tree.codigos)")
        FCFileManager.createDirectories(forPath: "\(Cnstnt.Tree.usuarios)")
        FCFileManager.createDirectories(forPath: "\(Cnstnt.Tree.logs)")
        FCFileManager.createDirectories(forPath: "\(Cnstnt.Tree.collector)")
        
        FCFileManager.removeItem(atPath: "\(Cnstnt.Tree.logs)/error.txt")
        FCFileManager.removeItem(atPath: "\(Cnstnt.Tree.logs)/log.txt")
        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.logs)/error.txt")
        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.logs)/log.txt")
        
    }
    
    // MARK: WRITELOG
    public func writeLogger(_ string: String, _ file: String){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        var logTime = formatter.string(from: Date())
        switch file{
        case "error.txt":
            logTime = "ERROR: \(logTime) - \(string)"
            break
        case "log.txt":
            logTime = "\(logTime) - \(string)"
            break
        default:
            logTime = "DESCONOCIDO: \(logTime) - \(string)"
            break
        }
        let path = "\(Cnstnt.Tree.logs)/\(file)"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(path)
            do {
                let handle = try FileHandle(forWritingTo: fileURL)
                handle.seekToEndOfFile()
                handle.write(logTime.data(using: .utf8)!)
                handle.closeFile()
            } catch { return }
        }
    }
    
    // MARK: READLOG
    public func readLogger(_ file: String) -> String{
        var string = ""
        let path = "\(Cnstnt.Tree.logs)/\(file)"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(path)
            do {
                string = try String(contentsOf: fileURL, encoding: .utf8)
            } catch { return "El archivo no existe." }
        }
        return string
    }
    
    // MARK: READ IMAGE FROM FOLDER
    public func readImageFromFolder(){
        
    }
    
    // MARK: SAVE IMAGE PROFILE TO FOLDER
    public func saveImageProfile(_ image: UIImage, _ folder: String, name: String) -> String{
        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.anexos)/\(folder)/\(name)", withContent: image, overwrite: true)
        ConfigurationManager.shared.utilities.writeLogger("Imagen salvada: \(name)\r\n", "log.txt")
        refreshFolderCapacity()
      return "Archivo salvado"
    }
    
    // MARK: SAVE ANEXO TO FOLDER
    public func saveAnexoToFolder(_ data: NSData, _ name: String) -> String{
        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.anexos)/\(name)", withContent: data, overwrite: true)
        ConfigurationManager.shared.utilities.writeLogger("Anexo salvado: \(name)\r\n", "log.txt")
        refreshFolderCapacity()
        return "Archivo salvado"
    }
    
    // MARK: SAVE IMAGE TO GARBAGE COLLECTOR
    public func saveImageToFolderCollector(_ image: UIImage, _ name: String) -> String{
        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.collector)/\(name)", withContent: image, overwrite: true)
        ConfigurationManager.shared.utilities.writeLogger("Imagen salvada: \(name)\r\n", "log.txt")
        refreshFolderCapacity()
        return "Archivo salvado"
    }
    
    // MARK: SAVE IMAGE TO FOLDER
    public func saveImageToFolder(_ image: UIImage, _ name: String) -> String{
        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.anexos)/\(name)", withContent: image, overwrite: true)
        ConfigurationManager.shared.utilities.writeLogger("Imagen salvada: \(name)\r\n", "log.txt")
        refreshFolderCapacity()
        return "Archivo salvado"
    }
    
    // MARK: SAVE PRESET CONSULTA TO FOLDER
    public func savePresetConsultaToFolder(_ data: NSData, _ name: String) -> String{
        FCFileManager.createFile(atPath: "\(Cnstnt.Tree.anexos)/\(name)", withContent: data, overwrite: true)
        ConfigurationManager.shared.utilities.writeLogger("Preset salvado: \(name)\r\n", "log.txt")
        _ = writeSharedData(data: data as Data, to: name)
        refreshFolderCapacity()
        return "Archivo salvado"
    }
    
    fileprivate func sharedContainerURL() -> URL? {
        var groupURL: URL?
        if ConfigurationManager.shared.isConsubanco{
            groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "com.consubanco.consullave.Consultas")
        }else{
            groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.digipro.movil.Widgets")
        }
        return groupURL
    }
    
    func writeSharedData(data:Data, to fileNamed:String) -> Bool {
        guard let url = sharedContainerURL() else { return false }
        let filePath = url.appendingPathComponent(fileNamed)
        do {
            try data.write(to: filePath); return true
        } catch {
            print("Write failed: \(error)"); return false
        }
    }
    
    // MARK: REMOVE ALL FILES FROM FORMAT
    public func removeFilesForFormat(_ formato: FEFormatoData){
        
        let url = "\(Cnstnt.Tree.usuarios)/\(ConfigurationManager.shared.codigoUIAppDelegate.Codigo)_\(ConfigurationManager.shared.usuarioUIAppDelegate.User)/Formatos/\(formato.FlujoID)/\(formato.PIID)/\(formato.Guid)_\(formato.ExpID)_\(formato.TipoDocID)-\(formato.FlujoID)-\(formato.ProcesoID)"
        
        if FCFileManager.existsItem(atPath: "\(url).bor"){
            FCFileManager.removeItem(atPath: "\(url).bor")
        }
        if FCFileManager.existsItem(atPath: "\(url).json"){
            FCFileManager.removeItem(atPath: "\(url).json")
        }
    }
    
    // MARK: DETECT FILE IN FOLDER
    public func detectIfFileExistInLibrary(_ url: String) -> Bool{
        return FCFileManager.existsItem(atPath: url)
    }
    
    // MARK: GET DATA FROM FILE
    public func getDataFromFile(_ url: String) -> Data?{
        return FCFileManager.readFileAtPath(asData: url)
    }
    
    // MARK: DATE FOR ELEMENTS
    public func getFormatDate() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
        return formatter.string(from: Date())
    }
    
    // MARK: DATE
    public func getCurrentDate() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddhhmmss"
        return formatter.string(from: Date())
    }
    
    // MARK: GUID GENERATOR
    public func guid() -> String {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddhhmmss"
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: date as Date)
        var milli = String(date.timeIntervalSince1970 * 1000)
        milli = milli.replacingOccurrences(of: ".", with: "")
        return "\(timeStamp)\(String(milli.suffix(5)))"
    }
    
    // MARK: REMOVE RESOURCE
    public func removeFromDeviceFolder(_ path: String){
        FCFileManager.removeItem(atPath: "\(path)");
        refreshFolderCapacity()
    }
    
    // HUD Loading
    public func incrementHUD(_ hud: JGProgressHUD, _ view: UIView, progress previousProgress: Int, _ label: String) {
        
        if previousProgress == 100 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                UIView.animate(withDuration: 0.1, animations: {
                    hud.textLabel.text = "Éxito"
                    hud.detailTextLabel.text = nil
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                })
                hud.dismiss(afterDelay: 1.0)
            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                UIView.animate(withDuration: 0.1, animations: {
                    let progress = previousProgress
                    hud.progress = Float(progress)/100.0
                    hud.textLabel.text = label
                    hud.detailTextLabel.text = "\(progress)% Completado"
                })
            }
        }
        
    }
    
    // Banner Notification
    public func setNotificationBanner(_ title: String, _ subtitle: String, _ style: BannerStyle, _ direction: BannerPosition) -> NotificationBanner{
        let banner = NotificationBanner(title: title, subtitle: subtitle, style: style)
        return banner
    }
    public func setStatusBarNotificationBanner(_ title: String, _ style: BannerStyle, _ direction: BannerPosition) -> StatusBarNotificationBanner{
        let banner = StatusBarNotificationBanner(title: title, style: style)
        return banner
    }
    
    // TouchID Authentication
    public func authenticationWithTouchID() -> Promise<Bool> {
        
        return Promise<Bool>{ resolve, reject in
            
            let localAuthenticationContext = LAContext()
            localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
            
            var authError: NSError?
            let reasonString = "Para acceder de manera fácil y segura a la cuenta configurada en el dispositivo."
            
            if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                
                localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                    
                    if success {
                        
                        resolve(true)
                        
                    } else {
                        guard let error = evaluateError else {
                            reject(APIErrorResponse.defaultError)
                            return
                        }
                        reject(APIErrorResponse.defaultError)
                        print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                        
                    }
                }
            } else {
                
                guard let error = authError else {
                    return
                }
                print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
            }
            
        }
        
    }
    
    public func configureDirectAccess() -> Promise<Bool>{
        
        return Promise<Bool>{ resolve, reject in
            
            ConfigurationManager.shared.utilities.authenticationWithTouchID()
                .then { response in
                    print(response)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() , execute: {
                        // Perform access to Plantillas only
                        resolve(true)
                    })
                    
                }
                .catch { error in
                    print(error)
                    reject(error)
            }
            
        }
        
    }
    
    public func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    public func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
}

public struct Console{
    
    public func initConsole(_ ex: CGFloat, _ ye: CGFloat, _ w: CGFloat, _ h: CGFloat){
        
        ConfigurationManager.shared.viewConsole = UIView.init(frame: CGRect(x: ex, y: ye, width: w, height: h))
        ConfigurationManager.shared.viewConsole?.backgroundColor = UIColor.gray
        ConfigurationManager.shared.textConsole = UITextView.init(frame: CGRect(x: 0, y: 0, width: (ConfigurationManager.shared.viewConsole?.frame.size.width)!, height: (ConfigurationManager.shared.viewConsole?.frame.size.height)!))
        ConfigurationManager.shared.textConsole?.contentInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        ConfigurationManager.shared.textConsole?.layer.cornerRadius = 5
        ConfigurationManager.shared.textConsole?.font = UIFont(name: "Times", size: 9.0)
        ConfigurationManager.shared.textConsole?.backgroundColor = UIColor.black
        ConfigurationManager.shared.textConsole?.textColor = UIColor.white
        ConfigurationManager.shared.textConsole?.isEditable = false
        ConfigurationManager.shared.viewConsole?.addSubview(ConfigurationManager.shared.textConsole!)
        
    }
    
    
    public func addTextConsole(_ string: String, _ typeConsole: String){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss a"
        let logTime = formatter.string(from: Date())
        switch typeConsole{
        case "error":
            let string1 = ConfigurationManager.shared.textConsole?.attributedText
            let string2 = NSAttributedString(string: "\(logTime) Error - \(string) \r\n", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            let newMutableString = string1?.mutableCopy() as! NSMutableAttributedString
            newMutableString.append(string2)
            ConfigurationManager.shared.textConsole?.attributedText = newMutableString.copy() as? NSAttributedString
            let bottom = NSMakeRange(newMutableString.length - 0, 0)
            ConfigurationManager.shared.textConsole!.scrollRangeToVisible(bottom)
            break
        case "log":
            let string1 = ConfigurationManager.shared.textConsole?.attributedText
            let string2 = NSAttributedString(string: "\(logTime) - \(string) \r\n", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            let newMutableString = string1?.mutableCopy() as! NSMutableAttributedString
            newMutableString.append(string2)
            ConfigurationManager.shared.textConsole?.attributedText = newMutableString.copy() as? NSAttributedString
            let bottom = NSMakeRange(newMutableString.length - 0, 0)
            ConfigurationManager.shared.textConsole!.scrollRangeToVisible(bottom)
            break
        default:
            let string1 = ConfigurationManager.shared.textConsole?.attributedText
            let string2 = NSAttributedString(string: "\(logTime) Unknown - \(string) \r\n", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            let newMutableString = string1?.mutableCopy() as! NSMutableAttributedString
            newMutableString.append(string2)
            ConfigurationManager.shared.textConsole?.attributedText = newMutableString.copy() as? NSAttributedString
            let bottom = NSMakeRange(newMutableString.length - 0, 0)
            ConfigurationManager.shared.textConsole!.scrollRangeToVisible(bottom)
            break
        }
        
    }
}

// MARK: FormularioUtilities

public enum ReturnFormulaType { //TODO: Give me an appropriate name.
    case typeString(String)
    case typeInt(Int)
    case typeArray(NSArray)
    case typeDictionary(NSDictionary)
    case typeNil(String?)
}

public enum ReturnOperacionType{
    case typeString(String)
    case typeInt(Int)
    case typeBoolean(Bool)
}
