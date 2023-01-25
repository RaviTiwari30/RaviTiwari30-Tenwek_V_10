class SpeechProcessor {
  static processTranscript(responseData) {
    let totalTranscript = '';
    if (responseData != null && responseData.results != null) {
      for (let k = 0; k < responseData.results.length; k++) {
        totalTranscript += ' ' + responseData.results[k].transcript.trim();
      }
    }
    return totalTranscript;
  }
}

export default SpeechProcessor;