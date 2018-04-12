Pod::Spec.new do |s|

  s.name         = "JYCircleProgressView"
  s.version      = "0.1"
  s.summary      = "带渐变色的圆形进度条"
  s.homepage     = "https://github.com/xiaolouxinyue/JYCircleProgressView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Jaym" => "ywjiang1124@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/xiaolouxinyue/JYCircleProgressView.git", :tag => s.version }
  s.source_files = "JYCircleProgressView/JYCircleProgressView/*"
  s.requires_arc = true

end
