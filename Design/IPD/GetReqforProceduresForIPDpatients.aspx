<%@ Page Language="C#"  MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="GetReqforProceduresForIPDpatients.aspx.cs" Inherits="Design_IPD_GetReqforProceduresForIPDpatients" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>

  <script type="text/javascript">

    $(document).ready(function () {
            bindRoomType();            
        });

        function bindRoomType() {
            jQuery("#cmbRoom option").remove();
            jQuery.ajax({
                url: "../IPD/PatientSearch.aspx/BindRoomType",
                data: '{FloorID:"' + $('#ddlFloor').val() + '",isAttenderRoom:"' + 0 + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    RoomData = jQuery.parseJSON(result.d);
                    $("#cmbRoom").append($("<option></option>").val("0").html("ALL"));
                    for (i = 0; i < RoomData.length; i++) {
                        $("#cmbRoom").append($("<option></option>").val(RoomData[i].IPDCaseTypeID).html(RoomData[i].Name)).chosen('destroy').chosen();
                    }
                },
                error: function (xhr, status) {
                }
            });
        }

        function Search() {
            var data = {
                RoomType: $('#cmbRoom').val(),
                PID: $('#txtPatientID').val(),
                TID: $('#txtTransactionNo').val(),
                Fromdate: $('#ucFromDate').val(),
                Todate: $('#ucToDate').val()
            }
            serverCall('GetReqforProceduresForIPDpatients.aspx/GetPatientBookingDetails', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {                    
                    if (responseData.Pstatus) {
                        GetPatientBookingDetails(responseData.PatientList);
                        $('#divPatientlist').show();
                    } else {
                        $('#divPatientlist').hide();
                        $('#tblPatientList tbody').empty();
                    }                    
                }
                else {
                    $('#divPatientlist').hide();                   
                    $('#tblPatientList tbody').empty();
                    modelAlert(responseData.response);
                }
            });
        }

        var getBookingReport = function () {
            var data = {
                RoomType: $('#cmbRoom').val(),
                PID: $('#txtPatientID').val(),
                TID: $('#txtTransactionNo').val(),
                Fromdate: $('#ucFromDate').val(),
                Todate: $('#ucToDate').val()
            }

            serverCall('GetReqforProceduresForIPDpatients.aspx/GetPatientBookingReport', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    window.open('../../Design/common/ExportToExcel.aspx');
                else
                    modelAlert('Record Not Found');
            });
        }

        function GetPatientBookingDetails(data) {
            $('#tblPatientList tbody').empty();

            for (var i = 0; i < data.length > 0; i++) {
                var j = i + 1;

                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdDate" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].IssueDate + '</td>';
                row += '<td id="tdUHID" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].UHID + '</td>';
                row += '<td id="tdPname" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].PName + '</td>';
                row += '<td id="tdAge" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Age + '</td>';
                row += '<td id="tdGender" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Gender + '</td>';
                row += '<td id="tdIPD" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].IPDNo + '</td>';
                row += '<td id="tdWard" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Ward + '</td>';
                row += '<td id="tdItem" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ItemName + '</td>';
                row += '<td id="tdQty" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Quantity + '</td>';
                row += '<td id="tdSubgroup" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].SubCat + '</td>';
                row += '<td id="tdDoctor" class="GridViewLabItemStyle" style="text-align: center; display:none; ">' + data[i].Doctorname + '</td>';
                row += '<td id="tdUser" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].EntryBy + '</td>';
                row += '</tr>';

                $('#tblPatientList tbody').append(row);
            }
        }

    </script>

        <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="sm" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Procedures Request for IPD Patient (Ortho. Only)</b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Ward 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="cmbRoom" title="Select Room Type" tabindex="10" onkeyup="if(event.keyCode==13){Search(0);};"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtPatientID" onkeyup="if(event.keyCode==13){Search(0);};" tabindex="1" autocomplete="off" data-title="Enter UHID" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTransactionNo" runat="server" ClientIDMode="Static" Style="text-transform: uppercase" MaxLength="10" TabIndex="9" AutoCompleteType="Disabled" data-title="Enter IPD No." onkeyup="if(event.keyCode==13){Search(0);};"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" ReadOnly="true" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucToDate" runat="server" ReadOnly="true" ClientIDMode="Static" ToolTip="Click To Select To Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="Calendarextender2" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3"></div>
                        <div class="col-md-2" style="text-align:center">
                             <input type="button" class="ItDoseButton" title="Click to Search Patient" tabindex="16" value="Search" id="btnSearch" onclick="Search()" />
                        </div>                       
                        <div class="col-md-3" style="text-align:center">
                             <input type="button" class="ItDoseButton" title="Click to Export Report" tabindex="16" value="Report" id="btnReport" onclick="getBookingReport()" />
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </div>

            <div class="row" style="display: none" id="divPatientlist">
                <div class="Purchaseheader">
                    <label id="lblProcedureList">Procedures Request Detail </label>
                </div>
                <div id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tblPatientList" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                               <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>                                
                                <th class="GridViewHeaderStyle">Date</th>
                                <th class="GridViewHeaderStyle">UHID</th>
                                <th class="GridViewHeaderStyle">PName</th>
                                <th class="GridViewHeaderStyle">Age</th>
                                <th class="GridViewHeaderStyle">Gender</th>
                                <th class="GridViewHeaderStyle">IPDNo</th>
                                <th class="GridViewHeaderStyle" style="width:155px;">Ward</th>                                
                                <th class="GridViewHeaderStyle">ItemName</th>
                                <th class="GridViewHeaderStyle">Quantity</th>                                
                                <th class="GridViewHeaderStyle">SubGroup</th>
                                <th class="GridViewHeaderStyle" style="display:none">Doctorname</th>                                
                                <th class="GridViewHeaderStyle">EntryBy</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>