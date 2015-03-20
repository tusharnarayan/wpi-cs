WPI CS 4241 Webware B 2014

Tushar Narayan
tnarayan@wpi.edu
	
Assignment: Module #A

FLOW OF THE DOCUMENT:
Jade templates are used to define the structure of the webpage.
There are three Jade files that together define the newsletter.html page:
1) layout.jade - defines the basic layout of the page
2) newsletter.jade - defines the content blocks for each of the four divs
	that make up the page
3) table.jade - defines the table that the fourth div is composed of. This is
	defined separately because when the table needs to be update, Jade is used
	to compile the HTML on the fly. This enables us to meet both of the following
	two requirements: (a) that content is dynamically updated when an image is 
	selected, and (b) that the data in the table should be defined in a Javascript
	2D array. We define the data in the script.js file (see below), and compile
	the HTML for the table itself on the fly. We use Javascript to fill the table
	once the HTML is compiled.
	
There are six text files that are used to pull in content from. Four of these
(imageInfo*.txt) define the text that accompanies each image - each sentence
in the file fills one of the textareas when the corresponding image is selected.
The other two files (header*.txt) are pulled into the newsletter.jade file.

The index.js file in the routes file was changed to add some router.get statements
that allow for the dynamic updating of the three textareas using content from the 
text files, and for the dynamic creation of the table HTML.

The only change made to the www file in the bin folder was to use the assigned 
port number (4039).

The css styling for the webpage elements is defined in the public/css/style.css file.
The images used are found in the public/img/ folder.
The javascript used for the webpage's dynamic behavior is in the public/js/script.js file.
