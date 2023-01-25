<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SetDocShareDate.aspx.cs" Inherits="Design_DocAccount_SetDocShareDate" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(function () {
            $('#txtShareFromDate').change(function () {
                ChkDate();
            });

            $('#txtShareToDate').change(function () {
                ChkDate();
            });
        });

        function ChkDate() {
            var fromDate = "";

            if ($("#<%=txtShareFromDate.ClientID%>").is(':visible'))
                fromDate = $("#<%=txtShareFromDate.ClientID%>").val();
            else
                fromDate = $("#<%=lblShareFromDate.ClientID%>").text();

            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + fromDate + '",DateTo:"' + $('#txtShareToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $("#<%=lblmsg.ClientID %>").text('To date can not be less than from date!');
                        $('#btnSave').attr('disabled', 'disabled');
                    }
                    else {
                        $("#<%=lblmsg.ClientID %>").text('');
                        $('#btnSave').removeAttr('disabled');
                    }
                },
                beforeSend: function () {
                    $(document).ready(function () {
                    });
                }
            });
        }
    </script>

    <script type="text/javascript">
        function SetDocShareDate() {
            $("#<%=lblmsg.ClientID %>").text('');
            $('#btnSave').attr('disabled', true).val("Submitting...");
            var ShareFrom = "";

            if ($("#<%=txtShareFromDate.ClientID%>").is(':visible'))
                ShareFrom = $("#<%=txtShareFromDate.ClientID%>").val();
            else
                ShareFrom = $("#<%=lblShareFromDate.ClientID%>").text()

            $.ajax({
                url: "Services/DocAccount.asmx/SaveDocShareDate",
                data: '{ ShareFrom:"' + ShareFrom + '",ShareTo:"' + $("#<%=txtShareToDate.ClientID%>").val() + '"}', // parameter map
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        $("#<%=lblmsg.ClientID %>").text('Record Saved Successfully');
                        $('#btnSave').attr('disabled', false).val("Save");
                        if ($("#<%=txtShareFromDate.ClientID%>").is(':visible')) {
                            $("#<%=txtShareFromDate.ClientID%>").hide();
                            $("#<%=lblShareFromDate.ClientID%>").show();
                            $("#<%=lblShareFromDate.ClientID%>").text($("#<%=txtShareToDate.ClientID%>").val());
                        }
                        else {
                            $("#<%=lblShareFromDate.ClientID%>").text($("#<%=txtShareToDate.ClientID%>").val());
                        }
                    }
                    else if (result.d == "0") {
                        $("#<%=lblmsg.ClientID %>").text('Record Not Saved');
                        $('#btnSave').attr('disabled', false).val("Save");
                    }
                    else {
                        $("#<%=lblmsg.ClientID %>").text('Doctor Share already Process Month of ' + result.d);
                        $('#btnSave').attr('disabled', false).val("Save");
                    }
                },
                error: function (xhr, status) {
                    $("#<%=lblmsg.ClientID %>").text('Record Not Saved');
                    $('#btnSave').attr('disabled', false).val("Save");
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
            }
    </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Set Doctor Share Date</b><br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblShareFromDate" Font-Bold="true" runat="server"></asp:Label>
                            <asp:TextBox ID="txtShareFromDate" ClientIDMode="Static" runat="server" ToolTip="Click To Select From Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtShareFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                        </div>
                        <div class="col-md-5">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtShareToDate" ClientIDMode="Static" runat="server" CssClass="requiredField" ToolTip="Click To Select To Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="txtShareToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-11">
                        </div>
                        <div class="col-md-2">
                            <input type="button" class="ItDoseButton" id="btnSave" value="Save" title="Click to Save" onclick="SetDocShareDate()" />
                        </div>
                        <div class="col-md-11">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
    </div>
</asp:Content>
