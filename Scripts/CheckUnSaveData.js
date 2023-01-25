$(document).ready(function () {
    needToConfirm = false;
    window.onbeforeunload = askConfirm;

    $("input,textarea").on("change", function () {
        needToConfirm = false;
    });

    $("select").change(function () {
        needToConfirm = false;
    });
});

function askConfirm() {
    if (needToConfirm) {
        //// Put your custom message here 
        //var s = confirm("If you exit this page, your unsaved changes will be lost.");
        //if (!s) {
        //    if (typeof ($modelUnBlockUI) == 'function')
        //        $modelUnBlockUI()
        //}

        return true;
    }
}
function OffBeforeUnload() {
    needToConfirm = false;
    $(window).off('beforeunload');
}