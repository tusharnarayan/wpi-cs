/*array with strings that are facts about me; displayed on page*/
var about = [
	     "I will be working as a Product Quality Engineer at Palantir Technologies starting June 2015.",
	     "I'm a Founding Father and president of the Beta Theta Pi Fraternity's WPI colony.",
	     "I went to Harvard University for Summer School in 2010, and graduated from high school in India in 2011.",
	     "I've lived in various parts of India, and in the Kingdom of Bahrain in the Middle East.",
	     "I'm currently in Worcester, Massachusetts."
	     ];

/*two dimensional array; contains various things I like (books, cuisines, programming languages)*/
var likes = [
	     ["Harry Potter", "Lord of the Rings", "Lord of the flies", "Outliers", "Black Swan", "Jack West series", "The Saxon Chronicles", "Wars of the Roses", "The Clifton Chronicles"],
	     ["Thai", "Chinese", "Indian", "Italian", "Mexican", "Mid-Eastern", "Malaysian", "Singaporean", "Sri Lankan"],
	     ["C", "Java", "Racket", "HTML", "CSS", "Javascript", "Lua", "C++", "Ruby"],
	     ["Skydiving", "Bungee jumping", "Piloting an airplane", "Visiting Thailand", "Writing a novel", "Developing an Android app", "Owning more board games", "Meeting new people", "Challenging myself daily"]
	     ];

/*global to track which image is currently displayed
  start by displaying the first image by default*/
var currentlyDisplayedImageIndex = 0;

/*global to track which introduction text snippet is currently displayed
  start by displaying the first snippet by default*/
var currentlyDisplayedSnippet = 0;

/*globals for setting width and height of images displayed*/
var imageWidth = 400;
var imageHeight = 180;

/* array for images that are displayed on the page*/
var images = [
              "/img/stonehenge.jpg",
			  "/img/london_eye.jpg",
			  "/img/eiffel_tower.jpg",
			  "/img/great_barrier_reef.jpg"
              ];

/*
  function to ensure that the selection of an image thumbnail updates
  the image displayed and also updates the textareas and the table
*/
function updateContent(){
    updateImage();
    getImageInfoText();
}

/*
  function to ensure that the appropriate image gets displayed based on the 
  radio button selection
  appropriately sets the global that tracks which image is currently displayed
  and then displays the corresponding image
*/
function updateImage(){
    //get all radio buttons for the images
    var imageRadios = document.getElementsByClassName("myImageShow");
    //iterate over all buttons to find the one that was selected
    for(var i = 0; i < imageRadios.length; i++){
	if(imageRadios[i].checked == true){
	    //selected thumbnail radio found, set global to that index and exit for loop
	    currentlyDisplayedImageIndex = i;
	    break;
	}
    }

    //display full sized image corresponding to the thumbnail selected
    var imageContainer = document.getElementById('image_slideshow');
    imageContainer.innerHTML = "<img src = '" + images[currentlyDisplayedImageIndex] +
	"' width='" + imageWidth + "' height='" + imageHeight + "'/>";
}

/*
  function that manages the scrolling of the introduction text
  the text is refreshed every 3 seconds (as controlled by the startTimer() function)
 */
function scrollIntroductionText(){
    currentlyDisplayedSnippet = (currentlyDisplayedSnippet == (about.length - 1))?
	0 : (currentlyDisplayedSnippet + 1);

    var introContainer = document.getElementById('scroll_snippets');

    introContainer.innerHTML = about[currentlyDisplayedSnippet];
}

/*
  function that dynamically pulls the content from the server to fill
  the three textareas
  also chains the function that dynamically updates the table
*/
function getImageInfoText(){
	//generate new request
    xmlhttp = new XMLHttpRequest();
    
	//callback function
    xmlhttp.onreadystatechange = function(){
	//check if response received
	if(xmlhttp.readyState == 4 && xmlhttp.status == 200){
	  //split the response into three sentences - one for each textarea
	  var textResponse = xmlhttp.responseText.split("\n");
	  
	  //fill in the HTML for the three textareas
	  document.getElementById("info1").innerHTML = textResponse[0];
	  document.getElementById("info2").innerHTML = textResponse[1];
	  document.getElementById("info3").innerHTML = textResponse[2];
	  
	  //update the table dynamically
	  getTableText();
	}
    }
    
	//form the server request
    fileName = "imageInfo" + (currentlyDisplayedImageIndex + 1);
	
	//open the request
    xmlhttp.open("GET", "/textfiles/" + fileName, true);
	
	//send the request
    xmlhttp.send();
}

/*
  function that dynamically pulls the HTML for the table
  from the server
*/
function getTableText(){
	//generate new request
    xmlhttp = new XMLHttpRequest();

	//callback function
    xmlhttp.onreadystatechange = function(){
	//check if response received
	if(xmlhttp.readyState == 4 && xmlhttp.status == 200){
		//get the div that contains the table
	    var tableDiv = document.getElementById("footer");
		//set table HTML to the HTML received from the server
	    tableDiv.innerHTML = xmlhttp.responseText;
		
		//get the table element
	    var tableElement = document.getElementById("likes");
		//get the rows for the table
	    var tableRows = tableElement.rows;
		//fill in the table with data from the 2D array
	    for(var i = 0, j = 0; i < tableRows.length; i++, j += tableRows.length){
		//fill in an entire row for each iteration of the loop
		tableRows[i].cells[0].innerHTML = likes[currentlyDisplayedImageIndex][j + 0];
		tableRows[i].cells[1].innerHTML = likes[currentlyDisplayedImageIndex][j + 1];
		tableRows[i].cells[2].innerHTML = likes[currentlyDisplayedImageIndex][j + 2];
	    }
	}
    }

	//open the request
    xmlhttp.open("GET", "/table/", true);
	
	//send the request
    xmlhttp.send();
}

/* 
   function that updates the introduction text every 3 seconds
 */
function startTimer(){
    setInterval(scrollIntroductionText, 3000);
}

/*
  function that is called once the page is fully loaded
  does initial ("default") page setup
  
  binds radio buttons for the images to the corresponding handler function
*/
function start(){
    //load initial snippet
    scrollIntroductionText();

    /*load images*/
    //smaller size for the thumbnail of each image
    var thumbnailSize = 75;

    //get the form for displaying radio buttons for each image thumbnail
    var imageContainer = document.getElementById('image_selector');
    
    //add a radio button with a thumbnail for each image to the form
    for(var i = 0; i < images.length; i++){
	imageContainer.innerHTML += "<label><input type = radio name = myImageShowRadios class = myImageShow id = image" + i + " ><img src = '" + images[i] +
	    "' width='" + thumbnailSize + "' height='" + thumbnailSize + "'/></label><br />";
    }

    //set the first image's thumbnail radio button to checked
    var imageToCheck = document.getElementById('image0');
    imageToCheck.checked = true;

    /*since the updateContent() function starts by incrementing the global,
      set it to -1 here before the call to the function.
      This avoids duplication of the entire code of the updateContent() function here.
     */
    currentlyDisplayedImageIndex = -1;

    /*now that the radio buttons have been constructed, call the function
      that sets the contents of the second, third, and fourth divs appropriately
	*/
    updateContent();

    //bind radio  buttons to event handlers
    var imageRadios = document.forms["radioForm"].elements["myImageShowRadios"];
    for(var i = 0; i < imageRadios.length; i++){
	imageRadios[i].onclick = updateContent;
    }

    //start the timer to update scroll through introduction text
    startTimer();
}

/*call start function once page is fully loaded */
window.addEventListener("load", start, false);
