ffxivmc = angular.module("ffxivmc",[])

mainController = ($scope,$http) ->
  $scope.formData = {}
  $scope.marketTypes = [{id: 1, name: 'Limsa'},
                        {id: 2, name: 'Gridania'}
                        {id: 3, name: 'Uldah'}
                        {id: 4, name: 'Foundation'}]

  #when landing on the page, get all todos and show them
  $http.get('/marketorder')
      .success((data) ->
          $scope.orders = data
      )
      .error((data) ->
          console.log('Error: ' + data)
      )

  $scope.selectOrder = (item_id) ->
    $http.get('/marketorder?item=' + item_id)
      .success((data) ->
        $scope.selected_order = data
      )
      .error((data) ->
        console.log('Error: ' + data)
      )

  $scope.updateOrder = (order) ->
    $http.put('/marketorder/' + order._id,order)
      .success((data) ->
        console.log("saved!")
      )
      .error((data) ->
        console.log("Error: " + data)
      )

  #when submitting the add form, send the text to the node API
  $scope.createOrder = () ->
      $http.post('/marketorder', $scope.formData)
          .success((data) ->
              $scope.formData = {} #clear the form so our user is ready to enter another
              $scope.orders = data
              console.log(data)
          )
          .error((data) ->
              console.log('Error: ' + data)
          )

  #delete a todo after checking it
  $scope.deleteOrder = (item_id) ->
      $http.delete('/marketorder?item=' + item_id)
          .success((data) ->
              $scope.todos = data
              console.log(data)
          )
          .error((data) ->
              console.log('Error: ' + data)
          )
