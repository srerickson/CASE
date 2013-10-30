app.controller "EvaluationSetController", ["$scope","$http",($scope,$http)->

  $scope.id  = false
  $scope.questions = []
  $scope.birds = []
  $scope.results = []

  $scope.show_questions = []
  $scope.sub_questions = []
  $scope.show_birds = []

  # $scope.question_select = ""


  # $scope.$watch("question_select",()->
  #   nums = $scope.question_select.split(",")
  #   $scope.show_questions = $scope.questions.filter( (q)-> q.position.toString() in nums)
  # )


  $scope.init = (num)-> 
    $http.get("/birds.json")
      .success (data, status, headers, config)->
        $scope.birds = data

        # make sure birds are sorted by name
        $scope.birds.sort( 
          sort_by('name',true, (a)->
            a.toUpperCase();
          )  
        )

        $http.get("/evaluation_sets/#{num}.json")
          .success (data, status, headers, config)->
            $scope.questions = data.evaluation_questions

            # make sure questions are sorted by position
            $scope.questions.sort((a,b)->
              a.position - b.position 
            )

            # $scope.question_select = $scope.questions.map((q)-> q.position.toString()).join(",")
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
                  

          .error (data, status, headers, config)->
            console.log status

  # http://stackoverflow.com/a/979325
  sort_by = (field, reverse, primer) ->
    if primer
      key = (x)->
        primer(x[field])
    else
      key = (x)-> 
        x[field]
    reverse = [-1, 1][+!!reverse]
    return (a, b) ->
       a = key(a)
       b = key(b)
       return reverse * ((a > b) - (b > a))
 

  $scope.sort_by_name = (order='asc')->
    if order == 'desc'
      asc = false
    else
      asc = true
    $scope.birds.sort( 
      sort_by('name',asc, (a)->
        a.toUpperCase();
      )  
    )

  $scope.sort_by_question = (q_id, order)->
    order = if order == 'desc' then -1 else 1
    $scope.birds.sort( (a,b)->
      a_score = if a.results.hasOwnProperty(q_id) then a.results[q_id].answer_score else NaN
      b_score = if b.results.hasOwnProperty(q_id) then b.results[q_id].answer_score else NaN
      if a_score == b_score and a_score != NaN
        a_count = a.results[q_id].yes_count + a.results[q_id].no_count + a.results[q_id].na_count
        b_count = b.results[q_id].yes_count + b.results[q_id].no_count + b.results[q_id].na_count
        return (a_count - b_count) * order
      else
        return (a_score - b_score) * order
    )    



  $scope.is_sub_question = (q)->
    q.id in $scope.sub_questions



]



app.controller "BirdResultController", ["$scope","$http",($scope,$http)->

  $scope.bird = {}
  $scope.fully_loaded = false


]