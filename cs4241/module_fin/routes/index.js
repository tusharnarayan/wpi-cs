var express = require('express');
var router = express.Router();
var spawn = require('child_process').spawn;

/*
  use the sql server side javascript
 */
var sqlObject = require('../js/sqlserver.js');

/*
  from https://github.com/expressjs/body-parser
  middleware that can parse JSON
 */
var bodyParser = require('body-parser');

/*
  set up router to use the middleware JSON parser
 */
router.use(bodyParser.json());

/*
  require jade to generate dynamic HTML
*/
var jade = require('jade');

/*
  require fs to use the filesystem
 */
var fs = require('fs');


/* Python sandbox*/
router.get('/helloworld', function(req, res) {
	
	res.render('index', { title: 'Express' });
    });


/* GET home page. */
router.get('/', function(req, res) {
	res.render('index', { title: 'Express' });
    });

/* GET reservations page */
router.get('/reservations.html', function(req, res) {
	res.render('reservations', { title: 'Reservations' });
    });

/* GET shows */
router.get('/shows', function(req, res) {
	sqlObject.getAllShowNamesAndTimes(req, res);
    });

/* GET showtimes for a particular show */
router.get('/showtimes/:fname', function(req, res) {
	sqlObject.queryShowtimesFromShow(req, res, req.param("fname"));
    });

/* GET showtimes for a particular show */
router.get('/getChartData', function(req, res) {
	sqlObject.queryAll(req, res);
});

/* GET showtimes for a particular show */
router.post('/sendconfirmation', function(req,res) {
	//var python = spawn('python',['/' + dir + '/scripts/sendemail.py', 'klbrann@wpi.edu']);
	var python = spawn('python', ['print', '"Hello World"']);
	var output = "";
	python.stdout.on('data', function(){ output += data });
	python.on('close', function(code){
		if (code !== 0) {  return res.send(500, code); }
		return res.send(200, output)
	});
});

/* POST reservation to DB for the  */
router.post('/addReservation', function(req, res) {
	sqlObject.changeRemainingSeats(req, res);
    });


router.get('/showInfo/:fname', function(req,res) {
	//generate directory name
	var dir = __dirname.split("/").slice(1,-1).join("/");

	//generate template path
	var templatePath = "/" + dir + "/views/showinfo.jade";

	//generate text path
	var filePath = "/" + dir + "/text/" + req.param("fname") + ".txt";

	var fileContent;

	fs.readFile(filePath, function read(err, data) {
		if (err) throw err;
		fileContent = data;
	});

	//compile the HTML on the fly
	fs.readFile(templatePath, 'utf8', function (err, data) {
		if(err) throw err;
		var fn = jade.compile(data);
		var html = fn({content:fileContent});
		res.send(html);
	});

});

/* GET HTML for textfiles */
router.get('/textfiles/:fname', function(req, res) {
	//generate directory name
	var dir = __dirname.split("/").slice(1,-1).join("/");
	
	//generate template path
	var templatePath = "/" + dir + "/views/textfiles.jade";
	
	//generate text path
	var filePath = "/" + dir + "/text/" + req.param("fname") + ".txt";
	
	console.log(filePath);
	
	var fileContent;
	
	fs.readFile(filePath, function read(err, data) {
		if (err) throw err;
		fileContent = data;
	    });
	
	//compile the HTML on the fly
	fs.readFile(templatePath, 'utf8', function (err, data) {
		if(err) throw err;
		var fn = jade.compile(data);
		var html = fn({content:fileContent});
		res.send(html);
	    });
	
    });

module.exports = router;
