let cfg = {
    rotLimit: [-90,90],
    targetRot: Math.random()*180-90,
    targetClose: 4,
    limitTargetDist: 45,
    rotLockpick: 0,
    rotLock: 0,
    mouseBuffer: 0,
    mouseControl: 4,
    loopRate: 25,
    lockSpeed: 3,
    lockpickDecr: 20,
    lockpickDur: 200,
    decrInterval: 150,
    pushing: false,
    pauseGame: false,
    endGame: false,
    lockpickObj:"",
    lockObj:"",
    sdrObj:"",
    intervalObj:null,
    lockpickDecrTime:null
};

$(function(){
    $(document).ready(() => {
        $(document).on("mousemove",function(e){
            if (cfg.mouseBuffer && !cfg.pushing && !cfg.endGame && !cfg.pauseGame){
                var deltaR = (e.clientX-cfg.mouseBuffer)/cfg.mouseControl;
                cfg.rotLockpick += deltaR;
                cfg.rotLockpick = clamp(cfg.rotLockpick,cfg.rotLimit[1],cfg.rotLimit[0]);
                cfg.lockpickObj.css({
                    transform: "rotateZ("+cfg.rotLockpick+"deg)",
                });
            }
            cfg.mouseBuffer = e.clientX;
        });
        $(document).on('mouseleave',function(e){
            cfg.mouseBuffer = 0;
        });
        $(document).on('keydown',function(e){
            if (!cfg.pushing && !cfg.pauseGame && !cfg.endGame && e.keyCode == 32){
                var targetDist,lockClose;
                clearInterval(cfg.intervalObj);
                cfg.pushing = true;
                targetDist = Math.abs(cfg.rotLockpick-cfg.targetRot)-cfg.targetClose;
                targetDist = clamp(targetDist,cfg.limitTargetDist,0);
                lockClose = rangeHandler(targetDist,0,cfg.limitTargetDist,1,0.02);
                lockClose = lockClose*cfg.rotLimit[1];
                cfg.intervalObj = setInterval(()=>{
                    cfg.rotLock+=cfg.lockSpeed;
                    if (cfg.rotLock >= cfg.rotLimit[1]){
                        clearInterval(cfg.intervalObj);
                        cfg.endGame = true;
                        $('#wrap').fadeOut(400);
                        $.post('https://lockpicking/success');
                    } else if (cfg.rotLock >= lockClose){
                        cfg.rotLock = lockClose;
                        if (!cfg.lockpickDecrTime || Date.now() > cfg.lockpickDecrTime + cfg.decrInterval){
                            cfg.lockpickDur-=cfg.lockpickDecr;
                            cfg.lockpickDecrTime = Date.now();
                            if (cfg.lockpickDur <= 0){
                                cfg.endGame = true;
                                var tl = new TimelineLite();
                                var top = $(".top");
                                var bot = $(".bot");
                                tl.to(top,0.7,{
                                    rotationZ: -400,
                                    x: -200,
                                    y: -100,
                                    opacity:0
                                });
                                tl.to(bot,0.7,{
                                    rotationZ: 400,
                                    x: 200,
                                    y: 100,
                                    opacity: 0,
                                    onComplete: () => {
                                        $('#wrap').fadeOut(200);
                                        $.post('https://lockpicking/fail');
                                    }
                                });
                            }
                        }
                    }
                    cfg.lockObj.css({
                        transform: 'rotateZ(' + cfg.rotLock + 'deg)'
                    });
                    cfg.sdrObj.css({
                        transform: 'rotateZ(' + cfg.rotLock + 'deg)'
                    });
                },cfg.loopRate);
            }
        });
        $(document).on('keyup',function(e){
            if (cfg.pushing && e.keyCode == 32){
                cfg.pushing = false;
                clearInterval(cfg.intervalObj);
                cfg.intervalObj = setInterval(()=>{
                    cfg.rotLock -= cfg.lockSpeed;
                    cfg.rotLock = Math.max(cfg.rotLock,0);
                    cfg.lockObj.css({
                        transform: "rotateZ("+cfg.rotLock+"deg)"
                    });
                    cfg.sdrObj.css({
                        transform: "rotateZ("+cfg.rotLock+"deg)"
                    });
                    if (cfg.rotLock <= 0){
                        cfg.rotLock = 0;
                        clearInterval(cfg.intervalObj);
                    }
                },cfg.loopRate);
            };
            if (e.keyCode == 27){
                $("#wrap").fadeOut();
                cfg.pauseGame = true;
                $.post('https://lockpicking/cancel');
            };
        });
    });
});

function clamp(v,max,min){
    return Math.min(Math.max(v,min),max);
}

function rangeHandler(last,lastMin,lastMax,currentMin,currentMax){
    return ((last-lastMin)*(currentMax-currentMin))/(lastMax-lastMin)+currentMin;
}

window.addEventListener('message',function(e){
    if (e.data.start) {
        $('#wrap').show();
        clearInterval(cfg.intervalObj);
        cfg = {
            rotLimit: [-90,90],
            targetRot: Math.random()*180-90,
            targetClose: 4,
            limitTargetDist: 45,
            rotLockpick: 0,
            rotLock: 0,
            mouseBuffer: 0,
            mouseControl: 4,
            loopRate: 25,
            lockSpeed: 3,
            lockpickDecr: 20,
            lockpickDur: 200,
            decrInterval: 150,
            pushing: false,
            pauseGame: false,
            endGame: false,
            intervalObj:null,
            lockpickDecrTime:null,
            lockpickObj: $("#lockpick"),
            lockObj: $("#lock"),
            sdrObj: $("#screwdriver")
        };
        cfg.lockpickObj.css({
            transform: "rotateZ("+cfg.rotLockpick+"deg)"
        });
        cfg.lockObj.css({
            transform: "rotateZ("+cfg.rotLock+"deg)"
        });
        cfg.sdrObj.css({
            transform: "rotateZ("+cfg.rotLock+"deg)"
        });
        TweenLite.to($(".top"),0,{
            rotationZ: 0,
            x: 0,
            y:0,
            opacity: 1
        });
        TweenLite.to($(".bot"),0,{
            rotationZ: 0,
            x: 0,
            y:0,
            opacity: 1
        });
    }
});