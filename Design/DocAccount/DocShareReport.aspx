<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DocShareReport.aspx.cs" Inherits="Design_DocAccount_DocShareReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#ddlDoctor").chosen();
        });
        function check() {
            if ($("#<%=ddlDate.ClientID %>").val() == "Select") {
                $("#<%=lblMsg.ClientID %>").text('Please Select Date');
                $("#<%=ddlDate.ClientID %>").focus();
                return false;
            }
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Doctor Share Report</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report&nbsp;Criteria
            </div>

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="Label1" runat="server" Text="Report Format :" Visible="False"></asp:Label>
                                 Post Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtPostedStatus" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rbtPostedStatus_SelectedIndexChanged">
                                <asp:ListItem Value="0" Selected="True">Un Posted</asp:ListItem>
                                <asp:ListItem Value="1">Posted</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Share Month
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDate" CssClass="requiredField" runat="server" Width="220px"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rblType" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="1" Text="OPD"></asp:ListItem>
                                <asp:ListItem Value="2" Text="IPD"></asp:ListItem>
                                <asp:ListItem Value="3" Text="ALL" Selected="True"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtDoctorType" runat="server" ClientIDMode="Static" ToolTip="Select Mode" AutoPostBack="true" OnSelectedIndexChanged="rbtDoctorType_SelectedIndexChanged" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Individual" Selected="True" Value="0" />
                                <asp:ListItem Text="Unit" Value="1" />
                                <%--<asp:ListItem Text="Individual as well as Unit" Value="2"></asp:ListItem>--%>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDoctor" runat="server" Width="220px" TabIndex="1" ToolTip="Select Doctor" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                       <%-- <div class="col-md-3">
                            <label class="pull-left">
                                Mode
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rblPaymentType" runat="server" ClientIDMode="Static" ToolTip="Select Mode" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Cash" Value="1" />
                                <asp:ListItem Text="Credit" Value="2" />
                                <asp:ListItem Text="ALL" Value="3" Selected="True" />
                            </asp:RadioButtonList>
                        </div>--%>
                       <div class="col-md-3">
                            <label class="pull-left">
                                Report Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rblReportType" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rblReportType_SelectedIndexChanged">
                                <asp:ListItem Value="1" Selected="True">Summary</asp:ListItem>
                                <asp:ListItem Value="2">Detail</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        </div>
                    <div class="row">
                         
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblReportFormat" runat="server" Text="Report Format :" Visible="False"></asp:Label>
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rblReportFormat" runat="server" RepeatDirection="Horizontal" Visible="False">
                                <asp:ListItem Value="1" Selected="True">Pdf</asp:ListItem>
                                <asp:ListItem Value="2">Excel</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-11">
                        </div>
                        <div class="col-md-2">
                            <asp:Button ID="btnReport" runat="server" Text="Report" OnClick="btnReport_Click" CssClass="ItDoseButton" TabIndex="4" ClientIDMode="Static" OnClientClick="return check();" />
                        </div>
                        <div class="col-md-11">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
