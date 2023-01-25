<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TicketingAllInfo.aspx.cs" MasterPageFile="~/DefaultHome.master" Inherits="Design_HelpDesk_TicketingAllInfo" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">

    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtFDSearch').change(function () {
                ChkDate();
            });

            $('#txtTDSearch').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFDSearch').val() + '",DateTo:"' + $('#txtTDSearch').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblErrormsg').text('To date can not be less than from date');
                        $('#btnSearch').attr('disabled', 'disabled');
                    }
                    else {
                        $('#lblErrormsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });
        }

        function searchTicketingInfo() {
            $("#lblErrormsg").text('');
            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/searchTicketingInfo",
                data: '{FrmDate:"' + $("#FrmDate").val() + '",ToDate:"' + $("#ToDate").val() + '",Raised:"' + $("#ddlRaised").val() + '",Resolved:"' + $("#ddlResolved").val() + '",ticketNo:"' + $("#txtTicket").val() + '",chkIssue:"' + $("#ChkIss").is(':checked') + '",chkRaised:"' + $("#chksol").is(':checked') + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                secureuri: false,
                fileElementId: 'fileToUpload',
                success: function (response) {
                    ticket = response.d;
                    if (ticket == "1") {
                        window.open('../common/ExportToExcel.aspx');
                    }
                    else if (ticket == "0") {
                        $("#lblErrormsg").text('Record Not Found');
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Ticketing All Information Report</b><br />
            <asp:Label ID="lblErrormsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
              <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left"><asp:Label ID="Label1" runat="server" Style="text-align: right;" Text="Ticket No."></asp:Label></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTicket" runat="server" ClientIDMode="Static"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftb" runat="server" TargetControlID="txtTicket" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3"><label class="pull-left">
                        <asp:CheckBox ID="ChkIss" runat="server" Checked="false" ClientIDMode="Static" Text="Raised Dept." />
                        </label>
                            <b class="col-md-5">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlRaised" runat="server" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                        <div class="col-md-3"><label class="pull-left">
                        <asp:CheckBox ID="chksol" runat="server" Checked="false" ClientIDMode="Static" Text="Resolved Dept." /></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlResolved" runat="server" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                    </div>
                </div></div>
              <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label><b class="pull-right">:</b></div>
                        <div class="col-md-5">
                            <asp:TextBox ID="FrmDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="FrmDate" Format="dd-MMM-yyyy" Animated="true" runat="server"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="Todatecal" TargetControlID="ToDate" Format="dd-MMM-yyyy" Animated="true" runat="server"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            
                        </div>
                        <div class="col-md-5"></div>
                    </div></div>
              </div>
        </div>
                  <div class="POuter_Box_Inventory" style="text-align:center">
                <input type="button" value="Search" class="ItDoseButton" onclick="searchTicketingInfo()" />
            </div></div>        
</asp:Content>
