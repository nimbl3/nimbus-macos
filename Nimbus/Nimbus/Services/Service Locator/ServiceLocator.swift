//
//  ServiceLocator.swift
//  Braive
//
//  Created by Pirush Prechathavanich on 4/3/18.
//  Copyright © 2018 Nimbl3. All rights reserved.
//

class ServiceLocator: ServiceProvider {
    
    //todo:- this service locator could expose unwanted external knowledge.
    //       strict its access by adding another layer of protocol which only
    //       application flow controller level can only has access. could
    //       perhaps have exposable services and strictly-used services.
    
    private var services: [String: Service] = [:]
    private var requiredKeys: Set<String> = Set()
    
    deinit {
        services.values.forEach { $0.prepareToClose() }
    }
    
    func registerService(_ service: Service) {
        let serviceKey = key(for: service)
        if let replacedService = services.updateValue(service, forKey: serviceKey) {
            replacedService.prepareToClose()
        }
        service.takeOff()
    }
    
    func registerRequiredService(_ service: Service) {
        requiredKeys.insert(key(for: service))
        registerService(service)
    }
    
    func getService<T: Service>(_ type: T.Type) -> T {
        guard let service = services[key(for: type)] as? T else {
            fatalError("\(key(for: type)) service couldn't be found or hasn't been registered.")
        }
        return service
    }
    
    func removeService(_ service: Service) {
        let serviceKey = key(for: service)
        service.prepareToClose()
        services.removeValue(forKey: serviceKey)
    }
    
    func clearAllServices(includingRequired: Bool = true) {
        let removingServices: Dictionary<String, Service>.Values
        if includingRequired {
            removingServices = services.values
        } else {
            removingServices = services
                .filter { !requiredKeys.contains($0.key) }
                .values
        }
        
        removingServices.forEach { removeService($0) }
    }
    
    // MARK: - service provider
    
    func service<T: Service>(of type: T.Type) -> T? {
        return services[key(for: type)] as? T
    }
    
    // MARK: - private helper
    
    private func key(for serviceType: Service.Type) -> String {
        return "\(serviceType.self)"
    }
    
    private func key(for service: Service) -> String {
        return "\(type(of: service))"
    }
    
}
