$(document).ready(function() {
  $('.container .form-group').find('.rating').raty({
    half: true,
    halfShow: true,
    scoreName: 'rating',
    hints: ['Bad!', 'Poor!', 'Good!', 'Very Good!', 'Awesome!'],
    score: 3.5
  });

  $(".btn-client-url").click(function(){
    $("#modal-client-url .modal-body .url-text").val($(this).data('url'))
  });

  $(".btn-select-text").click(function(){
    $('.url-text').select()
  })
});
