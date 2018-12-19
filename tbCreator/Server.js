"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var express = require("express");
var fs = require("fs");
var app = express();
var port = 3000;
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use("/", express.static(__dirname));

var filePath = __dirname + "/scenarios.json";
console.log(filePath);
var scenarios;

var scenariosRouter = express.Router();
scenariosRouter.put("/", function(req, res) {
    res.send(writeScenario(req.body.name, req.body.data));

});
scenariosRouter.get("/", function(req, res) {
    res.send(getScenarios());
});

scenariosRouter.delete("/", function(req, res) {
    res.send(deleteScenario(req.body.name));
});
app.use("/scenarios", scenariosRouter);

function getScenarios() {
    if (scenarios) {
        return scenarios;
    }
    try {
        return JSON.parse(fs.readFileSync(filePath, 'utf8'));
    } catch (err) {
        if (err.code === "ENOENT") {
            try {
                fs.writeFileSync(filePath, JSON.stringify({}), 'utf8');
                return {};
            } catch (err) {
                return {error: err};
            }
        }
        console.log("other code");
        console.log(err);
        return {error: err};
    }
}

function writeScenario(name, data) {
    var scenarios = getScenarios();
    if (scenarios.hasOwnProperty(name)) {
        return {error: "Scenario " + name + " already exists."}
    }
    scenarios[name] = data;
    try {
        fs.writeFileSync(filePath, JSON.stringify(scenarios), 'utf8');
        return {};
    } catch (err) {
        return {error: err};
    }
}

function deleteScenario(name) {
    var scenarios = getScenarios();
    if (scenarios.hasOwnProperty(name)) {
        delete scenarios[name];
        try {
            fs.writeFileSync(filePath, JSON.stringify(scenarios), 'utf8');
            return {};
        } catch (err) {
            return {error: err};
        }
    } else {
        return {error: "Scenario " + name + " does not exist."}
    }

}

app.listen(port);
console.log("Server started on port " + port);
