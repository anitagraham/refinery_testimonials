# encoding: utf-8
require "spec_helper"
require 'i18n'

# Use add_testimonial when testing the online interface

def add_testimonial(from, quote)

  click_link ::I18n.t('create_new', :scope => 'refinery.admin.testimonials.actions')
  fill_in "Name", :with => from
  # sleep 5
  html = '<p>#{quote}</p>'
  page.execute_script("WYMeditor.INSTANCES[0].html('#{html}')")
  click_button "Save"
end

# Use build_testimonial when testing basic functionality

def build_testimonial(from, quote)
  Refinery::Testimonials::Testimonial.create :name => from, :quote=>quote
end

module Refinery
  module Admin
    describe "Testimonials" do
      login_refinery_user

      context "When there are no testimonials" do
        it "Says no items yet" do

          visit refinery.admin_testimonials_path
          expect(page).to have_content(::I18n.t('no_items_yet', :scope => 'refinery.admin.testimonials.records'))

        end

        it "doesn't show reorder testimonials link" do
          visit refinery.admin_testimonials_path

          within "#actions" do
            expect(page).to have_no_content(::I18n.t('reorder', :scope => 'refinery.admin.testimonials.actions'))
            expect(page).to have_no_selector("a[href='/refinery/testimonials/testimonials']")
          end
        end
      end

      describe "action links" do
        it "shows add new testimonial link" do
          visit refinery.admin_testimonials_path

          within "#actions" do
            expect(page).to have_content(::I18n.t('create_new', :scope => 'refinery.admin.testimonials.actions'))
            expect(page).to have_selector("a[href='/refinery/testimonials/testimonials/new']")
          end
        end

        context "when some testimonials exist" do
          before { 2.times { |i| build_testimonial("Testimonial #{i}", "quote")} }

          it "shows reorder testimonials link" do
            visit refinery.admin_testimonials_path

            within "#actions" do
              expect(page).to have_content(::I18n.t('reorder', :scope => 'refinery.admin.testimonials.actions'))
              expect(page).to have_selector("a[href='/refinery/testimonials/testimonials']")
            end
          end
        end
      end

      describe "new/create", :js => true do
        it "allows a testimonial to be created" do
          visit refinery.admin_testimonials_path
          add_testimonial("My first Testimonial", "Quote")

          expect(page).to have_content("'Quote by My first Testimonial' was successfully added.")

          expect(page.html).to include('Remove this testimonial forever')
          expect(page.html).to include('Edit this testimonial')
          expect(page.html).to include('/refinery/testimonials/testimonials/1/edit')

          expect(Refinery::Testimonials::Testimonial.count).to eq(1)
        end
      end

      describe "edit/update" do
        before do
          build_testimonial("Update me", "quote")

          visit refinery.admin_testimonials_path
          expect(page).to have_content("Update me")
        end

        context 'when saving and returning to index' do
          it "updates testimonial" do
            click_link "Edit this testimonial"

            fill_in "Name", :with => "Updated"
            click_button "Save"

            expect(page).to have_content("'Quote by Updated' was successfully updated.")
          end
        end
      end

      describe "Destroy" do
        context "When a testimonial can be deleted" do
          before do
            build_testimonial('Delete me', 'Quote me')
          end

          it "Will show delete button" do
            visit refinery.admin_testimonials_path
            within ".record" do
              expect(page.html).to include(::I18n.t('delete', :scope => 'refinery.admin.testimonials.testimonial'))
              expect(page).to have_selector("a[href='/refinery/testimonials/testimonials/1']")
            end
          end

          it "Will delete the testimonial" do
            visit refinery.admin_testimonials_path
            click_link "Remove this testimonial forever"

            expect(page).to have_content("'Quote by Delete me' was successfully removed.")
            expect(Refinery::Testimonials::Testimonial.count).to eq(0)
          end
        end
      end
    end
  end
end