# encoding: utf-8
require "spec_helper"
require 'i18n'


# Use add_testimonial when testing the online interface
  def add_testimonial(from, quote)

    click_link ::I18n.t('create_new', :scope => 'refinery.testimonials.admin.testimonials.actions')
      fill_in "Name", :with => from
      sleep 5
      html = "<p>#{quote}</p>"
      page.evaluate_script("WYMeditor.INSTANCES[0].html(#{html})")  
    click_button "Save" 
  end
  
# Use build_testimonial when testing ....  
  def build_testimonial(from, quote)
    Testimonials::Testimonial.create :name => "#{name} #{i}", :quote=>quote
  end
  

module Refinery
  module Admin
    describe "Testimonials" do
      login_refinery_user

      context "when no testimonials" do
        it "Says no items yet" do
          visit refinery.testimonials_testimonials_admin_testimonials_path

          expect(page).to have_content(::I18n.t('no_items_yet', :scope => 'refinery.testimonials.admin.testimonials.records'))
        end

        it "doesn't show reorder testimonials link" do
          visit refinery.testimonials_admin_testimonials_path

          within "#actions" do
            expect(page).to have_no_content(::I18n.t('reorder', :scope => 'refinery.testimonials.admin.testimonials.actions'))
            expect(page).to have_no_selector("a[href='/refinery/testimonials/testimonials']")
          end
        end
      end

      describe "action links" do
        it "shows add new testimonial link" do
          visit refinery.testimonials_testimonials_admin_testimonials_path

          within "#actions" do
            expect(page).to have_content(::I18n.t('create_new', :scope => 'refinery.testimonials.admin.testimonials.actions'))
            expect(page).to have_selector("a[href='/refinery/testimonials/testimonials/new']")
          end
        end


        context "when some testimonials exist" do
          before { 2.times { |i| build_testimonial("Testimonial #{i}", "quote")} }

          it "shows reorder testimonials link" do
            visit refinery.testimonials_admin_testimonials_path

            within "#actions" do
              expect(page).to have_content(::I18n.t('reorder', :scope => 'refinery.testimonials.admin.testimonials.actions'))
              expect(page).to have_selector("a[href='/refinery/testimonials/testimonials']")
            end
          end
        end
      end

      describe "new/create" do
        it "allows a testimonial to be created" do
          visit refinery.testimonials_admin_testimonials_path
          add_testimonial("My first Testimonial", "quote")

          expect(page).to have_content("'My first testimonial' was successfully added.")

          expect(page.body).to have_content(/Remove this testimonial forever/)
          expect(page.body).to have_content(/Edit this testimonial/)
          expect(page.body).to have_content(%r{/refinery/testimonials/my-first-testimonial/edit})
          expect(page.body).to have_content(%r{href="/my-first-testimonial"})

          expect(Refinery::Testimonial.count).to have_value(1)
        end
      end

      describe "edit/update" do
        before do
          build_testimonial("Update me", "quote")

          visit refinery.testimonials_admin_testimonials_path
          expect(page).to have_content("Update me")
        end

        context 'when saving and returning to index' do
          it "updates testimonial" do
            click_link "Edit this testimonial"

            fill_in "Name", :with => "Updated"
            click_button "Save"

            expect(page).to have_content("'Updated' was successfully updated.")
          end
        end
      end

      describe "destroy" do
        context "when testimonial can be deleted" do
          before { Testimonial.create :name => "Delete me" }

          it "will show delete button" do
            visit refinery.testimonials_admin_testimonials_path

            click_link "Remove this testimonial forever"

            expect(page).to have_content("'Delete me' was successfully removed.")

            Refinery::Testimonial.count.should == 0
          end
        end
      end

      context "duplicate testimonial names" do
        before { Testimonial.create :name => "I was here first" }

        it "will append nr to url path" do
          visit refinery.new_admin_testimonial_path

          fill_in "Name", :with => "I was here first"
          click_button "Save"

          Refinery::Testimonial.last.url[:path].should == ["i-was-here-first--2"]
        end
      end

      context "with translations" do
        before do
          Refinery::I18n.stub(:frontend_locales).and_return([:en, :ru])

          # Create a home page in both locales (needed to test menus)
          home_page = FactoryGirl.create(:page, :name => 'Home',
          :link_url => '/',
          :menu_match => "^/$")
          Globalize.locale = :ru
          home_page.name = 'Домашняя страница'
          home_page.save
          Globalize.locale = :en
        end

        describe "add a testimonial with name for default locale" do
          before do
            visit refinery.testimonials_admin_testimonials_path
            click_link "Add new testimonial"
            fill_in "Name", :with => "News"
            click_button "Save"
          end

          it "succeeds" do
            expect(page).to have_content("'News' was successfully added.")
            Refinery::Testimonial.count.should == 2
          end

          it "shows locale flag for testimonial" do
            p = ::Refinery::Testimonial.by_slug('news').first
            within "#page_#{p.id}" do
              expect(page).to have_css("img[src='/assets/refinery/icons/flags/en.png']")
            end
          end

          it "shows name in the admin menu" do
            p = ::Refinery::Testimonial.by_slug('news').first
            within "#page_#{p.id}" do
              expect(page).to have_content('News')
              page.find_link('Edit this page')[:href].should include('news')
            end
          end

        end

        describe "add a testimonial with name for both locales" do
          let(:en_page_name) { 'News' }
          let(:en_page_slug) { 'news' }
          let(:ru_page_name) { 'Новости' }
          let(:ru_page_slug) { 'новости' }
          let(:ru_page_slug_encoded) { '%D0%BD%D0%BE%D0%B2%D0%BE%D1%81%D1%82%D0%B8' }
          let!(:news_page) do
            Refinery::I18n.stub(:frontend_locales).and_return([:en, :ru])

            _page = Globalize.with_locale(:en) {
              Testimonial.create :name => en_page_name
            }
            Globalize.with_locale(:ru) do
              _page.name = ru_page_name
              _page.save
            end

            _page
          end

          it "succeeds" do
            news_page.destroy!
            visit refinery.testimonials_admin_testimonials_path

            click_link "Add new page"
            within "#switch_locale_picker" do
              click_link "Ru"
            end
            fill_in "Name", :with => ru_page_name
            click_button "Save"

            within "#page_#{Testimonial.last.id}" do
              click_link "Application_edit"
            end
            within "#switch_locale_picker" do
              click_link "En"
            end
            fill_in "Name", :with => en_page_name
            click_button "Save"

            expect(page).to have_content("'#{en_page_name}' was successfully updated.")
            Refinery::Testimonial.count.should == 2
          end

          it "shows both locale flags for page" do
            visit refinery.testimonials_admin_testimonials_path

            within "#page_#{news_page.id}" do
              expect(page).to have_css("img[src='/assets/refinery/icons/flags/en.png']")
              expect(page).to have_css("img[src='/assets/refinery/icons/flags/ru.png']")
            end
          end

          it "shows name in admin menu in current admin locale" do
            visit refinery.testimonials_admin_testimonials_path

            within "#page_#{news_page.id}" do
              expect(page).to have_content(en_page_name)
            end
          end

          it "uses the slug from the default locale in admin" do
            visit refinery.testimonials_admin_testimonials_path

            within "#page_#{news_page.id}" do
              page.find_link('Edit this page')[:href].should include(en_page_slug)
            end
          end

          it "shows correct language and slugs for default locale" do
            visit "/"

            within "#menu" do
              page.find_link(news_page.name)[:href].should include(en_page_slug)
            end
          end

          it "shows correct language and slugs for second locale" do
            visit "/ru"

            within "#menu" do
              page.find_link(ru_page_name)[:href].should include(ru_page_slug_encoded)
            end
          end
        end

        describe "add a testimonial with name only for secondary locale" do
          let(:ru_testimonial) {
            Globalize.with_locale(:ru) {
              Testimonial.create :name => ru_testimonial_name
            }
          }
          let(:ru_testimonial_id) { ru_testimonial.id }
          let(:ru_testimonial_name) { 'Новости' }
          let(:ru_testimonial_slug) { 'новости' }

          before do
            ru_testimonial
            visit refinery.testimonials_admin_testimonials_path
          end

          it "succeeds" do
            ru_testimonial.destroy!
            click_link "Add new testimonial"
            within "#switch_locale_picker" do
              click_link "Ru"
            end
            fill_in "Name", :with => ru_testimonial_name
            click_button "Save"

            expect(page).to have_content("'#{ru_testimonial_name}' was successfully added.")
            Refinery::Testimonial.count.should == 2
          end

          it "shows locale flag for testimonial" do
            within "#page_#{ru_page_id}" do
              expect(page).to have_css("img[src='/assets/refinery/icons/flags/ru.png']")
            end
          end

          it "doesn't show locale flag for primary locale" do
            within "#page_#{ru_page_id}" do
              expect(page).to_not have_css("img[src='/assets/refinery/icons/flags/en.png']")
            end
          end

          it "shows name in the admin menu" do
            within "#page_#{ru_page_id}" do
              testimonial.should have_content(ru_testimonial_name)
            end
          end

          it "uses id instead of slug in admin" do
            within "#page_#{ru_page_id}" do
              page.find_link('Edit this testimonial')[:href].should include(ru_testimonial_id.to_s)
            end
          end

          it "shows in frontend menu for 'ru' locale" do
            visit "/ru"

            within "#menu" do
              expect(page).to have_content(ru_testimonial_name)
              expect(page).to have_css('a', :href => ru_testimonial_slug)
            end
          end

          it "won't show in frontend menu for 'en' locale" do
            visit "/"

            within "#menu" do
            # we should only have the home page in the menu
              expect(page).to have_css('li', :count => 1)
            end
          end
        end
      end

      describe "TranslateTestimonials" do
        login_refinery_translator

        describe "add testimonial to main locale" do
          it "doesn't succeed" do
            visit refinery.testimonials_admin_testimonials_path

            click_link "Add new testimonial"

            fill_in "Name", :with => "Huh?"
            click_button "Save"

            expect(page).to have_content("You do not have the required permission to modify testimonials in this language")
          end
        end

        describe "add testimonial to second locale" do
          before do
            Refinery::I18n.stub(:frontend_locales).and_return([:en, :lv])
            Testimonial.create :name => 'First Testimonial'
          end

          it "succeeds" do
            visit refinery.testimonials_admin_testimonials_path

            click_link "Add new testimonial"

            within "#switch_locale_picker" do
              click_link "Lv"
            end
            fill_in "Name", :with => "Brīva vieta reklāmai"
            click_button "Save"

            expect(page).to have_content("'Brīva vieta reklāmai' was successfully added.")
            Refinery::Testimonial.count.should == 2
          end
        end

        describe "delete testimonial from main locale" do
          before { Testimonial.create :name => 'Default Testimonial' }

          it "doesn't succeed" do
            visit refinery.testimonials_admin_testimonials_path

            click_link "Remove this testimonial forever"

            expect(page).to have_content("You do not have the required permission to modify testimonials in this language.")
            Refinery::Testimonial.count.should == 1
          end
        end
      end
    end
  end
end