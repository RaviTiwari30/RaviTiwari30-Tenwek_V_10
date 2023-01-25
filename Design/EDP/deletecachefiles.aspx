<%@ Page Language="C#" AutoEventWireup="true"  MasterPageFile="~/DefaultHome.master" CodeFile="DeleteCacheFiles.aspx.cs" Inherits="Design_EDP_DeleteCacheFiles" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <cc1:ToolkitScriptManager runat="server" ID="scriptManager"></cc1:ToolkitScriptManager>

    <div id="Pbody_box_inventory">

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Delete Cache Files</b><br />
            <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="ItDoseButton" ClientIDMode="Static" OnClick="btnDelete_Click" />
        </div>

    </div>

</asp:Content>