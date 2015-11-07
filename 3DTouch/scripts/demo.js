function checkSimulator () {
  if (window.navigator.simulator === true) {
    alert('This plugin is not available in the simulator.');
    return true;
  } else if (window.ThreeDeeTouch === undefined) {
    alert('Plugin not found. Maybe you are running in AppBuilder Companion app which currently does not support this plugin.');
    return true;
  } else {
    return false;
  }
}

document.addEventListener('deviceready', function () { 
  if (checkSimulator()) {
    return;
  }
	// register a callback handler which will fire when the app is launched from a home icon action
	ThreeDeeTouch.onHomeIconPressed = function (payload) {
    // wrapping the alert in a timeout so it doesn't block the UI when the app is launched
    setTimeout(function() {
	    alert("Icon pressed. Type: " + payload.type + ". Title: " + payload.title + ".");      
    }, 500);
    // now do something based on the payload.type, f.i. navigate to a specific page
    if (payload.type == 'infopage') {
      document.location.href = "#tabstrip-home";
    } else if (payload.type == 'demopage') {
      document.location.href = "#tabstrip-demo";
    } else {
      // hook up any other icons you may have and do something awesome
      // (e.g. launch the Camera UI, then share the image to Twitter)
      console.log(JSON.stringify(payload));
    }
  }
}, false);

(function (global) {
  var DemoViewModel,
      app = global.app = global.app || {};

  DemoViewModel = kendo.data.ObservableObject.extend({

    isAvailable: function () {
      if (!checkSimulator()) {
	      ThreeDeeTouch.isAvailable(function (avail) {
  	      alert(avail ? "YES" : "NO");
  			});
      }
    },

    configureQuickActions: function () {
      if (!checkSimulator()) {
        ThreeDeeTouch.configureQuickActions([
          {
            type: 'infopage', // optional, but can be used in the onHomeIconPressed callback
            title: 'Info', // mandatory
            subtitle: 'Deeplink to the info page', // optional
            iconType: 'Compose' // optional
          },
          {
            type: 'demopage',
            title: 'Demo',
			      subtitle: 'Deeplink to the demo',
      			iconType: 'Share'
			    },
			    {
			      type: 'search',
			      title: 'Search',
			      iconType: 'Search'
			    }
			  ]);
      }
    },


    configureQuickActionsAlt: function () {
      if (!checkSimulator()) {
        ThreeDeeTouch.configureQuickActions([
          {
        		type: 'capturePhoto',
        		title: 'Capture photo',
        		subtitle: 'Snag a pic',
        		iconType: 'CapturePhoto'
      		},
          {
        		type: 'captureVideo',
        		title: 'Capture video',
        		subtitle: 'Record a video',
        		iconType: 'CaptureVideo'
      		}
			  ]);
      }
    },

    enableLinkPreview: function () {
      if (!checkSimulator()) {
	      ThreeDeeTouch.enableLinkPreview(function () {
  	      alert("Link preview is now enabled. Apply a bit of pressure when pressing that link!");
  			});
      }
    },

    disableLinkPreview: function () {
      if (!checkSimulator()) {
	      ThreeDeeTouch.disableLinkPreview(function () {
  	      alert("Link preview is now disabled.");
  			});
      }
    }
  });

  app.demoService = {
    viewModel: new DemoViewModel()
  };
})(window);