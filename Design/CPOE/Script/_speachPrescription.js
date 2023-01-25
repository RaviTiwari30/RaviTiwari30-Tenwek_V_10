var prSdk = {};
var speechModule = {};
var lastlistnerElem = '';
$(document).ready(function () {
    try {
        authenticate(function (prSdk) {
            createPatientSession(prSdk, function (session) {
                speechModule = session.getSpeechRecognitionModule();
                onInitAttchFocusEvent();
            });
        });

    } catch (ex) {
        modelAlert('Unable to Load Voice Prescription !');
    }

});



var listnerElems = ['textarea', 'text'];
var searchListnerElems = ['txtMedicineSearch'];
var activateTags = ['H5'];
var onInitAttchFocusEvent = function () {
    $(document).on('click', function (e) {
        if (activateTags.indexOf(e.target.tagName) > -1) {
            var parentDiv = $(e.target).next();
            parentDiv.find('input[type=text],textarea').each(function () {
                $(this).attr('name', 'name' + this.id);
                attchVoice(e);
            });
        }
        else if (listnerElems.indexOf(e.target.type) > -1) {
            $(e.target).attr('name', 'name' + e.target.id);
            attchVoice(e);
        }
        else {
            speechModule.stopVoiceCapture();
        }
    });
}


var attchVoice = function (e) {
    if (lastlistnerElem != e.target.id)
        speechModule.stopVoiceCapture();

    speechModule.addSectionDetails(e.target.name, document.getElementById(e.target.id), []);
    speechModule.startVoiceCapture();
    speechModule.addTextListener(function (r) {
        $(e.target).keyup();
    });
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



var onCloseSession = function () {

}