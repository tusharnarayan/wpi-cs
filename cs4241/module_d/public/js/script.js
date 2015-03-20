/* global to track which of the Ticket or Revenue pie chart is currently displayed 
 * pieFlag % 2 is the revenue pie chart
 * else is the ticket sales pie chart
 */
var pieFlag = 0;

//setting up the http requests
var formHttp = new XMLHttpRequest();
//callback function
formHttp.onreadystatechange = function(){
    //check if response received
    if(formHttp.readyState == 4 && formHttp.status == 200){
    var textResponse = formHttp.responseText;

        document.getElementById("forminstructions").innerHTML = textResponse;
}
}
var revenueHttp = new XMLHttpRequest();
//callback function
revenueHttp.onreadystatechange = function(){
    //check if response received
    if(revenueHttp.readyState == 4 && revenueHttp.status == 200){
    var textResponse = revenueHttp.responseText;

        document.getElementById("revenuebyweek").innerHTML = textResponse;
}
}
var ticketHttp = new XMLHttpRequest();
//callback function
ticketHttp.onreadystatechange = function(){
    //check if response received
    if(ticketHttp.readyState == 4 && ticketHttp.status == 200){
    var textResponse = ticketHttp.responseText;

        document.getElementById("ticketssoldbyweek").innerHTML = textResponse;
}
}

/*
 * using callbacks, serve up the unformatted text files via parsed JADE fragments
 * the files contain instructions for various parts of the page
 */
function getTextFiles(filename){
    if(filename == "forminstructions")
    {
        formHttp.open("get", "/textfiles/" + filename, true);
        formHttp.send();
    }
    else if(filename == "revenuebyweek")
    {
        revenueHttp.open("get", "/textfiles/" + filename, true);
        revenueHttp.send();
    }
    else if(filename == "ticketssoldbyweek")
    {
        ticketHttp.open("get", "/textfiles/" + filename, true);
        ticketHttp.send();
    }
    else
    {
        console.log("Oh no, we messed up the xmlhttp requests");
    }
}

/*
 * gets all table names and adds them as options to a select menu
 * so that the user can select which table they want to add/overwrite
 * data to
 */
function getAllTables(){
    //generate new request
    var xmlhttp1 = new XMLHttpRequest();

    //callback function
    xmlhttp1.onreadystatechange = function(){
        //check if response received
        if(xmlhttp1.readyState == 4 && xmlhttp1.status == 200){
	    //add all table names to the select menu in the first div
            var tables = jQuery.parseJSON(xmlhttp1.responseText);
	    $.each($.parseJSON(tables), function(key, value){
		    $('#showSelector')
		    	.append($('<option>', {value: value })
				.text(value));
		});
	}
    }

    //open the request
    xmlhttp1.open("GET", "/getAllTables", true);

    //send the request
    xmlhttp1.send();
}

/*
 * get data from the DB for the Wicked table
 * replace existing table on the page with the updated data
 */
function getWickedData(){
    $("#wickedTable").empty();
    $("#wickedTable").append('<caption>Data for Wicked</caption>');
    $("#wickedTable").append('<tr>' +
                          '<td>' + 'Week' + '</td>' +
                          '<td>' + 'Revenue' + '</td>' +
                          '<td>' + 'Seats Sold' + '</td>' +
			   '</tr>');

    var response = '';
    $.ajax({ type: "GET",
                url: "/getWickedData",
                async: false,
                success: function(text){
                response = text;
            }
        });
    var parsedResponse = jQuery.parseJSON(response);
    jQuery.each(parsedResponse, function (i, value){
            $("#wickedTable")
                .append('<tr>' +
                          '<td>' + value.weekNum + '</td>' +
                          '<td>' + value.revenue + '</td>' +
                          '<td>' + value.seatCount + '</td>' +
			'</tr>');
        });
}

/*
 * get revenue data from the DB and graph it
 */
function getRevenueData(key) {
    var response = '';
    $.ajax({
        type: "GET",
        url: "/getRevenueData",
        async: false,
        success: function (text) {
            response = text;
        }
    });
    //store data in arrays so that we can construct line charts for each show
    var wickedData = new Array();
    var onceData = new Array();
    var theLionKingData = new Array();
    var parsedResponse = jQuery.parseJSON(response);
    jQuery.each(parsedResponse, function (i, value) {
        if(value.showName=='Wicked'){
            wickedData.push([Number(value.weekNum),Number(value.revenue)]);
        } else if(value.showName=='Once'){
            onceData.push([Number(value.weekNum),Number(value.revenue)]);
        } else if(value.showName=='The Lion King'){
            theLionKingData.push([Number(value.weekNum),Number(value.revenue)]);
        }
    });

    var dataToPrint = 0;
    if(key == 'Wicked')
    {
        dataToPrint = [{name: 'Wicked',
                        data: wickedData}];
    }
    else if(key =='Once')
    {
        dataToPrint = [{name: 'Once',
                        data: onceData}];
    }
    else if(key =='The Lion King')
    {
        dataToPrint = [
                        {name: 'The Lion King',
                        data: theLionKingData}];
    }
    else
    {
        dataToPrint = [{name: 'Wicked',
                        data: wickedData},
                        {name: 'Once',
                        data: onceData},
                        {name: 'The Lion King',
                        data: theLionKingData}];
    }
    //construct the chart
    $("#revenueGraph")
        .highcharts({
            chart: {
                type: 'line'
            },
            title: {
                text: 'Revenue by Week'
            },
            yAxis: {
                text: 'Revenue ($)'
            },
            xAxis: {
                text: 'Week'
            },
            series: dataToPrint
            /*[
                {name: 'Wicked',
                data: wickedData},
                {name: 'Once',
                data: onceData},
                {name: 'The Lion King',
                data: theLionKingData}]*/
        });
}

/*
 * get ticket data from DB and graph it
 */
function getTicketsData() {
    var response = '';
    $.ajax({
        type: "GET",
        url: "/getTicketsData",
        async: false,
        success: function (text) {
            response = text;
        }
    });
    //store ticket data in arrays so we can construct a line chart
    var wickedData = new Array();
    var onceData = new Array();
    var theLionKingData = new Array();
    var parsedResponse = jQuery.parseJSON(response);
    jQuery.each(parsedResponse, function (i, value) {
        if(value.showName=='Wicked'){
            wickedData.push([Number(value.weekNum),Number(value.seatCount)]);
        } else if(value.showName=='Once'){
            onceData.push([Number(value.weekNum),Number(value.seatCount)]);
        } else if(value.showName=='The Lion King'){
            theLionKingData.push([Number(value.weekNum),Number(value.seatCount)]);
        }
    });
    //construct the chart
    $("#ticketsGraph")
        .highcharts({
            chart: {
                type: 'line'
            },
            title: {
                text: 'Tickets Sold by Week'
            },
            yAxis: {
                text: 'Tickets'
            },
            xAxis: {
                text: 'Week'
            },
            series: [
                {name: 'Wicked',
                    data: wickedData},
                {name: 'Once',
                    data: onceData},
                {name: 'The Lion King',
                    data: theLionKingData}]
        });
}

/*
 * get data from the DB to construct the tickets pie chart
 */
function getPieChartData() {
    var response = '';
    $.ajax({
        type: "GET",
        url: "/getTicketsData",
        async: false,
        success: function (text) {
            response = text;
        }
    });
    //add up tickets data for each show so that we can construct
    //a pie chart
    var wickedTicketsSold = 0;
    var onceTicketsSold = 0;
    var theLionKingTicketsSold = 0;
    var parsedResponse = jQuery.parseJSON(response);
    jQuery.each(parsedResponse, function (i, value) {
        if(value.showName=='Wicked'){
            wickedTicketsSold+=Number(value.seatCount);
        } else if(value.showName=='Once'){
            onceTicketsSold+=Number(value.seatCount);
        } else if(value.showName=='The Lion King'){
            theLionKingTicketsSold+=Number(value.seatCount);
        }
    });
    //construct the chart
    $("#pieChart")
        .highcharts({
            title: {
                text: 'Total Tickets Sold'
            },
            plotOptions: {
              dataLabels: {
                  enabled: true,
                  format: '<br>{point.name}</b>: {point.percentage:.1f} %'
              }
            },
            yAxis: {
                text: 'Tickets'
            },
            xAxis: {
                text: 'Week'
            },
            series: [
                {
                    type: 'pie',
                    name: 'Tickets Sold',
                    data: [
                        ['The Lion King', theLionKingTicketsSold],
                        ['Once', onceTicketsSold],
                        ['Wicked', wickedTicketsSold]
                    ]
                }]
        });
}

/*
 * get data from the DB to construct the revenue pie chart
 */
function getPieRevenueChart()
{
    var response = '';
    $.ajax({
        type: "GET",
        url: "/getRevenueData",
        async: false,
        success: function (text) {
            response = text;
        }
    });
    //add up revenue data for each show so that we can construct
    //a pie chart
    var wickedData = 0;
    var onceData = 0;
    var theLionKingData = 0;
    var parsedResponse = jQuery.parseJSON(response);
    jQuery.each(parsedResponse, function (i, value) {
        if(value.showName=='Wicked')
        {
            wickedData+=Number(value.revenue);
        } 
        else if(value.showName=='Once')
        {
            onceData+=Number(value.revenue);
        }
        else if(value.showName=='The Lion King')
        {
            theLionKingData+=Number(value.revenue);
        }
    });
    //construct the chart
    $("#pieChart")
        .highcharts({
            title: {
                text: 'Total Revenue'
            },
            plotOptions: {
              dataLabels: {
                  enabled: true,
                  format: '<br>{point.name}</b>: {point.percentage:.1f} %'
              }
            },
            yAxis: {
                text: 'Revenue'
            },
            xAxis: {
                text: 'Week'
            },
            series: [
                {
                    type: 'pie',
                    name: 'Revenue',
                    data: [
                        ['The Lion King', theLionKingData],
                        ['Once', onceData],
                        ['Wicked', wickedData]
                    ]
                }]
        });
}

/*
 * function to control the Toggle Tickets/Revenue button
 */
function toggleWrapper()
{
    if(pieFlag % 2 == 0)
    {
        getPieRevenueChart();
    }
    else
    {
        getPieChartData();
    }
    pieFlag++;
}

/*
 * function to add options to filter the "Revenue by Week" graph
 * based on the shows available in the system
 */
function filter()
{
    /* Get the appropriate filtered data */
    getRevenueData(document.getElementById("filterselect").value);
}

/*
 * get data from the DB for the Once table
 * replace existing table on the page with the updated data
 */
function getOnceData(){
    $("#onceTable").empty();
    $("#onceTable").append('<caption>Data for Once</caption>');
    $("#onceTable").append('<tr>' +
                          '<td>' + 'Week' + '</td>' +
                          '<td>' + 'Revenue' + '</td>' +
                          '<td>' + 'Seats Sold' + '</td>' +
			   '</tr>');

    var response = '';
    $.ajax({ type: "GET",
                url: "/getOnceData",
                async: false,
                success: function(text){
                response = text;
            }
        });
    var parsedResponse = jQuery.parseJSON(response);
    jQuery.each(parsedResponse, function (i, value){
            $("#onceTable")
                .append('<tr>' +
                          '<td>' + value.weekNum + '</td>' +
                          '<td>' + value.revenue + '</td>' +
                          '<td>' + value.seatCount + '</td>' +
			'</tr>');
        });
}

/*
 * get data from the DB for the Lion King table
 * replace existing table on the page with the updated data
 */
function getLionKingData(){
    $("#lionKingTable").empty();
    $("#lionKingTable").append('<caption>Data for The Lion King</caption>');
    $("#lionKingTable").append('<tr>' +
                          '<td>' + 'Week' + '</td>' +
                          '<td>' + 'Revenue' + '</td>' +
                          '<td>' + 'Seats Sold' + '</td>' +
			   '</tr>');

    var response = '';
    $.ajax({ type: "GET",
                url: "/getLionKingData",
                async: false,
                success: function(text){
                response = text;
            }
        });
    var parsedResponse = jQuery.parseJSON(response);
    jQuery.each(parsedResponse, function (i, value){
            $("#lionKingTable")
                .append('<tr>' +
                          '<td>' + value.weekNum + '</td>' +
                          '<td>' + value.revenue + '</td>' +
                          '<td>' + value.seatCount + '</td>' +
			'</tr>');
        });
}

/*
 * adds data to the Wicked table in the DB using AJAX
 */
function addWickedContent(jsonStringToAdd){
    $.ajax({
            type: "POST",
                contentType: 'application/json; charset=UTF-8',
                url: "/addWickedInfo",
		data: JSON.stringify(jsonStringToAdd),
		dataType: "json",
		success: function(){
		alert("The data has been written successfully!");
		//clear previously entered values
		$("input#week").val('');
		$("input#revenue").val('');
		$("input#seatCount").val('');
		//fetch updated data from the DB
		getWickedData();
		//update all graphs on the page
		updateGraphs();
	    }
	});    
}

/*
 * adds data to the Once table in the DB using AJAX
 */
function addOnceContent(jsonStringToAdd){
    $.ajax({
            type: "POST",
                contentType: 'application/json; charset=UTF-8',
                url: "/addOnceInfo",
		data: JSON.stringify(jsonStringToAdd),
		dataType: "json",
		success: function(){
		alert("The data has been written successfully!");
		//clear previously entered values
		$("input#week").val('');
		$("input#revenue").val('');
		$("input#seatCount").val('');
		//fetch updated data from the DB
		getOnceData();
		//update all graphs on the page
		updateGraphs();
	    }
	});    
}

/*
 * adds data to the Lion King table in the DB using AJAX
 */
function addLionKingContent(jsonStringToAdd){
    $.ajax({
            type: "POST",
                contentType: 'application/json; charset=UTF-8',
                url: "/addLionKingInfo",
		data: JSON.stringify(jsonStringToAdd),
		dataType: "json",
		success: function(){
		alert("The data has been written successfully!");
		//clear previously entered values
		$("input#week").val('');
		$("input#revenue").val('');
		$("input#seatCount").val('');
		//fetch updated data from the DB
		getLionKingData();
		//update all graphs on the page
		updateGraphs();
	    }
	});    
}

/*
 * function to add content to the DB
 * does some basic sanity checking on the inputs
 * and adds the content to the appropriate DB table
 */
function addContent(){
    //variables to hold the input data
    var week = 0, revenue = 0, seatCount = 0;

    /* make sure all three inputs have numbers as input */

    if(isNaN(parseInt($("input#week").val()))){
	alert("Week should be a number!");
	return;
    }

    if(isNaN(parseInt($("input#revenue").val()))){
        alert("Revenue should be a number!");
	return;
    }

    if(isNaN(parseInt($("input#seatCount").val()))){
        alert("Seat Count should be a number!");
	return;
    }

    /* parse and save the inputted values */
    week = parseInt($("input#week").val());
    revenue = parseInt($("input#revenue").val());
    seatCount = parseInt($("input#seatCount").val());
    
    /* some basic logic checking on the inputted values */
    if(week < 1){
	alert("Week numbers must be greater than 0!");
	return;
    }

    if(week > 52){
	alert("Week numbers must be smaller than 53!");
	return;
    }
    
    /* compose the JSON string to prepare for transmission */
    var jsonStringToAdd = {
        week: week,
        revenue: revenue,
        seatCount: seatCount
    };

    /* call appropriate DB entry function depending on dropdown selection */
    var show = $("select#showSelector").val();
    
    if(show == "Wicked"){
	addWickedContent(jsonStringToAdd);
    }
    else if(show == "Once"){
	addOnceContent(jsonStringToAdd);
    }
    else{
	addLionKingContent(jsonStringToAdd);
    }
}

/*
 * wrapper to call the functions that update all the graphs on the page
 * preserves the current user selection for which pie chart to display
 */
function updateGraphs(){
    getRevenueData('All');
    getTicketsData();
    if(pieFlag % 2 == 0){
        getPieRevenueChart();
    }
    else{
        getPieChartData();
    }
}

/*
 * function to call on page load
 */
function start(){
    /* add listeners for button clicks */
    var formSubmitButton = document.getElementById("formEntry");
    formSubmitButton.addEventListener("click", addContent, false);

    document.getElementById("piechartbutton").addEventListener("click", toggleWrapper, false);
    document.getElementById("filterselect").addEventListener("change", filter, false);

    /* get data from the server to dynamically populate the menu */
    getAllTables();

    /* get text files from server */
    getTextFiles("forminstructions");
    getTextFiles("revenuebyweek");
    getTextFiles("ticketssoldbyweek");

    /* get all data for each table in the system */
    getWickedData();
    getOnceData();
    getLionKingData();

    /* get data from server to plot the three charts */
    getRevenueData('All');
    getTicketsData();
    getPieChartData();    
}

/*call start function once page is fully loaded */
window.addEventListener("load", start, false);
