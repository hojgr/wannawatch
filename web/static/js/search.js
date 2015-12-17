let selector = $(".search input")
let last_search = "";

let visible = false;
let beginSearchTimeout;

selector.keypress(function() {
    setTimeout(() => {
	let v = $(this).val();
	
	searchWork(v);
    });
});

selector.focusin(function() {
    let v = $(this).val();
    if(v) {
	searchWork(v);
    }
});

$('html').click(function(e) {
    if(visible) {
	if ($(e.target).closest('.search .center').length === 0) {
	    hideHints();
	}
    }
});

$(document).keyup(function(e) {
    if (e.keyCode == 27) {
	if(visible) {
	    hideHints();
	}
    }
});

function hideHints() {
    visible = false;
    console.log("Hiding it");
    $(".hints").hide();
}

function searchWork(val) {
    if(!visible) {
	console.log("Showing it");
	visible = true;
	$(".hints").show();
    }

    if(val != last_search) {
	last_search = val;
	$("#search-load").css("display", "block");
	$("#search-loaded").html("");
	clearTimeout(beginSearchTimeout);
	beginSearchTimeout = setTimeout(realSearch, 500, val)
    }
}

function realSearch(val) {
    $.get("/api/movie/search", {s: val}, function(data) {
	let appendix = "";
	for(let movie of data.primary) {
	    appendix += genPrimary(movie.img, movie.name, movie.year); 
	}

	for(let movie of data.secondary) {
	    appendix += genSecondary(movie.name, movie.year);
	}
	
	$("#search-load").hide();
	$("#search-loaded").html(appendix);
    });

    console.log("Searching: ", val);
}

function genPrimary(image, name, year) {
    let r = '<a href="javascript:void(0)">';
    r += '<div class="hint-item item-primary">';
    r += '<div class="poster"><img src="' + image + '" /></div>';
    r += '<div class="name">' + name + ' (' + year + ')</div>';
    r += '<div style="clear: both"></div>';
    r += '</div>';
    r += '</a>';

    return r;
}

function genSecondary(name, year) {
    let r = '<a href="javascript:void(0)">';
    r += '<div class="hint-item item-secondary">';
    r += '<div class="poster"></div>'
    r += '<div class="name">' + name + ' (' + year + ')</div>';
    r += '<div style="clear: both"></div>';
    r += '</div>';
    r += '</a>';

    return r;
}
