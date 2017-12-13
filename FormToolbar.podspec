Pod::Spec.new do |s|
  s.name             = "FormToolbar"
  s.version          = "1.1"
  s.summary          = "Simple, movable and powerful toolbar for UITextField and UITextView."
  s.homepage         = "https://github.com/sgr-ksmt/FormToolbar"
  s.license          = 'MIT'
  s.author           = { "Suguru Kishimoto" => "melodydance.k.s@gmail.com" }
  s.source           = { :git => "https://github.com/sgr-ksmt/FormToolbar.git", :tag => s.version.to_s }
  s.platform         = :ios, '9.0'
  s.requires_arc     = true
  s.source_files     = "FormToolbar/**/*"
end
