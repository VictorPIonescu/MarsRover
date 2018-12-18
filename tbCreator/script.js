var inversions = {
    "white": "black",
    "black": "white"
};

var colorToBit = {
  "white": 1,
  "black": 0
};

var list = document.getElementById("listView");
var output = document.getElementById("output");

function toggleSensorBox(element) {
    element.style.backgroundColor = inversions[element.style.backgroundColor];
}

function append() {
    if (list.childElementCount === 0) {
        list.appendChild(createListItem());
    } else {
        list.insertBefore(createListItem(), list.children[0]);
    }
}

function prepend(item) {
    list.insertBefore(createListItem(), item.nextSibling);
}

function remove(item) {
    list.removeChild(item);
}

function createListItem() {
    var itemDiv = document.createElement("div");
    itemDiv.className = "sensorRow";

    for (var i = 0; i < 3; i++) {
        var smallSensorBox = document.createElement("div");
        smallSensorBox.className = "sensorBox smallBox";
        // closure
        smallSensorBox.onclick = function(box) {return function() {toggleSensorBox(box)}}(smallSensorBox);
        smallSensorBox.style.backgroundColor = "white";
        itemDiv.appendChild(smallSensorBox);
    }

    var prependButton = document.createElement("button");
    prependButton.innerText = "add before";
    prependButton.onclick = function(index) {return function() {prepend(index)}}(itemDiv);

    var removeButton = document.createElement("button");
    removeButton.innerText = "remove";
    removeButton.onclick = function(index) {return function() {remove(index)}}(itemDiv);

    itemDiv.appendChild(prependButton);
    itemDiv.appendChild(removeButton);

    return itemDiv;
}

function createOutput() {
    output.innerHTML = "";
    createSensorList("sensor_l", 0);
    createSensorList("sensor_m", 1);
    createSensorList("sensor_r", 2);
}

function createSensorList(sensorName, sensorBoxIndex) {
    var time = 0;
    var interval = 10;//document.getElementById("intervalInput").value;
    var timeUnit = "ns";//document.getElementById("timeUnitInput").value;

    output.append(sensorName + " <= ");
    for (var i = list.childElementCount - 1; i >= 0; i--) {
        if (i < list.childElementCount - 1) {
            output.append("\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0\xa0");
        }
        output.append("'" + colorToBit[list.children[i].children[sensorBoxIndex].style.backgroundColor] + "'");
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
