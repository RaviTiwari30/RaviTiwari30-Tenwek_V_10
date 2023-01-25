import EventEmitter from 'event-emitter';
class MicStream extends EventEmitter {

  status = 'stopped';
  constructor(options = {}) {
    super();
    //this.bufferSize = 256;
    this.autoStart = false;
    this.sampleRate = 44100;
    this.i = 0;

    if (options.bufferSize != null) {
      this.bufferSize = options.bufferSize
    }
    if (this.bufferSize == null) {
      this.bufferSize = 0;
    }
    if (options.autoStart != null) {
      this.autoStart = options.autoStart;
    }

    this.context = null;
    this.init();
  }

  init = () => {
    navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;
    navigator.mediaDevices.getUserMedia({ audio: { sampleSize: 16 }, video: false }).then((mediaStream) => {
      const AudioContext = window.AudioContext || window.webkitAudioContext;
      this.context = new AudioContext();
      var audioInput = this.context.createMediaStreamSource(mediaStream);
      var recorder = this.context.createScriptProcessor(this.bufferSize, 1, 1);
      recorder.onaudioprocess = this.processAudioData;
      audioInput.connect(recorder);
      recorder.connect(this.context.destination);
      this.sampleRate = this.context.sampleRate;
      console.log('SampleRate of Mic', this.sampleRate);

      this.context.onstatechange = () => {
        console.log('Mic State Changed ' + this.context.state);
        if (this.context.state === 'running') {
          this.emit('running');
          this.status = 'running';
        }
        if (this.context.state === 'suspended') {
          this.emit('stopped');
          this.status = 'stopped';
        }
        if (this.context.state === 'closed') {
          this.emit('closed');
          this.status = 'closed';
        }
      }

      if (!this.autoStart) {
        this.context.suspend();
      }
      this.emit('opened');
    }).catch((error) => {
      if (this.context != null)
        this.context.close();
      this.emit('error', error);
    });
  }

  processAudioData = (data) => {
    //Getting data from only one channel
    //Converting to 16bit PCM
    const left = data.inputBuffer.getChannelData(0);

    //const pcmData = this.convertFloat32ToInt16(left);
    //this.emit('data', pcmData);
    this.emit('data', left);
  }

  /**
   * Will suspend the stream. Callback onAudioEnd will be called.
   */
  stop = () => {
    if (this.context != null && this.context.state !== 'closed') {
      this.context.suspend();
    } else {
      // this.emit('error', { code: 100, message: 'Mic not yet initalized' });
    }
  }
  /**
   * Will Start the stream. Callback onAudioStart will be called.
   */
  start = () => {
    console.log('starting');
    if (this.context != null && this.context.state !== 'closed') {
      this.context.resume();
    } else {
      // this.emit('error', { code: 100, message: 'Mic not yet initalized' });
    }
  }

  /**
   * Will close the stream. We need to reinitalize the object to reuse it.
   */
  close = () => {
    if (this.context !== null && this.context.state !== 'closed')
      this.context.close();
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
}

export default MicStream;