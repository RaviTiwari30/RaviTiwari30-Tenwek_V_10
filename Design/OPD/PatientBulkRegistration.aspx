<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="PatientBulkRegistration.aspx.cs" Inherits="Design_OPD_PatientBulkRegistration" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>


<asp:Content ID="ct1" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <script type="text/javascript">
        var SaveRegistration = function () {
            data = {
                Qty: $('#txtQty').val().trim(),
                Gender: $('input[type=radio][name=sex]:checked').val(),
                Remarks: $('#txtRemarks').val().trim(),
            }
            if (Number(data.Qty) <= 0) {
                modelAlert('Please Enter No. of Total Patient ', function () {
                    $('#txtQty').focus();
                });
                return false;
            }
            if (String.isNullOrEmpty(data.Remarks)) {
                modelAlert('Please Enter Remarks ', function () {
                    $('#txtRemarks').focus();
                });
                return false;
            }
            serverCall('Services/PatientRegistration.asmx/SaveBulkPatientRegistration', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    printReport(responseData.BulkID, 0);
                    window.location.reload();
                });
            });
        }

        var Search = function () {
            data = {
                fromdate: $('#txtFromDate').val(),
                todate: $('#txtToDate').val(),
            }
            serverCall('Services/PatientRegistration.asmx/searchPreviousData', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0)
                    bindDetail(responseData);
            });
        }
        var bindDetail = function (data) {
            $('#tbSearch tbody').empty();
            for (var i = 0; i < data.length; i++) {
                var j = $('#tbSearch tbody tr').length + 1;
                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdAName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].EntryDateTime + '</td>';
                row += '<td id="tdAUnit" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Remarks + '</td>';
                row += '<td id="tdACode" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].EName + '</td>';
                row += '<td id="tdARemarks" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].TotalQty + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Gender + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/print.gif" onclick="printReport(this,1);" style="cursor: pointer;" title="Click To Print" /></td>';
                row += '<td id="tdID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].maxID + '</td>';
                row += '</tr>';
                $('#tbSearch tbody').append(row);
            }
        }
        var printReport = function (rowID, a) {
            var row = '';
            BulkID = '';
            if (a == 1) {
                row = $(rowID).closest('tr');
                BulkID = $(row).find('#tdID').text().trim();
            }
            else
                BulkID = rowID;
            serverCall('Services/PatientRegistration.asmx/PrintBulkRegistration', { BulkID: BulkID }, function (response) {
                var responseData = JSON.parse(response);
                    window.open(responseData.responseURL);
            });
        }
    </script>



    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc1" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Patient Bulk Registration</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Patient Registration
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">No. of Total Patient</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <input type="text" id="txtQty" onlynumber="10" maxvalue="500" maxlength="3" title="Enter No. of Total Patient" class="requiredField" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Gender</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input id="rdoMale" type="radio" name="sex" checked="checked" value="Male" class="pull-left" />
                            <span class="pull-left">Male</span>
                            <input id="rdoFemale" type="radio" name="sex" value="Female" class="pull-left" />
                            <span class="pull-left">Female</span>
                            <input id="rdoTGender" type="radio" name="sex" value="TransGender" class="pull-left" />
                            <span class="pull-left">TGender</span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Remarks</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <textarea id="txtRemarks" style="height: 30px; text-transform: uppercase; max-width: 214px; max-height: 70px" class="requiredField"></textarea>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <input type="button" id="btnSave" value="Save" onclick="SaveRegistration()" />
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
         <div class="Purchaseheader">
            Search Previous Details
         </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" CssClass="requiredField" ReadOnly="true"></asp:TextBox>
                            <cc1:CalendarExtender ID="cc1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" CssClass="requiredField" ReadOnly="true"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-5">
                            <input type="button" id="btnSearch" value="Search" onclick="Search()" />
                        </div>
                    </div>
                    <div class="row">
                        <div id="divSearch" style="max-height: 400px; overflow-x: auto">
                            <table class="FixedHeader" id="tbSearch" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 150px;">Registration Date</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">Remarks</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Entry By</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Registration Qty.</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Gender</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Print</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
    </div>
</asp:Content>
