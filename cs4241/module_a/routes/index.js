var express = require('express');
var router = express.Router();

/*
	require jade to use the compileFile function for generating dynamic
	HTML for the table
*/
var jade = require('jade');

/* GET home page. */
router.get('/', function(req, res) {
  res.render('index', { title: 'Express' });
});

/* GET hello page. */
router.get('/hello.html', function(req, res) {
  res.render('hello', { title: 'Hello World', quip: 'It does not do to leave a live dragon out of your calculations, if you live near him.' });
});

/* GET newsletter page */
router.get('/newsletter.html', function(req, res) {
	res.render('newsletter', { title: 'Tushar Narayan Newsletter' });
});

/* GET text files for textareas */
router.get('/textfiles/:fname', function(req, res) {
	//generate directory name
	var dir = __dirname.split("/").slice(1,-1).join("/");
	
	//generate file path
	var path = "/" + dir + "/text/" + req.param("fname") + ".txt";
	
	//use sendFile function to send the file back to the calling function
	res.sendFile(path);
    });

/* GET HTML for table */
router.get('/table/', function(req, res) {
	//generate directory name
	var dir = __dirname.split("/").slice(1,-1).join("/");
	
	//generate file path
	var path = "/" + dir + "/views/table.jade";
	
	//compile the HTML on the fly using the compileFile function of Jade
	//see: http://jade-lang.com/api/
	//prototype: jade.compileFile(path, options)
	var compiledHTML = jade.compileFile(path, {});
	
	//use sendFile function to send the compiled HTML back to the calling function
	res.send(compiledHTML());
    });

module.exports = router;
