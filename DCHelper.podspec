Pod::Spec.new do |s|
  s.name             = 'DCHelper'
  s.version          = '0.0.8'
  s.summary          = '项目基础模块'
  
  s.description      = <<-DESC
  项目基础模块
  DESC
  
  s.homepage         = 'https://github.com/Lanhaoo/DCHelper'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Lanhaoo' => 'lanhao_dev@163.com' }
  s.source           = { :git => 'https://github.com/Lanhaoo/DCHelper.git', :tag => s.version }
  
  s.ios.deployment_target = '9.0'
  s.swift_version    = '5.0'
  s.source_files = 'DCHelper/**/*'
  s.frameworks = 'UIKit'
  s.requires_arc = true
  s.dependency 'HandyJSON', '~> 5.0.2'
  s.dependency 'TangramKit'
  s.dependency 'SnapKit'
  s.dependency 'MBProgressHUD'
  s.dependency 'IQKeyboardManagerSwift'
  s.dependency 'Masonry'
  s.dependency 'Adjust', '~> 4.33.3'
  s.dependency 'SystemServices'
  s.dependency 'FWPopupView'
  s.dependency 'BRPickerView'
  s.dependency 'MJRefresh'
  s.dependency 'SDWebImage'
  s.dependency 'Alamofire'
  s.dependency 'SDCycleScrollView','>= 1.82'
  s.dependency 'FCUUID'
  s.dependency 'UITextView+Placeholder'
  
  s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'x86_64 armv7 arm64',
    'VALID_ARCHS' => 'x86_64 armv7 arm64',
  }
  s.user_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'x86_64 armv7 arm64',
    'VALID_ARCHS' => 'x86_64 armv7 arm64',
  }
  
end
