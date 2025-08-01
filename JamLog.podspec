Pod::Spec.new do |s|
  s.name             = 'JamLog'
  s.version          = '1.1.1'
  s.summary          = 'Log to Jam from iOS.'

  s.description      = <<-DESC
This framework lets you send log events to Jam for iOS so that they can be associated with your Jam.
                       DESC

  s.homepage         = 'https://github.com/jamdotdev/jam-ios-log'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Matt Comi' => 'matt@jam.dev' }
  s.source           = { :git => 'https://github.com/jamdotdev/jam-ios-log.git', :tag => "v#{s.version}" }
  s.swift_version = '5.9'
  s.ios.deployment_target = '17.0'

  s.source_files = 'Sources/JamLog/**/*'
end
