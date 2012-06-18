class OrgStyle < ActiveRecord::Base

  has_many :fse_birds, :class_name => "Bird", :foreign_key => "fse_org_style_id"
  has_many :op_birds, :class_name => "Bird", :foreign_key => "op_org_style_id"

  def as_json(options={})
    super(options.merge(
      :include => {
        :fse_birds => {
          :include => {
            :logo => {:methods => [:original_url]},
            :images => {:methods => [:original_url]},
            :habitat => {},
            :genus_type => {},
            :fse_org_style => {},
            :op_org_style => {}
          },
          :methods => [:path]
        },
        :op_birds => {
          :include => {
            :logo => {:methods => [:original_url]},
            :images => {:methods => [:original_url]},
            :habitat => {},
            :genus_type => {},
            :fse_org_style => {},
            :op_org_style => {}
          },
          :methods => [:path]
        }
      }
    ))
  end


end
