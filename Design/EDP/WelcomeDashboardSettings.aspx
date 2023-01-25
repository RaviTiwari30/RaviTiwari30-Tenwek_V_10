<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="WelcomeDashboardSettings.aspx.cs" Inherits="Design_EDP_WelcomeDashboardSettings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(function () {
            var icons = ["icon-search", "icon-zoomin", "icon-zoomout", "icon-rssfeed", "icon-home", "icon-user", "icon-print", "icon-save", "icon-book", "icon-book-empty", "icon-folder-collapsed", "icon-folder-open", "icon-flag", "icon-bookmark", "icon-heart", "icon-cancel", "icon-trash", "icon-pin", "icon-tag", "icon-lightbulb", "icon-gear", "icon-wrench", "icon-locked", "icon-unlocked", "icon-key", "icon-clipboard", "icon-scissors", "icon-edit", "icon-page", "icon-copy", "icon-note", "icon-pdf", "icon-doc", "icon-xls", "icon-document", "icon-script", "icon-date", "icon-calendar", "icon-clock", "icon-envelope-closed", "icon-envelope-open", "icon-mail-closed", "icon-mail-open", "icon-link", "icon-unlink", "icon-web", "icon-globe", "icon-contacts", "icon-profile", "icon-image", "icon-suitcase", "icon-briefcase", "icon-cross", "icon-add", "icon-remove", "icon-info", "icon-alert", "icon-comment-text", "icon-comment-video", "icon-comment", "icon-cart", "icon-basket", "icon-messages", "icon-users", "icon-video", "icon-audio", "icon-volume-off", "icon-volume-on", "icon-compose", "icon-inbox", "icon-archive", "icon-reply", "icon-sent", "icon-attachment", "icon-square-plus", "icon-square-minus", "icon-treeview-corner-plus", "icon-treeview-corner-minus", "icon-treeview-corner", "icon-treeview-vertical-line", "icon-triangle-n", "icon-triangle-ne", "icon-triangle-e", "icon-triangle-se", "icon-triangle-s", "icon-triangle-sw", "icon-triangle-w", "icon-triangle-nw", "icon-triangle-ns", "icon-triangle-ew", "icon-arrowstop-n", "icon-arrowstop-e", "icon-arrowstop-s", "icon-arrowstop-w", "icon-transfer-ew", "icon-shuffle", "icon-carat-1-n", "icon-carat-1-ne", "icon-carat-1-e", "icon-carat-1-se", "icon-carat-1-s", "icon-carat-1-sw", "icon-carat-1-w", "icon-carat-1-nw", "icon-carat-2-ns", "icon-carat-2-ew", "icon-plus", "icon-minus", "icon-close", "icon-check", "icon-help", "icon-notice", "icon-arrow-n", "icon-arrow-ne", "icon-arrow-e", "icon-arrow-se", "icon-arrow-s", "icon-arrow-sw", "icon-arrow-w", "icon-arrow-nw", "icon-arrow-n-s", "icon-arrow-ne-sw", "icon-arrow-e-w", "icon-arrow-se-nw", "icon-arrow-nesw", "icon-arrow-4diag", "icon-newwin", "icon-extlink", "icon-arrowthick-n", "icon-arrowthick-ne", "icon-arrowthick-e", "icon-arrowthick-se", "icon-arrowthick-s", "icon-arrowthick-sw", "icon-arrowthick-w", "icon-arrowthick-nw", "icon-undo", "icon-redo", "icon-replyall", "icon-refresh", "icon-bullet-on", "icon-bullet-off", "icon-star-on", "icon-star-off", "icon-arrowreturn-se", "icon-arrowreturn-sw", "icon-arrowreturn-ne", "icon-arrowreturn-nw", "icon-arrowreturn-ws", "icon-arrowreturn-es", "icon-arrowreturn-wn", "icon-arrowreturn-en", "icon-arrowrefresh-w", "icon-arrowrefresh-n", "icon-arrowrefresh-e", "icon-arrowrefresh-s", ];
            var ddlLabelIcon = $('#ddlLabelIcon');
            ddlLabelIcon.bindDropDown({ data: icons, defaultValue: 'Select', isSearchAble: true });
            getWelcomeFunctionMaster(function () { });
            getWelcomeLabels(function () { });
            getActiveEmployees(function () { });
            initIcon(function () { });

            $('#ddlMapLabel').change(function (elem) {
                if (this.value == '0')
                    return false;


                var empID = $('#ddlUsers').val();
                if (empID == '0') {
                    modelAlert('Please Select Employee Name First');
                    return false;
                }
                var divAvilablesLabels = $('#divAvilablesLabels')
                $isAlreadyExits = divAvilablesLabels.find('#' + this.value);
                if ($isAlreadyExits.length > 0) {
                    modelAlert('Label Already Added', function () {
                        this.value = 0;
                    });
                    return false;
                }
                saveLabelForEmployee({ emp_ID: empID, label_ID: this.value }, function (response) {
                    bindLabelsEmployeeWise($('#ddlUsers').val());
                });
            });



            //$('#ddlLabelIcon').on('chosen:ready', function (event, data) {
            //    // $(data.chosen).find('ul.chosen-results').after('<span class="icon32 icon-color icon-search">Click me</span>');
            //    $(data.chosen.results_data).each(function () {
            //        this.html = '<span  class="icon32 icon-color ' + this + '"></span>&nbsp;' + this;
            //    });
            //}).chosen();



        });


        var initIcon = function (callback) {
            var ddlLabelIcon = $('#ddlLabelIcon');
            ddlLabelIcon.next().bind("click", function () {
                ddlLabelIcon.next().find('.chosen-results').find('li').not(':first').each(function () {
                    var span = '<span  class="icon32 icon-color ' + $(this).text() + '"></span>&nbsp;' + $(this).text();
                    $(this).html(span);
                });
            });
        }



        var getWelcomeFunctionMaster = function (callback) {
            serverCall('Services/WelcomeDashboardSettings.asmx/GetWelcomeFunctionMaster', {}, function (response) {
                var responseData = JSON.parse(response);
                $('#ddlLabelValueFunctions').bindDropDown({ data: responseData, defaultValue: 'Select', valueField: 'Function_Name', textField: 'Display_Name', isSearchAble: true });
            });
        }


        var getWelcomeLabels = function (callback) {
            serverCall('Services/WelcomeDashboardSettings.asmx/GetWelcomeLabels', {}, function (response) {
                var responseData = JSON.parse(response);
                $('#ddlLabels,#ddlMapLabel').bindDropDown({ data: responseData, defaultValue: 'Select', valueField: 'ID', textField: 'Label_Text', isSearchAble: true });
            });
        }

        var getActiveEmployees = function () {
            serverCall('Services/WelcomeDashboardSettings.asmx/GetActiveEmployees', {}, function (response) {
                var responseData = JSON.parse(response);
                $('#ddlUsers').bindDropDown({ data: responseData, defaultValue: 'Select', valueField: 'Employee_ID', textField: 'EmpName', isSearchAble: true });
            });
        }



        var getLabelsEmployeeWise = function (userID, callback) {
            serverCall('Services/WelcomeDashboardSettings.asmx/GetLabelsEmployeeWise', { userID: userID }, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
        }



        var bindLabelsEmployeeWise = function (userID) {
            $('#divAvilablesLabels').html('');
            if (userID == '0')
                return false;

            getLabelsEmployeeWise(userID, function (response) {
                $(response).each(function () {
                    parseLabel(this, function (response) {
                        $('#divAvilablesLabels').append(response);
                    });
                });
            });
        }

        var parseLabel = function (labelDetails,callback) {
            var label = '<div id="' + labelDetails.ID + '" class="col-md-6"><div class="well span3 top-block"><span class="icon32 icon-color ' + labelDetails.Label_Icon + '"></span><div>' + labelDetails.Label_Text + '</div><div>451852</div><span class="notification green">4</span> <span onclick="deleteEmployeeLabel(' + labelDetails.ID + ')" class="notification-left icon32 icon-color icon-trash"></span></div></div>';
            callback(label);
        }


        var getLabelDetails = function (labelID, calback) {
            serverCall('Services/WelcomeDashboardSettings.asmx/GetLabelDetails', { labelID: labelID }, function (response) {
                var responseData = JSON.parse(response);
                calback(responseData[0]);
            });
        }


        var editLabel = function (labelID) {
            if (labelID == '0') {
                modelAlert('Please Select Label First', function () { });
                return;
            }

            getLabelDetails(labelID, function (response) {
                $('#spnLabelID').text(response.ID);
                $('#txtLabelText').val(response.Label_Text);
                $('#ddlLabelIcon').val(response.Label_Icon).chosen('destroy').chosen();
                $('#ddlLabelValueFunctions').val(response.Label_FunctionName).chosen('destroy').chosen();
                $('#btnSave').val('Update');
                initIcon(function () { });
            });
        }


        var deleteLabel = function (labelID) {
            if (labelID == '0') {
                modelAlert('Please Select Label First', function () { });
                return;
            }
            serverCall('Services/WelcomeDashboardSettings.asmx/DeleteWelcomeLabel', { labelID: parseInt(labelID) }, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.message, function () {
                    if (responseData.status)
                        window.location.reload();
                });
            });
        }

        var deleteEmployeeLabel = function (labelID) {
            serverCall('Services/WelcomeDashboardSettings.asmx/DeleteEmployeeLabel', { labelID: parseInt(labelID) }, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.message, function () {
                    if (responseData.status)
                        bindLabelsEmployeeWise($('#ddlUsers').val());
                });
            });
        }


        var saveLabelForEmployee = function (data, callback) {
            serverCall('Services/WelcomeDashboardSettings.asmx/SaveLabelsForEmployee', { data: data }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    callback();
                else
                    modelAlert(responseData.message);
            });
        }




        var saveWelcomeLabel = function (btnSave, callback) {
            validateLabel(function (data) {
                var btnValue = btnSave.value;
                $(btnSave).attr('disabled', true).val('Submitting...');
                var serviceUrl = 'Services/WelcomeDashboardSettings.asmx/SaveWelcomeLabel';
                if (!String.isNullOrEmpty(data.id))
                    serviceUrl = 'Services/WelcomeDashboardSettings.asmx/UpdateWelcomeLabel';
                serverCall(serviceUrl, { data: data }, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.message, function () {
                        if (responseData.status) {
                            $(btnSave).removeAttr('disabled').val(btnValue);
                            window.location.reload();
                        }
                        else
                            $(btnSave).removeAttr('disabled').val(btnValue);
                    });
                });
            });
        }



        var validateLabel = function (callback) {
            var data = {
                id: $('#spnLabelID').text().trim(),
                labelName: $('#txtLabelText').val().trim(),
                labelIcon: $('#ddlLabelIcon').val().trim(),
                labelValueFunction: $('#ddlLabelValueFunctions').val().trim(),
            }

            if (String.isNullOrEmpty(data.labelName)) {
                modelAlert('Please Enter Label Name', function () {
                    $('#txtLabelText').focus();
                });
                return;
            }

            if (data.labelIcon == '0') {
                modelAlert('Please Select Label ICon', function () {
                    $('#ddlLabelIcon').focus();
                });
                return;
            }

            if (data.labelValueFunction == '0') {
                modelAlert('Please Select Label Value Function', function () {
                    $('#ddlLabelValueFunctions').focus();
                });
                return;
            }
            callback(data);
        }

    </script>

    <style type="text/css">
     .chosen-container ul.chosen-results li.highlighted {
            background-color: #D1DBE6;
            color: black;
            font-weight: bold;
            background-image: none;
        }
    </style>


    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Welcome Dashboard Settings</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-12">
                    <div class="Purchaseheader">Edit/Preview Labels</div>
                    <div class="row col-md-24">
                        <div class="row">
                            <div class="col-md-24">
                                <select id="ddlLabels">
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <%--<b>PreView </b>
                                <div style="margin-bottom: 0px; padding: 0px;" class="well span3 top-block">
                                    <span class="icon32 icon-color icon-user"></span>
                                    <div>Last Login Time</div>
                                    <div>14-Sep-2017 01:14 PM</div>
                                    <span class="notification green">5</span>
                                    
                                </div>--%>
                            </div>
                            <div class="col-md-12">
                                <input type="button" class="ItDoseButton pull-right" style="margin-left: 10px; width: 100px" onclick="deleteLabel($('#ddlLabels').val())" value="Delete" />
                                <input type="button" class="ItDoseButton pull-right" style="width: 100px" onclick="editLabel($('#ddlLabels').val())" value="Edit" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-12">
                    <div class="Purchaseheader">Create Label</div>
                    <div class="row col-md-24">
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">Display Text</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-18">
                                <input id="txtLabelText" type="text" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">Display Icon</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-18">
                                <select id="ddlLabelIcon"></select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">Value Function </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-18">
                                <select id="ddlLabelValueFunctions"></select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24 ">
                                <span id="spnLabelID" style="display: none"></span>
                                <input type="button" id="btnSave" class="ItDoseButton save pull-right" onclick="saveWelcomeLabel(this, function () { });" value="Save" tabindex="35" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Map Labels</div>
            <div class="row">
                <div class="col-md-12">
                    <div class="row col-md-24">
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">User Name</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-18">
                                <select onchange="bindLabelsEmployeeWise(this.value);" id="ddlUsers"></select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-12">
                    <div class="row col-md-24">
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">Select Label</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-18">
                                <select id="ddlMapLabel"></select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Avilables Labels</div>
            <div id="divAvilablesLabels" class="row">
            </div>
        </div>
</asp:Content>

