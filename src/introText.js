import * as THREE from 'three'
import { Text } from 'troika-three-text'
import {setup} from "./setup"

import vertShader from "./shaders/intro/text/vertShader.glsl"
import fragShader from "./shaders/intro/text/fragShader.glsl"

import {gsap} from "gsap"
import {visualMesh} from "./introVisual" 

var { scene } = setup;

// "•"
var textContent = "Will Nutter • Creative Developer \n Javascript • GLSL • THREE.js"
textContent = "I create visuals\n and imagine experiences\n you can interact with"
//textContent = "We build fun products that bring people together";

var text = TextObj(textContent,0.3,5);
text.position.set(0,1,0);

scene.add(text);

function TextObj(inputText, fontSize = 0.5, maxWidth){
    var text = new Text();

    var fonts = {
        Rbold: "./fonts/Roboto-Bold.ttf",
        Rblack: "./fonts/Roboto-Black.ttf",
        BCsb: "./fonts/BarlowCondensed-SemiBold.ttf",
        S: "./fonts/sequel.ttf"
    }

    text.text = inputText;
    text.fontSize = fontSize;
    text.anchorX = "center";
    text.anchorY = "50%";
    text.color = 0xffffff;
    text.textAlign = "center";
    text.maxWidth = maxWidth;
    text.font = fonts["S"];

    var shaderMaterial = new THREE.ShaderMaterial({
        uniforms: {
            iTime: {value: 0},
            transition: {value: 0.},
        },
        vertexShader: vertShader,
        fragmentShader: fragShader,
        // transparent: true
    });

    text.material = shaderMaterial;

    text.sync(()=>{
        var duration = 2.;
        gsap.to(text.material.uniforms.transition, { value: 1, duration: duration, onComplete: visualMesh.setProgress, ease: "power2.out" });
        gsap.to(visualMesh.material.uniforms.transition, { value: 1, duration: duration, ease: "power2.out" });

    });


    return text;
}

export {text};

// function TextObj(
//     inputText, maxWidth, fontSize = 0.1,
//     align = "right", anchorX = "right", anchorY = "50%",
//     font = "times", letterSpacing = 0, outlineWidth = 0, lineHeight = "normal") {
//     var fonts = {
//         times: "./fonts/timesbd.ttf",
//         arialb: "./fonts/arialbd.ttf",
//         arialbi: "./fonts/arialbi.ttf",
//         ariali: "./fonts/ariali.ttf",
//         arial: "./fonts/arial.ttf",
//     }

//     var text = new Text();

//     text.text = inputText;
//     text.fontSize = fontSize;
//     text.letterSpacing = letterSpacing;
//     text.maxWidth = maxWidth;
//     text.textAlign = align;
//     text.anchorX = anchorX;
//     text.anchorY = anchorY;
//     text.lineHeight = lineHeight;
//     text.position.z = -4;
//     text.depthOffset = -0.1;
//     text.font = fonts[font];
//     text.outlineWidth = outlineWidth;
//     // text.strokeWidth = .53;
//     // text.strokeColor = 0x000000;
//     text.color = 0x000000;
//     // text.position.x = -maxWidth;

//     // console.log("maxWidth",maxWidth, text);
//     text.sync();

//     return text;

// }