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

/* All functions to be exported if required in node */
module.exports = {

    /* This function adds the wicked info to the sql database
     * This replaces the existing data to roll over
     */
    addWickedInfo: function(req, response){
	var prepareQuery = c.prepare('REPLACE INTO Wicked ' + 
				     'VALUES(:weekNum, :revenue, :seatCount, :showName)');
	var insertedInfo = req.body;
	c.query(prepareQuery({
		    weekNum: insertedInfo.week,
			revenue: insertedInfo.revenue,
			seatCount: insertedInfo.seatCount,
			showName: "Wicked"}))
	.on('end', function(){
		console.log('Done with all results');
		response.send(req.body);
	    });
    },
   
    /* This function adds the once info into the sql database
     * This replaces the existing data in the database.
     */
    addOnceInfo: function(req, response){
	var prepareQuery = c.prepare('REPLACE INTO Once ' + 
				     'VALUES(:weekNum, :revenue, :seatCount, :showName)');
	var insertedInfo = req.body;
	c.query(prepareQuery({
		    weekNum: insertedInfo.week,
			revenue: insertedInfo.revenue,
			seatCount: insertedInfo.seatCount,
			showName: "Once"}))
	.on('end', function(){
		console.log('Done with all results');
		response.send(req.body);
	    });
    },
    
    /* This function adds the Lion King data into the sql database
     * This replaces the existing data in the database.
     */
    addLionKingInfo: function(req, response){
	var prepareQuery = c.prepare('REPLACE INTO TheLionKing ' + 
				     'VALUES(:weekNum, :revenue, :seatCount, :showName)');
	var insertedInfo = req.body;
	c.query(prepareQuery({
		    weekNum: insertedInfo.week,
			revenue: insertedInfo.revenue,
			seatCount: insertedInfo.seatCount,
			showName: "The Lion King"}))
	.on('end', function(){
		console.log('Done with all results');
		response.send(req.body);
	    });
    },
    
    /* This function queries the database and describes all of the tables in the 
     * database.
     */
    showAllTables: function(req, response){
	var jsonString = [];
	c.query('SHOW TABLES;')
	.on('result', function(res) {
		res.on('row', function(row) {
			console.log('Result: ' + inspect(row));
			jsonString.push(row.Tables_in_epguleksen_db)
			    })
		    .on('error', function(err) {
			    console.log('Result error: ' + inspect(err));
			})
		    .on('end', function(info) {
			    console.log('Finished successfully');
			});
	    })
	.on('end', function() {
		console.log('Done with all results');
		response.json(JSON.stringify(jsonString));
	    });
    },
    
    /* This function queries the revenue data and returns it to the server */
    getRevenueData: function(req, response){
        var jsonString = [];
        c.query('(SELECT revenue, showName, weekNum FROM Wicked)' +
                'UNION ALL (SELECT revenue, showName, weekNum FROM Once)' +
                'UNION ALL (SELECT revenue, showName, weekNum FROM TheLionKing)')
            .on('result', function(res) {
                res.on('row', function (row) {
                    jsonString.push({showName: row.showName, weekNum: row.weekNum, revenue: row.revenue});
                })
                    .on('error', function (err) {
                        console.log('Result error: ' + inspect(err));
                    })
                    .on('end', function (info) {
                        console.log('Finished successfully');
                    });
            })
        .on('end', function() {
            console.log('Done with all results');
            response.json(JSON.stringify(jsonString));
        });
    },

    /* Gets the ticket data from the show in question and returns it to the server */
    getTicketsData: function(req, response){
        var jsonString = [];
        c.query('(SELECT seatCount, showName, weekNum FROM Wicked)' +
        'UNION ALL (SELECT seatCount, showName, weekNum FROM Once)' +
        'UNION ALL (SELECT seatCount, showName, weekNum FROM TheLionKing)')
            .on('result', function(res) {
                res.on('row', function (row) {
                    jsonString.push({showName: row.showName, weekNum: row.weekNum, seatCount: row.seatCount});
                })
                    .on('error', function (err) {
                        console.log('Result error: ' + inspect(err));
                    })
                    .on('end', function (info) {
                        console.log('Finished successfully');
                    });
            })
            .on('end', function() {
                console.log('Done with all results');
                response.json(JSON.stringify(jsonString));
            });
    },

    /* Get the wicked data and return it to the server */
    getWickedData: function(req, response){
        var jsonString = [];
        c.query('SELECT * FROM Wicked;')
        .on('result', function(res) {
                res.on('row', function(row) {
                        //console.log('Result: ' + inspect(row));
                        jsonString.push({weekNum: row.weekNum,
				    revenue: row.revenue,
				    seatCount: row.seatCount});
                            })
                    .on('error', function(err) {
                            console.log('Result error: ' + inspect(err));
                        })
                    .on('end', function(info) {
                            console.log('Finished successfully');
                        });
            })
        .on('end', function() {
                console.log('Done with all results');
		response.json(JSON.stringify(jsonString));
            });
    },

    /* Get the Once data and return it to the server */
    getOnceData: function(req, response){
        var jsonString = [];
        c.query('SELECT * FROM Once;')
        .on('result', function(res) {
                res.on('row', function(row) {
                        //console.log('Result: ' + inspect(row));
                        jsonString.push({weekNum: row.weekNum,
                                    revenue: row.revenue,
                                    seatCount: row.seatCount});
		    })
                    .on('error', function(err) {
                            console.log('Result error: ' + inspect(err));
                        })
                    .on('end', function(info) {
                            console.log('Finished successfully');
                        });
            })
        .on('end', function() {
                console.log('Done with all results');
                response.json(JSON.stringify(jsonString));
            });
    },
    
    /* Get the lion king data and return it to the server */
    getLionKingData: function(req, response){
        var jsonString = [];
        c.query('SELECT * FROM TheLionKing;')
        .on('result', function(res) {
                res.on('row', function(row) {
                        //console.log('Result: ' + inspect(row));
                        jsonString.push({weekNum: row.weekNum,
                                    revenue: row.revenue,
                                    seatCount: row.seatCount});
		    })
                    .on('error', function(err) {
                            console.log('Result error: ' + inspect(err));
                        })
                    .on('end', function(info) {
                            console.log('Finished successfully');
                        });
            })
        .on('end', function() {
                console.log('Done with all results');
                response.json(JSON.stringify(jsonString));
            });
    },

    killServer: function(){
        c.end();
    }
};
