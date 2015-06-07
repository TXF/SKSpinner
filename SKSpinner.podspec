#
# Be sure to run `pod lib lint SKSpinner.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SKSpinner"
  s.version          = "0.1.1"
  s.summary          = "An iOS Skype-alike activity indicator view."
  s.description      = <<-DESC
                       SKSpinner is an iOS control that displays a loader while tasks is being processed.
                       DESC
  s.homepage         = "https://github.com/TXF/SKSpinner"
  s.license          = 'MIT'
  s.author           = { "David" => "aarontox@yahoo.com" }
  s.source           = { :git => "https://github.com/TXF/SKSpinner.git", :tag => s.version.to_s }

  s.platform     = :ios, '5.0'
  s.requires_arc = true
  s.frameworks = 'QuartzCore'
  s.source_files = 'Pod/**/*'

end