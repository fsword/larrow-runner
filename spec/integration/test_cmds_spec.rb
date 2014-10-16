require 'spec_helper.rb'
require 'larrow/qingcloud'

module Larrow
  module Runner 
    ['git@github.com:fsword/sample_ruby.git'].each do |url|
      describe "test: #{url}" do
        subject{ Manager.new url }
        it{ expect(subject.go).not_to be_nil }
      end
    end
  end
end
