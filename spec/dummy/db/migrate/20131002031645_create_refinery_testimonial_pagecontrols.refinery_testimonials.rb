# This migration comes from refinery_testimonials (originally 2)

class CreateRefineryTestimonialPagecontrols < ActiveRecord::Migration

  def change
    create_table :refinery_testimonials_pagecontrols do |t|
      t.boolean    :show
      t.integer    :count
      t.string     :select
      t.references :page
      t.timestamps
    end

  end

end
