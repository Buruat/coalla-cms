# We need to have an ability to upload files which includes russian characters, so we
# have to extend upload carrierwave security rules (see code below). Because of ruby
# bug you can't upload such files in Windows OS
unless RUBY_PLATFORM.downcase.include?("win") || RUBY_PLATFORM.downcase.include?("mingw")

  CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/

end