app.controller "EvaluationSetController", ["$scope","$http",($scope,$http)->

  $scope.id  = false
  $scope.questions = []
  $scope.birds = []
  $scope.results = []

  $scope.show_questions = []
  $scope.sub_questions = []
  $scope.show_birds = []

  $scope.init = (num)-> 
    $http.get("/birds.json")
      .success (data, status, headers, config)->
        $scope.birds = data
        $http.get("/evaluation_sets/#{num}.json")
          .success (data, status, headers, config)->
            $scope.questions = data.evaluation_questions

            # scan for sub_questions
            for q in $scope.questions
              if q.sub_question
                $scope.sub_questions.push q.id


            for bird,i in $scope.birds

              $scope.birds[i].results = []
              for result,j in data.evaluation_results

                if result.bird_id == bird.id
                  $scope.birds[i].results.push result
                  

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
 




  $scope.sort_by_name = (order)->
    if order == 'desc'
      asc = false
    else
      asc = true
    $scope.birds.sort( 
      sort_by('name',asc, (a)->
        a.toUpperCase();
      )  
    )


  $scope.is_sub_question = (r)->
    r.evaluation_question_id in $scope.sub_questions



]



app.controller "BirdResultController", ["$scope","$http",($scope,$http)->

  $scope.bird = {}
  $scope.fully_loaded = false


]