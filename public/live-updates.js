function setupTrainTracking(clock_div) {
    clock = document.getElementById(clock_div);
    window.setInterval(function() {
        var date = (new Date()).toISOString();
        date = date.replace(/.\d+Z/,'Z');
        clock.innerText = date;
    }, 900);
};
