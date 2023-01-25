<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Conversion.aspx.cs" Inherits="Design_MIS_TAT" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <Ajax:ScriptManager ID="sc" runat="server">
    </Ajax:ScriptManager>
    <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
  <%--  <script type="text/javascript" src="../../Scripts/gviz-api.js"></script>
    <script type="text/javascript" src="../../Scripts/jsapi.js"></script>--%>
     <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
        google.load('visualization', '1', { packages: ['corechart'] });
        google.load('visualization', '1', { packages: ['table'] });
    </script>
    <script type="text/javascript">
        google.load;
        $(window).load(function () {
            var tablewidth = $(window).width() - 20;
            var Leftwidth = 140;
            var RightWidth = tablewidth - 150;


            $('#MainTable').css('width', tablewidth);
            $('#tdLeft').css('width', Leftwidth);
            $('#tdRight').css('width', RightWidth);

            $('#Revenue_OPD').click(function () {
                $.blockUI();
                hide_Graph();
                //$('#Revenue_OPD_Area').show();
                $('#Datetable').show();
                Revenue_OPD_DoctorWise($('#txtFromDate').val(), $('#txtToDate').val());
                $.unblockUI();
            });
        });
        function ChkDate(oldValue, newValue) {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        alert('To date can not be less than from date!');
                        getDate();
                        $('#txtFromDate').val(oldValue);
                    }
                    else if ($('#Revenue_OPD_Area').is(':visible')) {
                        Revenue_OPD_DoctorWise($('#txtFromDate').val(), $('#txtToDate').val());

                    }
                }
            });
        }
        function ChkDate1(oldValue, newValue) {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        alert('To date can not be less than from date!');
                        getDate();
                        $('#txtToDate').val(oldValue);
                    }
                    else if ($('#Revenue_OPD_Area').is(':visible')) {
                        Revenue_OPD_DoctorWise($('#txtFromDate').val(), $('#txtToDate').val());

                    }
                }
            });
        }
        function hide_Graph() {
            $('#Revenue_OPD_Area').hide();
        }
        function Revenue_OPD_DoctorWise(FromDate, ToDate) {

            $.ajax({
                url: "Services/mis.asmx/Conversion",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"1"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    debugger;
                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {
                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'MRNo.');
                        dataTable.addColumn('string', 'Patient Name');
                        dataTable.addColumn('string', 'Date');
                        dataTable.addColumn('number', 'Appointment Taken');
                        dataTable.addColumn('number', 'Investigation Taken');
                        dataTable.addColumn('number', 'Procedure Taken');
                        dataTable.addColumn('number', 'Medicine Taken');
                        dataTable.addColumn('number', 'Admission Taken');
                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].PatientID);
                            dataTable.setCell(i, 1, mis_data[i].pname);
                            dataTable.setCell(i, 2, mis_data[i].OpdDate);
                            dataTable.setCell(i, 3, mis_data[i].OpdTaken);
                            dataTable.setCell(i, 4, mis_data[i].InvTaken);
                            dataTable.setCell(i, 5, mis_data[i].ProTaken);
                            dataTable.setCell(i, 6, mis_data[i].MedTaken);
                            dataTable.setCell(i, 7, mis_data[i].AdmisionTaken);
                        }

                        var table = new google.visualization.Table(document.getElementById('Revenue_OPD_Area'));
                        table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });
                        $('#Revenue_OPD_Area').show();
                    }
                    else
                        $('#Revenue_OPD_Area').hide();
                }
            });
        }
    </script>
    <div id="Pbody_box_inventory" style="width: 1250px">
        <div class="POuter_Box_Inventory" style="width: 1248px">
            <div style="text-align: center;">
                <b>&nbsp;Patient Conversion Analysis</b>
                <div class="Purchaseheader">
                    Conversion Analysis
                </div>
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"
                                onFocus="(this.name=this.value)" onchange="ChkDate(this.name,this.value)"></asp:TextBox>
                            <cc1:CalendarExtender ID="Fromdatecal" runat="server" Animated="true" Format="dd-MMM-yyyy"
                                TargetControlID="txtFromDate">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"
                                onFocus="(this.name=this.value)" onchange="ChkDate1(this.name,this.value)"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Animated="true" Format="dd-MMM-yyyy"
                                TargetControlID="txtToDate">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <%--<span id="Revenue_OPD" style="cursor: pointer;border:1px solid white" class="ItDoseButton">Conversion</span>--%>
                             <input type="button" value="Conversion" id="Revenue_OPD" class="ItDoseButton" />
                        </div>

                    </div>
                     <div class="row"></div>
                </div>
                <div class="row"></div>
                <table style="border: thin solid #000000; vertical-align: top; width: 100%">
                    <tr style="border: double; background-color: white;">
                        <td style="width: 90%">
                            <div id="Revenue_OPD_Area">
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</asp:Content>

