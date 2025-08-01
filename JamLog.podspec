#
# Be sure to run `pod lib lint JamLog.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JamLog'
  s.version          = '1.0.2'
  s.summary          = 'Log to Jam from iOS.'

  s.description      = <<-DESC
This framework lets you send log events to Jam for iOS so that they can be associated with your Jam.
                       DESC

  s.homepage         = 'https://github.com/jamdotdev/jam-ios-log'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mattcomi' => 'matt@jam.dev' }
  s.source           = { :git => 'https://github.com/jamdotdev/jam-ios-log', :tag => s.version.to_s }

  s.ios.deployment_target = '17.0'

  s.source_files = 'Sources/JamLog/**/*'
end
