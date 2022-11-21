Pod::Spec.new do |s|
  s.name             = 'ezgif.swift'
  s.version          = '1.0.0'
  s.summary          = 'A short description of ezgif.swift.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/eyrecoffee@163.com/ezgif.swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'eyrecoffee@163.com' => 'eyrefree@eyrefree.org' }
  s.source           = { :git => 'https://github.com/eyrecoffee@163.com/ezgif.swift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'ezgif.swift/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ezgif.swift' => ['ezgif.swift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
