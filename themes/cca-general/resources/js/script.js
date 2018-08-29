$(document).ready(function() {
    initNavBarSlideOut();
    initScrollForNavBar();

});

var initNavBarSlideOut = function() {
    // Open navbarSide when button is clicked
    $('#navbarSideButton').on('click', function() {
        $('#navbarSide').addClass('reveal');
        $('.overlay').show();
    });

    // Close navbarSide when the outside of menu is clicked
    $('.overlay').on('click', function() {
        $('#navbarSide').removeClass('reveal');
        $('.overlay').hide();
    });

    // Close navbarSide when "close" button is pressed
    $('.close-side-button').on('click', function() {
        $('#navbarSide').removeClass('reveal');
        $('.overlay').hide();
    });
};
