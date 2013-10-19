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

    //SC Config




    // model configuration (data)
	var secondsInYear = 60 * 60 * 24 * 365;
	var graphTitle = $("#controlButton").data("track");
	var model = {
	  title: 'Kanari',
	  series: [{
	    title: 'Thumbs Up',
	    points: [
	      {x: secondsInYear * 0, y: 7.0},
	      {x: secondsInYear * 1, y: 6.9},
	      {x: secondsInYear * 2, y: 9.5},
	      {x: secondsInYear * 3, y: 14.5},
	      {x: secondsInYear * 4, y: 18.2},
	      {x: secondsInYear * 5, y: 21.5},
	      {x: secondsInYear * 6, y: 25.2},
	      {x: secondsInYear * 7, y: 26.5},
	      {x: secondsInYear * 8, y: 23.3},
	      {x: secondsInYear * 9, y: 18.3},
	      {x: secondsInYear * 10, y: 13.9},
	      {x: secondsInYear * 11, y: 9.6}
	    ] 
	  },
	  {
	    title: 'Thumbs Down',
	    points: [
	      {x: secondsInYear * 0, y: -0.2},
	      {x: secondsInYear * 1, y: 0.8}, 
	      {x: secondsInYear * 2, y: 5.7},
	      {x: secondsInYear * 3, y: 11.3},
	      {x: secondsInYear * 4, y: 17.0},
	      {x: secondsInYear * 5, y: 22.0},
	      {x: secondsInYear * 6, y: 24.8},
	      {x: secondsInYear * 7, y: 24.1},
	      {x: secondsInYear * 8, y: 20.1},
	      {x: secondsInYear * 9, y: 14.1},
	      {x: secondsInYear * 10, y: 8.6},
	      {x: secondsInYear * 11, y: 2.5}
	    ] 
	  }, {
	    title: 'Confused',
	    points: [
	      {x: secondsInYear * 0, y: -0.2},
	      {x: secondsInYear * 1, y: 0.8}, 
	      {x: secondsInYear * 2, y: 5.7},
	      {x: secondsInYear * 3, y: 11.3},
	      {x: secondsInYear * 4, y: 17.0},
	      {x: secondsInYear * 5, y: 22.0},
	      {x: secondsInYear * 6, y: 24.8},
	      {x: secondsInYear * 7, y: 24.1},
	      {x: secondsInYear * 8, y: 20.1},
	      {x: secondsInYear * 9, y: 14.1},
	      {x: secondsInYear * 10, y: 8.6},
	      {x: secondsInYear * 11, y: 2.5}
	    ] 
	  }, {
	    title: 'Love',
	    points: [
	      {x: secondsInYear * 0, y: -0.2},
	      {x: secondsInYear * 1, y: 0.8}, 
	      {x: secondsInYear * 2, y: 5.7},
	      {x: secondsInYear * 3, y: 11.3},
	      {x: secondsInYear * 4, y: 17.0},
	      {x: secondsInYear * 5, y: 22.0},
	      {x: secondsInYear * 6, y: 24.8},
	      {x: secondsInYear * 7, y: 24.1},
	      {x: secondsInYear * 8, y: 20.1},
	      {x: secondsInYear * 9, y: 14.1},
	      {x: secondsInYear * 10, y: 8.6},
	      {x: secondsInYear * 11, y: 2.5}
	    ] 
	  }]
	};
    
	
	// view configuration (styling)
	var view = {
	  width: 960,
	  height: 400
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
			    $('#testing').css({
			        left:  e.pageX,
			        top:   0
			    });
			})
            .on('WIDGET_INITIALIZED', function(){
                iframeElement   = document.querySelector('iframe');
                widget   = SC.Widget(iframeElement);
                console.log(widget);
            })

        //@nathanTODO next step attach click event on SC graph to set number of milliseconds and play from location on chart



    }

    /* Private Methods ________________________________________________________________ */

	//chart
	
	function makeChart(){
        console.log("making the Chart");
		var lineChart = new MeteorCharts.Line({
					  container: 'graph',
					  model: model,
					  view: view
					});
	}
	
	//soundcloud
	function startRecord(e) {
	    updateTimer(0);
	    SC.record({
	      start: function(){
	        setRecorderUIState("recording");
            $("#controlState").text("Stop");
	      },
	      progress: function(ms, avgPeak){
	        updateTimer(ms);
	      }
	    });
	    e.preventDefault();
	}
	
	function stopRecord(e) {
	    setRecorderUIState("recorded");
        $("#controlState").text("Play");
	    SC.recordStop();
	    e.preventDefault();
	}
	
	function playRecord(e) {
	    updateTimer(0);
	    setRecorderUIState("playing");
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
            console.log("drawing player after 5 seconds" + uri);
            SC.oEmbed(uri, {auto_play: false,
                            color: "#000000",
                            theme_color: "#000000",
                            iframe: true,
                            show_artwork: false,
                            "height": 81,
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
                        }, document.getElementById("player"))}, 5000);
        setTimeout(function() {
            $(document).trigger("WIDGET_INITIALIZED");
        }, 8000);
	}

	function genPlayer(){
	  $("#uploadStatus").trigger("UPLOAD_COMPLETE", [{uri: 'http://soundcloud.com/audienceanalog/macbeth'}]);
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

    return {
        init: init
    };

}(jQuery, document, window, undefined));


jQuery(function() {
    "use strict";
    Kanari.main.init();
});
