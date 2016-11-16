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
	
	if( $(elm).is( ":visible" ) ) {
		$(self).animate( { paddingLeft: "45%", borderBottomWidth: "10px" }, "slow", "swing" );
		$(elm).animate( { borderBottomWidth: "0" }, { duration: "slow", easing: "swing", queue: false } );
	} else {
		$(self).animate( { paddingLeft: "0", borderBottomWidth: "2px"  }, "slow", "swing" );
		$(elm).animate( { borderBottomWidth: "2px" }, { duration: "slow", easing: "swing", queue: false } );
	}
	$(elm).slideToggle( 'slow', 'swing' );
	
	/*

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
	
	*/
}
