// Module dependencies.
var application_root = __dirname,
    _ = require( 'underscore' ),
    express = require( 'express' ),
    cors = require('cors'),
    twilio = require( 'twilio' );

var Twilio = new twilio.RestClient('AC99968521d55e87de3292dfe26a036e25', '419bb1b7bbefbbe57d37c55abe04b337');

var User = function(phone, firstName, lastName) {
	this.phone = phone;
	this.firstName = firstName;
    this.lastName = lastName;
}

var users = [];

function isPhoneNumber(number) {
    //TODO: Fix this
    return number.length == 10;
}

function sendVerificationMessage(number, code) {
    Twilio.sms.messages.create({
        to: '+1' + number,
        from: '7706912561',
        body: "Your verification code for Who's Hungry is " + code
    }, function(error, message) {
        if (!error) {
            console.log('Verification code sent to ' + number + ' on ');
            console.log(message.dateCreated);
        } else {
            console.log('Could not send verification code to ' + number);
        }
    });
}

var verificationCodes = {};

//Create server
var app = express();

// Configure server
app.configure( function() {
    //parses request body and populates request.body
    app.use( express.bodyParser() );

    //checks request.body for HTTP method overrides
    app.use( express.methodOverride() );

    app.use(cors());

    //perform route lookup based on url and HTTP method
    app.use( app.router );

    //Show all errors in development
    app.use( express.errorHandler({ dumpExceptions: true, showStack: true }));
});

//Router
//Get a list of all tasks
app.get( '/api/tasks', function( request, response ) {
    response.send(tasks);
});

//Insert a new task
app.post( '/api/sendverification', function( request, response ) {
	if (typeof request.body.number == 'undefined') {
		response.status(400).end();
		console.log("Request does not have phone number");
	} else if (!isPhoneNumber(request.body.number)) {
        response.status(400).end();
        console.log("Invalid phone number: " + request.body.number);
    } else {
        var phoneNumber = request.body.number.replace
		var code = Math.floor(Math.random()*10000);
        verificationCodes[request.body.number] = code;
        sendVerificationMessage(request.body.number, code);

        response.status(200).end();
	}
});

app.post( '/api/verify', function( request, response) {
    if (typeof request.body.number == 'undefined' || typeof request.body.code == 'undefined'
        || typeof request.body.firstname == 'undefined' || request.body.lastname == 'undefined') {
        response.status(400).end();
        console.log("Request does not have phone number and verification code");
    } else if (!isPhoneNumber(request.body.number)) {
        response.status(400).end();
        console.log("Invalid phone number: " + request.body.number);
    } else if (request.body.code != verificationCodes[request.body.number]) {
        response.status(400).end();
        console.log("Invalid validation code!");
    } else {
        delete verificationCodes[request.body.number];

        var user = new User(request.body.number, request.body.firstname, request.body.lastname);
        users.push(user);

        response.status(200).end();
        console.log("User added!");
        console.log(user);
    }
});

app.post( '/api/getcontacts', function(request, response) {
    if (typeof request.body != 'array') {
        response.status(400).end();
        console.log("Request body is not an array.");
        console.log(request.body);
    } else {
        var requestNumbers = request.body;
    
        var numbersOnServer = _.filter(users, function(user) {
            return _.find(requestNumbers, function(number) {
                return user.phone == number;
            }).length > 0;
        });

        response.status(200).end(numbersOnServer);
    }
});

//Start server
var port = 80;
app.listen( process.env.PORT || port, function() {
    console.log( 'Express server listening on port %d in %s mode', port, app.settings.env );
});
