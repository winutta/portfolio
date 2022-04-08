import { visualMesh } from "./introVisual";
import { text } from "./introText"

import {gsap} from "gsap"

document.addEventListener("keydown", keyDownHandler);

function keyDownHandler(e){
    if(e.keyCode === 32 ){
        exitIntro()
    }
}

// Make the easing nicer, plus animate the fading to black

function exitIntro(){

    
    // gsap.to(text.position, { y: text.position.y + 6.,duration: 4}); 
    // gsap.to(visualMesh.position, { y: visualMesh.position.y + 6., duration: 4 }).delay(.1);  
    var duration = 2.;
    gsap.to(text.material.uniforms.exit, { value: 1, duration: duration, ease: "power2.out" });
    gsap.to(visualMesh.material.uniforms.exit, { value: 1, duration: duration, ease: "power2.out" });

}

export {exitIntro};