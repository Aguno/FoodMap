var express = require('express');
var app = express();

var mongoose = require('mongoose');
mongoose.connect('mongodb://localhost:27017/test');

var db = mongoose.connection;

db.on('error', console.error.bind(console, 'connection error:'));

db.once('open', function callback () {
        console.log("mongo db connection OK.");
});

var Basicinformation = mongoose.Schema({
    category : 'string',
    name : 'string',
    number : 'string',
    openinghours : 'string',
    latitude : 'number',
    longitude : 'number'

});

var basicinformation = mongoose.model('basicinformation',Basicinformation);

var basic = db.collection('basicinformation');

var Menulist = mongoose.Schema({

    category : 'string',
    name : 'string',
    menu : 'string'
})

var menulist = mongoose.model('menulist', Menulist);

var menu = db.collection('menulist');

// get function

app.get('/chicken',(req,res)=>{
    console.log('who get in here/users');
    
    basic.find({ category : "chicken" }).toArray(function(error, data){
        console.log('--- read all ---')
        if(error){
            console.log(error);
        }else{
            res.json(data);
        }
    });

})

app.get('/boonshik',(req,res)=>{
    console.log('who get in here/users');
       
    basic.find({ category : "boonshik" }).toArray(function(error, data){
        console.log('--- read all ---')
        if(error){
            console.log(error);
        }else{
            res.json(data);
        }
    });
        
})

app.get('/pasta',(req,res)=>{      
    console.log('who get in here/users');
        
    basic.find({ category : "pasta" }).toArray(function(error, data){
        console.log('--- read all ---')
        if(error){
            console.log(error);
        }else{
            res.json(data);
        }
    });
          
})



app.listen(80, () => {
    console.log('example app listening on port 80');
});
