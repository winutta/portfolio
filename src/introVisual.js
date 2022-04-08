import * as THREE from 'three'
import {setup} from "./setup"

import vertShader from "./shaders/intro/visual/vertShader.glsl"
import fragShader from "./shaders/intro/visual/fragShader.glsl"

import {gsap} from "gsap"

import { speedController } from './speedController'
import { exitIntro } from './introExit'

var shaderGeometry = new THREE.PlaneGeometry(1,1,10,10);
var shaderMaterial = new THREE.ShaderMaterial({
    uniforms: {
        rTime: {value: 0},
        iTime: {value: 0},
        iSpeed: {value: 1.},
        maxSpeed: {value: speedController.maxSpeed},
        minSpeed: {value: speedController.minSpeed},
        transition: {value: 0},
        exit: {value: 0},
        ready: {value: 0},
    },
    vertexShader: vertShader,
    fragmentShader: fragShader,
    // transparent: true
});
var shaderMesh = new THREE.Mesh(shaderGeometry, shaderMaterial);

shaderMesh.progressSpeed = 0.;
shaderMesh.setProgress = function(){
    gsap.to(shaderMesh, { progressSpeed: 1, duration: 2, onComplete: speedController.scheduleUpdate, onCompleteParams: [speedController]  });
    gsap.to(shaderMaterial.uniforms.ready, {value: 1, duration: 2.})
    // setTimeout(exitIntro,13000);
    // gsap.to(speedController, {speed: 3, duration: 2});
}

var y = -1.75;
y = -1.;
shaderMesh.position.set(0,y,0);
var scale = 2.5;
shaderMesh.scale.set(scale,scale,1);

var {scene,clock} = setup;

scene.add(shaderMesh);

var updateTime = function(time){
    var delta = clock.getDelta();

    shaderMaterial.uniforms.iTime.value += delta * shaderMesh.progressSpeed * speedController.speed;
    shaderMaterial.uniforms.iSpeed.value = speedController.speed;
    // console.log(speedController.speed)

    

    time *= 0.001;
    shaderMaterial.uniforms.rTime.value = time;

    // shaderMaterial.uniforms.iTime.value = time;

}




export {shaderMesh as visualMesh, updateTime};