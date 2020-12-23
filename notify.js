const apn = require('apn');
//var path = require('path');
const bodyParser = require('body-parser');
var constants = require('./constant')

//notification
let options = {
    token: {
    key: "./AuthKey_YNHLK5SY95.p8",
    // Replace keyID and teamID with the values you've previously saved.
    keyId: constants.key_id,
    teamId: constants.team_id
    },
    production: false,
   // gateway: 'gateway.push.apple.com',      // gateway address
};
//help you locate your file location
//console.log(path.join(__dirname, 'AuthKey_YNHLK5SY95.p8'));

let notification = new apn.Notification();
notification.expiry = Math.floor(Date.now() / 1000) + 24 * 3600; // will expire in 24 hours from now
notification.badge = 2;
notification.sound = "ping.aiff";
notification.alert = "Attention, one user has been test positive in your area!";
notification.payload = {'messageFrom': 'Solarian Programmer'};

notification.topic = constants.bundle_id;

//connect database 
const admin = require('firebase-admin');
const serviceAccount = require('./dp4coruna-5597f3088ecd.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});
const db = admin.firestore();
console.log("Access database");

var sleep = require('sleep'); 
// server to listem to request 
const express = require('express');
const app = express();
app.use(bodyParser.json());

console.log("Server listening");
app.post('/', function (req, res) {
    //start response 
    console.log("got post request from user");
    start()
    
    console.log("notification sent ");
})

var filepath = '~/path/to/file.png'
//app.get('/report/:chart_id/:user_id', function (req, res) {
 //   res.sendFile(filepath);});



app.listen(5000, () => {
	console.info('We are up!');
}); 

const start = async() =>{
    try {
    sleep.sleep(3);
    let apnProvider = new apn.Provider(options);
    // read data 
    const snapshot = await db.collection('users').get();
    var i;
    console.log(snapshot.size);
    for (i = 0; i < snapshot.size; i++) {
        let doc = snapshot.docs[i]
        let token = doc.data().token;
        apnProvider.send(notification, token).then( result => {
            // Show the result of the send operation:
            console.log("send");
            //console.log(token);
            //console.log(device);
            console.log(result);
            //console.log(result.failed);
            });
    }
    apnProvider.shutdown();
    }catch(err){
        console.log('Error at newFunction ::', err)
        throw err
    }
}

//
//
//
//

//main function to call xueyang algorithm 
app.post('/python', function(req, res) {
    corner = [40.54989739306218,-74.33724079281092]
    scale = [2.5290974344421646e-06, 3.2905937003357638e-06]
    const body = req.body
    //res.send(`You sent: ${body} to Express`)
    console.log("Get data")
    console.log(body)
    //here is input
    const x1 = Math.round((corner[0] - body.A.x)/scale[0])
    const y1 = Math.round(-1*(corner[1] - body.A.y)/scale[1])
    const x2 = Math.round((corner[0] - body.B.x)/scale[0])
    const y2 = Math.round(-1*(corner[1] - body.B.y)/scale[1])
    console.log((corner[1] - body.A.y))
    console.log(-1*(corner[1] - body.B.y))
    console.log(x1,y1,x2,y2)
    //here we run python code
    // Use child_process.spawn method from  
    // child_process module and assign it 
    // to variable spawn 
    var spawn = require("child_process").spawn; 
      
    // Parameters passed in spawn - 
    // 1. type_of_script 
    // 2. list containing Path of the script 
    //    and arguments for the script  
      
    // E.g : http://localhost:3000/name?firstname=Mike&lastname=Will 
    // so, first name = Mike and last name = Will 
    var process = spawn('python',["shortestPath.py", x1, y1, x2, y2] ); 
  
    // Takes stdout data from script which executed 
    // with arguments and send this data to res object 

    
    //prepare return json data
    var return_json = {}
    var key = 'return'
    return_json[key] = []
    process.stdout.on('data', function(data) { 
      
        var text = data.toString()
        console.log(text)
        text = text.replace('(', '')
        text = text.replace('[', '')
        text = text.split("), ")
        for (let i in text) {
            let lat = corner[0] - parseInt(text[i].replace('(', '').split(", ")[0])*scale[0]
            let lot = corner[1] + parseInt(text[i].replace('(', '').split(", ")[1])*scale[1]
            if(i%2){
                return_json[key].push([lat,lot])
            }
        }
        /*
        for (let i in return_json[key]) {
            return_json[key][i] = parseInt(return_json[key][i],10)
        }
        for (let i in return_json[key]){
            return_json[key][i] = return_json[key][i] 
        }
        */
        //return_json[key].push(text);
        res.status(200).json(return_json);
        console.log(return_json)
    } ) 
    
    
 });

 //method for test xueyang's code
 app.post('/python1', function(req, res) {
    console.log("got request")
    var return_json = {}
    var key = 'return'
    return_json[key] = []
    var spawn = require("child_process").spawn;
    var process = spawn('python',["test.py"]);
    process.stdout.on('data', function(data) { 
        var text = data.toString()
        
        text = text.replace('(', '')
        text = text.replace('[', '')
        text = text.split("), ")
        for (let i in text) {
            text[i] = text[i].replace('(', '')
            let lat = parseFloat(text[i].split(", ")[0],10)
            let lot = parseFloat(text[i].split(", ")[1],10)
            if(i%2){
                return_json[key].push([lat,lot])
            }
        }
        console.log(return_json)
        res.status(200).json(return_json);
    })
   
 });