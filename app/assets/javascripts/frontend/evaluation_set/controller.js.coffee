app.controller "EvaluationSetController", ["$scope","$http","$modal",($scope,$http,$modal)->

  $scope.id  = false
  $scope.questions = []
  $scope.birds = []
  $scope.results = []

  $scope.show_questions = []
  $scope.sub_questions = []
  $scope.show_birds = []

  $scope.sort_field = 'name'
  $scope.sort_order = "asc"

  # sort method updates this after each sort
  # for the view's sake
  $scope.sort_type = "" 

  # data 
  $scope.response_details = false

  $scope.set_sort_field = (val)->
    $scope.sort_field = val 

  $scope.toggle_sort_order = ()->
    $scope.sort_order = if $scope.sort_order == 'desc' then 'asc' else 'desc'

  $scope.init = (num)-> 
    $scope.id = num 
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



  # Supports 4 Types of Sorting
  #
  #  - Birdname A-Z
  #  - Answer Score for a given question (passed as field)
  #  - Euclidean distance from a bird (passed as field)
  #  - Euclidean distance from an arbitrary set of values
  #
  $scope.do_sort = (field,order)->
    order_factor = if order == 'desc' then -1 else 1

    # Sort by Bird Name
    if field == 'name'
      $scope.birds.sort( (a,b)->
        a = a.name.toUpperCase()
        b = b.name.toUpperCase()
        return ((a>b)-(b>a)) * order_factor
      )
      $scope.sort_type = "name"

    # Sort by Question
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
      $scope.sort_type = "question"

    # Sort by Euclidian Distance
    else if field instanceof Object or field instanceof Array
      vals = []
      if field instanceof Object and field.hasOwnProperty("id") and field.hasOwnProperty("results")   
        # field is a bird
        vals = $scope.questions.map((q)-> field.results[q.id];).map( (r)-> r.answer_score; )
      else if field instanceof Array and field.length == $scope.questions.length
        vals = field 
      else
        return 
      for bird in $scope.birds 
        deltas = []
        for val, i in vals
          if val == "*"
            deltas[i] = 0
          else 
            q_id = $scope.questions[i].id 
            deltas[i] = val - bird.results[q_id].answer_score
        bird.distance = Math.sqrt(  deltas.map( (delta)-> delta*delta).reduce((x,y)-> x+y) )
      $scope.birds.sort (a,b)->
        return a.distance - b.distance
      $scope.sort_type = "proximity"
      # after the sort, scroll to top
      $("html, body").animate({ scrollTop: 0 }, 600);

    # end of sort ()-> 


  $scope.is_sub_question = (q)->
    q.id in $scope.sub_questions


  $scope.load_kase = (id)->
    $modal.open(
      templateUrl: "/assets/frontend/evaluation_set/_kase_popup.html"
      windowClass: "kase_popup"
      resolve:
        id: ()-> id
      controller: ($scope,id)->
        $http.get("/birds/#{id}.json")
          .success (data, status, headers, config)->
            $scope.kase = data  

    )


  $scope.$watch('sort_field',()->
    if $scope.birds.length 
      $scope.do_sort($scope.sort_field, $scope.sort_order)
  )

  $scope.$watch('sort_order',()->
    if $scope.birds.length 
      $scope.do_sort($scope.sort_field, $scope.sort_order)
  )

  $scope.$on 'load_response_details', (e, for_bird_question)->
    url = "/evaluation_sets/#{$scope.id}/user_evaluation_answers.json"
    url += "?question_id=#{for_bird_question.question.id}"
    url += "&bird_id=#{for_bird_question.bird.id}"
    $http.get(url).success (response, status, headers, config)->
      $scope.$broadcast("response_details", {
        bird: for_bird_question.bird
        question: for_bird_question.question
        answers: response.user_evaluation_answers
      })

]



app.controller "BirdResultController", ["$scope","$http",($scope,$http)->

  $scope.bird = {}
  $scope.fully_loaded = false

  $scope.load_response_details = (question)->
    $scope.$emit("load_response_details",
      question: question
      bird: $scope.bird
    )

]



app.controller "ResponseDetailsController", ["$scope",($scope)->

  $scope.question = {}
  $scope.answers = []
  $scope.bird = {}
  $scope.show = false

  $scope.$on("response_details", (e, data)->
    $scope.question = data.question
    $scope.answers = data.answers
    $scope.bird = data.bird
    $scope.show = true
  )

  $scope.answers_of_type = (t)->
    $scope.answers.filter( (a)-> a.answer == t)

  $scope.comments_for_answer_type = (t)->
    answers = $scope.answers.filter( (a)-> a.answer == t and !!a.comment )
    answers.map( (a)-> a.comment )




]


app.directive "toggleSummary", ()->
  (scope,elem,attr)->
    elem.bind("click",()->
      elem.closest("section").find("p, ul").toggleClass("hidden", 250)
      elem.children().toggleClass("hidden")
    )
