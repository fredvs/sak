unit main_mfm;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

implementation
uses
 mseclasses,main;

const
 objdata: record size: integer; data: array[0..4737] of byte end =
      (size: 4738; data: (
  84,80,70,48,7,116,109,97,105,110,102,111,8,115,97,107,95,100,101,109,
  111,8,98,111,117,110,100,115,95,120,3,137,0,8,98,111,117,110,100,115,
  95,121,3,220,0,9,98,111,117,110,100,115,95,99,120,3,205,3,9,98,
  111,117,110,100,115,95,99,121,3,233,0,26,99,111,110,116,97,105,110,101,
  114,46,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,0,
  27,99,111,110,116,97,105,110,101,114,46,102,114,97,109,101,46,108,111,99,
  97,108,112,114,111,112,115,49,11,0,16,99,111,110,116,97,105,110,101,114,
  46,98,111,117,110,100,115,1,2,0,2,0,3,205,3,3,233,0,0,7,
  99,97,112,116,105,111,110,6,20,68,101,109,111,32,111,102,32,109,115,101,
  32,119,105,116,104,32,115,97,107,15,109,111,100,117,108,101,99,108,97,115,
  115,110,97,109,101,6,9,116,109,97,105,110,102,111,114,109,0,6,116,108,
  97,98,101,108,7,116,108,97,98,101,108,49,8,116,97,98,111,114,100,101,
  114,2,2,8,98,111,117,110,100,115,95,120,2,16,8,98,111,117,110,100,
  115,95,121,2,40,9,98,111,117,110,100,115,95,99,120,2,80,9,98,111,
  117,110,100,115,95,99,121,2,15,7,99,97,112,116,105,111,110,6,15,84,
  104,105,115,32,105,115,32,97,32,108,97,98,101,108,13,114,101,102,102,111,
  110,116,104,101,105,103,104,116,2,15,0,0,7,116,98,117,116,116,111,110,
  8,116,98,117,116,116,111,110,49,8,98,111,117,110,100,115,95,120,2,120,
  8,98,111,117,110,100,115,95,121,2,48,9,98,111,117,110,100,115,95,99,
  120,2,98,9,98,111,117,110,100,115,95,99,121,2,21,5,115,116,97,116,
  101,11,15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,17,97,
  115,95,108,111,99,97,108,111,110,101,120,101,99,117,116,101,0,7,99,97,
  112,116,105,111,110,6,8,76,111,97,100,32,83,65,75,9,111,110,101,120,
  101,99,117,116,101,7,13,108,111,97,100,97,115,115,105,115,116,105,118,101,
  0,0,7,116,98,117,116,116,111,110,8,116,98,117,116,116,111,110,50,8,
  116,97,98,111,114,100,101,114,2,1,8,98,111,117,110,100,115,95,120,3,
  224,0,8,98,111,117,110,100,115,95,121,2,48,9,98,111,117,110,100,115,
  95,99,120,2,98,9,98,111,117,110,100,115,95,99,121,2,21,5,115,116,
  97,116,101,11,11,97,115,95,100,105,115,97,98,108,101,100,16,97,115,95,
  108,111,99,97,108,100,105,115,97,98,108,101,100,15,97,115,95,108,111,99,
  97,108,99,97,112,116,105,111,110,17,97,115,95,108,111,99,97,108,111,110,
  101,120,101,99,117,116,101,0,7,99,97,112,116,105,111,110,6,10,85,110,
  108,111,97,100,32,83,65,75,9,111,110,101,120,101,99,117,116,101,7,15,
  117,110,108,111,97,100,97,115,115,105,115,116,105,118,101,0,0,11,116,115,
  116,114,105,110,103,101,100,105,116,12,116,115,116,114,105,110,103,101,100,105,
  116,49,16,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,
  0,17,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,49,11,
  0,8,116,97,98,111,114,100,101,114,2,8,8,98,111,117,110,100,115,95,
  120,3,64,1,8,98,111,117,110,100,115,95,121,3,160,0,9,98,111,117,
  110,100,115,95,99,120,3,52,1,9,98,111,117,110,100,115,95,99,121,2,
  21,5,118,97,108,117,101,6,45,87,114,105,116,101,32,115,111,109,101,116,
  104,105,110,103,32,104,101,114,101,46,46,46,32,85,115,101,32,70,49,50,
  32,107,101,121,32,116,111,32,114,101,97,100,46,32,13,114,101,102,102,111,
  110,116,104,101,105,103,104,116,2,15,0,0,12,116,98,111,111,108,101,97,
  110,101,100,105,116,13,116,98,111,111,108,101,97,110,101,100,105,116,49,13,
  102,114,97,109,101,46,99,97,112,116,105,111,110,6,13,84,97,107,101,32,
  104,111,108,108,121,100,97,121,16,102,114,97,109,101,46,108,111,99,97,108,
  112,114,111,112,115,11,0,17,102,114,97,109,101,46,108,111,99,97,108,112,
  114,111,112,115,49,11,0,16,102,114,97,109,101,46,111,117,116,101,114,102,
  114,97,109,101,1,2,0,2,2,2,85,2,2,0,8,116,97,98,111,114,
  100,101,114,2,3,8,98,111,117,110,100,115,95,120,3,184,1,8,98,111,
  117,110,100,115,95,121,3,134,0,9,98,111,117,110,100,115,95,99,120,2,
  98,9,98,111,117,110,100,115,95,99,121,2,17,0,0,17,116,98,111,111,
  108,101,97,110,101,100,105,116,114,97,100,105,111,18,116,98,111,111,108,101,
  97,110,101,100,105,116,114,97,100,105,111,49,13,102,114,97,109,101,46,99,
  97,112,116,105,111,110,6,3,114,101,100,16,102,114,97,109,101,46,108,111,
  99,97,108,112,114,111,112,115,11,0,17,102,114,97,109,101,46,108,111,99,
  97,108,112,114,111,112,115,49,11,0,16,102,114,97,109,101,46,111,117,116,
  101,114,102,114,97,109,101,1,2,0,2,2,2,23,2,2,0,8,116,97,
  98,111,114,100,101,114,2,5,8,98,111,117,110,100,115,95,120,3,64,1,
  8,98,111,117,110,100,115,95,121,2,78,9,98,111,117,110,100,115,95,99,
  120,2,36,9,98,111,117,110,100,115,95,99,121,2,17,0,0,17,116,98,
  111,111,108,101,97,110,101,100,105,116,114,97,100,105,111,18,116,98,111,111,
  108,101,97,110,101,100,105,116,114,97,100,105,111,50,13,102,114,97,109,101,
  46,99,97,112,116,105,111,110,6,5,103,114,101,101,110,16,102,114,97,109,
  101,46,108,111,99,97,108,112,114,111,112,115,11,0,17,102,114,97,109,101,
  46,108,111,99,97,108,112,114,111,112,115,49,11,0,16,102,114,97,109,101,
  46,111,117,116,101,114,102,114,97,109,101,1,2,0,2,2,2,38,2,2,
  0,8,116,97,98,111,114,100,101,114,2,6,8,98,111,117,110,100,115,95,
  120,3,64,1,8,98,111,117,110,100,115,95,121,2,102,9,98,111,117,110,
  100,115,95,99,120,2,51,9,98,111,117,110,100,115,95,99,121,2,17,0,
  0,17,116,98,111,111,108,101,97,110,101,100,105,116,114,97,100,105,111,18,
  116,98,111,111,108,101,97,110,101,100,105,116,114,97,100,105,111,51,13,102,
  114,97,109,101,46,99,97,112,116,105,111,110,6,4,98,108,117,101,16,102,
  114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,0,17,102,114,
  97,109,101,46,108,111,99,97,108,112,114,111,112,115,49,11,0,16,102,114,
  97,109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,0,2,2,2,
  29,2,2,0,8,116,97,98,111,114,100,101,114,2,7,8,98,111,117,110,
  100,115,95,120,3,64,1,8,98,111,117,110,100,115,95,121,2,126,9,98,
  111,117,110,100,115,95,99,120,2,42,9,98,111,117,110,100,115,95,99,121,
  2,17,0,0,7,116,115,108,105,100,101,114,8,116,115,108,105,100,101,114,
  49,16,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,0,
  17,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,49,11,0,
  8,116,97,98,111,114,100,101,114,2,9,8,98,111,117,110,100,115,95,120,
  3,112,1,8,98,111,117,110,100,115,95,121,3,200,0,5,118,97,108,117,
  101,2,0,25,115,99,114,111,108,108,98,97,114,46,102,97,99,101,46,108,
  111,99,97,108,112,114,111,112,115,11,0,0,0,9,116,109,101,109,111,101,
  100,105,116,10,116,109,101,109,111,101,100,105,116,49,16,102,114,97,109,101,
  46,108,111,99,97,108,112,114,111,112,115,11,15,102,114,108,95,99,111,108,
  111,114,99,108,105,101,110,116,0,17,102,114,97,109,101,46,108,111,99,97,
  108,112,114,111,112,115,49,11,0,21,102,114,97,109,101,46,115,98,104,111,
  114,122,46,112,97,103,101,115,105,122,101,2,1,21,102,114,97,109,101,46,
  115,98,118,101,114,116,46,112,97,103,101,115,105,122,101,2,1,8,116,97,
  98,111,114,100,101,114,2,4,8,98,111,117,110,100,115,95,120,3,128,1,
  8,98,111,117,110,100,115,95,121,2,8,9,98,111,117,110,100,115,95,99,
  120,3,252,0,9,98,111,117,110,100,115,95,99,121,2,117,5,118,97,108,
  117,101,6,73,84,104,101,32,113,117,105,99,107,32,98,114,111,119,110,32,
  102,111,120,44,32,106,117,109,112,115,32,111,118,101,114,32,116,104,101,32,
  108,97,122,121,32,100,111,103,46,46,46,32,85,115,101,32,70,49,50,32,
  107,101,121,32,116,111,32,114,101,97,100,32,97,108,108,46,32,13,114,101,
  102,102,111,110,116,104,101,105,103,104,116,2,15,0,0,15,116,109,97,105,
  110,109,101,110,117,119,105,100,103,101,116,16,116,109,97,105,110,109,101,110,
  117,119,105,100,103,101,116,49,14,111,112,116,105,111,110,115,119,105,100,103,
  101,116,49,11,13,111,119,49,95,97,117,116,111,115,99,97,108,101,13,111,
  119,49,95,97,117,116,111,119,105,100,116,104,0,12,102,114,97,109,101,46,
  108,101,118,101,108,111,2,1,12,102,114,97,109,101,46,108,101,118,101,108,
  105,2,255,13,102,114,97,109,101,46,99,97,112,116,105,111,110,6,15,116,
  109,97,105,110,109,101,110,117,119,105,100,103,101,116,16,102,114,97,109,101,
  46,108,111,99,97,108,112,114,111,112,115,11,10,102,114,108,95,108,101,118,
  101,108,111,10,102,114,108,95,108,101,118,101,108,105,0,17,102,114,97,109,
  101,46,108,111,99,97,108,112,114,111,112,115,49,11,0,16,102,114,97,109,
  101,46,111,117,116,101,114,102,114,97,109,101,1,2,0,2,18,2,38,2,
  0,0,8,116,97,98,111,114,100,101,114,2,11,8,98,111,117,110,100,115,
  95,120,2,1,8,98,111,117,110,100,115,95,121,2,238,9,98,111,117,110,
  100,115,95,99,120,2,113,9,98,111,117,110,100,115,95,99,121,2,39,23,
  109,101,110,117,46,109,101,110,117,46,115,117,98,109,101,110,117,46,99,111,
  117,110,116,2,2,23,109,101,110,117,46,109,101,110,117,46,115,117,98,109,
  101,110,117,46,105,116,101,109,115,14,1,13,115,117,98,109,101,110,117,46,
  99,111,117,110,116,2,3,13,115,117,98,109,101,110,117,46,105,116,101,109,
  115,14,1,13,115,117,98,109,101,110,117,46,99,111,117,110,116,2,3,13,
  115,117,98,109,101,110,117,46,105,116,101,109,115,14,1,7,99,97,112,116,
  105,111,110,6,7,79,112,101,110,32,38,65,5,115,116,97,116,101,11,15,
  97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,0,0,1,7,99,
  97,112,116,105,111,110,6,7,79,112,101,110,32,38,66,5,115,116,97,116,
  101,11,15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,0,0,
  1,7,99,97,112,116,105,111,110,6,7,79,112,101,110,32,38,67,5,115,
  116,97,116,101,11,15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,
  110,0,0,0,7,99,97,112,116,105,111,110,6,5,38,79,112,101,110,5,
  115,116,97,116,101,11,15,97,115,95,108,111,99,97,108,99,97,112,116,105,
  111,110,0,0,1,7,99,97,112,116,105,111,110,6,6,38,67,108,111,115,
  101,5,115,116,97,116,101,11,15,97,115,95,108,111,99,97,108,99,97,112,
  116,105,111,110,0,0,1,7,99,97,112,116,105,111,110,6,5,38,69,120,
  105,116,5,115,116,97,116,101,11,15,97,115,95,108,111,99,97,108,99,97,
  112,116,105,111,110,17,97,115,95,108,111,99,97,108,111,110,101,120,101,99,
  117,116,101,0,0,0,7,99,97,112,116,105,111,110,6,5,38,70,105,108,
  101,5,115,116,97,116,101,11,15,97,115,95,108,111,99,97,108,99,97,112,
  116,105,111,110,0,0,1,13,115,117,98,109,101,110,117,46,99,111,117,110,
  116,2,4,13,115,117,98,109,101,110,117,46,105,116,101,109,115,14,1,7,
  99,97,112,116,105,111,110,6,3,79,110,101,5,115,116,97,116,101,11,15,
  97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,0,0,1,7,99,
  97,112,116,105,111,110,6,3,84,119,111,5,115,116,97,116,101,11,15,97,
  115,95,108,111,99,97,108,99,97,112,116,105,111,110,0,0,1,7,99,97,
  112,116,105,111,110,6,5,84,104,114,101,101,5,115,116,97,116,101,11,15,
  97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,0,0,1,7,99,
  97,112,116,105,111,110,6,4,70,111,117,114,5,115,116,97,116,101,11,15,
  97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,0,0,0,7,99,
  97,112,116,105,111,110,6,6,105,116,101,109,38,50,5,115,116,97,116,101,
  11,15,97,115,95,108,111,99,97,108,99,97,112,116,105,111,110,0,0,0,
  20,109,101,110,117,46,109,101,110,117,46,102,111,110,116,46,99,111,108,111,
  114,4,47,79,47,0,20,109,101,110,117,46,109,101,110,117,46,102,111,110,
  116,46,115,116,121,108,101,11,7,102,115,95,98,111,108,100,0,19,109,101,
  110,117,46,109,101,110,117,46,102,111,110,116,46,110,97,109,101,6,8,115,
  116,102,95,109,101,110,117,25,109,101,110,117,46,109,101,110,117,46,102,111,
  110,116,46,108,111,99,97,108,112,114,111,112,115,11,9,102,108,112,95,99,
  111,108,111,114,9,102,108,112,95,115,116,121,108,101,0,26,109,101,110,117,
  46,109,101,110,117,46,102,111,110,116,97,99,116,105,118,101,46,99,111,108,
  111,114,4,47,47,79,0,26,109,101,110,117,46,109,101,110,117,46,102,111,
  110,116,97,99,116,105,118,101,46,115,116,121,108,101,11,7,102,115,95,98,
  111,108,100,0,25,109,101,110,117,46,109,101,110,117,46,102,111,110,116,97,
  99,116,105,118,101,46,110,97,109,101,6,8,115,116,102,95,109,101,110,117,
  31,109,101,110,117,46,109,101,110,117,46,102,111,110,116,97,99,116,105,118,
  101,46,108,111,99,97,108,112,114,111,112,115,11,9,102,108,112,95,99,111,
  108,111,114,0,0,0,11,116,115,116,114,105,110,103,103,114,105,100,8,100,
  101,109,111,103,114,105,100,16,102,114,97,109,101,46,108,111,99,97,108,112,
  114,111,112,115,11,10,102,114,108,95,102,105,108,101,102,116,9,102,114,108,
  95,102,105,116,111,112,11,102,114,108,95,102,105,114,105,103,104,116,12,102,
  114,108,95,102,105,98,111,116,116,111,109,0,17,102,114,97,109,101,46,108,
  111,99,97,108,112,114,111,112,115,49,11,0,8,116,97,98,111,114,100,101,
  114,2,10,8,98,111,117,110,100,115,95,120,2,8,8,98,111,117,110,100,
  115,95,121,2,80,9,98,111,117,110,100,115,95,99,120,3,36,1,9,98,
  111,117,110,100,115,95,99,121,3,134,0,14,100,97,116,97,99,111,108,115,
  46,99,111,117,110,116,2,5,14,100,97,116,97,99,111,108,115,46,105,116,
  101,109,115,14,1,13,100,97,116,97,108,105,115,116,46,100,97,116,97,1,
  6,0,6,0,6,0,6,0,6,0,6,0,0,10,118,97,108,117,101,102,
  97,108,115,101,6,1,48,9,118,97,108,117,101,116,114,117,101,6,1,49,
  0,1,13,100,97,116,97,108,105,115,116,46,100,97,116,97,1,6,0,6,
  0,6,0,6,0,6,0,6,0,0,10,118,97,108,117,101,102,97,108,115,
  101,6,1,48,9,118,97,108,117,101,116,114,117,101,6,1,49,0,1,13,
  100,97,116,97,108,105,115,116,46,100,97,116,97,1,6,0,6,0,6,0,
  6,0,6,0,6,0,0,10,118,97,108,117,101,102,97,108,115,101,6,1,
  48,9,118,97,108,117,101,116,114,117,101,6,1,49,0,1,13,100,97,116,
  97,108,105,115,116,46,100,97,116,97,1,6,0,6,0,6,0,6,0,6,
  0,6,0,0,10,118,97,108,117,101,102,97,108,115,101,6,1,48,9,118,
  97,108,117,101,116,114,117,101,6,1,49,0,1,13,100,97,116,97,108,105,
  115,116,46,100,97,116,97,1,6,0,6,0,6,0,6,0,6,0,6,0,
  0,10,118,97,108,117,101,102,97,108,115,101,6,1,48,9,118,97,108,117,
  101,116,114,117,101,6,1,49,0,0,13,102,105,120,99,111,108,115,46,99,
  111,117,110,116,2,1,13,102,105,120,99,111,108,115,46,105,116,101,109,115,
  14,1,5,119,105,100,116,104,2,30,7,110,117,109,115,116,101,112,2,1,
  0,0,13,102,105,120,114,111,119,115,46,99,111,117,110,116,2,1,13,102,
  105,120,114,111,119,115,46,105,116,101,109,115,14,1,6,104,101,105,103,104,
  116,2,17,7,110,117,109,115,116,101,112,2,1,0,0,8,114,111,119,99,
  111,117,110,116,2,6,13,100,97,116,97,114,111,119,104,101,105,103,104,116,
  2,17,12,115,116,97,116,112,114,105,111,114,105,116,121,2,1,13,114,101,
  102,102,111,110,116,104,101,105,103,104,116,2,15,0,0,13,116,102,105,108,
  101,110,97,109,101,101,100,105,116,8,115,97,107,105,116,100,105,114,13,102,
  114,97,109,101,46,99,97,112,116,105,111,110,6,18,68,105,114,101,99,116,
  111,114,121,32,111,102,32,115,97,107,105,116,16,102,114,97,109,101,46,108,
  111,99,97,108,112,114,111,112,115,11,0,17,102,114,97,109,101,46,108,111,
  99,97,108,112,114,111,112,115,49,11,0,19,102,114,97,109,101,46,98,117,
  116,116,111,110,115,46,99,111,117,110,116,2,1,19,102,114,97,109,101,46,
  98,117,116,116,111,110,115,46,105,116,101,109,115,14,1,7,105,109,97,103,
  101,110,114,2,17,0,0,20,102,114,97,109,101,46,98,117,116,116,111,110,
  46,105,109,97,103,101,110,114,2,17,16,102,114,97,109,101,46,111,117,116,
  101,114,102,114,97,109,101,1,2,0,2,18,2,0,2,0,0,8,116,97,
  98,111,114,100,101,114,2,12,8,98,111,117,110,100,115,95,120,2,120,8,
  98,111,117,110,100,115,95,121,2,254,9,98,111,117,110,100,115,95,99,120,
  3,204,0,9,98,111,117,110,100,115,95,99,121,2,39,18,99,111,110,116,
  114,111,108,108,101,114,46,111,112,116,105,111,110,115,11,13,102,100,111,95,
  100,105,114,101,99,116,111,114,121,15,102,100,111,95,115,97,118,101,108,97,
  115,116,100,105,114,0,13,114,101,102,102,111,110,116,104,101,105,103,104,116,
  2,15,0,0,11,116,119,105,100,103,101,116,103,114,105,100,12,116,119,105,
  100,103,101,116,103,114,105,100,49,16,102,114,97,109,101,46,108,111,99,97,
  108,112,114,111,112,115,11,0,17,102,114,97,109,101,46,108,111,99,97,108,
  112,114,111,112,115,49,11,0,8,116,97,98,111,114,100,101,114,2,13,8,
  98,111,117,110,100,115,95,120,3,160,2,8,98,111,117,110,100,115,95,121,
  2,56,9,98,111,117,110,100,115,95,99,120,3,10,1,9,98,111,117,110,
  100,115,95,99,121,3,138,0,13,102,105,120,114,111,119,115,46,99,111,117,
  110,116,2,1,13,102,105,120,114,111,119,115,46,105,116,101,109,115,14,1,
  6,104,101,105,103,104,116,2,17,0,0,13,114,101,102,102,111,110,116,104,
  101,105,103,104,116,2,15,0,0,7,116,98,117,116,116,111,110,8,116,98,
  117,116,116,111,110,51,8,116,97,98,111,114,100,101,114,2,14,8,98,111,
  117,110,100,115,95,120,3,208,2,8,98,111,117,110,100,115,95,121,2,24,
  9,98,111,117,110,100,115,95,99,120,2,50,9,98,111,117,110,100,115,95,
  99,121,2,21,5,115,116,97,116,101,11,15,97,115,95,108,111,99,97,108,
  99,97,112,116,105,111,110,0,7,99,97,112,116,105,111,110,6,5,104,101,
  108,108,111,0,0,9,116,101,110,117,109,101,100,105,116,5,116,121,112,101,
  95,13,102,114,97,109,101,46,99,97,112,116,105,111,110,6,4,84,121,112,
  101,16,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,11,0,
  17,102,114,97,109,101,46,108,111,99,97,108,112,114,111,112,115,49,11,0,
  16,102,114,97,109,101,46,111,117,116,101,114,102,114,97,109,101,1,2,0,
  2,18,2,0,2,0,0,8,116,97,98,111,114,100,101,114,2,15,8,98,
  111,117,110,100,115,95,120,3,48,3,8,98,111,117,110,100,115,95,121,2,
  6,9,98,111,117,110,100,115,95,99,121,2,39,19,100,114,111,112,100,111,
  119,110,46,99,111,108,115,46,99,111,117,110,116,2,1,19,100,114,111,112,
  100,111,119,110,46,99,111,108,115,46,105,116,101,109,115,14,1,0,0,13,
  114,101,102,102,111,110,116,104,101,105,103,104,116,2,15,0,0,0)
 );

initialization
 registerobjectdata(@objdata,tmainfo,'');
end.
