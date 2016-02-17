function getColour(value){
  return "hsla(" + hue(value / 100) + ",100%,50%,0.8)"
}

function hue(value) {
  return (1-value) * 120;
}
