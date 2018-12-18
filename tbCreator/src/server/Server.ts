import * as express from "express";
const app = express();
const port = 3000;


// to support JSON-encoded bodies
app.use(express.json());
// to support URL-encoded bodiesW
app.use(express.urlencoded({extended: true}));
app.use("/", express.static(__dirname + "/client/"));

app.listen(port);
console.log("Server started on port " + port);