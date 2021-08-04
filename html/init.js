$(document).ready(function(){
  window.addEventListener('message', function(event) {
      var node = document.createElement('textarea');
      var selection = document.getSelection();
		
	console.log(event.data.clipboard)
      node.textContent = event.data.clipboard;
      document.body.appendChild(node);

      selection.removeAllRanges();
      node.select();
      document.execCommand('copy');

      selection.removeAllRanges();
      document.body.removeChild(node);
  });
});