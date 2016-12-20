/**
 * @providesModule AmazingAudio
 */
'use strict';

var NativeAmazingAudio = require('NativeModules').AmazingAudioReact;
var invariant = require('invariant');
var Promisify = require('es6-promisify');

/**
 * High-level docs for the AmazingAudio iOS API can be written here.
 */

var AmazingAudio = {
  test: function() {
    NativeAmazingAudio.test();
  },
  /** param play:string
   * returns Thenable<{loop:string, duration:string} */
  load: Promisify(NativeAmazingAudio.load),
  /** param loop:string
   * options: any
   * returns Thenable<any>
   */
  play: Promisify(NativeAmazingAudio.play),
  /** param loop:string
   * options: any
   * returns Thenable<any>
   */
  update: Promisify(NativeAmazingAudio.update),
  /** param loop:string
   * returns Thenable<any>
   */
  stop: Promisify(NativeAmazingAudio.stop)
};

module.exports = AmazingAudio;

