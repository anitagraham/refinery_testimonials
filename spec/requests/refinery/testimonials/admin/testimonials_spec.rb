# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Testimonials" do
    describe "Admin" do
      describe "testimonials" do
        login_refinery_user

        describe "testimonials list" do
          before do
            FactoryGirl.create(:testimonial, :name => "UniqueTitleOne")
            FactoryGirl.create(:testimonial, :name => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.testimonials_admin_testimonials_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.testimonials_admin_testimonials_path

            click_link "Add New Testimonial"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Name", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Testimonials::Testimonial.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Name can't be blank")
              Refinery::Testimonials::Testimonial.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:testimonial, :name => "UniqueTitle") }

            it "should fail" do
              visit refinery.testimonials_admin_testimonials_path

              click_link "Add New Testimonial"

              fill_in "Name", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Testimonials::Testimonial.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:testimonial, :name => "A name") }

          it "should succeed" do
            visit refinery.testimonials_admin_testimonials_path

            within ".actions" do
              click_link "Edit this testimonial"
            end

            fill_in "Name", :with => "A different name"
            click_button "Save"

            page.should have_content("'A different name' was successfully updated.")
            page.should have_no_content("A name")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:testimonial, :name => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.testimonials_admin_testimonials_path

            click_link "Remove this testimonial forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Testimonials::Testimonial.count.should == 0
          end
        end

      end
    end
  end
end
