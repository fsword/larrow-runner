require 'spec_helper.rb'
module Larrow
  module Runner
    module Scm
      describe Github do
        it 'split_org_and_name' do
          git_url = 'git@github.com:org1/proj_name1.git'
          https_url = 'https://github.com/org1/proj_name1.git'
          [git_url, https_url].each do |url|
            github = Github.new url
            github.checkout_url.should   == git_url
          end
        end
      end
    end
  end
end
