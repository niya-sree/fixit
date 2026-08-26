const http = require("http");
const PORT = process.env.PORT || 3000;
http.createServer((req, res) => {
  if (req.url === "/health") { 
    res.writeHead(200); 
    return res.end("ok");
  }
  res.writeHead(200); 
  res.end("Service running\n");
}).listen(PORT, "0.0.0.0" , () => console.log(`up on ${PORT}`));
