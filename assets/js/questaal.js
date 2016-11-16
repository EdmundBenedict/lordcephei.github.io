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
		$(self).animate( { borderBottomWidth: "6px" }, "slow", "swing" );
		$(elm).animate( { borderBottomWidth: "0" }, { duration: "slow", easing: "swing", queue: false } );
	} else {
		$(self).animate( { borderBottomWidth: "3px"  }, "slow", "swing" );
		$(elm).animate( { borderBottomWidth: "3px" }, { duration: "slow", easing: "swing", queue: false } );
	}
	$(elm).slideToggle( 'slow', 'swing' );
}
