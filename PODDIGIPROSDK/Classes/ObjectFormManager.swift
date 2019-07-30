//
//  UniversalFunctions.swift
//  DGFmwrk
//
//  Created by Jonathan Viloria M on 1/11/19.
//  Copyright © 2019 Digipro Movil. All rights reserved.
//

import Foundation

public protocol ObjectFormDelegate: class {
    func setVariableHeight(Height h: CGFloat)
    func setMessage(_ string: String, _ state: String)
    func updateIfIsValid(animated: Bool)
    func setMinMax()
    func setExpresionRegular()
    func setOcultarTitulo(_ bool: Bool)
    func setOcultarSubtitulo(_ bool: Bool)
    func setHabilitado(_ bool: Bool)
    func setEdited(v: String)
    func setVisible(_ bool: Bool)
    func setRequerido(_ bool: Bool)
    func triggerEvent(_ action: String)
}

public final class ObjectFormManager<Delegate: ObjectFormDelegate>: NSObject {
    public weak var delegate: ObjectFormDelegate?
}

public protocol AttachedFormDelegate: class {
    func setVariableHeight(Height h: CGFloat)
    func setMessage(_ string: String, _ state: String)
    func updateIfIsValid(animated: Bool)
    func setOcultarTitulo(_ bool: Bool)
    func setOcultarSubtitulo(_ bool: Bool)
    func setHabilitado(_ bool: Bool)
    func setEdited(v: String)
    func setVisible(_ bool: Bool)
    func setAnexoOption(_ anexo: FEAnexoData)
    func setRequerido(_ bool: Bool)
    func setAttributesToController()
    func triggerEvent(_ action: String)
}

public final class AttachedFormManager<Delegate: AttachedFormDelegate>: NSObject {
    public weak var delegate: AttachedFormDelegate?
}
