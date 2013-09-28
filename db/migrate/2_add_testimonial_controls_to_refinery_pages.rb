
class CreatePageTestimonials < ActiveRecord::Migration

  def up
    create_table  :refinery_page_testimonials do |t|
      t.boolean   :testimonials_show
      t.integer   :testimonials_count
      t.integer   :testimonials_select
			t.reference :refinery_pages
      t.timestamps
    end

  end

  def down

    drop_table :refinery_testimonials

  end

end
