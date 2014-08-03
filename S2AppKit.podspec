
Pod::Spec.new do |s|

  s.name         = 'S2AppKit'
  s.version      = '2.0.5'
  s.summary      = 'S2AppKit is a SDK extension. wrapping library.'
  s.description  = <<-DESC
S2AppKit is a application framework. if use then very very happpy!
DESC
  s.homepage     = 'http://github.com/straightspirits/S2AppKit-ios'
  s.source       = { :git => 'https://github.com/straightspirits/S2AppKit-ios.git', :tag => 'v' + s.version.to_s() }
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Fumio Furukawa' => 'fumio@straight-spirits.com' }
  s.platform     = :ios, '6.0'
  s.ios.deployment_target = '6.0'
  s.requires_arc = true

  s.default_subspec = 'Core';

  s.subspec 'Core' do |ss|
    ss.source_files  = '{Application,Foundation,Networking,Services,Text,UICase,UIKit,ZipArchive}/*.{h,m}', 'ZipArchive/minizip/*.{h,c}'
    ss.library   = 'z'
    ss.dependency 'MBProgressHUD', '~> 0.8'
  end

  s.subspec 'iAd' do |ss|
    ss.source_files = 'iAd/*.{h,m}'
    ss.frameworks = 'iAd'
  end

#  s.subspec 'AdMob' do |ss|
#    ss.source_files = 'iAd/*.{h,m}'
#    ss.dependency 'AdMob'
#  end

  s.subspec 'Networking' do |ss|
    ss.dependency 'AFNetworking', '~> 2.0'
  end

end
