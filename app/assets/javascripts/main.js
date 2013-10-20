/**
Script for Kanari

@class main
@namespace Kanari
@type {Object}
**/
var Kanari = Kanari  || {};

// @brettTodo - ideally this step process would be a hash based nav
// so the user can navigate back and forward natively

Kanari.main = (function($, document, window, undefined) {
    "use strict";
    // configuration properties

	// view configuration (styling)

    // line charts are instantiated with a container DOM element,
    // a model, and a view
    var view = {
        backgroundColor: '#1B1B24',
        width: 960,
        height: 400,
        series: [
            {
                stroke: '#645DBA', // light green
                strokeWidth: 2,
                lineJoin: 'round'
            },
            {
                stroke: '#8455B7', // light blue
                strokeWidth: 2,
                lineJoin: 'round'
            },
            {
                stroke: '#5483B4', // pink
                strokeWidth: 2,
                lineJoin: 'round'
            },
            {
                stroke: '#E0C25E', // pink
                strokeWidth: 2,
                lineJoin: 'round'
            }

        ]
	};
	
    /* Public Methods _________________________________________________________________ */

    /**
    The initialization of the page and plugins used in the page.

    @method init

    @return {Null} No return value
    **/
    function init() {
		// line charts are instantiated with a container DOM element,
		// a model, and a view

        var iframeElement;
        var widget;

		$(document)
			.on('click', '#recorderUI.reset #controlButton', startRecord)
			.on('click', '#recorderUI.recording #controlButton, #recorderUI.playing #controlButton', stopRecord)			
			.on('click', '#recorderUI.recorded #controlButton', playRecord)						
			.on('click', '#upload', uploadFile)
			.on('click', '#makeplayer', genPlayer)
			.on('click', '#reset', reset)
			.on('UPLOAD_COMPLETE', showPlayer)
            .on('mousemove', function(e){
                //console.log(e.pageX);
			    $('#cursor').css({
			        left:  e.pageX,
			        top:   0
			    });
			})
            .on('WIDGET_INITIALIZED', function(){
                iframeElement   = document.querySelector('iframe');
                widget   = SC.Widget(iframeElement);
                widget.bind(SC.Widget.Events.READY, ready());
                function ready() {
                    $(".kanari-container").on("click", {
                        widget: widget
                    }, function(e){
                        widget = e.data.widget;
                        var setPlayhead = widget.getDuration(function(durationSC) {
                            var playheadX = $("#cursor").offset().left - $(".kanari-container").offset().left;
                            var containerWidth = $(".kanari-container").width();
                            console.log('Track Duration: ' + durationSC);
                            var new_playhead = Math.floor((playheadX / containerWidth) * durationSC);
                            console.log("New Playhead: " + new_playhead);
                            widget.play().seekTo(new_playhead);

                        });
                    });

                }

            });


    }

    /* Private Methods ________________________________________________________________ */

	//chart
	
	function makeChart(){
        console.log("making the Chart");
        $.ajax({
            type: 'GET',
            data: {
                "id": EVENT_ID
            },
            timeout: 5000,
            url: '/events/ajax_get_aggregate_votes',
            success: function (data){
                var lineChart = new MeteorCharts.Line({
                    container: 'graph',
                    model: data,
                    view: view
                });
            },
            error: function (e) {
                console.log("An error occurred, text: " + e.statusText + "; statusCode: " + e.status);
                alert('There was an error loading the data, please try again.');
            }
        });
	}
	
	//soundcloud
	function startRecord(e) {
	    updateTimer(0);
	    SC.record({
	      start: function(){
            console.log("SC.record#start method");
            updateEventTime('start_time');
	        setRecorderUIState("recording");
            $("#controlState").text("Stop");
              $("#controlState").children(".icon").removeClass(".glyphicon-record");
              $("#controlState").children(".icon").addClass(".glyphicon-stop");
	      },
	      progress: function(ms, avgPeak){
	        updateTimer(ms);
	      }
	    });
	    e.preventDefault();
	}
	
	function stopRecord(e) {
        console.log("stopRecord method");
        updateEventTime('end_time');
	    setRecorderUIState("recorded");
        $("#controlState").text("Play");
        $("#upload").removeClass("disabled");
        $("#controlState").children(".icon").removeClass(".glyphicon-stop");
        $("#controlState").children(".icon").addClass(".glyphicon-play");

	    SC.recordStop();
	    e.preventDefault();
	}
	
	function playRecord(e) {
	    updateTimer(0);
	    setRecorderUIState("playing");
        $("#controlState").children(".icon").removeClass(".glyphicon-play");
        $("#controlState").children(".icon").addClass(".glyphicon-pause");
	    SC.recordPlay({
	      progress: function(ms){
	        updateTimer(ms);
	      },
	      finished: function(){
	        setRecorderUIState("recorded");
	      }
	    });
	    e.preventDefault();
	}
	
	function uploadFile(e){
	  setRecorderUIState("uploading");
	  SC.connect({
	    connected: function(){
	      $("#uploadStatus").html("Uploading...");
	      SC.recordUpload({
	        track: {
	          title: $("#controlButton").data("track"),
	          sharing: "public"
	        }
	      }, function(track){
			  $("#uploadStatus").html("Uploaded: <a href='" + track.permalink_url + "'>" + track.permalink_url + "</a>");
              $("#event-uri").val(track.uri);
			  $("#uploadStatus").trigger("UPLOAD_COMPLETE", [{uri: track.uri}]);
		  });
	    }
	  });
	  e.preventDefault();
	}		
	
	
	function showPlayer(e, object){
		var uri = object.uri;
		console.log("SoundCloud track loading:" + uri)

        setTimeout(function() {
            console.log("called making chart");
            makeChart()
        }, 3000);

        setTimeout(function() {
            console.log("drawing player after many seconds or it bombs out." + uri);
            SC.oEmbed(uri, {auto_play: false,
                            color: "#1B1B24",
                            theme_color: "#1B1B24",
                            iframe: true,
                            show_artwork: false,
                            "height": 55,
                            maxwidth: 960,
                            maxheight: 100,
                            buying:	false,
                            liking:	false,
                            enable_api: true,
                            download: false,
                            sharing: false,
                            show_comments: false,
                            show_playcount:	false,
                            show_user: false
                        }, document.getElementById("player"))}, 10000);
        
        setTimeout(function() {
            $(document).trigger("WIDGET_INITIALIZED");
        }, 13500);
	}
	
	
	function genPlayer(){
      var eventUri = $('#event-uri').val();
      console.log("Testing player: "+ eventUri);
	  $("#uploadStatus").trigger("UPLOAD_COMPLETE", [{uri: eventUri}]);
	}
	
	
	function reset(e){
	  SC.recordStop();
	  setRecorderUIState("reset");
	  e.preventDefault();
	}
	
	function updateTimer(ms){
	  $("#timer").text(SC.Helper.millisecondsToHMS(ms));
	}

	function setRecorderUIState(state){
	  // state can be reset, recording, recorded, playing, uploading
	  // visibility of buttons is managed via CSS
	  $("#recorderUI").attr("class", state);
      $("#state").text(state);
	}

    function updateEventTime(which_time)
    {
        $.ajax({
            type: 'POST',
            data: {
                id: EVENT_ID,
                which_event_time: which_time
            },
            timeout: 10000,
            url: '/events/ajax_set_event_time',
            success: function (data){
                console.log("Updated start_time for event successfully");
            },
            error: function (e) {
                console.log("An error occurred, text: " + e.statusText + "; statusCode: " + e.status);
            }
        });
    }

    return {
        init: init
    };

}(jQuery, document, window, undefined));


jQuery(function() {
    "use strict";
    Kanari.main.init();
});
