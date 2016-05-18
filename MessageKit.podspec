Pod::Spec.new do |s|
    s.name = 'MessageKit'
    s.version = '0.0.0'
    s.license = 'MIT'
    s.summary = 'Messaging in Swift'
    s.authors = { 'Michael Loistl' => 'michael@aplo.co' }
    s.homepage = "https://github.com/michaelloistl/MessageKit"
    s.source = { :git => 'https://github.com/michaelloistl/MessageKit.git', :tag => s.version }

    s.ios.deployment_target = '8.0'
    s.osx.deployment_target = '10.9'
    s.watchos.deployment_target = '2.0'

    s.source_files = 'MessageKit/*.{swift}'

    s.requires_arc = true

    s.dependency 'PureLayout', '~> 3.0'
end
