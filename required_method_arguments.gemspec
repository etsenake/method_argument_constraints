# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'required_method_arguments/version'

Gem::Specification.new do |spec|
  spec.name          = "required_method_arguments"
  spec.version       = RequiredMethodArguments::VERSION
  spec.authors       = ["Josh Etsenake"]
  spec.email         = ["etsenake@gmail.com"]

  spec.summary       = %q{Asserts requirements on method arguments}
  spec.description   = %q{Call required! with the param name and constraint to enforce validation on it}

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = 'https://rubygems.org'
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = ["lib/required_method_arguments.rb"]
  spec.require_paths = ["lib"]
  spec.license       = 'MIT'
end
