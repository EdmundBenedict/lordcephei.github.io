function dropdown( self, tar = null ) {
    var elm;
    if( tar ) {
        elm = document.getElementById(tar);
    } else { 
        var dropdowns = document.getElementsByTagName( "div" );
        for( var i = 0; i < dropdowns.length; i++ )
        {
           next = dropdowns[i + 1]
           if(dropdowns[i] == self && next.className == "dropContent")
           {
             elm = next;
             break;
           }
        }
    }
    
    if( !elm ) {
        return;
    }

    if(elm.style.display != 'block') {
        elm.style.display = 'block';
        self.style.textAlign = 'left';
        self.style.borderBottom = '5px solid #575757';
        //self.innerHTML="Click to hide."
    } else {
        elm.style.display = 'none';
        self.style.textAlign = 'center';
        self.style.borderBottom = '5px solid #575757';
        //self.innerHTML="Click to show.";
    }
}
