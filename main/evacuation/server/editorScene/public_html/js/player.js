/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function Player() {
    var Direction = {
        forward: 1,
        backward: 2
    };

    Player.StopReason = {
        VideoHasFinished: 1,
        VideoIsLoading: 2,
        UserRequest: 3,
        LoadingInformation: 4,
    };

    var _verbose = true,
        _connection = new WebSocket("ws://localhost:8090"),
        _assyncParser = new Worker("../js/playerWebWorker");
        _blockFrames = {},
        _blocksInformation = {},
        _blocksSeekings = [],
        _blocksSeekingInformation = [],
        _blocksIds = [],
        _blocksIdsInformation = [],
        _currentFrame = -1,
        _currentPedestrianID = -1,
        _totalLengthBlocks = 0,
        _totalFrameByBlock = 100,
        _direction = Direction.forward,
        _animationID = null,
        here = this,
        _speed = 1;

    _connection.onerror = function() {
        var str = "",
        name = "",
        indice = 0;
        for (indice = 0; indice < arguments.length; indice++) {
            for(name in arguments[indice]) {
                str = name+":"+arguments[indice][name]+"\n";
            }
        }
        console.log(str);
    }
    _assyncParser.onmessage = function _messageWorker(msg) {
        var parsedMessage = msg.data;
        if(parsedMessage.action === "getFrame") {
            _processFrame(parsedMessage);
        } else if(parsedMessage.action === "getInformation") {
            _processInformation(parsedMessage);
        } else if(parsedMessage.action === "open") {
            _processOpen(parsedMessage);
        } else if(parsedMessage.action === "outOfRange") {
            _processOutOfRange(parsedMessage);
        }
    }

    _connection.onmessage = function _message(msg) {
        _assyncParser.postMessage(msg.data);
    };

    _connection.onopen = function (event) {
        here.isOpen = true;
        if (here.onconnected !== null) {
            here.onconnected();
        }
    };

    here.isOpened = false;
    here.firstLoad = true;
    here.hasFinished = true;
    here.hasStopped = true;
    here.isWaitingNextBlock = true;
    here.stopReason = Player.StopReason.UserRequest;

    Object.defineProperty(here, "Speed", {
        get: function() {
            return parseInt(_speed);
        },
        set: function(value) {
            value = Math.abs(parseInt(value));
            _speed = (value == 0 || !(value === value)) ? 1 : value;
        }
    });

    Object.defineProperty(here, "CurrentPedestrianID", {
        get: function() {
            return parseInt(_currentPedestrianID);
        },
        set: function(value) {
            var index = 0;
            value = Math.abs(parseInt(value));
            value = (value === 0 || !(value === value) || value === null || value === parseInt(null)) ? -1 : value;
            _currentPedestrianID = parseInt(_currentPedestrianID);

            if(value !== _currentPedestrianID) {
                _currentPedestrianID = value;
                if(_currentPedestrianID >= 0) {
                    here.stopReason = Player.StopReason.LoadingInformation;

                    if(here.onstopped !== null) {
                        here.onstopped();
                    }

                    for(index = 0; index < _blocksIds.length; index++ ) {
                        if(!_hasBlockInformation(_blocksIds[index],_currentPedestrianID)) {
                            _seekNewBlockInformation(_blocksIds[index],_currentPedestrianID);
                        }
                    }
                }
            }
        }
    });

    Object.defineProperty(here, "IsInformationAvailable", {
        get: function() {
            return _isInformationAvailable();
        }
    });


    //events
    here.onconnected = null;
    here.onanimationframe = null;
    here.onblockreceived = null;
    here.onblockinformationreceived = null;
    here.onloadfile = null;
    here.onclose = null;
    here.beforecontinue = null;
    here.onstopped = null;

    //public methods...
    here.play = _play;
    here.next = _next;
    here.playBack = _playBack
    here.previous = _previous;
    here.stop = _stop;
    here.getCurrentFrame = _getCurrentFrame;
    here.getCurrentInformation = _getCurrentInformation;
    here.open = _open;
    //here.isInformationAvailable = _isInformationAvailable;

    function _play() {
        if((!here.hasStopped)&&(_direction !== Direction.forward)) {
            here.stop();
        }

        if (here.hasStopped) {
            here.hasStopped = false;
            _direction = Direction.forward;
            _animationID = requestAnimationFrame(_playForward);
        }
    }

    function _next() {
        if(here.hasStopped) {
            var frame = _getNextFrame();

            if(here.onanimationframe !== null) {
                if(isDefined(frame)) {
                    here.onanimationframe(frame);
                } else {
                    _verbose && console.log("Erro com frame repassado por função _getNextFrame");
                }
            }
        }
    }

    function _playBack() {
        if((!here.hasStopped)&&(_direction !== Direction.backward)) {
            here.stop();
        }

        if(here.hasStopped) {
            here.hasStopped = false;
            _direction = Direction.backward;
            _animationID = requestAnimationFrame(_playBackward);
        }
    }

    function _previous() {
        if(here.hasStopped) {
            var frame = _getPreviousFrame();

            if(here.onanimationframe !== null) {
                if(isDefined(frame)) {
                    here.onanimationframe(frame);
                } else {
                    _verbose && console.log("Erro com frame repassado por função _getPreviousFrame");
                }
            }
        }
    }

    function _stop(stopReason) {
        if((arguments.length === 1) && (typeof(stopReason) === "number") && (stopReason >= 1) && (stopReason <= 3)) {
           here.stopReason = stopReason;
        } else {
            here.stopReason = Player.StopReason.UserRequest;
        }
        here.hasStopped = true;
        cancelAnimationFrame(_animationID);
        _animationID = null;
    }

    function _open(file) {
        if(here.isOpen) {
            _connection.send(JSON.stringify({action:"open",fileName:file}));
        } else {

        }
    }

    function _isInformationAvailable() {
        var currentBlock = _getCurrentBlock();
        return ((_currentPedestrianID >= 0)&&(_blocksInformation.hasOwnProperty(currentBlock))&&(_blocksInformation[currentBlock].hasOwnProperty(_currentPedestrianID)));
    }

    function _processFrame(message) {
        _verbose && console.log("Trying load block:"+message.id);
        _removeFromSeeking(message.id);
        _addBlockFrame(message.id, message.data);
        _verbose && console.log("Loaded block:"+message.id);
        _checkWaiting();
        if (here.onblockreceived !== null) {
            here.onblockreceived(message);
        }
    }

    function _processInformation(message) {
        _removeFromSeekingInformation(message.idBlock,message.idInformation);
        _addBlockInformation(message.idBlock, message.idInformation, message.data);

        if (here.onblockinformationreceived !== null) {
            here.onblockinformationreceived(message);
        }
    }

    function _processOpen(message) {
        _totalLengthBlocks = message.totalLength;
        _checkCache();
        here.hasFinished = false;
        if (here.onloadfile !== null) {
            here.onloadfile(message.data);
        }
    }

    function _processOutOfRange(message) {
        _verbose && console.log("Out of range seek in the video:"+here.videoName);
    }

    function _removeFromSeeking(id) {
        var index = _blocksSeekings.indexOf(id);
        if(index >= 0) {
            _blocksSeekings.splice(index,1);
        }
    }

    function _removeFromSeekingInformation(idBlock,idPedestrian) {
        var index = _blocksSeekings.reduce(function(prev,actu, index){
            if(typeof(prev) === "number") {
                return prev;
            } else {
                if((prev.idBlock === actu.idBlock) && (prev.idPedestrian === actu.idPedestrian)) {
                    return index;
                }
            }
        },{idBlock:idBlock, idPedestrian:idPedestrian});
        if(typeof(index) === "number") {
            _blocksSeekings.splice(index,1);
        }
    }

    function _addSeeking(id) {
        _blocksSeekings.push(id);
    }

    function _addSeekingInformation(idBlock, idPedestrian) {
      _blocksSeekingInformation.push({idBlock:idBlock,
                            idPedestrian:idPedestrian});
    }

    function _addBlockFrame(id,frames) {
        _blockFrames[id] = frames;
        _blocksIds.push(id);
    }

    function _addBlockInformation(idBlock,idPedestrian,information) {
        _verbose && console.log("The pedestrian("+idPedestrian+") and block("+idBlock+") has been added.");
        if(!_blocksInformation.hasOwnProperty(idBlock)) {
            _blocksInformation[idBlock] = {};
        }
        _blocksInformation[idBlock][idPedestrian] = information;
        _blocksIdsInformation.push({idBlock:idBlock,
                                    idPedestrian:idPedestrian});

    }

    function _removeBlockFrame(id) {
        var index = _blocksIds.indexOf(id);
        if( index >= 0) {
            _blocksIds.splice(index,1);
            delete _blockFrames[id];
            delete _blocksInformation[id];
        }
    }

    function _checkCache() {
        var currentBlock = _getCurrentBlock(),
            cacheLength = Math.floor(0.3*_speed )+2,
            cutIndexPrevious = currentBlock + cacheLength,
            cutIndexNext = currentBlock - cacheLength,
            indice = 0,
            toRemove = [];
        _blocksIds.sort();

        if(_direction === Direction.backward) {
            for(indice = 1; indice <= cacheLength; indice++) {
                if ((!_hasBlock(currentBlock-indice)) && (!_isSeekingBlock(currentBlock-indice))) {
                    _seekNewBlock(currentBlock-indice);
                }
            }

            toRemove = _blocksIds.filter(function (x) {
                return x > cutIndexPrevious;
            });

            _blocksIds = _blocksIds.filter(function (x) {
                return x <= cutIndexPrevious;
            });


        } else if(_direction === Direction.forward) {
            for(indice = 1; indice <= cacheLength; indice++) {
                if ((!_hasBlock(currentBlock+indice)) && (!_isSeekingBlock(currentBlock+indice))) {
                    _seekNewBlock(currentBlock+indice);
                }
            }

            toRemove = _blocksIds.filter(function(x) {
                return x < cutIndexNext;
            });

            _blocksIds = _blocksIds.filter(function (x) {
                return x >= cutIndexNext;
            });

        }
        for(indice = 0; indice < toRemove.length; indice++) {
            delete _blockFrames[toRemove[indice]];
        }

    }

    function _checkWaiting() {
        var block = _getCurrentBlock();
        if((here.isWaitingNextBlock)&&(!here.hasFinished)) {
            if(here.stopReason === Player.StopReason.VideoIsLoading) {
                if(_hasBlock(block)) {
                    if(_direction === Direction.forward) {
                        here.play();
                    } else if(_direction === Direction.backward) {
                        here.playBack();
                    }

                    if(here.beforecontinue !== null) {
                        here.beforecontinue();
                    }
                }
            }
        }
    }

    function _seekNewBlock(idBlock) {
        if ((!_hasBlock(idBlock)) && (!_isSeekingBlock(idBlock)) && idBlock >= 0 && idBlock <= _totalLengthBlocks) {
            _addSeeking(idBlock);
            _connection.send(JSON.stringify({action:"getFrame",idBlock:idBlock}));
            _seekNewBlockInformation(idBlock,_currentPedestrianID);
        }
    }
    function _seekNewBlockInformation(idBlock,idPedestrian) {
        if(idPedestrian > 0) {
            if ((!_hasBlockInformation(idBlock,idPedestrian)) && (!_isSeekingBlockInformation(idBlock,idPedestrian)) && idBlock >= 0 && idBlock <= _totalLengthBlocks) {
                _verbose && console.log("trying do get information pedestrian("+idPedestrian+") and block("+idBlock+")");
                _connection.send(JSON.stringify({action:"getInformation",idBlock:idBlock,idPedestrian:idPedestrian}));
            }
        }
    }

    function _isSeekingBlock(idBlock) {
        return (_blocksSeekings.indexOf(idBlock) >= 0);
    }

    function _isSeekingBlockInformation(idBlock,idPedestrian) {
        return _blocksSeekings.some(function(test) {
            return ((this.idBlock === test.idBlock) && (this.idPedestrian === test.idPedestrian));
        },{idBlock:idBlock, idPedestrian:idPedestrian});
    }

    function _hasBlock(idBlock) {
        return isDefinedInObject.call(_blockFrames,idBlock);
    }

    function _hasBlockInformation(idBlock,idPedestrian) {
        return (isDefinedInObject.call(_blocksInformation,idBlock) && (isDefinedInObject.call(_blocksInformation[idBlock],idPedestrian)));
    }

    function _getCurrentBlock() {
        if(_currentFrame < 0) {
            return -1;
        } else {
            return ((_currentFrame - _getCurrentFrameInBlock()) / _totalFrameByBlock);
        }
    }

    function _getCurrentFrameInBlock() {
        if(_currentFrame < 0) {
            return -1;
        } else {
            return _currentFrame % _totalFrameByBlock;
        }

    }
    function _finishVideo() {
        here.hasFinished = true;
        here.stop(Player.StopReason.VideoHasFinished);
        if (here.onstopped !== null) {
            here.onstopped(Player.StopReason.VideoHasFinished);
        }
    }
    function _getNextFrame()  {
        if ((_getCurrentBlock()+1) === _totalLengthBlocks && (_getCurrentFrameInBlock()+_speed) >= _totalFrameByBlock) {
            _finishVideo();
            _currentFrame = _totalLengthBlocks*_totalFrameByBlock;
        } else if (_getCurrentBlock() < _totalLengthBlocks) {
            _currentFrame += _speed;
        }
        _checkCache(Direction.forward);
        return here.getCurrentFrame();
    }

    function _getPreviousFrame() {
       if(_getCurrentBlock() === 0 && (_getCurrentFrameInBlock()-_speed) < 0) {
            _finishVideo();
            _currentFrame = -1;
        } else if (_getCurrentBlock() >= 0) {
            _currentFrame -= _speed;
        }
        _checkCache(Direction.backward);
        return here.getCurrentFrame();
    }

    function _getCurrentFrame() {
        var blockID = _getCurrentBlock(),
            block = null,
            frameIndex = _getCurrentFrameInBlock(),
            frame = null;

        if((_isSeekingBlock(blockID))&&(!here.hasFinished)) {
            here.stop(Player.StopReason.VideoIsLoading);
            if (here.onstopped !== null) {
                here.onstopped(Player.StopReason.VideoIsLoading);
            }
            _verbose && console.log("Block("+blockID+") is still seeking.");
            return null;
        } else if(!_hasBlock(blockID)){
            _verbose && console.log("Block("+blockID+") is not in the cache.");
        } else if(!isDefined(block = _blockFrames[blockID])) {
            _verbose && console.log("Block("+blockID+") is in the cache but it's value is undefined.");
        } else if(!isDefinedInObject.call(block,frameIndex)) {
            _verbose && console.log("frame number("+frameIndex+") is not in the block.");
        } else if(!isDefined(frame = block[frameIndex])) {
            _verbose && console.log("frame number("+frameIndex+") is in the block, but it's value is undefined.");
        } else {
            return frame;
        }
        here.stop();
        return null;
    }

    function _getCurrentInformation() {
        var blockID = _getCurrentBlock(),
            block = null,
            informationIndex = _getCurrentFrameInBlock(),
            information = null;

        if((_isSeekingBlockInformation(blockID,_currentPedestrianID))&&(!here.hasFinished)) {
            here.stop(Player.StopReason.VideoIsLoading);
            if (here.onstopped !== null) {
                here.onstopped(Player.StopReason.VideoIsLoading);
            }
            _verbose && console.log("Block information("+blockID+") and pedestrian("+_currentPedestrianID+") is still seeking.");
            return null;
        } else if(!_hasBlockInformation(blockID,_currentPedestrianID)){
            _verbose && console.log("Block information("+blockID+") and pedestrian("+_currentPedestrianID+") is not in the cache.");
        } else if(!isDefined(block = _blocksInformation[blockID][_currentPedestrianID])) {
            _verbose && console.log("Block information("+blockID+") and pedestrian("+_currentPedestrianID+") is in the cache but it's value is undefined.");
        } else if(!isDefinedInObject.call(block,informationIndex)) {
            _verbose && console.log("Information frame("+informationIndex+") is not in the block information.");
        } else if(!isDefined(information = block[informationIndex])) {
            _verbose && console.log("Information frame("+informationIndex+") is in the block, but it's value is undefined.");
        } else {
            return information;
        }
        here.stop();
        return null;
    }

    function _playForward() {
        var frame = _getNextFrame();

        if(here.onanimationframe !== null) {
            if(isDefined(frame)) {
                here.onanimationframe(frame);
            } else {
                _verbose && console.log("Erro com frame repassado por função _getNextFrame");
            }
        }
        if(!here.hasStopped) {
            _animationID = requestAnimationFrame(_playForward);
        }
    }

    function _playBackward() {
        var frame = _getPreviousFrame();
        if(here.onanimationframe !== null) {
            if(isDefined(frame)) {
                here.onanimationframe(frame);
            } else {
                _verbose && console.log("Erro com frame repassado por função _getPreviousFrame");
            }
        }
        if(!here.hasStopped) {
            _animationID = requestAnimationFrame(_playBackward);
        }
    }

}



function isDefinedInObject(name) {
    return (this.hasOwnProperty(name) || ((this instanceof Array) && (parseInt(name) == parseInt(name)) && (this.length < name)))
}
function isDefined(val) {
    return ((typeof(val) !== "undefined")&&(val !== null));
}
