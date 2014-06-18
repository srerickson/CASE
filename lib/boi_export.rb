module BOIExport 

  def self.export_bird(b)
    f = File.open("export/birds/#{b.id}.json", "w") do |f|
      f.write(JSON.pretty_generate( BirdSerializer.new(b).serializable_hash ))
    end
  end


end