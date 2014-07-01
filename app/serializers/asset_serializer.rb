class AssetSerializer < ActiveModel::Serializer

  attributes :url

  def url
    object.asset.url
  end

end