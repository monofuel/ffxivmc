ffxivmc = angular.module("ffxivmc",[])

mainController = ($scope,$http) ->

  $( "#item_name" ).on('change keyup blur input',() ->
    $scope.selectItem($( "#item_name" ).val())
    )
  $( "#item_id" ).on('change keyup blur input',() ->
    $scope.selectItem($( "#item_id" ).val())
    )
  $( "#repair_name" ).on('change keyup blur input',() ->
    name = $( "#repair_name" ).val()
    id = get_item_id(name)
    if ($scope.selected_item == undefined)
      return
    if ($scope.selected_item.repair_material != id)
      $scope.selected_item.repair_material = id
    )
  $( "#repair_id" ).on('change keyup blur input',() ->
    id = parseInt($( "#repair_id" ).val())
    name = get_item_name(id)
    console.log(name)
    if ($( "#repair_name" ).val() != name)
      $( "#repair_name" ).val(name)
    )

  get_item_id = (name) ->
    for item in $scope.items
      if (item.name == name)
        return item.id
    return ""

  get_item_name = (id) ->
    for item in $scope.items
      if (item.id == id)
        return item.name
    return ""

  set_new_item_button = () ->
    $("#item_button").on("click",$scope.createItem)
    $("#item_button").html("Create new item")
    $("#item_button").attr("disabled", false)

  set_update_item_button = () ->
    $("#item_button").on("click",$scope.updateItem)
    $("#item_button").html("Update item")
    $("#item_button").attr("disabled", false)

  set_new_recipe_button = () ->
    $("#recipe_button").on("click",$scope.createRecipe)
    $("#recipe_button").html("Create new recipe")
    $("#recipe_button").attr("disabled", false)

  set_update_recipe_button = () ->
    $("#recipe_button").on("click",$scope.updateRecipe)
    $("#recipe_button").html("Update recipe")
    $("#recipe_button").attr("disabled", false)

  set_new_item_button()

  $http.get('/item')
      .success((data) ->
        $scope.items = data

        itemNames = new Array()
        for item in data
          itemNames.push(item.name)

        $( "#item_name" ).autocomplete(
          source: itemNames
          )
        $( "#repair_name" ).autocomplete(
          source: itemNames
          )
      )
      .error((data) ->
        console.log('Error: ' + data)
      )

  $scope.selectItem = (item) ->
    if (item == undefined || item == "")
      set_new_item_button()
      return

    if (isNaN((parseInt(item))))
      $http.get('/item?name=' + item)
        .success((data) ->
          if (Object.keys(data).length > 0)
            $scope.selected_item = data
            $( "#repair_name" ).val(get_item_name(
              $scope.selected_item.repair_material))
            $scope.selected_recipe = {}
            $scope.selected_recipe.craft_mats = new Array()
            $scope.selectRecipe($scope.selected_item.id)
            set_update_item_button()
            set_new_recipe_button()
        )
        .error((data) ->
          console.log('Error: ' + data)
        )
    else
      $http.get('/item?id=' + item)
        .success((data) ->
          if (Object.keys(data).length > 0)
            $scope.selected_item = data
            $( "#repair_name" ).val(get_item_name(
              $scope.selected_item.repair_material))
            $scope.selected_recipe = {}
            $scope.selected_recipe.craft_mats = new Array()
            $scope.selectRecipe(item)
            set_update_item_button()
            set_new_recipe_button()
        )
        .error((data) ->
          console.log('Error: ' + data)
        )

  $scope.addNewMat = () ->
    if ($scope.selected_recipe == undefined)
      $scope.selected_recipe = {}
    if ($scope.selected_recipe.craft_mats == undefined)
      $scope.selected_recipe.craft_mats = new Array()
    $scope.selected_recipe.craft_mats.push({item:0,quantity:0})

  $scope.updateItem = (item) ->
    $http.put('/item/' + item.id,item)
      .success((data) ->
        console.log("saved!")
      )
      .error((data) ->
        console.log("Error: " + data)
      )

  $scope.createItem = () ->
    $http.post('/item', $scope.selected_item)
        .success((data) ->
          console.log(data)
        )
        .error((data) ->
          console.log('Error: ' + data)
        )

  $scope.deleteItem = (item) ->
    $http.delete('/item?item=' + item)
        .success((data) ->
          console.log(data)
        )
        .error((data) ->
          console.log('Error: ' + data)
        )

  $scope.selectRecipe = (item) ->
    $http.get('/recipe?id=' + item)
      .success((data) ->
        if (Object.keys(data).length > 0)
          $scope.selected_recipe = data
          set_update_recipe_button()

      )
      .error((data) ->
        console.log('Error: ' + data)
      )

  $scope.updateRecipe = (item) ->
    $http.put('/recipe/' + item.id,item)
      .success((data) ->
        console.log("saved!")
      )
      .error((data) ->
        console.log("Error: " + data)
      )

  $scope.createRecipe = () ->
    $http.post('/recipe', $scope.selected_recipe)
        .success((data) ->
          console.log(data)
        )
        .error((data) ->
          console.log('Error: ' + data)
        )

  $scope.deleteRecipe = (item) ->
    $http.delete('/recipe?item=' + item)
        .success((data) ->
          console.log(data)
        )
        .error((data) ->
          console.log('Error: ' + data)
        )
