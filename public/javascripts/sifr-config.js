/*****************************************************************************
It is adviced to place the sIFR JavaScript calls in this file, keeping it
separate from the `sifr.js` file. That way, you can easily swap the `sifr.js`
file for a new version, while keeping the configuration.

You must load this file *after* loading `sifr.js`.

That said, you're of course free to merge the JavaScript files. Just make sure
the copyright statement in `sifr.js` is kept intact.
*****************************************************************************/

// Make an object pointing to the location of the Flash movie on your web server.
// Try using the font name as the variable name, makes it easy to remember which
// object you're using. As an example in this file, we'll use Futura.
var century = { src: 'century.swf' };
// Now you can set some configuration settings.
// See also <http://wiki.novemberborn.net/sifr3/JavaScript+Configuration>.
// One setting you probably want to use is `sIFR.useStyleCheck`. Before you do that,
// read <http://wiki.novemberborn.net/sifr3/DetectingCSSLoad>.

// sIFR.useStyleCheck = true;

// Next, activate sIFR:
sIFR.activate(century);

// If you want, you can use multiple movies, like so:
//
//    var futura = { src: '/path/to/futura.swf' };
//    var garamond = { src '/path/to/garamond.swf' };
//    var rockwell = { src: '/path/to/rockwell.swf' };
//    
//    sIFR.activate(futura, garamond, rockwell);
//
// Remember, there must be *only one* `sIFR.activate()`!

// Now we can do the replacements. You can do as many as you like, but just
// as an example, we'll replace all `<h1>` elements with the Futura movie.
// 
// The first argument to `sIFR.replace` is the `futura` object we created earlier.
// The second argument is another object, on which you can specify a number of
// parameters or "keyword arguemnts". For the full list, see "Keyword arguments"
// under `replace(kwargs, mergeKwargs)` at 
// <http://wiki.novemberborn.net/sifr3/JavaScript+Methods>.
// 
// The first argument you see here is `selector`, which is a normal CSS selector.
// That means you can also do things like '#content h1' or 'h1.title'.
//
// The second argument determines what the Flash text looks like. The main text
// is styled via the `.sIFR-root` class. Here we've specified `background-color`
// of the entire Flash movie to be a light grey, and the `color` of the text to
// be red. Read more about styling at <http://wiki.novemberborn.net/sifr3/Styling>.
sIFR.replace(century, {
  selector: '.middle h5',
  css: ['.sIFR-root { color: #78736d;text-transform:uppercase;font-weight:bold;padding:0px;}'],
  wmode: 'transparent'
});
sIFR.replace(century, {
  selector: 'p.intro',
  css: ['.sIFR-root { color: #78736d;padding:0px;}'],
  wmode: 'transparent'
});
sIFR.replace(century, {
  selector: '.sidebar-content h5, .sub-titles h5',
  css: ['.sIFR-root { color: #ffffff;text-transform:uppercase;padding:0px;}'],
  wmode: 'transparent'
});
sIFR.replace(century, {
  selector: '.top-titles h5',
  css: ['.sIFR-root { color: #cc9933;text-transform:uppercase;font-weight:bold;padding:0px;}'],
  wmode: 'transparent'
});

sIFR.replace(century, {
  selector: '.video-cal h6',
  css: ['.sIFR-root { color: #ffffff;padding:0px;}'],
  wmode: 'transparent'
});
sIFR.replace(century, {
  selector: '.video-detail h2',
  css: ['.sIFR-root { color: #0099cc;padding:0px;text-transform: uppercase;}'],
  wmode: 'transparent'
});
sIFR.replace(century, {
  selector: '.comment-title h6',
  css: ['.sIFR-root { color: #cc9933;padding:0px;font-weight:bold;text-transform: uppercase;}'],
  wmode: 'transparent'
});
sIFR.replace(century, {
  selector: '.right-title h5',
  css: ['.sIFR-root { color: #cc9933;padding:0px;text-transform: uppercase;}'],
  wmode: 'transparent'
});
sIFR.replace(century, {
  selector: '.center h2',
  css: ['.sIFR-root { color: #ffffff;padding:0px;}'],
  wmode: 'transparent'
});
sIFR.replace(century, {
  selector: '.bounty-detail-title h2',
  css: ['.sIFR-root { color: #000000;padding:0px;text-transform: uppercase;}'],
  wmode: 'transparent'
});
sIFR.replace(century, {
  selector: '.winner h2',
  css: ['.sIFR-root { color: #ffffff;padding:0px;text-transform: uppercase;line-height:normal;height:35px;}'],
  wmode: 'transparent'
});