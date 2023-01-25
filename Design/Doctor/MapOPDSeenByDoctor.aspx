<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MapOPDSeenByDoctor.aspx.cs" Inherits="Design_Doctor_MapOPDSeenByDoctor" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            loadCurrentDoctor(function () {
                loadSeenByDoctor(function () {
                    bindMapOPDSeenByDoctorMaster( function () {

                    });
                });
            });
        });
        var loadCurrentDoctor = function (callback) {
            ddlCurrentDoctor = $('#ddlCurrentDoctor');
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: "all" }, function (response) {
                ddlCurrentDoctor.bindDropDown({
                    defaultValue: 'Select', data: JSON.parse(response),
                    valueField: 'DoctorID', textField: 'Name', isSearchAble: true
                });
                callback(ddlCurrentDoctor.val());
            });
        }
        var loadSeenByDoctor = function (callback) {
            ddlSeenByDoctor = $('#ddlSeenByDoctor');
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: "all" }, function (response) {
                ddlSeenByDoctor.bindDropDown({
                    defaultValue: 'Select', data: JSON.parse(response),
                    valueField: 'DoctorID', textField: 'Name', isSearchAble: true
                });
                callback(ddlSeenByDoctor.val());
            });
        }

        var Save = function () {
            var data = {
                Date: $('#txtDate').val(),
                ActualDoctorID: $('#ddlCurrentDoctor').val().trim(),
                SeenByDoctorID: $('#ddlSeenByDoctor').val(),
                ID : $('#spnDoctoeID').text().trim(),
            }

            if (String.ActualDoctorID == 0) {
                modelAlert('Please Select Current Doctor', function () {
                    $('#ddlCurrentDoctor').focus();
                });
                return false;
            }
            if (data.SeenByDoctorID == 0) {
                modelAlert('Please Select SeenBy Doctor ', function () {
                    $('#ddlSeenByDoctor').focus();
                });
                return false;
            }

            serverCall('MapOPDSeenByDoctor.aspx/SaveMapOPDSeenByDoctor', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    bindMapOPDSeenByDoctorMaster(0, function () {
                        Clear();
                    });
                });
            });
        }
        var Delete = function (rowID) {
            debugger;
            var row = $(rowID).closest('tr');
            var ID = row.find('#tdAID').text();
            var selectedDate = row.find('#tdDate').text();         
            serverCall('MapOPDSeenByDoctor.aspx/UpdateMapOPDSeenByDoctor', { ID: ID, selectedDate: selectedDate }, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    bindMapOPDSeenByDoctorMaster(function () {
                    });
                });
            });
        }
        var bindMapOPDSeenByDoctorMaster = function (callback) {
            serverCall('MapOPDSeenByDoctor.aspx/BindMapOPDSeenByDoctor', { }, function (response) {
                var responseData = JSON.parse(response);
                bindMapOPDSeenByDoctor(responseData);
            });
            callback(true);
        }

        var bindMapOPDSeenByDoctor = function (data) {
            $('#tbMapOPDSeenByDoctor tbody').empty();
            for (var i = 0; i < data.length; i++) {
                var j = $('#tbMapOPDSeenByDoctor tbody tr').length + 1;
                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdDate" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Date + '</td>';
                row += '<td id="tdCurrentDoctor" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DName + '</td>';
                row += '<td id="tdSeenByDoctor" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].SeenByName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].EName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].EntryByDateTime + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgDelete" src="../../Images/NotOK.png" onclick="Delete(this);" style="cursor: pointer;" title="Click To Delete" /></td>';
                row += '<td id="tdAID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ID + '</td>';
                row += '</tr>';
                $('#tbMapOPDSeenByDoctor tbody').append(row);
            }
        }        
    </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc1" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Map OPD SeenBy Doctor</b>
             <span style="display:none" id="spnID"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtDate" runat="server" ClientIDMode="Static" CssClass="requiredField" ReadOnly="true"></asp:TextBox>
                    <cc1:CalendarExtender ID="cc1" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                     <asp:TextBox ID="txtCurrDate" runat="server" ClientIDMode="Static" CssClass="requiredField" ReadOnly="true" style="display:none"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtCurrDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Current Doctor</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlCurrentDoctor" class="requiredField"></select>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">SeenBy Doctor</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlSeenByDoctor" class="requiredField"></select>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <input type="button" id="btnSave" value="Save" onclick="Save()" />
            </div>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tbMapOPDSeenByDoctor" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Date</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Curent Doctor</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">SeenBy Doctor</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Entry By</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Entry Date</th>                              
                                <th class="GridViewHeaderStyle" style="width: 80px;">Delete</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
</asp:Content>

