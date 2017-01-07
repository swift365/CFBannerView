Pod::Spec.new do |s|
s.name = 'CFBannerView'
s.version = '0.0.3'
s.license= { :type => "MIT", :file => "LICENSE" }
s.summary = 'CFBannerView is a Swift module for subViews to uiview.'
s.homepage = 'https://github.com/swift365/CFBannerView'
s.authors = { 'chengfei.heng' => 'hengchengfei@sina.com' }
s.source = { :git => 'https://github.com/swift365/CFBannerView.git', :tag => "0.0.3"  }
s.ios.deployment_target = '8.0' #支持的版本号
s.source_files = "CFBannerView/Classes/*.swift", "CFBannerView/Classes/**/*.swift"  #包含的source文件
s.dependency 'SDWebImage', '~> 4.0.0-beta2'
end
