/* pushing all ModalWindow objects to this array for easy access */
var modalArray = [];


/* Execute when docuemnt is ready */
$(document).ready( function() {

	displayToolInfoEvent();
	tileClickEvent();
	showHideTrayEvent();

});


/* Object constructor that takes jQuerry objects as parameters */
/* New ModalWindow-objects are created in the tileClickEvent() */
function  ModalWindow(modal, button, tool) {
	this.modal = modal;
	this.button = button;
	this.tool = tool;
	this.isOpen;

	this.showModalWindow = function() 
	{ 
		modal.modal(); 
		this.isOpen = true;
		button.removeClass("tile-icon-inactive");
	}

	this.minimize = function() 
	{ 
		modal.modal("hide"); 
		this.isOpen = false; 
		button.addClass("tile-icon-inactive");
	}

	this.close = function() 
	{ 
		modal.remove();
		button.remove();
		$("body").removeClass("modal-open"); //removing class bootstraps append that dont get removed when removing modal.
		$(".modal-backdrop").remove(); //removing element bootstraps append that dont get removed when removing modal.

		//Removing object from array.
		$.each(modalArray, function(index, value) {
			if( modal.attr("id") == value.modal.attr("id") )
			{
					modalArray.splice(index, 1);
			}
		});
	}

	this.maximize =  function(btn) 
	{ 
		if( $(btn).hasClass("fa-window-restore") )
		{
			modal.find(".cu-modal-dialog").removeClass("maximized"); 
			$(btn).addClass("fa-window-maximize").removeClass("fa-window-restore"); 
		}
		else
		{
			modal.find(".cu-modal-dialog").addClass("maximized");
			$(btn).addClass("fa-window-restore").removeClass("fa-window-maximize"); 
		}
	}
}


/* Event for the help-popups fort he tools */
function displayToolInfoEvent() {
	$(".mif-question").click(function(){

		event.stopPropagation(); //Stops more onclick-events from triggering

		var url =  "about/" + $(this).parents("[data-info]").data("info");
		var toolTitle = $(this).parent().find(".tile-label").text();
		$("#help-title").text(toolTitle);

	  $.get(url, function(respnose) {
	    $("#tool-help-info").html(respnose);
		});

	  $("#tool-help").modal(); //Opening the Help-modal

	});
}


/* Event for the tile-buttons in the tray-bar (Are added in addEvents() ) */
function winButtonEvent(modal) 
{
	var isOpen = modal.isOpen;

	// Minimizez all modals when a new is opened so they don't stack
	$.each(modalArray, function(element, value) {
		value.minimize();
	});

	if( !isOpen )
	{
		modal.showModalWindow();
	}
}


/* Function for creating, adding events, and displaying a new modal-window when a tile is pressed */
function tileClickEvent() {

	$(".tile-wide, .tile-square, .tile-small").click(function() {

	var id = generateUniqueID();
	var modalId = "#modal_" + id;
	var buttonId = "#btn_" + id;

	var url = $(this).data("url");
	var toolTitle = $(this).find(".tile-label").text();

	var modalCode = createModalCode(modalId, url, toolTitle);
	$(modalCode).appendTo("#iframe-container");
	$(modalId).modal({backdrop: 'static', keyboard: false});

	var btnTile = createTileButton(this, buttonId);
	$(btnTile).appendTo("#bottom-tray");

	var newModal = new ModalWindow($(modalId), $(buttonId), $(this));
	modalArray.push(newModal);

	addEvents(newModal, buttonId);

	newModal.showModalWindow();

	}); 
}


/* returns the millisecons since JAN 1970, that's quite unique! */
function generateUniqueID() {
	return Date.now();
}


/* The code for the button in the tray-bar */
function createTileButton(tile, buttonId) {

	var imgSrc = $(tile).find(".icon").attr("src");
	var color =  $(tile).css("backgroundColor");
	var buttonId = buttonId.substring(1); // removing the # from the begining of the string.

	var tileCode = 
	'<div class="tile-small tile-icon" style="background-color:' + color + '"; id="' + buttonId + '">' +
		'<div class="tile-content iconic slide-up">' +
			'<div class="slide">' +
				'<img class="icon" src="' + imgSrc + '">' +
			'</div>' +
		'</div>' +
	'</div>';

	return tileCode;

}

/* Bootstrap modal-code that the iframe that displays the tool is embeded in */
function createModalCode(id, url, toolTitle) {

	var id = id.substring(1); // removing the # from the begining of the string.

	var newModal =
	'<div class="modal iframe-modal" id="' + id + '"  role="dialog">'  +
	 '<div class="modal-dialog cu-modal-dialog">' +
	   '<div class="modal-content cu-modal-content">' +
	     '<div class="cu-modal-header">' +
	     '<i class="fa fa-window-close-o fa-lg" aria-hidden="true"></i>' +
	     '<i class="fa fa-window-maximize maxormin hidden-xs fa-lg" aria-hidden="true"></i>' +
	    '<i class="fa fa-window-minimize fa-lg" aria-hidden="true"></i>' +
	       '<h4 class="modal-title">' + toolTitle + '</h4>' +
	     '</div>' +
	     '<div class="cu-modal-body cu-modal-body">' +
	      '<iframe src="' + url + '"></iframe>' +
	     '</div>' +
	   '</div>' +
	 '</div>' +
	'</div>';

 return newModal;

}


/*Adding events to the minimize, maximize and close buttons on the window, and to the button on the tray-bar for the new modal */
function addEvents(win, button) {

	win.modal.find(".fa-window-close-o, .fa-window-close").click(function() {
			win.close();
	});

	win.modal.find(".maxormin").click(function() {
		win.maximize(this);
	});

	win.modal.find(".fa-window-minimize").click(function() {
		win.minimize();
	});

	$(button).click(function () {
		winButtonEvent(win);
	});
}


/* Fixed button that shows and hides the tray-bar */
function showHideTrayEvent() {
	
	$("#btn-lock").click(function() 
	{
		if( $("#btn-lock").hasClass("btn-danger"))
		{
			$("#btn-lock").text("SHOW").removeClass("btn-danger").addClass("btn-info");
			$("#bottom-tray").css("height", "0px");
		}
		else
		{
			$("#btn-lock").text("HIDE").removeClass("btn-info").addClass("btn-danger");
			$("#bottom-tray").css("height", "auto");
		}
	});
}




