console.log("Hello World");
var http = require("http")

http.createServer(function(request,response){
  //Http head 200: ok text/plain
  response.writeHead(200,{'Contect-Type':'text/plain'});
  //Response datas
  response.end('Hello ni hao');
}).listen(8888);

//Terminal logs
console.log('Server running at http://127.0.0.1:8888');
