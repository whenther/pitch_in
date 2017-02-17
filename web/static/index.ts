import 'babel-polyfill';
import 'phoenix';
import 'phoenix_html';
// Expose jquery, for Foundation.
const $ = require('expose?$!expose?jQuery!jquery');

import './styles/main.scss';
import './fonts/Phosphate-Inline.ttf';
import './fonts/Phosphate-Solid.ttf';

import './favicon.ico';
import './robots.txt';
import './img/logo.png';
import './img/logo_216.png';
import './img/shovels.png';
import './img/shovels_56.png';
import './img/verified.png';

// Import foundation stuff.
import 'foundation-sites/js/foundation.core';
import 'foundation-sites/js/foundation.util.mediaQuery';
import 'foundation-sites/js/foundation.util.motion';
import 'foundation-sites/js/foundation.util.triggers';
import 'foundation-sites/js/foundation.responsiveMenu';
import 'foundation-sites/js/foundation.responsiveToggle';
import 'motion-ui';

// Datepicker
import '@fengyuanchen/datepicker';
console.log($.fn.datepicker);
$('[data-toggle="datepicker"]').datepicker({
  format: 'm/d/yyyy'
});

import components from './components/index';

$(document).ready(($) => {
  $(document).foundation();
  components($);
});

