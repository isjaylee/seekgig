$(document).ready(function() {
  $('input[name="searchable"]').on('switchChange.bootstrapSwitch', function(event, state) {
    $.ajax({
      type: 'POST',
      url: '/users/update_searchable',
      data: {
        searchable: state,
      },
      success: function(){
      }
    });
  });
});