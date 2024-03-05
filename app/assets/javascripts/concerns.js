// app/assets/javascripts/concerns.js

$(document).on('click', '.delete-concern', function(e) {
    e.preventDefault(); // Prevent the default link behavior
  
    var concernId = $(this).data('id'); // Get the ID of the concern
  
    // Send an AJAX request to delete the concern
    $.ajax({
      url: '/concerns/' + concernId,
      type: 'DELETE',
      success: function(response) {
        // Remove the concern from the page
        $('#concern_' + concernId).remove();
        alert('Concern deleted successfully!');
      },
      error: function(xhr) {
        alert('Error deleting concern');
      }
    });
  });
  