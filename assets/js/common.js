$(document).ready(function() {
    $('button.abstract, button.bibtex').click(function() {
        var target = $('#' + $(this).attr('aria-controls'));
        var willOpen = !target.hasClass('open');
        target.toggleClass('open', willOpen).prop('hidden', !willOpen);
        $(this).attr('aria-expanded', willOpen);
    });
    $('.navbar-nav').find('a').removeClass('waves-effect waves-light');
});
