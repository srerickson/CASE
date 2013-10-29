app.directive "caseResultPie", [ ()->

  linker = (scope, elem, attrs)->
    if scope.subQuestion()
      elem.addClass('sub_question')

    setTimeout( ()->
      draw_answer_pie.apply( elem,[
        scope.result.yes_count,
        scope.result.no_count,
        scope.result.na_count,
        scope.result.blank_count,
        scope.result.yes_comments,
        scope.result.no_comments,
        scope.result.na_comments,
      ]) 
    ,1)

  return {
    link: linker
    scope:{
      result:"=ngModel"
      subQuestion: "&"
    }

  }

]