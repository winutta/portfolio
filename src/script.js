import './style.css'
import * as THREE from 'three'
// import * as dat from 'dat.gui'
// import {GLTFLoader} from 'three/examples/jsm/loaders/GLTFLoader.js'
// import vertShader from "./shaders/vertShader.glsl"
// import fragShader from "./shaders/fragShader.glsl"

import {setup} from "./setup"
import {text} from "./introText"
import * as v from "./introVisual"


function main() {

// BASIC SETUP

var {scene,camera,renderer} = setup;
console.log(v);

// RENDER LOOP

function render(time)
{   
    v.updateTime(time);
    renderer.render(scene,camera);
    requestAnimationFrame ( render );
}

requestAnimationFrame ( render );

}

main();




