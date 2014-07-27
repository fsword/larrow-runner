require 'spec_helper.rb'
module Larrow
  module Runner 
    describe "integration" do
      [
        'git@github.com:fsword/essh.git'
      ].each do |url|
        describe url do
          subject{ Manager.new url }

          after :each do
            subject.release
          end
          it{ expect(subject.go).not_to be_nil }
        end
      end
    end
  end
end
