var x = document.getElementById("GInterface.Instances[1].Instances[1].bouton_Edit");
x.value = "m2 tech" // Code Formation
var change = new Event("change")
x.dispatchEvent(change);
var y = document.getElementById("GInterface.Instances[1].Instances[1]_0");
y.click();