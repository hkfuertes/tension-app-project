var counterDiv = document.getElementById('counterDiv');
var heart = document.getElementById('heartIcon');

function updateCounterUI(counter) {
  counterDiv.innerHTML = counter;

  if (heart.classList.contains('heart-inactive')) {
    heart.classList.remove('heart-inactive');

  } else {
    heart.classList.add('heart-inactive');
  }

}

var connection = new WebSocket('ws://' + location.hostname + ':81/', ['arduino']);

connection.onopen = function () {
  console.log('Connected: ');

  // Ejemplo 1, peticion desde cliente
  //(function scheduleRequest() {
  //   connection.send("");
  //   setTimeout(scheduleRequest, 100);
  //})();
};

connection.onerror = function (error) {
  console.log('WebSocket Error ', error);
};

connection.onmessage = function (e) {
  var data = JSON.parse(e.data);
  updateCounterUI(data.pulse);
  //console.log('Pulse: ', data.pulse);
};

connection.onclose = function () {
  console.log('WebSocket connection closed');
};