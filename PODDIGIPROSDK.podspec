#
# Be sure to run `pod lib lint PODDIGIPROSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'PODDIGIPROSDK'
    s.version          = '1.0.2'
    s.summary          = 'SDK de formatos electrónicos Primera prueba PODDIGIPROSDK'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = <<-DESC
    Prueba de Creación de POD DIGIPROSDK. Desarrollo para formatos
    DESC
    
    s.homepage         = 'https://github.com/AlexArroyo2104/PODDIGIPROSDK'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'AlexArroyo2104' => 'alejandrol@digipro.com.mx' }
    s.source           = { :git => 'https://github.com/AlexArroyo2104/PODDIGIPROSDK.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '11.0'
    s.swift_versions = '4.2'
    
    #s.resource_bundles = {
    #    'PODDIGIPROSDK' => ['PODDIGIPROSDK/Assets/**/*.{png, xib}']
    #}
    
    s.default_subspec = 'Core'
    s.subspec 'Core' do |core|
        core.source_files = 'PODDIGIPROSDK/Classes/**/*.{h,m,swift,xib}'
        core.public_header_files = 'PODDIGIPROSDK/Classes/**/*.h'
        core.resources = 'PODDIGIPROSDK/Assets/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}'
        #s.resource_bundles = {
        #    'PODDIGIPROSDK' => ['PODDIGIPROSDK/Assets/**/*.{png, xib}']
        # }
        
    end
    
    s.subspec 'AppExtension' do |ext|
        ext.source_files = 'PODDIGIPROSDK/Classes/**/*.{h,m,swift}'
        # For app extensions, disabling code paths using unavailable API
        ext.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'MYLIBRARY_APP_EXTENSIONS=1' }
    end
    #s.source_files = 'PODDIGIPROSDK/Classes/**/*.{h,swift}'
    
   
    
    #s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    # s.dependency 'AFNetworking', '~> 2.3'
end


