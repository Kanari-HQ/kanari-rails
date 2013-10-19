/**
 Kanari Global JS

 @class vote
 @namespace Kanari
 @type {Object}
 **/
var Kanari = Kanari || {};

Kanari.vote = (function($, document, window, undefined) {
    "use strict";

// configuration properties

    /* Public Methods _________________________________________________________________ */

    /**
     The initialization of the page and plugins used in the page.

     @method init

     @return {Null} No return value
     **/
    function init() {
        $(document)
            .on('click', '.buttons a', buttonClick);
        $('#infoModal').modal('show');
    }

    /* Private Methods ________________________________________________________________ */

    function buttonClick(e) {
        e.preventDefault();
        var $btn = $(this),
            $feedback = $('.feedback'),
            time = Date.now();

        console.log('Event: ' + EVENT_ID + ' respondent: ' + RESPONDANT_ID + ' response: ' + $btn.data('response'));

        $.ajax({
             type: 'POST',
             data: {
                 "vote[event_id]": EVENT_ID,
                 "vote[vote_type]": $btn.data('response'),
                 respondent: RESPONDANT_ID
             },
             timeout: 5000,
             url: '/votes',
             success: function (){
                 showFeedback($feedback);
             },
             error: function (e) {
                 console.log("An error occurred, text: " + e.statusText + "; statusCode: " + e.status);
             }
        });
    }

    function showFeedback($feedback) {
        $feedback.stop();
        $feedback.fadeIn(250, function(){
            setTimeout(function(){
                $feedback.fadeOut(200);
            }, 400);
        });
    }

    return {
        init: init
    }

}(jQuery, document, window, undefined));

jQuery(function() {
    "use strict";
    Kanari.vote.init();
})