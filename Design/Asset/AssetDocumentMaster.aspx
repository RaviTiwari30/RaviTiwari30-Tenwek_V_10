<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="AssetDocumentMaster.aspx.cs" Inherits="Design_Asset_AssetDocumentMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<script type="text/javascript">
    $(document).ready(function () {
        debugger;
        bindDocumentMaster();
    });

    var ValidateAndSave = function () {
        debugger;

        var data = {

            DocumentID: $('#spnDocumentID').text().trim(),
            DocumentName: $('#txtdocumentname').val().trim(),
            Description: $('#txtdescription').val(),
            Savetype: $('#btnSave').val(),
            IsActive: $('input[type=radio][name=rdoactive]:checked').val(),
        }

        if (String.isNullOrEmpty(data.DocumentName)) {
            debugger;
            modelAlert('Please Enter Document Name', function () {
                $('#txtdocumentname').focus();
            });
            return false;
        }
        if (String.isNullOrEmpty(data.Description)) {
            debugger;
            modelAlert('Please Enter Description', function () {
                $('#txtdescription').focus();
            });
            return false;
        }

        serverCall('Services/WebService.asmx/SaveAssetDocumentMaster', data, function (response) {
            var responseData = JSON.parse(response);
            modelAlert(responseData.response, function () {
                bindDocumentMaster();

                Clear();

            });
        });
    }

    var Clear = function () {
        $('#txtdocumentname').val('');
        $('#txtdescription').val('');
        $('#spnDocumentID').text('');
        $('input[type=radio][name=rdoactive][value=1]').prop('checked', true);
        $('#btnSave').val('Save');
    }

    function bindDetails(data) {
        debugger;
        $('#tbDocumentList tbody').empty();
        var row = '';
        for (var i = 0; i < data.length; i++) {
            debugger;
            var j = $('#tbDocumentList tbody tr').length + 1;
            row = '<tr>';
            row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
            row += '<td id="tddocumentname" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DocumentName + '</td>';
            row += '<td id="tddescription" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Description + '</td>';

            row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Active + '</td>';
            row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CreatedBy + '</td>';
            row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DateTime + '</td>';
            row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/edit.png" onclick="Edit(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
            row += '<td id="tdActive" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].IsActive + '</td>';
            row += '<td id="tdAID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ID + '</td>';
            row += '</tr>';

            $('#tbDocumentList tbody').append(row);
        }
    }
    function bindDocumentMaster() {
        serverCall('Services/WebService.asmx/bindAssetDocumentMasterDetails', { data: '' }, function (response) {
            var responseData = JSON.parse(response);
            bindDetails(responseData);
            Clear();
        });
    }

    var Edit = function (rowID) {
        var row = $(rowID).closest('tr');
        $('#txtdocumentname').val(row.find('#tddocumentname').text());
        $('#txtdescription').val(row.find('#tddescription').text());
        $('#spnDocumentID').text(row.find('#tdAID').text());
        if (row.find('#tdActive').text() == "0") {
            $('input[type=radio][name=rdoactive][value=1]').prop('checked', false);
            $('input[type=radio][name=rdoactive][value=2]').prop('checked', true);
        }
        else {
            $('input[type=radio][name=rdoactive][value=2]').prop('checked', false);
            $('input[type=radio][name=rdoactive][value=1]').prop('checked', true);
        }

        $('#btnSave').val('Update');
    }
    SearchbyfirstName = function (elem) {
        debugger;
        var name = $.trim($(elem).val());
        var length = $.trim($(elem).val()).length;

        $('#tbDocumentList tr').hide();
        $('#tbDocumentList tr:first').show();
        $('#tbDocumentList tr').find('td:eq(1)').filter(function () {
            debugger;
            if ($(this).text().substring(0, length).toLowerCase() == name.toLowerCase())
                return $(this);
        }).parent('tr').show();;
    }
</script>   
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Asset Document Master</b>
            <span style="display: none" id="spnDocumentID"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Enter Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">


                        <div class="col-md-3">
                            <label class="pull-left">Document Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtdocumentname" class="requiredField" maxlength="200" placeholder="Enter Document Name here" />
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">Description</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <textarea id="txtdescription" class="requiredField" style="height: 56px; text-transform: uppercase; margin: 0px; width: 228px; max-width: 228px; max-height: 90px;" placeholder="Enter Description here"></textarea>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Is Active</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="radio" name="rdoactive" value="1" checked="checked" />Yes
                            <input type="radio" name="rdoactive" value="2" />No
                        </div>
                    </div>

                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <input type="button" id="btnSave" value="Save" onclick="ValidateAndSave()" />
                <input type="button" id="btnClear" value="Clear" onclick="Clear()" />

            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Asset Document Details
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Search Document</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtsearch" onkeyup="SearchbyfirstName(this)" placeholder="Search by first name" />
                </div>
            </div>
            <div class="row">
                <div id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tbDocumentList" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Document Name</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Description</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Is Active Status</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Created By</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Created Date Time</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Edit</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

