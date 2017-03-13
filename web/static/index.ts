import 'babel-polyfill';
import 'phoenix';
import 'phoenix_html';
// Expose jquery, for Foundation.
const $ = require('expose?$!expose?jQuery!jquery');

import './styles/main.scss';
import './fonts/Phosphate-Inline.ttf';
import './fonts/Phosphate-Solid.ttf';

import './favicon.ico';
// import './img/logo.png';
// import './img/shovels.png';
const hero_path: string = require('./img/hero.jpg');
import './img/verified.png';
import './img/logo.svg';
import './img/shovels.svg';
import './img/logo_blue.png';
import './apple-touch-icon.png';
import './loaderio-5c03e76471bc81be95a31e8c9013e53c.txt';

// Import foundation stuff.
import 'foundation-sites/js/foundation.core';
import 'foundation-sites/js/foundation.util.mediaQuery';
import 'foundation-sites/js/foundation.util.motion';
import 'foundation-sites/js/foundation.util.triggers';
import 'foundation-sites/js/foundation.responsiveMenu';
import 'foundation-sites/js/foundation.responsiveToggle';
import 'motion-ui';
// import 'jquery-parallax.js';
import 'jquery-mask-plugin';

import components from './components/index';

$(document).ready(($) => {
  $(document).foundation();
  components($);
  $('body').removeClass('no-js');

  // $('.home-section .home-background').parallax({
  //   imageSrc: hero_path,
  //   position: 'center bottom'
  // });
});

