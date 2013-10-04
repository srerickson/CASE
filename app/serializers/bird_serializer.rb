class BirdSerializer < ActiveModel::Serializer

  attributes :id,
             :name,
             :thumbnail_100_url,
             :thumbnail_50_url,
             :url,
             :foritself,
             :brand,
             :fse_name,
             :fse_owner_founder,
             :fse_significant_member,
             :fse_mission_statement,
             :op_name,
             :op_vip_founders,
             :op_typical_member,
             :formation,
             :history,
             :lifespan,
             :resource,
             :availability,
             :participation,
             :tasks,
             :modularity,
             :granularity,
             :metrics,
             :alliances,
             :clients,
             :sponsors,
             :elites,
             :created_at,
             :updated_at,
             :summary,
             :birder_credits,
             :tangible_problem,
             :tangible_problem_detail

  has_one :fse_org_style
  has_one :op_org_style
  has_one :genus_type
  has_one :habitat
  has_one :updated_by

  def thumbnail_100_url
    begin
      object.logo.asset.url(:sq100, false)
    rescue
      nil
    end
  end

  def thumbnail_50_url
    begin
      object.logo.asset.url(:sq50, false)
    rescue
      nil
    end
  end


end