Pod::Spec.new do |s|
  s.name              = "ValueCoding"
  s.version           = "2.1.0"
  s.summary           = "Swift protocols for encoding/decoding value types."
  s.description       = <<-DESC
  
  ValueCoding is a simple pair of protocols to support the archiving 
  and unarchiving of Swift value types.

  It works by allowing a value type, which must conform to ValueCoding 
  to define via a typealias its archiver. The archiver is another type 
  which implements the ArchiverType protocol. This type will typically 
  be an NSObject which implements NSCoding and is an adaptor which is 
  responsible for encoding and decoding the properties of the value.

                       DESC
  s.homepage          = "https://github.com/danthorpe/ValueCoding"
  s.license           = 'MIT'
  s.author            = { "Daniel Thorpe" => "@danthorpe" }
  s.source            = { :git => "https://github.com/danthorpe/ValueCoding.git", :tag => s.version.to_s }
  s.module_name       = 'ValueCoding'
  s.social_media_url  = 'https://twitter.com/danthorpe'
  s.requires_arc      = true
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'  
  s.source_files      = 'Sources/*.swift' 
end

