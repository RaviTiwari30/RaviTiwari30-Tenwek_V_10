<%@ Page Language="C#" MaintainScrollPositionOnPostback="true" MasterPageFile="~/DefaultHome.master"
    AutoEventWireup="true" CodeFile="DownloadFinanceData.aspx.cs" Inherits="Design_IPD_DownloadFinanceData" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
      
    </script>

     <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <ajax:ScriptManager ID="ScriptManager1" runat="server">
            </ajax:ScriptManager>
            <b> Download Finance Data</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
        </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="btnSave" runat="server"  CssClass="ItDoseButton" OnClick="btnSave_Click" ClientIDMode="Static" Text="Download Data"  />
            </div>
        </div>
</asp:Content>