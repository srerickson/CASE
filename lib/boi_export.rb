module BOIExport 

  def self.export_bird(b)
    f = File.open("export/birds/#{b.id}.json", "w") do |f|
      f.write(JSON.pretty_generate( BirdSerializer.new(b).serializable_hash ))
    end
  end

  def self.export_evaluation_answers
    Bird.all.each do |b| 
      EvaluationQuestion.all.each do |q|
        responses = UserEvaluationAnswer.for_evaluation_set(1)
                                         .for_question(q.id)
                                         .for_bird(b.id)
                                         .to_a

        j = JSON.pretty_generate(
          ActiveModel::ArraySerializer.new(
            responses, each_serializer: UserEvaluationAnswerSerializer
          ).serializable_array
        )
        File.open("export/evaluation_answers/b_#{b.id}-q_#{q.id}.json","w").write(j)
      end
    end
  end

  def self.export_users 
    users = User.all.map(&:attributes)
    File.open("export/users.json","w") do |f|
      f.write(JSON.pretty_generate(users))
    end
  end


end