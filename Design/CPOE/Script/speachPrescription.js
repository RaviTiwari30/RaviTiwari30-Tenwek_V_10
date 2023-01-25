var prSdk = '';
var speechModule = {};
var lastlistnerElem = '';
var _btnVoicePrescription = {};
var disableIcon = '../../Images/ico_micoff.png';
var enbleIcon = '../../Images/ico_micon.png';
var _enableMic = false;
$(document).ready(function () {
    try {
        _btnVoicePrescription = $('#btnVoicePrescription')
        $(_btnVoicePrescription).click(function () {
            if (!_enableMic) {
                authenticate(function (prSdk) {
                    createPatientSession(prSdk, function (session) {
                        speechModule = session.getSpeechRecognitionModule();
                        _attchVoiceToTextEvent();
                        _btnVoicePrescription.attr('src', disableIcon);
                        _enableMic = true;
                    });
                });
            }
            else {
                _btnVoicePrescription.attr('src', enbleIcon);
                _enableMic = false;
                speechModule.stopVoiceCapture();
            }
        });

    } catch (ex) {
        modelAlert('Unable to Load Voice Prescription !');
    }
});



var _attchVoiceToTextEvent = function () {
    $('textarea,input[type=text]').each(function (i, e) {
        if (this.id == '')
            $(this).attr('id', '_id' + i);

        $(this).attr('onfocus', 'onVoiceToTextFocus(this)').attr('name', '_name' + i);
        attchVoiceTotext(this);
    });
}



var onVoiceToTextFocus = function (elem) {
    if (_enableMic) {
        //speechModule.stopVoiceCapture();
        speechModule.startVoiceCapture();
        speechModule.addTextListener(function (r) {
            $(elem).keyup();
        });
    }
}


var attchVoiceTotext = function (_el) {
    speechModule.addSectionDetails(_el.name, document.getElementById(_el.id), []);
}




var authenticate = function (callback) {
    prSdk = new PrayagadSdk();
    prSdk.authenticate('tester', 'tester', 'b3e904ca-16bb-418b-bd61-de00bc0812c6', { externalPractitionerId: 'EXT_SUNNY' })
        .then(function (res) {
            callback(prSdk);
        });
}



var createPatientSession = function (prSdk, callback) {
    prSdk.createSession({ gender: 'female', age: '32', externalPatientId: '1' }, '2').then(function (session) {
        callback(session);
    });
}
