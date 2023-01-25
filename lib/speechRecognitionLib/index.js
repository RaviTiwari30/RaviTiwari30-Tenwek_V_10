import MicStream from './micStream';
import AudioFileStream from './audioFileStream';
import SpeechRecognitionConnection from './connection';
import EventEmitter from 'event-emitter';
class SpeechRecognition extends EventEmitter {
  // Parameters
  lang = 'en-IN';
  continuous = true;
  interimResults = true
  maxAlternatives = 5;
  phrases = [];
  encoding = 'LINEAR16'
  sampleRate = 44100
  connection = null;
  bufferSize = null;
  engine = 'sangam';
  autoStart = false;
  serviceURI = 'wss://ehr.prayagad.com:9443/';
  // Number of packats dropped
  count = 0;
  recognitionStatus = 'stopped'; //stopped/running
  inputStream = null;

  // decide whether mode is mic or an audiofile
  mode = 0;

  // Speech Contexts that can be sent , phrases to improve accuracy
  speechContexts = [];
  constructor(options = {}) {
    super();

    this.initalizeConfig(options);
    // this.serviceURI = speechRecognitionServerUrl;
    // Initializing inputStream and connection
    if (this.mode == 0 && (this.inputStream == null || this.inputStream.context.state === 'closed')) {
      this.inputStream = new MicStream();
    }
    //  else {
    //   this.inputStream = new AudioFileStream(options.audioFile, {});
    // }
    this.connection = new SpeechRecognitionConnection({ serviceURI: this.serviceURI });
    this.initalizeInputStream();
    this.initalizeConnection();
    this.initalizeListeners();
    // Initializing all state changes and workflows

  }

  setRecognitionStatus = (status) => {
    if (status === 'running') {
      this.recognitionStatus = 'running';
      this.emit('start');
    }
    if (status === 'stopped') {
      this.recognitionStatus = 'stopped';
      this.emit('end');
    }
  }


  initalizeConfig = (options) => {

    if (options.lang != null) {
      this.lang = options.lang;
    }
    if (options.continuous != null) {
      this.continuous = options.continuous;
    }
    if (options.interimResults != null) {
      this.interimResults = options.interimResults;
    }
    if (options.maxAlternatives != null) {
      this.maxAlternatives = options.maxAlternatives;
    }
    if (options.serviceURI != null) {
      this.serviceURI = options.serviceURI;
    }
    if (options.phrases != null) {
      this.phrases = options.phrases;
    }
    if (options.encoding != null) {
      this.encoding = options.encoding;
    }
    if (options.sampleRate != null) {
      this.sampleRate = options.sampleRate;
    }
    if (options.bufferSize != null) {
      this.bufferSize = options.bufferSize;
    }
    if (options.speechContexts != null) {
      this.speechContexts = options.speechContexts;
    }
    if (options.engine != null) {
      this.engine = options.engine;
    }
    if (options.mode != null) {
      this.mode = options.mode;
    }
  }

  initalizeInputStream = () => {
    this.inputStream.on('running', () => {
      if (this.connection.serverState === 'running') {
        this.setRecognitionStatus('running');
      }
      if (this.connection.serverState === 'stopped') {
        this.inputStream.stop();
      }
    });

    this.inputStream.on('stopped', () => {
      if (this.connection.serverState === 'running') {
        this.connection.stop();
      }
      if (this.connection.serverState === 'stopped') {
        this.setRecognitionStatus('stopped');
      }
    });

    this.inputStream.on('error', (error) => {
      this.emit('error', error);
      if (this.connection.status === 'stopped') {
        // Do nothing
      }
      if (this.connection.status === 'running') {
        this.connection.stop();
      }
      this.inputStream.stop();
      this.connection.serverState = 'stopped';
    });

    this.inputStream.on('closed', () => {
      this.connection.closeConnection();
      this.setRecognitionStatus('stopped');
    });

    this.inputStream.on('data', (data) => {
      this.connection.sendData(data);
    });

  }

  initalizeConnection = () => {

    this.connection.on('running', () => {
      if (this.inputStream.status === 'running') {
        this.setRecognitionStatus('running');
      }
      if (this.inputStream.status === 'stopped') {
        this.inputStream.start();
      }
    });

    this.connection.on('stopped', () => {
      console.log('connection is stopped');
      console.log('mic status' + this.inputStream.status);
      if (this.inputStream.status === 'stopped') {
        this.setRecognitionStatus('stopped');
      }
      if (this.inputStream.status === 'running') {
        console.log('Stopping Mic because connection is stopped');
        this.inputStream.stop();
      }

    });

    this.connection.on('closed', () => {
      this.inputStream.close();
      this.setRecognitionStatus('stopped');
    });

    // Handling Errors
    this.connection.on('error', (error) => {
      this.emit('error', error);
      this.connection.serverState = 'stopped';
      this.connection.stop();
      if (this.inputStream.status === 'stopped') {
        // Do nothing
      }
      if (this.inputStream.status === 'running') {
        this.inputStream.stop();
      }
      this.setRecognitionStatus('stopped');
    });

    this.connection.on('results', (results) => {
      this.emit('results', results);
    });
  }

  initalizeListeners = () => {
    this.on('start', this.onstart);
    this.on('end', this.onend);
    this.on('results', this.onresults);
    this.on('error', this.onerror);
  }

  /*
  * Do send documentId. Otherwise the file will not be saved to backend. Will be availabe at unknown
  */
  start = (options = {}) => {

    this.initalizeConfig(options);
    if (this.connection.ws.readyState != 1) {
      console.log('Connection Disconneted, Reconnecting');
      this.connection = new SpeechRecognitionConnection({ serviceURI: this.serviceURI });
      this.initalizeConnection();
      return;
    } else {
      if (this.inputStream.context.state === 'closed') {
        if (this.mode == 0) {
          this.inputStream = new MicStream();
        }
        // else {
        //   this.inputStream = new AudioFileStream(options.audioFile, {});
        // }
        this.initalizeInputStream();
      }

      this.sampleRate = this.inputStream.sampleRate;

      // Initiating connection
      // 1. Send StartRequest Parameter to Server
      this.connection.start({
        engine: this.engine,
        encoding: this.encoding,
        sampleRate: this.sampleRate,
        languageCode: this.lang,
        speechContexts: this.speechContexts,
        maxAlternatives: this.maxAlternatives,
        autoStart: this.autoStart,
        interimResults: this.interimResults,
        recordingId: options.recordingId,
        documentId: options.documentId
      });
      // 2. Server Gives running response On ServerResposne Send start request to Mic
      // 3. On mic response of start Set Current recogntionStatus as running
    }

  }
  stop = () => {
    if (this.inputStream.status === 'running') {
      this.inputStream.stop();
    }
    // Initiating connection
    // 1. Send StopRequest Parameter to Mic
    // 2. On mic response of stop send stopRequest to Server
    // 3. On Server Response as stopped  Set Current recogntionStatus as stopped
  }

  abort = () => {
    this.connection.closeConnection();
    this.inputStream.close();
    // 1. Stop Mic
    // 2. Close Connection
    // 3. Set recogntionStatus as stopped
  }

  destory = () => {
    this.inputStream.close();
    this.connection.closeConnection();
  }

  onaudiostart = function () {
  }

  onsoundstart = function () {
  }

  onspeechstart = function () {
  }

  onspeechend = function () {
  }

  onsoundend = function () {
  }

  onaudioend = function () {
  }

  onresults = function (result) {
    console.log('Results', result);
  }

  onnomatch = function () {
  }

  onerror = function (error) {
    console.error('Error', error);
  }

  onstart = function () {
    console.log('Started');
  }

  onend = function () {
    console.log('Speech Recogntion Ended');
  }
}
export default SpeechRecognition;
