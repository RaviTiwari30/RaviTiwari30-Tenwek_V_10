<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="UserPrevilageReport.aspx.cs" Inherits="Design_EDP_UserPrevilageReport" %>

<%-- Add content controls here --%>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/PrintPharmacyLabel.ascx" TagName="wuc_PrintPharmacyLabel" TagPrefix="uc2" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content2" runat="server">
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager2" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>User Previlage Report</b> <br />
            <asp:Label ID="lblMessage" runat="server" ForeColor="Red" ></asp:Label>
        </div>

        <div class="POuter_Box_Inventory">

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Center Name 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlCentre" runat="server" ToolTip="Select Centre" ClientIDMode="Static">
                    </asp:DropDownList>

                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Department
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlDept" runat="server" ToolTip="Select Department" CssClass="chosen-container chosen-container-single" ClientIDMode="Static">
                    </asp:DropDownList>

                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Type
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlType" runat="server" ClientIDMode="Static">
                        <asp:ListItem Text="Page Access" Value="0"></asp:ListItem>
                        <asp:ListItem Text="User Authorization" Value="1"></asp:ListItem>
                    </asp:DropDownList>

                </div>

            </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                 <asp:Button ID="btnReport" Text="Report" runat="server" OnClick="btnReport_Click" />
            </div>
           
        </div>

    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#<%=ddlDept.ClientID %>").chosen();
            $("#<%=ddlCentre.ClientID %>").chosen();
            $("#<%=ddlType.ClientID %>").chosen();

        });
    </script>
</asp:Content>
