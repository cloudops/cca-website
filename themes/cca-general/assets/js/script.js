$(document).ready(function () {
    initNavBarSlideOut();
});

var initNavBarSlideOut = function () {
    // Open navbarSide when button is clicked
    $('#navbar-side-button').on('click', function () {
        $('.navbar-side').addClass('reveal');
        $('.overlay').show();
    });

    // Close navbarSide when the outside of menu is clicked
    $('.overlay').on('click', function () {
        $('.navbar-side').removeClass('reveal');
        $('.overlay').hide();
    });

    // Close navbarSide when "close" button is pressed
    $('.close-side-button').on('click', function () {
        $('.navbar-side').removeClass('reveal');
        $('.overlay').hide();
    });
};
