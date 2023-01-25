import EventEmitter from 'event-emitter';

class SpeechRecognitionConnection extends EventEmitter {
  ws = null;
  serviceURI = null;
  serverState = 'stopped';
  constructor(options = {}) {
    super();
    if (options.serviceURI != null) {
      this.serviceURI = options.serviceURI;
    }
    this.initalizeWebSocket();
  }

  initalizeWebSocket = () => {
    this.ws = new WebSocket(this.serviceURI);

    this.ws.onopen = () => {
      console.log('Connected to Speech Recognition Server');
      this.emit('opened');
    };

    this.ws.onclose = (reason) => {
      console.log('Disconnected from Speech Recognition Server', reason);
      if (this.serverState != 'stopped') {
        this.emit('error', { code: 1010, message: 'Client has been disconnected from server' });
      }
      this.emit('closed');
    };

    this.ws.onerror = (error) => {
      console.log('Error in WebSocket', error);
      this.emit('error', error);
    };


    this.ws.onmessage = (message) => {
      const { error, results, serverState } = JSON.parse(message.data);
      if (error != undefined) {
        this.emit('error', error);
      } else if (serverState !== undefined) {
        console.log('Server Status Changed', serverState);
        this.serverState = serverState;
        if (serverState === 'running') {
          this.emit('running');
        }
        if (serverState === 'stopped') {
          this.emit('stopped');
        }
      } else if (results != null) {
        this.emit('results', results);
      } else {
        this.emit('other', results);
      }
    };
  }


  start = (request) => {
    console.log('Request to start', request);
    if (this.ws.readyState === 1) {
      this.ws.send(JSON.stringify({ event: 'start', payload: request }));
    } else {
      this.emit('error', { code: 106, message: `Connection not in open state,Current state: ${this.ws.readyState}` })
    }
  }

  stop = () => {
    console.log('Request to stop');
    if (this.ws.readyState === 1) {
      this.ws.send(JSON.stringify({ event: 'stop' }));
    } else {
      // this.emit('error', { code: 106, message: `Connection not in open state,Current state: ${this.ws.readyState}` })
    }
  }

  sendData = (data) => {
    if (this.ws.readyState === 1 && this.serverState === 'running') {
      this.ws.send(data);
    } else {
      this.emit('error', { code: 106, message: `Connection not in open state or serverState is stopped,Current connection state: ${this.ws.readyState} Current server state: ${this.serverState}` })
    }
  }

  closeConnection = () => {
    if (this.ws.readyState === 1)
      this.ws.close();
  }
}

export default SpeechRecognitionConnection;