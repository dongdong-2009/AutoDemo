//Import event package
var events = require('events');
//New eventEmitter object
var eventEmitter = new events.EventEmitter();

// Band data_received with niming function
var receiver = function(){
  console.log('Receive datas successfully! ');
}

eventEmitter.on('data_received',receiver)


//Create events function

var connectHandler = function connected(){
  console.log('Connect successfully! ');

  //Cause data_received issue
  eventEmitter.emit('data_received');

}


//Band connection issue
eventEmitter.on('connection',connectHandler);

console.log('Function Begining. ');

//Call connection issue
eventEmitter.emit('connection');

console.log('Function running finished. ');
