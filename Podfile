platform :ios, '9.0'
use_frameworks!

target 'MessageKit' do
    pod 'PureLayout'
    
    pod 'ContextLabel', :git => 'https://github.com/michaelloistl/ContextLabel.git', :branch => 'swift-3'
end

target 'MessageKitTests' do
    
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
