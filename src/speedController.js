import { exitIntro } from "./introExit";

class SpeedController{
    constructor(){
        this.speed = 1.;
        this.acceleration = -0.05;
        this.accelVal = 0.05;
        this.decelVal = -0.1;
        // this.jerk = 0.005;
        this.maxSpeed = 15.;
        this.minSpeed = 1.;
        this.exited = false;

        document.addEventListener("mousedown",this);
        document.addEventListener("mouseup",this);
        // this.scheduleUpdate();
    }

    

    updateSpeed(ctx) {
        // console.log("updating speed", ctx.speed);
        ctx.speed += ctx.acceleration;

        if (ctx.speed < ctx.minSpeed) { ctx.speed = ctx.minSpeed}
        if (ctx.speed > ctx.maxSpeed) {
            ctx.speed = ctx.maxSpeed;
            if (!ctx.exited) {
                ctx.exited = true;
                setTimeout(exitIntro,2000);
                clearInterval(ctx.speedUpdater);
            }

        }

    }

    test(){
        console.log("testing");
    }

    scheduleUpdate(ctx){
        console.log(ctx);
        ctx.speedUpdater =  setInterval(ctx.updateSpeed,1000/20,ctx);
    }

    // Want to use mousedown and mouseup as well as touchstart and touchend to tell when accelerating or decelerating
    updateAcceleration(mouseDown){
        if(mouseDown){
            this.acceleration = this.accelVal;    
        } else{
            this.acceleration = this.decelVal;
        }
        console.log(this.acceleration);
    }

    mouseDownEvent(e){
        console.log("mouse down");
        var mouseDown = true;
        this.updateAcceleration(mouseDown);
    }

    mouseUpEvent(e){
        console.log("mouse up");
        var mouseDown = false;
        this.updateAcceleration(mouseDown);
    }

    handleEvent(e) {
        switch(e.type){
            case "mousedown":
                this.mouseDownEvent(e);
                break;
            case "mouseup":
                this.mouseUpEvent(e);
                break;
        }
    }


};

var speedController = new SpeedController();

export {speedController};

