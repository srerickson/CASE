class EvaluationSet  < ActiveRecord::Base;

  has_many :evaluation_questions, :order => "position ASC"
  has_many :user_evaluations
  belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"

  accepts_nested_attributes_for :evaluation_questions, :allow_destroy => true

  
  
  def all_results
    results = EvaluationSet.build_empty_results( Bird.all.map{|b| b.name}, self.evaluation_questions.map{|q| q.id.to_s})
    all_answers = UserEvaluationAnswer.includes({:user_evaluation => [:bird, :evaluation_set]})
                    .where("user_evaluations.evaluation_set_id = ?", self.id).order("birds.name ASC")
    all_answers.each do |a|
      q = a.evaluation_question.id.to_s
      if(a.yes?)
        results[a.user_evaluation.bird.name][q][:yes] += 1
      elsif(a.no?)
        results[a.user_evaluation.bird.name][q][:no] += 1 
      elsif(a.n_a?)
        results[a.user_evaluation.bird.name][q][:na] += 1
      else
        results[a.user_evaluation.bird.name][q][:blank] += 1
      end
    end
    results
  end



  def self.question_results(q_id)
    results = build_empty_results( Bird.all.map{|b| b.name},[q_id.to_s])
    all_answers = UserEvaluationAnswer.includes({:user_evaluation => [:bird, :evaluation_set]})
                    .where("evaluation_question_id = ?", q_id).order("birds.name ASC") 
    all_answers.each do |a|
      if(a.yes?)
        results[a.user_evaluation.bird.name][q_id.to_s][:yes] += 1
      elsif(a.no?)
        results[a.user_evaluation.bird.name][q_id.to_s][:no] += 1 
      elsif(a.n_a?)
        results[a.user_evaluation.bird.name][q_id.to_s][:na] += 1
      else
        results[a.user_evaluation.bird.name][q_id.to_s][:blank] += 1
      end
    end
    results
  end
  
  
  def self.build_empty_results(bird_collection,question_collection)
    results = Hash.new()
    bird_collection.each do |b|
      results[b] = Hash.new()
      question_collection.each do |q|
        results[b][q] = {:yes => 0, :no => 0, :na => 0, :blank => 0}
      end
    end
    results
  end


end
