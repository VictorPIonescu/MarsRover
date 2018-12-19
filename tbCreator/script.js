var inversions = {
    0: 1,
    1: 0
};

var colorToBit = {
  "white": 1,
  "black": 0
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

var scenariosURL = "/scenarios";

function toggleSensorBox(i, j) {
    current[i][j] = inversions[current[i][j]];
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
        output.appendChild(document.createElement("br"));
        time += interval;
    }
}

function getScenarios() {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', scenariosURL, true);
    xhr.onload = function() {
        if (xhr.status !== 200  || xhr.responseText.error) {
            console.log('Request failed.  Returned status of ' + xhr.status);
            console.log(xhr.responseText);
        } else {
            console.log(xhr.responseText);
        }
    };
    xhr.send();

}

function writeScenario() {
    var name = document.getElementById("scenarioInput").value;
    var data = output.innerText;
    var xhr = new XMLHttpRequest();
    xhr.open('PUT', scenariosURL);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.onload = function() {
        if (xhr.status !== 200  || xhr.responseText.error) {
            console.log('Request failed.  Returned status of ' + xhr.status);
            console.log(xhr.responseText);
        }
        else {
            console.log(xhr.responseText);
        }
    };
    xhr.send(JSON.stringify({
        name: name,
        data: data
    }));

}
