Pod::Spec.new do |s|
  s.name             = 'NSFWDetector'
  s.version          = '1.1.1'
  s.summary          = 'NSFW Content Detection aká porn detection with CoreML.'
  s.swift_version    = '4.2'

  s.description      = <<-DESC
Lightweight Library for scanning images for NSFW (Not Safe For Work) content.
                       DESC

  s.homepage         = 'https://github.com/lovoo/NSFWDetector'
  s.license          = { :type => 'BSD', :file => 'LICENSE' }
  s.author           = { 'Michael Berg' => 'michael.berg@lovoo.com' }
  s.source           = { :git => 'https://github.com/lovoo/NSFWDetector.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.pod_target_xcconfig = { 'COREML_CODEGEN_LANGUAGE' => 'Swift' }

  s.source_files = 'NSFWDetector/Classes/**/*'
end
