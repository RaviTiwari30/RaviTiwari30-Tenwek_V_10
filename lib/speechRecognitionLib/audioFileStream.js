class audioFileStream {

  context = null;
  constructor(options) {
    this.bufferSize = 256;
    this.autoStart = false;
    this.sampleRate = 44100;

    if (options != null && options.bufferSize != null) {
      this.bufferSize = options.bufferSize
    }

    if (options != null && options.onAudioStart != null) {
      this.onAudioStart = options.onAudioStart
    }

    if (options != null && options.onAudioEnd != null) {
      this.onAudioEnd = options.onAudioEnd;
    }

    if (options != null && options.autoStart != null) {
      this.autoStart = options.autoStart;
    }

  }


  init = (audioFile) => {
    const promise = new Promise(function (resolve, reject) {
      const AudioContext = window.AudioContext || window.webkitAudioContext;
      this.context = new AudioContext();

      var recorder = this.context.createScriptProcessor(512, 1, 1);
      recorder.onaudioprocess = this.processAudioData;
      const reader = new FileReader();
      reader.onloadend = (event) => {
        console.log('event', event);
        let int16Data = new Int16Array(event.target.result);
        console.log('int16Data', int16Data);
        var buffer = this.convertInt16ToFloat32(int16Data);
        console.log('buffer', buffer);
        let audioBuffer = this.context.createBuffer(1, buffer.length, this.context.sampleRate);
        audioBuffer.getChannelData(0).set(buffer);
        console.log('audioBUffer', audioBuffer);
        let source = this.context.createBufferSource();
        source.buffer = audioBuffer;
        source.connect(recorder);
        recorder.connect(this.context.destination);
        this.sampleRate = this.context.sampleRate;
        if (!this.autoStart) {
          //this.context.suspend();
        }


        // console.log(array);
        // this.context.decodeAudioData(event.target.result, function (buffer) {
        //   console.log(buffer);
        //   source.buffer = buffer;
        //   source.connect(recorder);
        //   recorder.connect(this.context.destination);
        //   this.sampleRate = this.context.sampleRate;
        //   if (!this.autoStart) {
        //     //  this.context.suspend();
        //   }
        console.log('Audio File  Details', audioFile);
        resolve("Stuff worked!");
        // }.bind(this), (error) => { console.log('Error Decoding Data', error) });
      };
      reader.readAsArrayBuffer(audioFile);

      reader.onerror = () => {
        reject(Error("It broke"));
      }

    }.bind(this));
    console.log(this);
    return promise;
  }

  handleError = (error) => {
    if (this.context != null)
      this.context.close();
    this.onError(error);
  }

  onError = (error) => {
    console.log(error);
  }

  processAudioData = (data) => {
    //Getting data from only one channel
    //console.log(data);
    const left = data.inputBuffer.getChannelData(0);
    console.log(left);
    //Converting to 16bit PCM
    const pcmData = this.convertFloat32ToInt16(left);
    this.onData(pcmData);
  }

  /**
   * Will suspend the stream. Callback onAudioEnd will be called.
   */
  stop = () => {
    if (this.context != null) {
      this.context.suspend();
      this.onAudioEnd();
    } else {
      this.onError({ code: 100, message: 'Mic not yet initalized' });
    }

  }
  /**
   * Will Start the stream. Callback onAudioStart will be called.
   */
  start = () => {
    if (this.context != null) {
      this.context.resume();
      this.onAudioStart();
    } else {
      this.onError({ code: 100, message: 'Data not yet initalized' });
    }

  }

  /**
   * Will close the stream. We need to reinitalize the object to reuse it.
   */
  close = () => {
    this.context.close();
  }


  onAudioStart = () => {
  }

  onAudioEnd = () => {
  }

  /*
  * It is expected to be overwitten.
  */
  onData = (input) => {
    // console.log(input);

  }

  /*
  *
  */
  convertFloat32ToInt16 = (input) => {
    var output = new DataView(new ArrayBuffer(input.length * 2)); // length is in bytes (8-bit), so *2 to get 16-bit length
    for (var i = 0; i < input.length; i++) {
      var multiplier = input[i] < 0 ? 0x8000 : 0x7fff; // 16-bit signed range is -32768 to 32767
      output.setInt16(i * 2, (input[i] * multiplier) | 0, true); // index, value, little edian
    }
    return Buffer.from(output.buffer);
  }
  convertInt16ToFloat32 = (data) => {
    var result = new Float32Array(data.length);
    data.forEach(function (sample, i) {
      //				result[i] = sample < 0 ? sample / 0x80 : sample / 0x7F;
      result[i] = sample / 32768;
    });
    return result;
  }
}

export default audioFileStream;