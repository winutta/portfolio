import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'



export class Setup {
    constructor(){

        
        // DISABLE RIGHT CLICK

        document.addEventListener('contextmenu', event => event.preventDefault(), false);

        // SCENE SETUP

        var scene = new THREE.Scene();
        scene.background = new THREE.Color(0x000000);

        // CAMERA SETUP

        var camera = new THREE.PerspectiveCamera(39, window.innerWidth / window.innerHeight, 0.25, 2000);
        camera.position.set(0,0,8);

        // RENDERER SETUP
        var targetCanvas = document.querySelector(".webgl");
        var renderer = new THREE.WebGLRenderer({canvas: targetCanvas,antialias: true});

        renderer.setPixelRatio( window.devicePixelRatio );
        renderer.setSize( window.innerWidth, window.innerHeight );

        // MOUSE SETUP

        var mouse = new THREE.Vector2();

        // CLOCK SETUP 

        var clock = new THREE.Clock();

        //ORBIT CONTROL SETUP

        // const controls = new OrbitControls(camera, renderer.domElement);
        // controls.update();

        // Add to instance

        this.scene = scene;
        this.camera = camera;
        this.renderer = renderer;
        this.mouse = mouse;
        this.clock = clock;

        // RESIZE

        window.addEventListener('resize', onWindowResize, false);

        function onWindowResize() {
            var width = window.innerWidth;
            var height = window.innerHeight;
            camera.aspect = width / height;
            camera.updateProjectionMatrix();
            renderer.setSize(width, height);
        }
    }
    
}

var setup = new Setup();

function getWorldDimensions(depth = 8){
    var vFOVC = setup.camera.fov * Math.PI / 180;
    var h = 2 * Math.tan(vFOVC / 2) * (depth);
    var w = h * setup.camera.aspect;
    return {w:w,h:h};
}

export {setup, getWorldDimensions}











