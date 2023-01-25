<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="IPD_AdvanceReport.aspx.cs" Inherits="Design_IPD_IPD_AdvanceReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="cntnt" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <link rel="Stylesheet" type="text/css" href="../../Scripts/chosen.css" />
    <script type="text/javascript" src="../../Scripts/chosen.jquery.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
            $('#ddlPanel').chosen();
            $('#ucFromDate').change(function () {
                ChkDate();
            });
            $('#ucToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#btnReport').attr('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#btnReport').removeAttr('disabled');
                    }
                }
            });

        }

        function checkAllCentre() {
            var status = $('#<%= chkAllCentre.ClientID %>').is(':checked');

            if (status == true)
                $('.chkAllCentreCheck input[type=checkbox]').attr("checked", "checked");
            else
                $(".chkAllCentreCheck input[type=checkbox]").attr("checked", false);
        }
        function chkCentreCon() {
            if (($('#<%= chkCentre.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkCentre.ClientID %>  input[type=checkbox]').length))
                $('#<%= chkAllCentre.ClientID %>').attr("checked", "checked");

            else
                $('#<%= chkAllCentre.ClientID %>').attr("checked", false);

        }

    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScripManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>IPD Advance & Settlement Report</b><br />
            <asp:Label ID="lblMsg" CssClass="ItDoseLblError" runat="server"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIpno" runat="server" MaxLength="10" ToolTip="Enter IPD No." ClientIDMode="Static" 
                               ></asp:TextBox>
                           
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblDtFrom" runat="server" Text="From Date"></asp:Label>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"
                                TabIndex="2"></asp:TextBox>
                            <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblDtTo" runat="server" Text="To Date"></asp:Label>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select To Date"
                                TabIndex="3"></asp:TextBox>
                            <cc1:CalendarExtender ID="ToDatecal" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Panel
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPanel" runat="server" TabIndex="4" ToolTip="Select Panel" ClientIDMode="Static">
                                
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-13">
                            <asp:RadioButtonList ID="rdbcolType" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="0" Selected="True">ALL</asp:ListItem>
                                <asp:ListItem Value="1">Advance Collection</asp:ListItem>
                                <asp:ListItem Value="2">Settlement</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre :&nbsp;" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static"
                                RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server"
                                RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </div>
                    </div>
                    <div class="row" style="display: none;">
                        <asp:RadioButtonList ID="rbtType" runat="server" AutoPostBack="True" OnSelectedIndexChanged="rbtType_SelectedIndexChanged"
                            TabIndex="1" ToolTip="Select Report Type">
                            <asp:ListItem Selected="True" Value="1">Dates Between</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnReport" Text="Report" OnClick="btnReport_Click" runat="server"
                ClientIDMode="Static" CssClass="ItDoseButton" />
        </div>
    </div>

</asp:Content>
