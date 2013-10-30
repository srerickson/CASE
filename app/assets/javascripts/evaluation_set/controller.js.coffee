app.controller "EvaluationSetController", ["$scope","$http",($scope,$http)->

  $scope.id  = false
  $scope.questions = []
  $scope.birds = []
  $scope.results = []

  $scope.show_questions = []
  $scope.sub_questions = []
  $scope.show_birds = []

  $scope.sort_field = 'name'
  $scope.sort_order = "asc"

  $scope.set_sort_field = (val)->
    $scope.sort_field = val 

  $scope.toggle_sort_order = ()->
    $scope.sort_order = if $scope.sort_order == 'desc' then 'asc' else 'desc'

  $scope.init = (num)-> 
    $http.get("/birds.json")
      .success (data, status, headers, config)->
        $scope.birds = data

        $http.get("/evaluation_sets/#{num}.json")
          .success (data, status, headers, config)->
            $scope.questions = data.evaluation_questions

            # make sure questions are sorted by position
            $scope.questions.sort((a,b)->
              a.position - b.position 
            )

            $scope.show_questions = $scope.questions

            # build list of sub_questions
            for q in $scope.questions
              $scope.sub_questions.push(q.id) if q.sub_question

            # build bird.results object 
            for result in data.evaluation_results
              bird_index = null
              for b,i in $scope.birds
                  if result.bird_id == b.id
                    bird_index = i
                    break
              break if bird_index == null
              $scope.birds[bird_index].results ||= {}
              $scope.birds[bird_index].results[result.evaluation_question_id] = result
            
            # initial default sort
            $scope.do_sort($scope.sort_field, $scope.sort_order)

          .error (data, status, headers, config)->
            console.log status





  $scope.do_sort = (field,order)->
    console.log "doing sort: #{field}, #{order}"
    order_factor = if order == 'desc' then -1 else 1
    if field == 'name'
      $scope.birds.sort( (a,b)->
        a = a.name.toUpperCase()
        b = b.name.toUpperCase()
        return ((a>b)-(b>a)) * order_factor
      )
    else if isFinite(field)
      q_id = null
      for q in $scope.questions
        if q.position == field 
          q_id = q.id
          break
      return if q_id == null
      $scope.birds.sort( (a,b)->
        a_score = if a.results.hasOwnProperty(q_id) then a.results[q_id].answer_score else NaN
        b_score = if b.results.hasOwnProperty(q_id) then b.results[q_id].answer_score else NaN
        if a_score == b_score and a_score != NaN
          a_count = a.results[q_id].yes_count + a.results[q_id].no_count + a.results[q_id].na_count
          b_count = b.results[q_id].yes_count + b.results[q_id].no_count + b.results[q_id].na_count
          return (a_count - b_count) * order_factor
        else
          return (a_score - b_score) * order_factor


      )    



  $scope.is_sub_question = (q)->
    q.id in $scope.sub_questions



  $scope.$watch('sort_field',()->
    if $scope.birds.length 
      $scope.do_sort($scope.sort_field, $scope.sort_order)
  )

  $scope.$watch('sort_order',()->
    if $scope.birds.length 
      $scope.do_sort($scope.sort_field, $scope.sort_order)
  )



]



app.controller "BirdResultController", ["$scope","$http",($scope,$http)->

  $scope.bird = {}
  $scope.fully_loaded = false


]