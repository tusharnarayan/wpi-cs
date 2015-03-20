/**
 * Created by Eric on 11/24/2014.
 * This file handles the sql parts of the project.
 */

var inspect = require('util').inspect;
var Client = require('mariasql');

var c = new Client();

/* This connects the server to the DB server for queries */
c.connect({
    host: 'localhost',
        user: 'epguleksen',
        password: 'epguleksen_pw',
        db: 'epguleksen_db'
        });

c.on('connect', function() {
    console.log('Client connected');
    })
    .on('error', function(err) {
        console.log('Client error: ' + err);
    })
    .on('close', function(hadError) {
        console.log('Client closed');
    });

function addPerson(req, response) {
    var jsonString = [];
    var insertedInto = req.body;
    console.log('INSERT INTO Person (Email, FirstName, LastName, NumSeats, Name, PerformanceDate) VALUES (' + insertedInto.email + ', ' + insertedInto.firstName + ', ' + insertedInto.lastName + ', ' + insertedInto.numSeats + ', ' + insertedInto.name + ', ' + insertedInto.performanceDate + ') ON DUPLICATE KEY UPDATE NumSeats = ' + insertedInto.numSeats + ';')
    c.query('INSERT INTO Person (Email, FirstName, LastName, NumSeats, Name, PerformanceDate) VALUES (?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE NumSeats = ?;',
        [insertedInto.email, insertedInto.firstName, insertedInto.lastName, insertedInto.numSeats, insertedInto.name, insertedInto.performanceDate, insertedInto.numSeats])
    .on('end', function () {
        console.log('Reservation Added');
        response.json(JSON.stringify(jsonString));
    });
};

/* All functions to be exported if required in node */
module.exports = {

    /* Get all of the show names and times */
    getAllShowNamesAndTimes: function(req, response)
    {
        var jsonString = [];
        var insertedInto = req.body;
        c.query('SELECT Name, PerformanceDate FROM VoxShow;')
        .on('result', function (res) {
            res.on('row', function (row) {
                //console.log('Result: ' + inspect(row));
                jsonString.push({
                    name: row.Name,
                    performanceDate: row.PerformanceDate
                });
            })
                .on('error', function (err) {
                    console.log('Result error: ' + inspect(err));
                })
                .on('end', function (info) {
                    console.log('Finished seat get successfully');
                });
        })
        .on('end', function () {
            console.log('Done with all results');
            response.json(JSON.stringify(jsonString));
        });
    },

    /* Get all of the showtimes from the database given the show.
    */
    queryShowtimesFromShow: function(req, response, fname)
    {
        var jsonString = [];
        var insertedInto = fname;
        console.log("name:" + fname);
	c.query('SELECT PerformanceDate FROM VoxShow WHERE Name = ?;', [insertedInto])
        .on('result', function (res) {
            res.on('row', function (row) {
                //console.log('Result: ' + inspect(row));
                jsonString.push({
                    performanceDate: row.PerformanceDate
                });
            })
                .on('error', function (err) {
                    console.log('Result error: ' + inspect(err));
                })
                .on('end', function (info) {
                    console.log('Finished seat get successfully');
                });
        })
        .on('end', function () {
            console.log('Done with all results');
            response.json(JSON.stringify(jsonString));
        });
    },
	
	/* This fucntion queries the data for the number of seats availible 
    * for the show.
    * Remember: dates are in YYYY-MM-DD
    */
    queryAll: function(req, response)
    {
        var jsonString = [];
        var insertedInto = req.body;
        c.query('SELECT * FROM VoxShow;')
        .on('result', function (res) {
            res.on('row', function (row) {
                //console.log('Result: ' + inspect(row));
                jsonString.push({
                    name: row.Name,
                    performanceDate: row.PerformanceDate,
                    capacity: row.Capacity,
                    remainingSeats: row.RemainingSeats,
                    location: row.Location
                });
            })
                .on('error', function (err) {
                    console.log('Result error: ' + inspect(err));
                })
                .on('end', function (info) {
                    console.log('Finished seat get successfully');
                });
        })
        .on('end', function () {
            console.log('Done with all results');
            response.json(JSON.stringify(jsonString));
        });
    },

    /* This fucntion queries the data for the number of seats availible 
    * for the show.
    * Remember: dates are in YYYY-MM-DD
    */
    queryShow: function(req, response)
    {
        var jsonString = [];
        var insertedInto = req.body;
        c.query('SELECT * FROM VoxShow WHERE Name = ? AND PerformanceDate = ?;', [insertedInto.name, insertedInto.date])
        .on('result', function (res) {
            res.on('row', function (row) {
                //console.log('Result: ' + inspect(row));
                jsonString.push({
                    name: row.Name,
                    performanceDate: row.PerformanceDate,
                    capacity: row.Capacity,
                    remainingSeats: row.RemainingSeats,
                    location: row.Location
                });
            })
                .on('error', function (err) {
                    console.log('Result error: ' + inspect(err));
                })
                .on('end', function (info) {
                    console.log('Finished seat get successfully');
                });
        })
        .on('end', function () {
            console.log('Done with all results');
            response.json(JSON.stringify(jsonString));
        });
    },

    /* This function adds the reservation to the database. Note that some validation
    * is needed for safe entry
    */
    addPerson: function (req, response) {
        var jsonString = [];
        var insertedInto = req.body;
        console.log('INSERT INTO Person (Email, FirstName, LastName, NumSeats, Name, PerformanceDate) VALUES (' + insertedInto.email + ', ' + insertedInto.firstName + ', ' + insertedInto.lastName + ', ' + insertedInto.numSeats + ', ' + insertedInto.name + ', ' + insertedInto.performanceDate + ') ON DUPLICATE KEY UPDATE NumSeats = ' + insertedInto.numSeats + ';')
        c.query('INSERT INTO Person (Email, FirstName, LastName, NumSeats, Name, PerformanceDate) VALUES (?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE NumSeats = ?;',
            [insertedInto.email, insertedInto.firstName, insertedInto.lastName, insertedInto.numSeats, insertedInto.name, insertedInto.performanceDate, insertedInto.numSeats])
        .on('end', function () {
            console.log('Reservation Added');
            response.json(JSON.stringify(jsonString));
        });
    },

    /*
    * This is a function that will update the show to have the correct 
    * number of seats.
    */
    changeRemainingSeats: function(req, response)
    {
	    console.log("in remain changing seats");
        var jsonString = [];
        var insertedInto = req.body;
        var seatsLeft = 0;

        //Get the data about the show and see if this is doable.
        c.query('SELECT * FROM VoxShow WHERE Name = ? AND PerformanceDate = ?;', [insertedInto.name, insertedInto.performanceDate])
        .on('result', function (res) {
            res.on('row', function (row) {
                //console.log('Result: ' + inspect(row));
                seatsLeft = row.RemainingSeats;
                console.log('Seats Remaining: ' + seatsLeft);

                if ((seatsLeft - insertedInto.numSeats) >= 0) {
                    console.log("Calling Add Person");
                    addPerson(req, response);
                    c.query('UPDATE VoxShow SET RemainingSeats = ? WHERE Name = ? AND PerformanceDate = ?;',
                    [seatsLeft - insertedInto.numSeats, insertedInto.name, insertedInto.performanceDate])
                    .on('end', function () {
                        console.log('Seats set to new amount');
                        //response.json(JSON.stringify(jsonString));
                    });
                }
                else
                {
                    jsonString.push({
                        error: "Not enough seats bro!"
                    });
                    response.json(JSON.stringify(jsonString));
                }                
            })
                .on('error', function (err) {
                    console.log('Result error: ' + inspect(err));
                })
                .on('end', function (info) {
                    console.log('Changed Seats successfully');
                });
        })
        .on('end', function () {
            console.log('Done with all results');
        });


        console.log("out of remain changing seats");
        return 0;
    },
    
    killServer: function(){
        c.end();
    }
};
