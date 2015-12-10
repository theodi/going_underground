var timeFormat = d3.time.format('%Y-%m-%dT%H:%M:%S+00:00');

function noData(signal_name, additional) {
  additional = typeof additional !== 'undefined' ? additional : '';

  d3.selectAll("#chart p").classed("hidden", true);
  d3.selectAll("#chart").html("<p class='no-data'>No data for " + signal_name + " " + additional +"</p>")
  parent.postMessage(signal_name, "*");
}

function getSignal(data, name, colour, axis) {
  axis = typeof axis !== 'undefined' ? axis : 'y';

  if (data.length == 0) return null;

  signal = {
      x: [],
      y: [],
      yaxis: axis,
      type: 'scatter',
      name: name,
      line: {
          color: colour,
          width: 2
      }
  };

  data.forEach(function(r) {
    signal.x.push(timeFormat.parse(r.timestamp))
    signal.y.push(r.value)
  });

  return signal;
}

function getTrend(trend, name, colour) {
  if (trend.from == undefined) return null;
  return {
      x: [timeFormat.parse(trend.from.timestamp), timeFormat.parse(trend.to.timestamp)],
      y: [trend.from.value, trend.to.value],
      mode: 'lines',
      name: name + ' Trend',
      line: {
        dash: 'dashdot',
        color: colour,
        width: 1
      }
  }
}

function getLayout(name, showlegend) {
  return {
    showlegend: showlegend,
    xaxis: {
      tickangle: 75,
      exponentformat: 'e',
      type: 'datetime',
      zeroline: true,
      zerolinewidth: 2,

      tickfont: {
        family: 'RailwayRegular'
      }
    },
    yaxis: {
      title: name,
      titlefont: {
        family: 'RailwayRegular',
        color: 'rgb(0, 0, 153)',
      },
      tickfont: {
        family: 'RailwayRegular',
        color: 'rgb(0, 0, 153)',
      }
    }
  };
}

function drawChart(chartDrawer) {
  d3.json(document.URL, function(error, json) {
    d3.selectAll("#chart p").classed("hidden", false);
    if (error) {
      json = JSON.parse(error.responseText)
      alert(json.status);
      d3.selectAll("#chart p").classed("hidden", true);
    } else {
      chartDrawer(json);
    }
  });
}
