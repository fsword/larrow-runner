require 'spec_helper.rb'
require 'larrow/qingcloud'

module Larrow
  module Runner 
    ['git@github.com:fsword/sample_ruby.git'].each do |url|
      describe "build: #{url}" do
        subject{ Manager.new url }
        it{ expect(subject.build_server).to be_a Model::Node }
        it do 
          image = subject.build_image
          expect(image).to be_a Qingcloud::Image
          image.destroy.force
        end
      end
    end
  end
end
