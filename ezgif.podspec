Pod::Spec.new do |s|
  s.name             = 'ezgif'
  s.version          = '1.0.1'
  s.summary          = 'Use ezgif.com in swift.'

  s.description      = <<-DESC
Use ezgif.com in swift.
                       DESC

  s.homepage         = 'https://github.com/EyreFree/ezgif.swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'EyreFree' => 'eyrefree@eyrefree.org' }
  s.source           = { :git => 'https://github.com/EyreFree/ezgif.swift.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/EyreFree777'

  s.ios.deployment_target = '11.0'

  s.requires_arc = true
  s.source_files = 'ezgif/Classes/**/*'
  
  s.frameworks = 'UIKit', 'WebKit'
  s.dependency 'EFFoundation', '~> 1.5.2'
end
