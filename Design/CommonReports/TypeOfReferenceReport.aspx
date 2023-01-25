<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="TypeOfReferenceReport.aspx.cs" Inherits="Design_OPD_TypeOfReferenceReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">


        $(document).ready(function () {
            $bindTypeOfReference(function () { });
        });


        var getSearchResults = function () {

            var data = {
                fromDate: $('#txtFromDate').val(),
                toDate: $('#txtToDate').val(),
                patientID: $.trim($('#txtUHID').val()),
                TypeOfReference: $.trim($('#ddlReferenceType option:selected').text())
            };

            serverCall('TypeOfReferenceReport.aspx/GetTypeOfReferenceReport', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    window.open('../../Design/common/ExportToExcel.aspx');
            });

        }
        var $bindTypeOfReference = function (callback) {
            serverCall('../Common/CommonService.asmx/GetTypeOfReference', {}, function (response) {
                var responseData = JSON.parse(response);
                var ddlReferenceType = $('#ddlReferenceType');
                ddlReferenceType.bindDropDown({ defaultValue: 'All', data: responseData, valueField: 'ID', textField: 'TypeOfReference', isSearchAble: true });
                callback(ddlReferenceType.val());
            });
        }

    </script>




    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Reference Type Details</b>
            <cc1:ToolkitScriptManager runat="server" ID="scrPT"></cc1:ToolkitScriptManager>
        </div>
        <div class="POuter_Box_Inventory ">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox runat="server" ID="txtFromDate" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExteFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox runat="server" ID="txtToDate" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtenderToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">UHID NO. </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtUHID" />
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Reference Type </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <select id="ddlReferenceType">
                            </select>
                        </div>
                        <div class="col-md-16">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory textCenter ">
            <input type="button" value="Search" onclick="getSearchResults(this)" class="margin-top-on-btn save" />
        </div>
    </div>

</asp:Content>

