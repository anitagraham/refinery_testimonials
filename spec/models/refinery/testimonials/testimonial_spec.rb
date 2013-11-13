require 'spec_helper'

module Refinery
  module Testimonials
    describe Testimonial do
      describe 'validations' do
        subject do
          FactoryGirl.create(:testimonial,
          :name => 'Refinery CMS',
          :quote => 'Like your work')
        end

        it { should be_valid }
        its(:errors) {should be_empty}
        its(:name) {should =='Refinery CMS'}
        its(:quote) {should =='Like your work'}
      end
    end
  end
end
