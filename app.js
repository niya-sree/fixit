const http = require("http");
const appName = process.env.APP_NAME;
const appENV = process.env.APP_ENV;
const PORT = process.env.APP_PORT || 3000;
http.createServer((req, res) => {
  if (req.url === "/health") { 
    res.writeHead(200); 
    return res.end("ok");
  }
  res.writeHead(200); 
  res.end(`${appName} running in ${appENV}\n`);
}).listen(PORT, "0.0.0.0" , () => {
  console.log(`${appName} up on ${PORT} in ${appENV}`);
});
