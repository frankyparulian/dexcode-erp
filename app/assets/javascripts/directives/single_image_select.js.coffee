app = angular.module("dexcode")

app.directive "singleImageSelect", ->
  restrict: "E"
  templateUrl: "/templates/shared/single_image_select.html"
  link: (scope, element, attrs) ->
    element.addClass "single-image-select"
    scope.imagePreviewStyle = "background-image: url(\"" + attrs.src + "\")"  if attrs.src
    scope.attrs = attrs
    return

  controller: [
    "$scope"
    "$element"
    ($scope, $element) ->
      clearFileInput = ->
        $el = $element.find(".file-select")
        $el.replaceWith $el.clone(true)

      $scope.removeFile = ->
#        $scope.singleImageSelect.file = null
#        $scope.singleImageSelect.removeFile = true
        $scope.imagePreviewStyle = ""
        clearFileInput()

      $scope.onFileSelect = ($files) ->
        file = $files[0]
        reader = new FileReader()
#        $scope.singleImageSelect.file = file
#        $scope.singleImageSelect.removeFile = false
        if file
          reader.readAsDataURL file
          reader.onload = (_file) ->
            $scope.$apply ->
              src = _file.target.result
              $scope.imagePreviewStyle = "background-image: url(\"" + src + "\")"
        else
          $scope.imageSrc = null
  ]
  controllerAs: "fileUpload"
