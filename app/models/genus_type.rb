class GenusType < ActiveRecord::Base
  has_many :birds

  def as_json(options={})
     super(options.merge(
      :include => {
        :birds => {
          :include => {
            :logo => {:methods => [:original_url]},
            :images => {:methods => [:original_url]},
            :habitat => {},
            :fse_org_style => {},
            :op_org_style => {}
          },
          :methods => [:path]
        }
      }
    ))
  end

end
