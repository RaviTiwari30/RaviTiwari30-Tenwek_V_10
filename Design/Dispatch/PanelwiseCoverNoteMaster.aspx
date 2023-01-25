<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PanelwiseCoverNoteMaster.aspx.cs" Inherits="Design_Dispatch_PanelwiseCoverNoteMaster" %>

<%@ Register TagPrefix="CE" Namespace="CuteEditor" Assembly="CuteEditor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div style="text-align: center">
                <b>Panelwise Cover Note/Pre-Auth Print Format Master</b>&nbsp;<br />
                <label id="lblMsg" class="ItDoseLblError"></label>
                <label id="lblCurrentEntryID" style="display: none;"></label>
            </div>
        </div>
        <div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-2">
                                <label class="pull-left">Format Type</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <select id="ddlFormatType" onchange="onFormatTypeChange(function(){});" tabindex="1" class="requiredField">
                                    <option value="0">Pre Auth</option>
                                    <option value="1" selected="selected">Cover Note</option>
                                </select>
                            </div>

                            <div class="col-md-2">
                                <label class="pull-left">Panel</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlPanel" onchange="bindOldContent(function(){})" tabindex="2" class="requiredField"></select>
                            </div>
                            <div class="col-md-2">
                                <label class="pull-left">Centre</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlCentre" onchange="bindOldContent(function(){})" tabindex="3" class="requiredField"></select>
                            </div>
                            <div class="col-md-2">
                                <label class="pull-left">Type</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <select id="ddlPatientType" onchange="bindOldContent(function(){})" tabindex="4" class="requiredField">
                                    <option value="0">Select</option>
                                    <option value="1">OPD</option>
                                    <option value="2">Emergency</option>
                                    <option value="3">IPD</option>
                                    <option value="4">Universal</option>
                                </select>

                            </div>

                        </div>

                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Print Format
                </div>

                <div class="row">
                    <div class="col-md-20">
                        <div style="width: 100%">
                            <div class="Purchaseheader">
                                Body Content
                            </div>
                            <CKEditor:CKEditorControl ID="txtCoverNoteFormat" BasePath="~/ckeditor" runat="server" Height="205px" ClientIDMode="Static" TabIndex="4" EnterMode="BR"></CKEditor:CKEditorControl>
                        </div>
                        <div style="width: 100%; height: 75px; background-color: white; border: 1px solid black; overflow: auto;">
                            <div class="Purchaseheader">
                                Bills Grid Columns
                            </div>
                            <div id="divBillsGridColumnsList" class="chosen-container-multi">
                                <ul style="border: none; background-image: none; background-color: #F5F5F5; padding: 0" class="chosen-choices">
                                </ul>
                            </div>
                        </div>
                        <div style="width: 100%; height: 53px; background-color: white; border: 1px solid black;">
                            <div class="Purchaseheader">
                                Header Details
                            </div>
                            <div class="row">
                                <div class="col-md-1">
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left">Show Centre Logo</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-3">
                                    <select id="ddlShowHeader" tabindex="5" class="requiredField">
                                        <option value="1" selected="selected">Yes</option>
                                        <option value="0">No</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">Header Text</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-10">
                                    <asp:TextBox ID="txtHeaderText" runat="server" ClientIDMode="Static" MaxLength="50"></asp:TextBox>
                                </div>
                                <div class="col-md-3">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <strong>Body Column :</strong><br />
                        <div style="width: 100%; height: 270px; overflow-y: scroll">
                            <ul id="ulBoldyColumn"></ul>
                        </div>
                        <hr style="width: 100%; height: 1px; background-color: black" />
                        <strong>Bill Grid Column :</strong><br />
                        <div style="width: 100%; height: 160px; overflow-y: scroll">
                            <ul id="ulBillGridColumn"></ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div style="text-align: center" class="POuter_Box_Inventory">
            <button type="button" class="save" onclick="saveCoverNoteMaster(this);">Save</button>
        </div>

    </div>
    <div id="divCoverNoteFormatModel" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width: 900px">
                <div class="modal-header">
                    <button type="button" class="close" onclick="CoverNoteFormatModelClose()" aria-hidden="true">&times;</button>
                    <b class="modal-title">Copy Same Format</b>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-5">
                                    <label class="pull-left" style="font-weight: bold">
                                        Copy Panel From
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-19">
                                    <label id="lblPanelFrom" class="pull-left patientInfo" style="font-weight: bold"></label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-5">
                                    <label class="pull-left" style="font-weight: bold">
                                        Select Panel To <input type="checkbox" onchange="checkAll(this)" />
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-19" style="max-height:250px; overflow:auto;">
                                    <ul id="ulPanelTo" style="list-style-type: none; margin-left: -10px;"></ul>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="copyCoverNoteMapping(this)" class="save">Save</button>
                    <button type="button" onclick="CoverNoteFormatModelClose()">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        $(function () {

            $("#txtInvoice").focus();
            showPatientSearchPopUpModel = function () {
                $('#divPatientSearchPopUpModel').showModel();
            }
            closePatientSearchPopUpModel = function () {
                $('#divPatientSearchPopUpModel').hideModel();
            }

            $bindPanel(function () {
                $bindCentre(function () {
                    $bindPrintoutFieldColumns(function () { });
                });
            });
        });

        var $bindPanel = function (callback) {
            var type = 3;
            if (Number($('#ddlFormatType').val()) == 0)
                type = 4;

            serverCall('../Common/CommonService.asmx/bindPanelRoleWisePanelGroupWise', { Type: type }, function (response) {
                var $ddlPanel = $('#ddlPanel');
                $ddlPanel.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'PanelID', textField: 'Company_Name', isSearchAble: true, selectedValue: "Select" });
                callback($ddlPanel.find('option:selected').text());
            });
        }


        var $bindCentre = function (callback) {
            serverCall('../Common/CommonService.asmx/BindCentre', {}, function (response) {
                $Centre = $('#ddlCentre');
                $Centre.bindDropDown({ defaultValue: "Universal", data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true, selectedValue: "Universal" });
                callback($Centre.find('option:selected').text());
            });
        }


        var onFormatTypeChange = function () {
            $bindPanel(function () {
                $bindPrintoutFieldColumns(function () {
                    if (Number($('#ddlFormatType').val()) == 0) {
                        $('#ddlPatientType').val('0');
                        $('select[id=ddlPatientType]').find('option[value=1]').attr('disabled', true).attr('style', 'color:red;font-weight:bold;');
                    }
                    else
                        $('select[id=ddlPatientType]').find('option[value=1]').removeAttr('disabled', true).removeAttr('style');

                    bindOldContent(function () {});
                });
            });
        }

        var $bindPrintoutFieldColumns = function (callback) {
            serverCall('PanelwiseCoverNoteMaster.aspx/bindCoverNoteColumnsDetail', { isCoverNote: $('#ddlFormatType').val() }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    var ulBoldyColumn = $('#ulBoldyColumn');
                    var ulBillGridColumn = $('#ulBillGridColumn');
                    ulBoldyColumn.find('li').remove();
                    ulBillGridColumn.find('li').remove();

                    var bodyColumn = "";
                    var billColumn = "";

                    $.each(responseData, function (i) {
                        var aa = '<li  role="menuitem"><a>'
                            + '<label class="trimList"  title="' + this.FieldName + '"  ';

                        if (Number(this.IsBillDetailColumn) == 2)
                            aa = aa + ' style="color:red;" ';

                        aa = aa + '><input id="' + $.trim(this.FieldName) + '" value="' + this.FieldName + '" class="ui-all" type="checkbox"  ';

                        bodyColumn = aa;
                        billColumn = aa;

                        if (Number(this.IsBillDetailColumn) == 0 || Number(this.IsBillDetailColumn) == 2)
                            bodyColumn = bodyColumn + 'onchange="onSelectColumn(this)" ';

                        if (Number(this.IsBillDetailColumn) == 1 || Number(this.IsBillDetailColumn) == 2)
                            billColumn = billColumn + 'onchange="onSelectBillDetailColumn(this)" ';

                        bodyColumn = bodyColumn + ' >' + this.FieldName + '</label> </li>';
                        billColumn = billColumn + ' >' + this.FieldName + '</label> </li>';

                        if (Number(this.IsBillDetailColumn) == 0 || Number(this.IsBillDetailColumn) == 2)
                            ulBoldyColumn.append(bodyColumn);

                        if (Number(this.IsBillDetailColumn) == 1 || Number(this.IsBillDetailColumn) == 2)
                            ulBillGridColumn.append(billColumn);
                    });

                    callback(true);
                }
            });
        }

        var onSelectColumn = function (el) {
            if ($(el).is(':checked')) {
                var FieldValue = CKEDITOR.instances['txtCoverNoteFormat'].getData() + ' {' + $(el).val() + '} ';
                CKEDITOR.instances['txtCoverNoteFormat'].setData(FieldValue);
                $(el).prop('checked', false);
            }
        }

        var onSelectBillDetailColumn = function (el) {
            var billsGridColumnsList = $('#divBillsGridColumnsList')
            if ($(el).is(':checked')) {
                $isAlreadyExits = billsGridColumnsList.find('#' + $(el).val());
                //if ($isAlreadyExits.length > 0) {
                //    modelAlert('Column Already Seleted');
                //    return false;
                //}
                if ($isAlreadyExits.length == 0)
                    billsGridColumnsList.find('ul').append('<li id=' + $(el).val() + ' class="search-choice"><span>' + $(el).val() + '</span><a onclick="$(this).parent().remove()" style="cursor:pointer" class="search-choice-close" data-option-array-index="4">' + $(el).val() + '</a></li>');
            }
            else {
                billsGridColumnsList.find('#' + $(el).val()).remove();
            }
        }


        var getData = function (callback) {
            $("#lblMsg").text("");
            var CoverNoteFormat = CKEDITOR.instances['txtCoverNoteFormat'].getData();
            var panelID = $("#ddlPanel").val();
            var centreID = $("#ddlCentre").val();
            var patientTypeID = $("#ddlPatientType").val();
            var showHeader = $("#ddlShowHeader").val();
            var headerText = $("#txtHeaderText").val();
            var formatType = $("#ddlFormatType").val();
            if (panelID == '0') {
                $("#lblMsg").text("Please Select Panel.");
                $("#ddlPanel").focus();
                return false;
            }
            if (patientTypeID == '0') {
                $("#lblMsg").text("Please Select Patient Type.");
                $("#ddlPatientType").focus();
                return false;
            }

            if (String.isNullOrEmpty(CoverNoteFormat)) {
                $("#lblMsg").text("Please Enter Body Content.");
                CKEDITOR.instances['txtCoverNoteFormat'].focus();
                return false;
            }



            var billGridColumns = "";
            $('#divBillsGridColumnsList ul li').each(function () {
                if (billGridColumns == "")
                    billGridColumns = this.id;
                else
                    billGridColumns = billGridColumns + "," + this.id;
            });

            data = {
                CoverNoteBodyContent: CoverNoteFormat,
                PanelID: panelID,
                CentreID: centreID,
                PatientTypeID: patientTypeID,
                BillGridColumns: billGridColumns,
                ShowHeader: showHeader,
                HeaderText: headerText,
                FormatType: formatType
            }
            callback(data);
        }

        var saveCoverNoteMaster = function (btnSave) {
            // debugger;
            getData(function (CoverNoteMasterData) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('PanelwiseCoverNoteMaster.aspx/SaveCoverNoteMaster', CoverNoteMasterData, function (response) {
                    var $responseData = JSON.parse(response);
                    modelAlert($responseData.response, function () {
                        if ($responseData.status) {
                            // window.location.reload();

                            modelConfirmation('Confirmation ?', 'Do you want to apply Same Format to Another Panel.', 'Yes Copy To Another Panel', 'Cancel', function (response) {
                                if (response) {
                                    loadPanelToModel($("#ddlPanel").val(), $("#ddlPanel option:selected").text(), $responseData.currentEntryID);
                                    //  $("#divCoverNoteFormatModel").showModel();
                                }
                                else {
                                    window.location.reload();
                                }
                            });

                        }
                        else
                            $(btnSave).removeAttr('disabled').val('Save');
                    });
                });
            });
        }


        var loadPanelToModel = function (panelId, panelName, currentEntryID) {
            $("#lblPanelFrom").text(panelName);
            $("#lblCurrentEntryID").text(currentEntryID);

            var type = 3;
            if (Number($('#ddlFormatType').val()) == 0)
                type = 4;
            serverCall('../Common/CommonService.asmx/bindPanelRoleWisePanelGroupWise', { Type: type }, function (response) {
                var responseData = JSON.parse(response);
                var responsePanelTo = responseData.filter(function (i) { return i.PanelID != panelId });
                var ulPanelTo = $('#ulPanelTo');
                ulPanelTo.find('li').remove();
                if (responsePanelTo.length > 0) {
                    $.each(responsePanelTo, function (i) {
                        var aa = '<li  role="menuitem"><a>'
                            + '<label class="trimList"  title="' + this.Company_Name + '" >'
                            + '<input   id="' + $.trim(this.PanelID) + '" value="' + this.PanelID + '" class="ui-all" type="checkbox" '
                            + ' >' + this.Company_Name + '</label></a> </li>';
                        ulPanelTo.append(aa);
                    });


                    $("#divCoverNoteFormatModel").showModel();
                }
                else {
                    var alertMessage = "Only One Panel Mapped in the Cuurent Centre Which have "+ $('#ddlFormatType option:selected').text() +" Functionality !!!";
                    modelAlert(alertMessage);
                }

            });
        }

        var CoverNoteFormatModelClose = function () {
            window.location.reload();
        }


        var checkAll = function (ctrlID) {
            if ($(ctrlID).is(':checked'))
                $('#ulPanelTo li input').prop('checked', true);
            else
                $('#ulPanelTo li input').prop('checked', false);
        }
        var copyCoverNoteMapping = function (btnCopy) {
            var panelList = [];
            $('#ulPanelTo li').each(function () {
                if ($(this).find('input').is(":checked")) {
                    panelList.push({
                        panelID: $(this).find('input').attr('id')
                    })
                }
            });

            if (panelList.length == 0) {
                modelAlert('Please Select Atleast One Panel To Copy !!!');
                return;
            }

            $(btnCopy).attr('disabled', true).val('Submitting...');

            data = {
                currentEntryID: $("#lblCurrentEntryID").text(),
                CentreID: $("#ddlCentre").val(),
                PatientTypeID: $("#ddlPatientType").val(),
                panelList: panelList,
                FormatType: $("#ddlFormatType").val(),
            }
            serverCall('PanelwiseCoverNoteMaster.aspx/CopyCoverNoteFormat', data, function (res) {
                $responseData = JSON.parse(res);
                modelAlert($responseData.response, function (res) {
                    if ($responseData.status)
                        window.location.reload();
                    else
                        $(btnCopy).removeAttr('disabled').val('Save');
                });
            });
        }


        var bindOldContent = function () {

            CKEDITOR.instances['txtCoverNoteFormat'].setData('');
            $("#txtHeaderText").val('');
            $("#ddlShowHeader").val('1');
            var billsGridColumnsList = $('#divBillsGridColumnsList');
            var ulBillGridColumn = $('#ulBillGridColumn');
            ulBillGridColumn.find('input').prop('checked', false);

            billsGridColumnsList.find('li').remove();

            data = {
                PanelID: Number($("#ddlPanel").val()),
                CentreID: Number($("#ddlCentre").val()),
                PatientTypeID: Number($("#ddlPatientType").val()),
                FormatType: Number($("#ddlFormatType").val())
            }
            serverCall('PanelwiseCoverNoteMaster.aspx/bindOldContent', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {

                    CKEDITOR.instances['txtCoverNoteFormat'].setData(responseData[0].BodyContent);

                    billsGridColumns = responseData[0].BillGridColumns.split(',');
                    if (billsGridColumns.length > 0) {
                        $.each(billsGridColumns, function (i) {
                            if (billsGridColumns[i] != "") {
                                ulBillGridColumn.find('#' + billsGridColumns[i]).prop('checked', true);

                                billsGridColumnsList.find('ul').append('<li id=' + billsGridColumns[i] + ' class="search-choice"><span>' + billsGridColumns[i] + '</span><a onclick="$(this).parent().remove()" style="cursor:pointer" class="search-choice-close" data-option-array-index="4">' + billsGridColumns[i] + '</a></li>');
                            }
                        });
                    }

                    $("#ddlShowHeader").val(responseData[0].IsCentreLogo);
                    $("#txtHeaderText").val(responseData[0].HeaderText);
                }
            });
        }

    </script>
</asp:Content>
