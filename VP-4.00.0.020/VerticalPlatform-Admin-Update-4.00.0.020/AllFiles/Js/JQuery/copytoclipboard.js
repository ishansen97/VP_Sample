/*copying to clipboard */
      
  ZeroClipboard.moviePath = '../../Media/Default/ZeroClipboard.swf';
	    function CopyToClipboard() {
	        $(".common_data_grid tbody td:last-child").each(function () {
	            //Create a new clipboard client
	            var clip = new ZeroClipboard.Client();

	            //Cache the last td and the parent row    
	            var lastTd = $(this);
	            var parentRow = lastTd.parent("tr");

	            clip.setHandCursor(true);

	            //Glue the clipboard client to the last td in each row
	            clip.glue(lastTd[0]);

	            //Grab the text from the parent row of the iconsS
	            var txt = $("td span.errormessage", parentRow).attr("title");
	            clip.setText(txt);

	            //Add a complete event to let the user know the text was copied
	            clip.addEventListener('complete', function (client, txt) {
	                alert("Copied the error message to clipboard:\n" + txt); 
	            });

	        });
	    };
