app.controller "EvaluationSetController", ["$scope","$http",($scope,$http)->

  $scope.id  = false
  $scope.questions = []
  $scope.birds = []
  $scope.results = []


  $scope.init = (num)-> 
    $http.get("/birds.json")
      .success (data, status, headers, config)->
        $scope.birds = data
        $http.get("/evaluation_sets/#{num}.json")
          .success (data, status, headers, config)->
            $scope.questions = data.evaluation_questions
            for b,i in $scope.birds
              $scope.birds[i].results = []
              for r,j in data.evaluation_results
                if r.bird_id == b.id
                  $scope.birds[i].results.push r
                  

          .error (data, status, headers, config)->
            console.log status

  # results_for_bird = (bird_id)->
  #   if bird_id 
  #     for r in $scope.results
  #       return r if r.id == bird_id


  $scope.shuffle = () ->
    a = $scope.birds
    # From the end of the list to the beginning, pick element `i`.
    for i in [a.length-1..1]
      # Choose random element `j` to the front of `i` to swap with.
      j = Math.floor Math.random() * (i + 1)
      # Swap `j` with `i`, using destructured assignment
      [a[i], a[j]] = [a[j], a[i]]

    # Return the shuffled array.
    $scope.birds = a


]



app.controller "BirdResultController", ["$scope","$http",($scope,$http)->

  $scope.bird = {}
  $scope.bird_results = []
  $scope.fully_loaded = false


]