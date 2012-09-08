module ApplicationHelper


  def css_class_for_answer(answer)
    "answer_#{answer.answer.downcase.gsub("/","")}"
  end

end
