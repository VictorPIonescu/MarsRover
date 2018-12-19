var bitInversions = {
    0: 1,
    1: 0
};

var displayInversions = {
    "hidden": "visible",
    "visible": "hidden"
};

var bitToColor = {
    0: "black",
    1: "white"
};

var newList = [];
var current = newList;
var savedLists;

var list = document.getElementById("listView");
var output = document.getElementById("output");
var savedListsList = document.getElementById("savedLists");
var outputStuff = document.getElementById("outputStuff");

var scenariosURL = "/scenarios";

window.onload = function() {
    getScenarios();
    var inputs = document.getElementsByTagName("input");
    for (input in inputs) {
        inputs[input].value = "";
    }

};

function toggleOutput() {
    output.style.visibility = displayInversions[output.style.visibility];
    createOutput();
}

function copyOutput() {
    var msg = document.createElement('span');
    msg.innerText = "copied!";

    output.style.visibility = "visible";
    output.focus();
    output.select();
    if (document.execCommand('copy')) {
        outputStuff.appendChild(msg);
    } else {
        msg.innerText = "NOT COPIED!";
        outputStuff.appendChild(msg);
    }
    setTimeout(function() {outputStuff.removeChild(msg)}, 2000);
    output.style.visibility = "hidden";
}

function toggleSensorBox(i, j) {
    current[i][j] = bitInversions[current[i][j]];
    refreshElementList(current);
}

function addAfter() {
    current.splice(0, 0, createItem());
    refreshElementList(current);
}

function prepend(index) {
    current.splice(index+1, 0, createItem());
    refreshElementList(current);
}

function remove(i) {
    current.splice(i, 1);
    refreshElementList(current);
}

function createItem() {
    return [1, 1, 1];
}

function refreshElementList() {
    list.innerHTML = "";
    for (var i = 0; i < current.length; i++)
    {
        var itemDiv = document.createElement("div");
        itemDiv.className = "sensorRow";

        for (var j = 0; j < current[i].length; j++) {
            var smallSensorBox = document.createElement("div");
            smallSensorBox.className = "sensorBox";
            // encapsulate value of i at this moment by calling a function with i was argument
            smallSensorBox.onclick = function (i, j) {
                return function () {
                    toggleSensorBox(i, j)
                }
            }(i, j);
            smallSensorBox.style.backgroundColor = bitToColor[current[i][j]];
            itemDiv.appendChild(smallSensorBox);
        }

        var prependButton = document.createElement("button");
        prependButton.innerText = "add before";
        prependButton.onclick = function (index) {
            return function () {
                prepend(index)
            }
        }(i);

        var removeButton = document.createElement("button");
        removeButton.innerText = "remove";
        removeButton.onclick = function (index) {
            return function () {
                remove(index)
            }
        }(i);

        itemDiv.appendChild(prependButton);
        itemDiv.appendChild(removeButton);

        list.appendChild(itemDiv);
    }
    createOutput();
}

function selectList(list) {
    current = list;
    refreshElementList();
}

function refreshSavedList() {
    savedListsList.innerHTML = "";
    var savedListElement = document.createElement("div");
    savedListElement.className = "savedListElement";
    savedListElement.id = "newListElement";
    savedListElement.onclick = function() {selectList(newList)};
    savedListElement.innerText = "NEW/UNSAVED";
    savedListsList.appendChild(savedListElement);

    var keys = Object.keys(savedLists);
    for (var i = 0; i < keys.length; i++) {
        var row = document.createElement("div");
        var key = keys[i];
        savedListElement = document.createElement("div");
        savedListElement.style.display = "inline-block";
        savedListElement.className = "savedListElement";
        savedListElement.onclick = function(key) {return function() {selectList(savedLists[key])}}(key);
        savedListElement.innerText = key;
        row.appendChild(savedListElement);

        var deleteButton = document.createElement("button");
        deleteButton.style.display = "inline-block";
        deleteButton.innerText = "remove";
        deleteButton.onclick = function(key) {return function() {deleteScenario(key)}}(key);
        row.appendChild(deleteButton);

        savedListsList.appendChild(row);

    }

}

function createOutput() {
    output.innerHTML = "";
    createSensorList("sensor_l", 0);
    createSensorList("sensor_m", 1);
    createSensorList("sensor_r", 2);
}

function createSensorList(sensorName, j) {
    var time = parseInt(document.getElementById("initialTime").value) || 0;
    var interval = parseInt(document.getElementById("intervalInput").value) || 20;
    var timeUnit = document.getElementById("timeUnitInput").value;

    output.append(sensorName + " <= ");
    for (var i = current.length - 1; i >= 0; i--) {
        if (i < current.length - 1) {
            output.append("\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0");
        }
        output.append("'" + current[i][j] + "'");
        output.append(" after " + time + " " + timeUnit);
        if (i === 0) {
            output.append(";");
        } else {
            output.append(",");
        }
        output.append("\n");
        output.appendChild(document.createElement("br"));
        time += interval;
    }
}

function getScenarios() {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', scenariosURL, true);
    xhr.onload = function() {
        if (xhr.status !== 200) {
            console.log('Request failed.  Returned status of ' + xhr.status);
            console.log(xhr.responseText);
        } else {
            var parsedResponse = JSON.parse(xhr.responseText);
            if (parsedResponse.error) {
                alert(parsedResponse.error);
            } else {
                console.log(parsedResponse);
                savedLists = parsedResponse;
                refreshSavedList();
            }
        }
    };
    xhr.send();

}

function writeScenario() {
    var name = document.getElementById("scenarioInput").value;
    var data = current;
    var xhr = new XMLHttpRequest();
    xhr.open('PUT', scenariosURL);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.onload = function() {
        if (xhr.status !== 200) {
            console.log('Request failed.  Returned status of ' + xhr.status);
            console.log(xhr.responseText);
        } else {
            var parsedResponse = JSON.parse(xhr.responseText);
            if (parsedResponse.error) {
                alert(parsedResponse.error);
            } else {
                console.log(parsedResponse);
                getScenarios();
                newList = [];
            }
        }
    };
    xhr.send(JSON.stringify({
        name: name,
        data: data
    }));
}

function deleteScenario(name) {
    console.log(name);
    var xhr = new XMLHttpRequest();
    xhr.open('DELETE', scenariosURL);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.onload = function() {
        if (xhr.status !== 200) {
            console.log('Request failed.  Returned status of ' + xhr.status);
            console.log(xhr.responseText);
        } else {
            var parsedResponse = JSON.parse(xhr.responseText);
            if (parsedResponse.error) {
                alert(parsedResponse.error);
            } else {
                console.log(parsedResponse);
                getScenarios();
            }
        }
    };
    xhr.send(JSON.stringify({
        name: name
    }));
}
